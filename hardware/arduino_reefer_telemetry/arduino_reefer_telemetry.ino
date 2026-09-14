// AEGIS-CARGO reefer telemetry probe — Arduino Uno R3 + XC3700 (LM35, 10 mV/degC).
// XC3700: Signal -> A0, VCC -> 5V, GND -> GND.
// Emits one JSON line per 250 ms at 9600 baud: {"temp_c":24.2,"adc":512}

const int PIN = A0;
const int N = 5;              // moving average window
int buf[N];
int idx = 0, filled = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  buf[idx] = analogRead(PIN);
  idx = (idx + 1) % N;
  if (filled < N) filled++;

  long sum = 0;
  for (int i = 0; i < filled; i++) sum += buf[i];
  float adc = (float)sum / filled;

  // LM35: 10 mV per degC against the 5 V reference over 1024 counts.
  float temp_c = adc * (5.0 / 1023.0) * 100.0;

  Serial.print(F("{\"temp_c\":"));
  Serial.print(temp_c, 1);
  Serial.print(F(",\"adc\":"));
  Serial.print((int)adc);
  Serial.println(F("}"));

  delay(250);
}
