ElementsOne <- c(
  
  "cranium", 
  "neurocranium_bone", "neurocranium_bone_indet", "frontal_bone", "parietal_bone", "parietal_bone_indet",
  "parietal_bone_right", "parietal_bone_left", "temporal", "temporal_bone_indet", "temporal_right", "temporal_left",
  "occipital", "sphenoid", "ethmoid", 
  "splanchnocranium", "splanchnocranium_indet", "maxilla", "palatine_bone",
  "zygomatic_bone", "zygomatic_bone_indet", "zygomatic_bone_right", "zygomatic_bone_left", "nasal_bone",
  "lacrimal_bone", "vomer_bone", "inferior_nasal_concha", "ossicles_of_the_middle_ear",
  "ossicles_of_the_middle_ear_indet", "malleus", "malleus_indet", "malleus_right", "malleus_left", "incus",
  "incus_indet", "incus_right", "incus_left", "stapes", "stapes_indet", "stapes_right", "stapes_left", 
  "mandible",
  
  
  "teeth", 
  "deciduous","deciduous_indet", 
  "di1", "dl1_indet", "di1_superior", "di1_superior_indet", "di1_superior_right",
  "di1_superior_left", "dl1_inferior", "dl1_inferior_indet", "dl1_inferior_right", "dl1_inferior_left", "di2",
  "dl2_indet", "di2_superior", "di2_superior_indet", "di2_superior_right", "di2_superior_left", "dl2_inferior",
  "di2_inferior_indet", "di2_inferior_right", "di2_inferior_left", "dc", "dc_indet", "dc_superior",
  "dc_superior_indet", "dc_superior_right", "dc_superior_left", "dc_inferior", "dc_inferior_indet",
  "dc_inferior_right", "dc_inferior_left", "dm1", "dm1_indet", "dm1_superior", "dm1_superior_indet",
  "dm1_superior_left", "dm1_superior_right", "dm1_inferior", "dm1_inferior_indet", "dm1_inferior_right",
  "dm1_inferior_left", "dm2", "dm2_indet", "dm2_superior", "dm2_superior_indet", "dm2_superior_right",
  "dm2_superior_left", "dm2_inferior", "dm2_inferior_indet", "dm2_inferior_right", "dm2_inferior_left", 
  
  "permanent", "permanent_indet",
  "i1", "i1_indet", "i1_superior", "i1_superior_indet", "i1_superior_right", "i1_superior_left", "i1_inferior",
  "i1_inferior_indet", "i1_inferior_right", "i1_inferior_left", "i2", "i2_indet", "i2_superior", "i2_superior_indet",
  "i2_superior_right", "i2_superior_left", "i2_inferior", "i2_inferior_indet", "i2_inferior_right", "i2_inferior_left",
  "c", "c_indet", "c_superior", "c_superior_indet", "c_superior_right", "c_superior_left", "c_inferior",
  "c_inferior_indet", "c_inferior_right", "c_inferior_left", "pm3", "pm3_indet", "pm3_superior", "pm3_superior_indet",
  "pm3_superior_right", "pm3_superior_left", "pm3_inferior", "pm3_inferior_indet", "pm3_inferior_right",
  "pm3_inferior_left", "pm4", "pm4_indet", "pm4_superior", "pm4_superior_indet", "pm4_superior_right",
  "pm4_superior_left", "pm4_inferior", "pm4_inferior_indet", "pm4_inferior_right", "pm4_inferior_left", "m1",
  "m1_indet", "m1_superior", "m1_superior_indet", "m1_superior_right", "m1_superior_left", "m1_inferior",
  "m1_inferior_indet", "m1_inferior_right", "m1_inferior_left", "m2", "m2_indet", "m2_superior", "m2_superior_indet",
  "m2_superior_right", "m2_superior_left", "m2_inferior", "m2_inferior_indet", "m2_inferior_right", "m2_inferior_left",
  "m3", "m3_indet", "m3_superior", "m3_superior_indet", "m3_superior_right", "m3_superior_left", "m3_inferior",
  "m3_inferior_indet", "m3_inferior_right", "m3_inferior_left", 
  
  "hyoid", 
  
  "vertebrae", "vertebrae_indet", "cervical",
  "cervical_indet", "c1_atlas", "c2_axis", "c3", "c4", "c5", "c6", "c7", "thoracic", "thoracic_indet", "t1", "t2",
  "t3", "t4", "t5", "t6", "t7", "t8", "t9", "t10", "t11", "t12", "lumbar", "lumbar_indet", "l1", "l2", "l3", "l4",
  "l5", 
  
  "thorax", 
  "thorax_indet", 
  "sternum", 
  "rib", "rib_fragments", "rib_indet", 
  "rib_1", "rib_1_right", "rib_1_left", "rib_2", "rib_2_right", "rib_2_left", "rib_3", "rib_3_right",
  "rib_3_left", "rib_4", "rib_4_right", "rib_4_left", "rib_5", "rib_5_right", "rib_5_left", "rib_6",
  "rib_6_right", "rib_6_left", "rib_7", "rib_7_right", "rib_7_left", "rib_8", "rib_8_right", "rib_8_left",
  "rib_9", "rib_9_right", "rib_9_left", "rib_10", "rib_10_right", "rib_10_left", "rib_11",
  "rib_11_right", "rib_11_left", "rib_12", "rib_12_right", "rib_12_left", 
  
  "shoulder", "shoulder_indet",
  "clavicle", "clavicle_indet", "clavicle_right", "clavicle_left", "scapula", "scapula_indet", "scapula_right",
  "scapula_left", 
  
  "arms", "arms_indet", 
  "humerus", "humerus_indet", "humerus_right", "humerus_left", "radius",
  "radius_indet", "radius_right", "radius_left", "ulna", "ulna_indet", "ulna_right", "ulna_left", 
  
  "hands",
  "hands_indet", 
  "carpal", "carpal_indet", "carpal_right", "carpal_right_indet", "trapezium_right", "trapezoid_right",
  "hamate_right", "triquetrum_right", "lunate_right", "pisiform_right", "capitate_right", "scaphoid_right",
  "carpal_left", "carpal_left_indet", "trapezium_left", "trapezoid_left", "hamate_left", "triquetrum_left",
  "lunate_left", "pisiform_left", "capitate_left", "scaphoid_left", 
  "metacarpal", "metacarpal_indet",
  "metacarpal_right", "metacarpal_right_indet", "metacarpal_1_right", "metacarpal_2_right", "metacarpal_3_right",
  "metacarpal_4_right", "metacarpal_5_right", "metacarpal_left", "metacarpal_left_indet", "metacarpal_1_left",
  "metacarpal_2_left", "metacarpal_3_left", "metacarpal_4_left", "metacarpal_5_left", 
  "hand_phalanx",
  "hand_phalanx_indet", 
  "hand_phalanx_proximal ", "hand_phalanx_proximal_indet", "hand_phalanx_right",
  "hand_phalanx_proximal_right_indet", "hand_phalanx_proximal_1_right", "hand_phalanx_proximal_2_right",
  "hand_phalanx_proximal_3_right", "hand_phalanx_proximal_4_right", "hand_phalanx_proximal_5_right",
  "hand_phalanx_left", "hand_phalanx_proximal_left_indet", "hand_phalanx_proximal_1_left",
  "hand_phalanx_proximal_2_left", "hand_phalanx_proximal_3_left", "hand_phalanx_proximal_4_left",
  "hand_phalanx_proximal_5_left", 
  "hand_phalanx_middle ", "hand_phalanx_middle_indet", "hand_middle_right",
  "hand_phalanx_middle_right_indet", "hand_phalanx_middle_2_right", "hand_phalanx_middle_3_right",
  "hand_phalanx_middle_4_right", "hand_phalanx_middle_5_right", "hand_middle_left", "hand_phalanx_middle_left_indet",
  "hand_phalanx_middle_2_left", "hand_phalanx_middle_3_left", "hand_phalanx_middle_4_left",
  "hand_phalanx_middle_5_left", 
  "hand_phalanx_distal", "hand_phalanx_distal_indet", "hand_phalanx_distal_right",
  "hand_phalanx_distal_right_indet", "hand_phalanx_distal_right_1", "hand_phalanx_distal_right_2",
  "hand_phalanx_distal_right_3", "hand_phalanx_distal_right_4", "hand_phalanx_distal_right_5", "hand_distal_left",
  "hand_phalanx_distal_left_indet", "hand_phalanx_distal_left_1", "hand_phalanx_distal_left_2",
  "hand_phalanx_distal_left_3", "hand_phalanx_distal_left_4", "hand_phalanx_distal_left_5", 
  
  "pelvic", "pelvic_indet",
  "sacrum", "sacrum_indet", "s1", "s2", "s3", "s4", "s5", "coccyx", "coccyx_indet", "cx1", "cx2", "cx3", "cx4",
  "os_coxae", "os_coxae_indet", "os_coxae_right", "os_coxae_right_indet", "ilium_right", "ischium_right",
  "pubis_right", "os_coxae_left", "os_coxae_left_indet", "ilium_left", "ischium_left", "pubis_left", 
  
  "legs",
  "legs_indet", "femur", "femur_indet", "femur_right", "femur_left", "tibia", "tibia_indet", "tibia_right",
  "tibia_left", "fibula", "fibula_indet", "fibula_right", "fibula_left", "patella", "patella_indet", "patella_right",
  "patella_left", 
  
  "foot", "foot_indet", 
  "tarsal", "tarsal_indet", "tarsal_right", "tarsal_right_indet", "talus_right",
  "calcaneous_right", "cuboid_right", "navicular_right", "lateral_cuneiform_right", "intermediate_cuneiform_right",
  "medial_cuneiform_right", "tarsal_left", "tarsal_left_indet", "talus_left", "calcaneous_left", "cuboid_left",
  "navicular_left", "lateral_cuneiform_left", "intermediate_cuneiform_left", "medial_cuneiform_left", 
  "metatarsal",
  "metatarsal_indet", "metatarsal_right", "metatarsal_right_indet", "metatarsal_1_right", "metatarsal_2_right",
  "metatarsal_3_right", "metatarsal_4_right", "metatarsal_5_right", "metatarsal_left", "metatarsal_left_indet",
  "metatarsal_1_left", "metatarsal_2_left", "metatarsal_3_left", "metatarsal_4_left", "metatarsal_5_left",
  "foot_phalanx", "foot_phalanx_indet", 
  "foot_phalanx_proximal ", "foot_phalanx_proximal_indet", "foot_proximal_right",
  "foot_phalanx_proximal_right_indet", "foot_phalanx_proximal_1_right", "foot_phalanx_proximal_2_right",
  "foot_phalanx_proximal_3_right", "foot_phalanx_proximal_4_right", "foot_phalanx_proximal_5_right",
  "foot_phalanx_left", "foot_phalanx_proximal_left_indet", "foot_phalanx_proximal_1_left",
  "foot_phalanx_proximal_2_left", "foot_phalanx_proximal_3_left", "foot_phalanx_proximal_4_left",
  "foot_phalanx_proximal_5_left", 
  "foot_phalanx_middle ", "foot_phalanx_middle_indet", "foot_middle_right",
  "foot_phalanx_middle_right_indet", "foot_phalanx_middle_2_right", "foot_phalanx_middle_3_right",
  "foot_phalanx_middle_4_right", "foot_phalanx_middle_5_right", "foot_middle_left", "foot_phalanx_middle_left_indet",
  "foot_phalanx_middle_2_left", "foot_phalanx_middle_3_left", "foot_phalanx_middle_4_left",
  "foot_phalanx_middle_5_left", 
  "foot_phalanx_distal", "foot_phalanx_distal_indet", "foot_phalanx_distal_right",
  "foot_phalanx_distal_right_indet", "foot_phalanx_distal_right_1", "foot_phalanx_distal_right_2",
  "foot_phalanx_distal_right_3", "foot_phalanx_distal_right_4", "foot_phalanx_distal_right_5", "foot_distal_left",
  "foot_phalanx_distal_left_indet", "foot_phalanx_distal_left_1", "foot_phalanx_distal_left_2",
  "foot_phalanx_distal_left_3", "foot_phalanx_distal_left_4", "foot_phalanx_distal_left_5"
)
Level <- c(
  1, 2, 3, 3, 3, 4, 4, 4, 3, 4, 4, 4, 3, 3, 3, 
  2, 3, 3, 3, 3, 4, 4, 4, 3, 3, 3, 3, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 4, 5,
  5, 5, 
  3, 
  
  1, 2, 3, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 3, 4, 4, 5,
  5, 5, 4, 5, 5, 5, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 
  2, 3, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 3, 4,
  4, 5, 5, 5, 4, 5, 5, 5, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 3,
  4, 4, 5, 5, 5, 4, 5, 5, 5, 3, 4, 4, 5, 5, 5, 4, 5, 5, 5, 
  
  1, 
  
  1, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3,
  3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 
  
  1, 2, 2, 2, 3, 3, 3, 4, 4, 3, 4, 4, 3, 4, 4, 3, 4, 4, 3, 4, 4, 3, 4, 4, 
  3, 4, 4, 3, 4, 4, 3, 4, 4, 3, 4, 4, 3, 4, 4, 3, 4, 4,  
  
  1, 2, 2, 3, 3, 3, 2, 3, 3, 3, 
  
  1, 2, 2, 3, 3, 3, 2, 3, 3, 3, 2, 3, 3, 3, 
  
  1, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 3, 3, 4, 4, 4, 4, 4, 4, 3, 4, 4,
  4, 4, 4, 4, 2, 3, 3, 4, 4, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5, 3, 4, 4, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 3, 4, 4,
  5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5, 
  
  1, 2, 2, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 2, 3, 3, 4, 4, 4, 4, 3, 4, 4, 4,4, 
  
  1, 2, 2, 3, 3, 3, 2, 3, 3, 3, 2, 3, 3, 3, 2, 3, 3, 3, 
  
  1, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4,
  4, 4, 2, 3, 3, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4, 2, 3, 3, 4, 4, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5, 3, 4, 4,
  5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 3, 4, 4, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5
)
Bone_Count <- c(
  1, 1, 0, 1, 2, 0, 1, 1, 2, 0, 1, 1, 1, 1, 1, 
  1, 0, 2, 2, 2, 0, 1, 1, 2, 2, 1, 2, 6, 0, 2, 0, 1, 1, 2, 0, 1, 1, 2, 0, 1, 1, 
  1, 
  
  1, #32 (or +20) 
  20, 0, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 4, 0, 2,
  0, 1, 1, 2, 0, 1, 1, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 
  32, 0, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 4,
  0, 2, 0, 1, 1, 2, 0, 1, 1, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1,
  4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 
  
  1, 
  
  24, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 12, 0, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 5, 0, 1, 1, 1, 1, 1, 
  
  25, 0, 1, 24, 0, 0, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1,
  2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 
  
  4, 0, 2, 0, 1, 1, 2, 0, 1, 1, 

  6, 0, 2, 0, 1, 1, 2, 0,1, 1, 2, 0, 1, 1, 
  
  54, 0, 16, 0, 8, 0, 1, 1, 1, 1, 1, 1, 1, 1, 8, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 0, 5, 0, 1, 1, 1, 1,
  1, 5, 0, 1, 1, 1, 1, 1, 28, 0, 10, 0, 5, 0, 1, 1, 1, 1, 1, 5, 0, 1, 1, 1, 1, 1, 8, 0, 4, 0, 1, 1, 1, 1, 4, 0, 1, 1,
  1, 1, 10, 0, 5, 0, 1, 1, 1, 1, 1, 5, 0, 1, 1, 1, 1, 1, 
  
  4, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 2, 0, 1, 0, 1, 1,
  1, 1, 0, 1, 1, 1, 
  
  8, 0, 2, 0, 1, 1, 2, 0, 1, 1, 2, 0, 1, 1, 2, 0, 1, 1, 
  
  52, 0, 14, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 7,
  0, 1, 1, 1, 1, 1, 1, 1, 10, 0, 5, 0, 1, 1, 1, 1, 1, 5, 0, 1, 1, 1, 1, 1, 28, 0, 10, 0, 5, 0, 1, 1, 1, 1, 1, 5, 0, 1,
  1, 1, 1, 1, 8, 0, 4, 0, 1, 1, 1, 1, 4, 0, 1, 1, 1, 1, 10, 0, 5, 0, 1, 1, 1, 1, 1, 5, 0, 1, 1, 1, 1, 1
)
Skeleton_Section <- c(
  "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium",
  "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium",
  "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium",
  "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium", "cranium",
  "cranium", "cranium", 
  
  "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", "teeth",
  "teeth", "teeth", "teeth", "teeth", "teeth", "teeth", 
  
  "hyoid", 
  
  "vertebrae", "vertebrae", "vertebrae", "vertebrae",
  "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae",
  "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae",
  "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae", "vertebrae",
  "vertebrae", 
  
  "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax",
  "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax",
  "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax",
  "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax", "thorax",
  "thorax", 
  
  "shoulder", "shoulder", "shoulder", "shoulder", "shoulder", "shoulder", "shoulder", "shoulder", "shoulder",
  "shoulder", 
  
  "arms", "arms", "arms", "arms", "arms", "arms", "arms", "arms", "arms", "arms", "arms", "arms", "arms",
  "arms", 
  
  "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands",
  "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands",
  "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands",
  "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands",
  "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands",
  "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands",
  "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", "hands", 
  
  "pelvic",
  "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic",
  "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic", "pelvic",
  "pelvic", "pelvic", "pelvic", "pelvic", 
  
  "legs", "legs", "legs", "legs", "legs", "legs", "legs", "legs", "legs",
  "legs", "legs", "legs", "legs", "legs", "legs", "legs", "legs", "legs", 
  
  "foot", "foot", "foot", "foot", "foot",
  "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot",
  "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot",
  "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot",
  "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot",
  "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot",
  "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot", "foot"
)

# rebuild elements_data
elements_data <- data.frame(
  ElementsOne = ElementsOne,
  Level = Level,
  Bone_Count = Bone_Count,
  Skeleton_Section = Skeleton_Section,
  stringsAsFactors = FALSE
)
