"""Draws the README figures from the CSV files that run_all.m writes.

    octave-cli run_all.m     (or run it in MATLAB)
    python3 docs/figures.py  (needs numpy and matplotlib)

The numbers all come from the MATLAB/Octave run; this script only draws them.
"""
import csv
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, "..")
IMG = os.path.join(HERE, "img")
os.makedirs(IMG, exist_ok=True)

INK = "#3b4148"
GRID = "#d9dde1"
FIXED = "#d1495b"
COMP = "#2e86ab"
IDEAL = "#1b1f23"
plt.rcParams.update({"font.size": 10, "axes.edgecolor": INK, "axes.labelcolor": INK, "xtick.color": INK,
                     "ytick.color": INK, "axes.grid": True, "grid.color": GRID, "grid.linewidth": 0.6,
                     "axes.spines.top": False, "axes.spines.right": False, "legend.frameon": False,
                     "svg.fonttype": "none", "figure.facecolor": "white"})


def read(path):
    with open(os.path.join(ROOT, path)) as f:
        rows = [r for r in csv.reader(f) if r and not r[0].startswith("#")]
    head = rows[0]
    data = np.array([[float(x) if x else np.nan for x in r] for r in rows[1:]])
    return {name: data[:, i] for i, name in enumerate(head)}


def save(fig, name):
    fig.tight_layout()
    fig.savefig(os.path.join(IMG, name), facecolor="white")
    if os.environ.get("CHECK_PNG"):
        fig.savefig(os.path.join(os.environ["CHECK_PNG"], name.replace(".svg", ".png")), dpi=90)
    plt.close(fig)
    print("wrote", name)


# 1. speed of sound against temperature ----------------------------------------------------
s = read("results/speed_of_sound.csv")
fig, ax = plt.subplots(figsize=(6.4, 3.2))
ax.plot(s["temp_c"], s["v_ideal"], color=IDEAL, lw=2, label="ideal gas  331.3·√(1 + T/273.15)")
ax.plot(s["temp_c"], s["v_linear"], color=COMP, lw=1.5, ls="--", label="course formula  331.3 + 0.606·T")
ax.axhline(343, color=FIXED, lw=1.2, label="fixed 343 m/s (most Arduino examples)")
ax.set_xlabel("air temperature (°C)")
ax.set_ylabel("speed of sound (m/s)")
ax.legend(loc="upper left", fontsize=9)
save(fig, "speed_of_sound.svg")

# 2. ruler test: error against distance -----------------------------------------------------
r = read("results/ruler_summary.csv")
fig, ax = plt.subplots(figsize=(6.4, 3.4))
ax.axhline(0, color=INK, lw=0.8)
ax.errorbar(r["true_cm"], r["err_fixed_cm"], yerr=r["sd_fixed_cm"], color=FIXED, marker="o", ms=4,
            capsize=3, label="fixed 343 m/s")
ax.errorbar(r["true_cm"], r["err_comp_cm"], yerr=r["sd_comp_cm"], color=COMP, marker="s", ms=4,
            capsize=3, label="temperature-compensated (LM35)")
ax.set_xlabel("tape-measure distance (cm)")
ax.set_ylabel("measured − true (cm)")
ax.set_title("Simulated ruler test at %.0f °C (mean ± 1 SD of 20 readings)" % np.nanmean(r["mean_temp_c"]),
             fontsize=10, color=INK)
ax.legend(loc="lower left", fontsize=9)
save(fig, "ruler_error.svg")
