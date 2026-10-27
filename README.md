NeuroSense RF — HFSS simulation starter
========================================
Files: NeuroSense_RF_HFSS.vbs, board_top.svg, README.txt

IMPORTANT: This package contains a reproducible model script, NOT HFSS simulation results.
No HFSS solver is installed in this environment. Do not submit analytical estimates or hypothetical plots as HFSS outputs.

HFSS workflow:
1. Open Ansys Electronics Desktop on a licensed workstation.
2. Run the .vbs through Tools > Run Script (menu names vary by version).
3. Check the project is created; if your HFSS version rejects any command, use the generated geometry dimensions below to reconstruct it manually.
4. Verify substrate material FR4_epoxy is eps_r ~4.4 and tan_delta ~0.02 in YOUR installation.
5. Validate model, confirm lumped-port directions/field reference and ground, and inspect boundaries. A 50-ohm port renormalization is NOT proof of a 50-ohm microstrip.
6. Analyze All. Plot dB(S(2,1)) and dB(S(1,1)) against frequency.
7. Refine mesh and sweep near resonances; export plots as CSV/images. Save electric fields at selected frequency using an appropriate sweep setup.

Geometry (mm):
FR4: x0..50, y0..40, z0..1.6
Ground sheet: z=0, x0..50, y0..40
Feed sheet: z=1.6, x0..50, y18.5..21.5
Loop: x18..30, y22..34, width 1; bottom split x23..25
Feed-loop minimum gap = 0.5 mm
Port 1: x=0, y18.5..21.5, z0..1.6
Port 2: x=50, y18.5..21.5, z0..1.6
Air region: x-40..90, y-40..80, z-40..41.6

Notes:
- Model uses PEC conductor sheets for speed; replace with 35-micron copper for loss-aware fabrication assessment.
- Lumped ports are an expedient starting approximation. Validate and consider calibrated wave ports for quantitative comparisons.
- The loop may not show a useful notch in 1-6 GHz without tuning. Do not assume a resonance exists.
- This top-side sensing structure can be loaded with a dielectric sample above the loop. It does NOT measure cerebral blood flow or cognitive workload.
- To run a dielectric test, add a 15x15x3 mm block centered over loop with 0.5 mm clearance, assign eps_r 10 (then 20), and rerun. Compare notch frequency; these are synthetic test dielectrics, not biological tissues.
- Script compatibility can vary between AEDT versions. No execution validation has been possible here.
