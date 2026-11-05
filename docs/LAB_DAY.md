# Lab-day procedure

About 2 hours. Everything here replaces a simulated file with a measured one; the analysis code stays the same.

## Bring

- Arduino Uno or Nano with USB cable, HC-SR04, LM35, breadboard, 7 jumper wires
- laptop with the Arduino IDE and MATLAB (or Octave), this repository cloned
- tape measure (at least 3 m), masking tape, a large flat wall or board
- two phones with phyphox installed
- for the targets: a glass pane or window, black cloth, a 2 cm pole (broom handle), a piece of foam, a mirror, a board you can hold at 45°
- the department's LiDAR, or a small one (TF-Luna, VL53L1X) on the same Arduino

## 1. Wiring and first check (15 min)

1. Wire as at the top of `arduino/ultrasonic_temp/ultrasonic_temp.ino`: HC-SR04 Trig → D9, Echo → D10; LM35 out → A0; both to 5 V and GND.
2. Upload the sketch, open the Serial Monitor at 115200 baud.
3. Check: the temperature is plausible (compare with a room thermometer), and a hand at about 30 cm reads about 30 cm.

## 2. Ruler test (45 min)

1. Tape the sensor on the table facing the wall; mark distances from the front of the sensor with masking tape: 5, 10, 20, 30, 50, 75, 100, 150, 200, 250, 300 cm.
2. At each distance, log at least 20 lines to a file named by the distance: `data/ruler_logs/5cm.csv`, `10cm.csv`, … (in the Serial Monitor: copy the lines into the file; or use any serial logger).
3. Write down the room temperature from a thermometer as well, for the report.
4. Join and analyse:

   ```matlab
   addpath('matlab');
   build_ruler_file('data/ruler_logs', 'data/ruler_test.csv');
   run_all          % now uses data/ruler_test.csv instead of the simulation
   ```

5. Then `python3 docs/figures.py` redraws the figure with the real data.

## 3. phyphox speed of sound (20 min)

1. Two phones on books at the same height, microphones facing each other, 5 m apart (measure microphone to microphone twice).
2. phyphox → Timers → Acoustic Stopwatch, Simple mode; raise the threshold until talking does not trigger it.
3. Arm both; clap sharply next to A, then the partner claps next to B. Write tA, tB and the temperature into `data/phyphox.csv` (copy `phyphox_template.csv`).
4. 5–10 trials. Then `phyphox_speed('data/phyphox.csv')`.

## 4. Targets: ultrasonic vs LiDAR (30 min)

1. For each target in `data/targets.csv`, place it at 100 cm (tape measure) in front of both sensors.
2. Write the ultrasonic reading (median of the compensated column over about 10 lines) and the LiDAR reading into the table; write 0 if a sensor gives no reading.
3. `compare_targets('data/targets.csv')` marks each one correct or wrong; compare with the predicted column.
4. Take a photo of each setup for the README.

## Afterwards

- commit `data/ruler_logs/`, `data/ruler_test.csv`, `data/phyphox.csv`, `data/targets.csv` and the new `results/`
- replace "simulated" in the README with the measured numbers, and the status line
- update the CV line from "simulated" to "tested on hardware"
