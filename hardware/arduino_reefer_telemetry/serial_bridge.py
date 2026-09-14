#!/usr/bin/env python3
"""AEGIS-CARGO serial bridge: Arduino reefer probe -> n8n reefer-telemetry webhook.

Reads {"temp_c":..,"adc":..} lines from the Uno, and when the probe crosses
THRESHOLD_C (pinch the sensor) POSTs one structured cold-chain payload.

The payload routes directly to the dedicated `reefer-telemetry` webhook in n8n,
bypassing the console crisis-intel sniffer and ingress LLM entirely.

`current_temp_c` is the cargo core temperature, not the probe reading: the probe
is the trigger, the consignment's own thermal state is what the engine scores.
The measured value rides along as `sensor_temp_c` for provenance.

Setup:
    pip install pyserial requests
    export AEGIS_WEBHOOK="https://<your-n8n-instance>/webhook/reefer-telemetry"
    python serial_bridge.py              # auto-detect port
    python serial_bridge.py --port COM4
    python serial_bridge.py --fire       # no hardware; send once (stage failsafe)
    python serial_bridge.py --selftest
"""

import argparse
import json
import os
import sys
import time

# Configurable via environment variable AEGIS_WEBHOOK; defaults to local n8n instance
WEBHOOK = os.environ.get(
    "AEGIS_WEBHOOK", "http://localhost:5678/webhook/reefer-telemetry"
)
BAUD = 9600
THRESHOLD_C = 28.0      # finger warm-up clears this; room air does not
DEBOUNCE_S = 30.0       # lockout after a trigger, stops request flooding

# Calibrated to match the console's reefer lever (TriggerConsole.jsx DEFAULTS):
# a 72 h hold still breaches the 2-8 degC regime, but a hub inside ~24 h saves it.
PAYLOAD = {
    "event_type": "THERMAL_EXCURSION",
    "container_id": "MED-7702",
    "product": "Monoclonal Antibodies (2-8C)",
    "current_temp_c": 5.8,
    "rise_rate_c_per_hr": 0.35,
    "ambient_c": 33.2,
    "reefer_power_status": "UNPOWERED_DRIFT",
    "sensor_id": "XC3700-HW-01",
    "event_source": "HARDWARE_IOT",
}


def parse_line(line):
    """-> temp_c float, or None for noise/partial frames."""
    try:
        return float(json.loads(line)["temp_c"])
    except (ValueError, KeyError, TypeError):
        return None


def should_fire(temp_c, last_fire, now, threshold=THRESHOLD_C, debounce=DEBOUNCE_S):
    return temp_c >= threshold and (now - last_fire) >= debounce


def fire(temp_c=None):
    import requests

    body = dict(PAYLOAD)
    if temp_c is not None:
        body["sensor_temp_c"] = round(temp_c, 1)
    print(f"Posting to {WEBHOOK} ...")
    try:
        r = requests.post(WEBHOOK, json=body, timeout=15)
        print(f"  -> POST {r.status_code} {r.reason}", flush=True)
        return r.status_code
    except Exception as e:
        print(f"  -> Request failed: {e}", flush=True)
        return None


def find_port():
    from serial.tools import list_ports

    ports = list(list_ports.comports())
    for p in ports:
        desc = f"{p.description} {p.manufacturer or ''}".lower()
        if any(k in desc for k in ("arduino", "ch340", "usb serial", "wch")):
            return p.device
    return ports[0].device if ports else None


def run(port):
    import serial

    port = port or find_port()
    if not port:
        sys.exit("no serial port found; pass --port COM3")
    print(f"listening on {port} @ {BAUD}, trigger >= {THRESHOLD_C} C", flush=True)

    last_fire = -DEBOUNCE_S
    with serial.Serial(port, BAUD, timeout=2) as ser:
        time.sleep(2)  # Uno resets on open
        while True:
            temp_c = parse_line(ser.readline().decode("utf-8", "replace").strip())
            if temp_c is None:
                continue
            now = time.monotonic()
            print(f"{temp_c:5.1f} C", flush=True)
            if should_fire(temp_c, last_fire, now):
                last_fire = now
                print(f"THERMAL EXCURSION at {temp_c:.1f} C -> {PAYLOAD['container_id']}")
                fire(temp_c)


def selftest():
    assert parse_line('{"temp_c":24.2,"adc":512}') == 24.2
    assert parse_line("garbage") is None
    assert parse_line('{"adc":512}') is None
    assert should_fire(28.0, last_fire=-30, now=0)
    assert not should_fire(27.9, last_fire=-30, now=0)
    assert not should_fire(30.0, last_fire=0, now=29)   # inside lockout
    assert should_fire(30.0, last_fire=0, now=30)       # lockout expired
    assert "bulletin" not in PAYLOAD, "a bulletin key would route via the LLM"
    print("selftest ok")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--port")
    ap.add_argument("--fire", action="store_true", help="send once, no hardware")
    ap.add_argument("--selftest", action="store_true")
    a = ap.parse_args()
    if a.selftest:
        selftest()
    elif a.fire:
        fire()
    else:
        run(a.port)
