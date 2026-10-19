# Skeletal-part representation: eight automated hypotheses

Each hypothesis treats skeletal-part representation as the **outcome** and a metadata variable as the **grouping cause/filter**. Use `%MNAU / %MAU / relative MNAU`-type values (not raw MNE) so assemblage size does not drive the comparison, and remember that representation profiles can reflect transport, destruction, recovery, identification or cultural selection — not one process automatically.

Pipeline per hypothesis: automated grouping → degenerate-ratio screening → Kruskal-Wallis + ε² + BH-FDR → Dunn post-hoc → PCA + PERMANOVA (with PERMDISP caveat) → three plotly 3D plots. Feature pool = the 63 RFE-ranked features (core 10 retained).


## Cross-experiment summary

|#                             |Hypothesis                       |Status |Grouping                           | Groups|   n| Sig feats|Top feature                       | Top eps2| PERMANOVA F|      p| Disp p|
|:-----------------------------|:--------------------------------|:------|:----------------------------------|------:|---:|---------:|:---------------------------------|--------:|-----------:|------:|------:|
|01_taphonomic_context         |Accumulation process             |ok     |taphonomic_context                 |      5| 128|        59|mnau_upper_appendicular_mean      |    0.650|       14.51| 0.0001|  0.011|
|02_depositional_environment   |Depositional environment         |ok     |karstic_system                     |      2| 121|         0|ProportionalRep_MNIbased_radius   |    0.077|        2.71| 0.0454|  0.047|
|03_funerary_x_cultural_period |Mortuary practice through time   |ok     |funerary_context × cultural_period |      5|  34|        49|mne_arms                          |    0.584|        5.72| 0.0001|  0.059|
|04_age_category               |Age-related preservation         |ok     |age_category                       |      5| 124|         1|mne_arms                          |    0.141|        2.72| 0.0034|  0.000|
|05_chronology_attrition       |Time depth / attrition           |ok     |geological_period                  |      3| 148|        17|mne_arms                          |    0.102|        1.67| 0.1150|  0.000|
|06_hominin_species            |Species (context-controlled)     |ok     |hominin_species                    |      4| 148|        56|density_evenness                  |    0.201|        2.54| 0.0097|  0.002|
|07_region_country             |Research-history / sampling bias |ok     |region                             |      5| 137|        39|mnau_distal_appendicular_mean     |    0.150|        1.99| 0.0277|  0.109|
|08_recovery_method            |Recovery / excavation bias       |ok     |discovery_context                  |      3|  94|         0|distal_appendicular_continuity_hm |    0.098|        0.77| 0.5616|  0.678|

## How to read these results

- **Strong, low-dispersion separation** (high ε², low PERMANOVA p, non-significant PERMDISP) is the most trustworthy signal.
- A **significant PERMDISP p** means the groups differ partly in *spread*, not only location — interpret the centroid difference cautiously.
- Experiments **07 (region/country)** and **08 (recovery method)** are bias-control checks: if they explain as much as the biological/cultural hypotheses, treat the latter as confounded by sampling/recovery.
- The recommended first-paper framing: representation differs more by accumulation process and depositional environment than by cultural period or species, **after** controlling for assemblage size and excavation completeness.


## Hypotheses in detail


### 01_taphonomic_context — Accumulation process
- **H:** Different accumulation causes produce different body-part profiles.
- **Expected:** Funerary contexts more anatomically balanced; carnivore/geological transport loses small, fragile, axial, low-density elements; cannibalism shows selective absence/over-representation of processed parts.
- **Why:** Strongest hypothesis: accumulation cause is directly linked to skeletal survival, transport and human/carnivore behaviour.
- **Result:** grouped by `taphonomic_context` into 5 groups; 59 significant features; top = mnau_upper_appendicular_mean (ε² = 0.65); PERMANOVA p = 1e-04. See `01_taphonomic_context/REPORT.md`.

### 02_depositional_environment — Depositional environment
- **H:** Depositional environment filters the skeleton before excavation.
- **Expected:** Cave interiors preserve more small elements; entrances/rockshelters show carnivore activity; fluvial deposits favour dense/large elements.
- **Why:** Tests whether site formation, not culture or species, explains anatomical differences.
- **Result:** grouped by `karstic_system` into 2 groups; 0 significant features; top = ProportionalRep_MNIbased_radius (ε² = 0.077); PERMANOVA p = 0.0454. See `02_depositional_environment/REPORT.md`.

### 03_funerary_x_cultural_period — Mortuary practice through time
- **H:** Mortuary practice changes completeness and element selection through time.
- **Expected:** Single inhumations approach complete skeletons; collective burials over-represent crania/long bones; non-inhumation contexts more fragmentary.
- **Why:** Separates intentional mortuary behaviour from preservation loss (Robb: human handling can pattern representation).
- **Result:** grouped by `funerary_context × cultural_period` into 5 groups; 49 significant features; top = mne_arms (ε² = 0.584); PERMANOVA p = 1e-04. See `03_funerary_x_cultural_period/REPORT.md`.

### 04_age_category — Age-related preservation
- **H:** Age affects preservation: infant/juvenile bones are smaller, less fused, more fragile.
- **Expected:** Infants/juveniles show lower representation of small unfused bones, axial elements, epiphyses, ribs, vertebrae, hands/feet, pelvis; adults more complete/identifiable.
- **Why:** Strong biological/taphonomic hypothesis; should be checked before interpreting cultural differences.
- **Result:** grouped by `age_category` into 5 groups; 1 significant features; top = mne_arms (ε² = 0.141); PERMANOVA p = 0.0034. See `04_age_category/REPORT.md`.

### 05_chronology_attrition — Time depth / attrition
- **H:** Older assemblages are more altered by long-term attrition and recovery bias.
- **Expected:** Earlier Pleistocene contexts lose fragile elements and over-represent teeth, cranial pieces, dense shafts; Holocene burials more complete.
- **Why:** Tests time-depth and preservation intensity (must be read alongside context).
- **Result:** grouped by `geological_period` into 3 groups; 17 significant features; top = mne_arms (ε² = 0.102); PERMANOVA p = 0.115. See `05_chronology_attrition/REPORT.md`.

### 06_hominin_species — Species (context-controlled)
- **H:** Species-level differences may reflect different depositional histories, not anatomy alone.
- **Expected:** Neanderthal / earlier Homo / H. sapiens may differ, but differences may vanish after controlling for age, site type, period, context.
- **Why:** Interesting but risky; do not read causally unless preservation and context are controlled.
- **Result:** grouped by `hominin_species` into 4 groups; 56 significant features; top = density_evenness (ε² = 0.201); PERMANOVA p = 0.0097. See `06_hominin_species/REPORT.md`.

### 07_region_country — Research-history / sampling bias
- **H:** Regional research history, geology, climate and excavation tradition affect recovery.
- **Expected:** Some regions more complete (cave preservation/modern excavation); others biased to diagnostic cranial/dental material.
- **Why:** Detects sampling and research-history bias; weaker as a behavioural hypothesis.
- **Result:** grouped by `region` into 5 groups; 39 significant features; top = mnau_distal_appendicular_mean (ε² = 0.15); PERMANOVA p = 0.0277. See `07_region_country/REPORT.md`.

### 08_recovery_method — Recovery / excavation bias
- **H:** Recovery method affects which bones enter the dataset.
- **Expected:** Formal/complete excavations recover more small bones; quarry/casual discoveries over-represent large, visible, diagnostic elements.
- **Why:** Essential bias-control analysis; may explain patterns that otherwise look biological or cultural.
- **Result:** grouped by `discovery_context` into 3 groups; 0 significant features; top = distal_appendicular_continuity_hm (ε² = 0.098); PERMANOVA p = 0.5616. See `08_recovery_method/REPORT.md`.

---
*Generated 2026-08-27 07:50.*
