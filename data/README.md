# Data

| File | What it is |
| --- | --- |
| `ruler_test_simulated.csv` | **simulated** ruler test written by `simulate_ruler_test.m` (26 °C, seed 1): `true_cm,temp_c,echo_us,d_fixed_cm,d_comp_cm` |
| `phyphox_example.csv` | **simulated** example of five two-phone trials at 5 m, 23 °C |
| `phyphox_template.csv` | empty template for the real phyphox trials: `d_m,tA_s,tB_s,temp_c` |
| `targets.csv` | the seven test targets with the predicted behaviour of each sensor; the measured columns are filled on the lab day |

On the lab day (see [docs/LAB_DAY.md](../docs/LAB_DAY.md)):

- `ruler_logs/<distance>cm.csv`: the Arduino's raw lines at each tape-measure distance
- `ruler_test.csv`: joined by `build_ruler_file.m`; when it exists, `run_all` uses it instead of the simulation
- `phyphox.csv`: the real phyphox trials

Empty cells mean no echo (the Arduino prints `0` for the echo time and nothing for the distances).
