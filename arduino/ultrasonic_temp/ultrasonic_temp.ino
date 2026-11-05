// Temperature-compensated ultrasonic distance meter (Arduino Uno or Nano, 5 V).
//
// Every 200 ms: 5 pings of the HC-SR04, the median echo time, the air temperature
// from an LM35, and the distance computed two ways. One CSV line per measurement:
//
//   ms,temp_c,echo_us,d_fixed_cm,d_comp_cm
//
//   d_fixed_cm : assumes 343 m/s (dry air at about 20 C), what most tutorials do
//   d_comp_cm  : uses v = 331.3 + 0.606 * T, the speed of sound at the measured T
//
// Wiring
//   HC-SR04  VCC -> 5V, Trig -> D9, Echo -> D10, GND -> GND
//   LM35     +Vs -> 5V, Vout -> A0, GND -> GND   (10 mV per degree C)
//
// Open the Serial Monitor at 115200 baud, or log with any serial terminal to a .csv file.

const uint8_t PIN_TRIG = 9;
const uint8_t PIN_ECHO = 10;
const uint8_t PIN_TEMP = A0;
const unsigned long ECHO_TIMEOUT_US = 25000;   // about 4.3 m; pulseIn returns 0 after this
const uint8_t PINGS = 5;

unsigned long pingOnce() {
  digitalWrite(PIN_TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(PIN_TRIG, HIGH);                 // a 10 us pulse starts one measurement
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG, LOW);
  return pulseIn(PIN_ECHO, HIGH, ECHO_TIMEOUT_US);
}

unsigned long medianEcho() {                    // median of 5 rejects a single bad echo
  unsigned long t[PINGS];
  for (uint8_t i = 0; i < PINGS; i++) {
    t[i] = pingOnce();
    delay(30);                                  // let the last echo die out (datasheet: 60 ms cycle)
  }
  for (uint8_t i = 1; i < PINGS; i++) {         // insertion sort, 5 values
    unsigned long v = t[i];
    int8_t j = i - 1;
    while (j >= 0 && t[j] > v) { t[j + 1] = t[j]; j--; }
    t[j + 1] = v;
  }
  return t[PINGS / 2];
}

float readTempC() {
  long sum = 0;
  for (uint8_t i = 0; i < 8; i++) sum += analogRead(PIN_TEMP);
  return (sum / 8.0) * 5.0 / 1023.0 * 100.0;    // 10 mV per degree, 5 V reference
}

void setup() {
  pinMode(PIN_TRIG, OUTPUT);
  pinMode(PIN_ECHO, INPUT);
  Serial.begin(115200);
  Serial.println(F("ms,temp_c,echo_us,d_fixed_cm,d_comp_cm"));
}

void loop() {
  unsigned long echo = medianEcho();
  float tc = readTempC();
  float vFixed = 343.0;                         // m/s
  float vComp = 331.3 + 0.606 * tc;             // m/s
  // distance = v * t / 2 (there and back); us -> s is 1e-6, m -> cm is 100
  float dFixed = echo * vFixed * 1e-4 / 2.0;
  float dComp = echo * vComp * 1e-4 / 2.0;

  Serial.print(millis()); Serial.print(',');
  Serial.print(tc, 1); Serial.print(',');
  Serial.print(echo); Serial.print(',');
  if (echo == 0) {                              // no echo: report empty distances
    Serial.println(F(","));
  } else {
    Serial.print(dFixed, 1); Serial.print(',');
    Serial.println(dComp, 1);
  }
  delay(50);                                    // 5 pings x 30 ms + 50 ms = about 200 ms per line
}
