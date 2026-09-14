import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import crypto from 'node:crypto';

const { nodes } = JSON.parse(readFileSync(new URL('./workflow_skeleton.json', import.meta.url), 'utf8'));
const code = name => nodes.find(n => n.name === name).parameters.jsCode;
const run = (name, context) => vm.runInNewContext(`(function(){${code(name)}\n})()`, context);
const future = new Date(Date.now() + 86400000).toISOString();
const week = new Date(Date.now() + 7 * 86400000).toISOString();
const feature = (id, alertlevel, lon, lat) => ({
  properties: { eventtype: 'EQ', eventid: id, episodeid: 1, alertlevel, todate: week },
  geometry: { type: 'Point', coordinates: [lon, lat] },
});
const data = {
  'Fetch GDACS Hazard Feed': [{ json: { features: [
    feature(1, 'red', 39.2, 21.3),
    feature(2, 'orange', -10, 0),
    feature(3, 'green', 39.2, 21.3),
  ] } }],
  'Supabase: Fleet Routes (GDACS)': [{ json: {
    id: 'v1', current_lat: 20, current_lon: 40,
    itinerary: [{ lat: 21.48, lon: 39.17, eta: future }],
  } }],
  'Supabase: Fleet Cargo (GDACS)': [{ json: {
    vessel_id: 'v1', container_id: 'MED-7702', disposition: 'IN_TRANSIT',
  } }],
};
const $ = name => ({ first: () => data[name][0], all: () => data[name] });
const rows = run('Normalize GDACS Incidents', { $, $json: {} });
assert.equal(rows.length, 2); // GREEN never enters the incident table.
assert.equal(rows[0].json.collision_payloads[0].container_id, 'MED-7702');
assert.equal(rows[1].json.collision_payloads.length, 0); // Stored, not intercepted.

data['Normalize GDACS Incidents'] = rows;
const emit = stored => run('Emit GDACS Route Collisions', {
  $, $input: { all: () => stored.map(incident_ref => ({ json: { incident_ref } })) },
});
assert.equal(emit(['EQ:1:1']).length, 1);
assert.equal(emit(['EQ:2:1']).length, 0);
assert.equal(emit([]).length, 0); // Existing incident did not pass the insert gate.

data['Supabase: Fleet Routes (GDACS)'] = [{ json: {} }];
data['Supabase: Fleet Cargo (GDACS)'] = [{ json: {} }];
assert.equal(run('Normalize GDACS Incidents', { $, $json: {} }).length, 2);
const state = {};
const article = { title: 'Missile attack closes Bab el-Mandeb shipping lane', contentSnippet: 'A missile attack near Bab el-Mandeb has closed the shipping lane.', link: 'https://example.org/rss-test', pubDate: new Date().toUTCString() };
const screen = () => run('Screen Maritime Articles', {
  $input: { all: () => [article, article, { title: 'Music review', link: 'https://example.org/music', pubDate: article.pubDate }].map(json => ({ json })) },
  $getWorkflowStaticData: () => state,
  require: name => { assert.equal(name, 'crypto'); return crypto; },
});
const shortlisted = screen();
assert.equal(shortlisted.length, 1);
data['Screen Maritime Articles'] = shortlisted;
const output = JSON.stringify({ is_actionable_hazard: true, threat_category: 'war_risk', severity: 'RED', center_lat: 13, center_lon: 43.4, exclusion_radius_nm: 75, active_duration_hours: 48, evidence_location: 'Bab el-Mandeb', evidence_event: 'missile attack' });
const hazards = run('Validate RSS Hazard', { $, $input: { all: () => [{ json: { output } }] }, $getWorkflowStaticData: () => state });
assert.equal(hazards.length, 1);
assert.ok(hazards[0].json.incident_ref.length <= 50);
assert.equal(screen().length, 0);
assert.equal(run('Screen Maritime Articles', {
  $input: { all: () => [{ json: { title: 'Port of Rotterdam closed', contentSnippet: 'Vessel traffic stopped today.', link: 'https://example.org/port-closed', pubDate: article.pubDate } }] },
  $getWorkflowStaticData: () => state,
  require: name => { assert.equal(name, 'crypto'); return crypto; },
}).length, 1);
data['Validate RSS Hazard'] = hazards;
data['Supabase: Fleet Routes (RSS)'] = [{ json: { id: 'v1', current_lat: 13, current_lon: 43.4, itinerary: [{ lat: 21.48, lon: 39.17, eta: future }] } }];
data['Supabase: Fleet Cargo (RSS)'] = [{ json: { vessel_id: 'v1', container_id: 'MED-7702', disposition: 'IN_TRANSIT' } }];
assert.equal(run('Match RSS Hazard to Fleet', { $ }).length, 1);
data['Supabase: Fleet Routes (RSS)'][0].json.current_lat = 0;
data['Supabase: Fleet Routes (RSS)'][0].json.current_lon = -10;
data['Supabase: Fleet Routes (RSS)'][0].json.itinerary = [];
// P1-B: Input Boundary Validation tests covering IoT webhook body, fast-path payload, and LLM output
const testWebhookBody = run('Input Boundary Validation', {
  $json: { body: { container_id: 'MED-7702', event_type: 'THERMAL_EXCURSION', current_temp_c: 5.8 } }
});
assert.equal(testWebhookBody[0].json.validation_ok, true);
assert.equal(testWebhookBody[0].json.fast_path, true);
assert.equal(testWebhookBody[0].json.intel.container_id, 'MED-7702');
assert.equal(testWebhookBody[0].json.intel.current_temp_c, 5.8);

const testFastPathPayload = run('Input Boundary Validation', {
  $json: { payload: { container_id: 'MED-7702', event_type: 'war_risk' } }
});
assert.equal(testFastPathPayload[0].json.validation_ok, true);
assert.equal(testFastPathPayload[0].json.fast_path, true);

const testCycloneFastPath = run('Input Boundary Validation', {
  $json: { payload: { container_id: 'MED-7702', event_type: 'cyclone', threat_category: 'natural_hazard', center_lat: 20.0, center_lon: 39.6, exclusion_radius_nm: 120 } }
});
assert.equal(testCycloneFastPath[0].json.validation_ok, true);
assert.equal(testCycloneFastPath[0].json.fast_path, true);
assert.equal(testCycloneFastPath[0].json.intel.event_type, 'cyclone');
assert.equal(testCycloneFastPath[0].json.intel.threat_category, 'natural_hazard');

const testLLMOutput = run('Input Boundary Validation', {
  $json: { output: JSON.stringify({ container_id: 'MED-7702', event_type: 'war_risk' }) }
});
assert.equal(testLLMOutput[0].json.validation_ok, true);
assert.equal(testLLMOutput[0].json.fast_path, false);

const testMissingCid = run('Input Boundary Validation', {
  $json: { body: { event_type: 'THERMAL_EXCURSION' } }
});
assert.equal(testMissingCid[0].json.validation_ok, false);
assert.ok(testMissingCid[0].json.validation_errors.includes('container_id missing or empty'));

const testMissingEvt = run('Input Boundary Validation', {
  $json: { body: { container_id: 'MED-7702' } }
});
assert.equal(testMissingEvt[0].json.validation_ok, false);
assert.ok(testMissingEvt[0].json.validation_errors.includes('event_type missing'));

// P1-D: Trace ID and Event Source verification
assert.ok(typeof testWebhookBody[0].json.trace_id === 'string' && testWebhookBody[0].json.trace_id.startsWith('TRC-'));
assert.equal(testWebhookBody[0].json.intel.trace_id, testWebhookBody[0].json.trace_id);
assert.equal(testWebhookBody[0].json.event_source, 'HARDWARE_IOT');
assert.equal(testWebhookBody[0].json.intel.event_source, 'HARDWARE_IOT');
assert.ok(typeof testWebhookBody[0].json.ingress_time_ms === 'number');

const testExplicitTrace = run('Input Boundary Validation', {
  $json: { payload: { container_id: 'MED-7702', event_type: 'war_risk', trace_id: 'TRC-CUSTOM-123' } }
});
assert.equal(testExplicitTrace[0].json.trace_id, 'TRC-CUSTOM-123');
assert.equal(testExplicitTrace[0].json.intel.trace_id, 'TRC-CUSTOM-123');
assert.equal(testExplicitTrace[0].json.event_source, 'CONSOLE_INJECT');

console.log('GDACS, RSS, Input Boundary Validation, and P1-D Traceability self-check ok');
