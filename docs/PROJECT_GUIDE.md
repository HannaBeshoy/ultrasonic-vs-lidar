# Project guide

This guide explains the physics behind every step and links it to the Physics course notes (PSC, Part I and the phyphox experiments, pp. 232–236). Read it next to the code.

## 1. Time of flight

The HC-SR04 sends a burst of eight 40 kHz pulses and raises its Echo pin until the echo returns. The pin's high time t is the round trip, so

    d = v · t / 2

This is the constant-velocity motion of Topic 1 (x = v·t), used backwards: a known speed and a measured time give a distance. A relative error in v or in t becomes the same relative error in d, which is why the speed of sound matters so much.

In the sketch, `pulseIn` returns t in microseconds, and d in cm = t · v · 10⁻⁴ / 2 with v in m/s.

## 2. The speed of sound depends on temperature

Sound in a gas travels at v = √(γRT/M): it grows with the square root of the absolute temperature. For air this is

    v = 331.3 · √(1 + T/273.15)  m/s     (T in °C)

and the straight line the course uses, v ≈ 331.3 + 0.606 · T, agrees with it within 0.2 m/s from −10 to 20 °C and within 0.8 m/s (0.25 %) up to 40 °C (`matlab/speed_of_sound.m`, both models). A 10 °C mistake in the temperature is a 6 m/s, 1.8 % mistake in v: 5 cm at 3 m.

## 3. The meter

`arduino/ultrasonic_temp/ultrasonic_temp.ino`:

- five pings 30 ms apart, so the previous echo has died out, and the **median** of the five echo times. A single wrong echo (from a side wall, or none at all) can never be the middle value, so it is rejected; this is the same filter the Signals and Systems project chose for LiDAR scans.
- the LM35 gives 10 mV per °C; eight readings of the 10-bit ADC are averaged. One ADC step is 5 V / 1023 = 4.9 mV, about 0.49 °C.
- both distances are printed, so the effect of compensation is seen in the same data.

## 4. The ruler test

At 11 known distances from 5 cm to 3 m (tape measure from the front of the sensor to a large flat wall), 20 readings each. For every distance `analyze_ruler_test.m` reports:

- the **mean error** (accuracy): a systematic error that more readings cannot remove;
- the **standard deviation** (repeatability): random error, which averaging does reduce, by √n.

Then a straight-line fit measured = a · true + b over all readings separates the two systematic errors: a ≠ 1 is a wrong speed of sound (it grows with distance), b ≠ 0 is a fixed delay in the electronics (the same at every distance). This is the "fit a line, read the physics from the slope" method of the coin-drop experiment (h against t², slope g/2).

Until the lab day, `simulate_ruler_test.m` writes a file in exactly the same format, with an explicit sensor model (stated at the top of the file). The analysis does not know whether its input is simulated.

## 5. Error budget

Independent errors add as the root sum of squares: σ = √(σ₁² + σ₂² + …). `error_budget.m` lists every source with the value it assumes. Temperature dominates without compensation; with compensation the largest remaining one is humidity (water vapour is lighter than air, so sound is up to 0.35 % faster), then the tape measure. The ultimate limits of the sensor itself (`pulseIn` resolution and echo jitter) are below 1 mm.

## 6. phyphox: an independent value of v

The ruler test uses the formula for v; the phyphox experiment measures v without the ultrasonic sensor at all. Two phones d apart run Acoustic Stopwatch. A clap at A starts A at once and B after d/v; a clap at B stops B at once and A after d/v:

    tA = T + d/v,   tB = T − d/v   →   v = 2d / (tA − tB)

The time between the claps and the reaction times cancel. With d = 5 m the difference is only about 29 ms, so 1 ms of trigger error is 3 % of v: repeat 5–10 times and report the mean with its standard error, σ/√n.

## 7. Ultrasonic vs LiDAR

Both sensors measure time of flight; they differ in what travels.

| | Ultrasonic | LiDAR |
| --- | --- | --- |
| carrier | sound, 40 kHz, wavelength 8.6 mm | infrared light, about 905 nm |
| speed | 343 m/s, depends on temperature | 3 · 10⁸ m/s, constant |
| beam | cone of about 15° | a few mrad |
| fails on | angled surfaces (specular reflection), soft absorbers | glass, mirrors, black surfaces |

A surface much smoother than the wavelength reflects like a mirror. For sound (8.6 mm) almost every wall is smooth, so a wall at 45° sends the echo away. For light (905 nm) most surfaces are rough, scattering light back in all directions, except glass and mirrors. Each sensor fails where the other works, which is the physical argument for sensor fusion.

## Notes for the three tracks

- **Embedded systems and edge AI.** Five pings and a median take about 150 ms per reading; the temperature correction is one multiply. Knowing the error budget tells a robot how much margin to keep, which matters more than one more decimal place.
- **FPGA to semiconductors.** On an FPGA the echo time is counted with the clock directly: at 100 MHz one count is 10 ns, 1.7 µm of distance, so the sensor, not the timer, sets the limit.
- **Product security.** An ultrasonic sensor can be jammed or spoofed with a 40 kHz source, a LiDAR with a laser. Different physics means an attacker has to defeat both at once, a second argument for fusion.

## Possible extensions

- add a humidity sensor (DHT22 or BME280) and the humidity term of the speed of sound;
- measure the beam width: move a pole sideways at fixed distance and record where it disappears;
- calibrate a and b from the real ruler test and check them on a second day.
