####################################################################################
meta_names <- c(
  "site_index", "sample_index", "site_name", "sum", "time_range", "geological_context",
  "number_of_individuals", "age", "gender", "accumulation_cause", "hominin_species"
)
####################################################################################
sections_order <- c("cranium","teeth","hyoid", "vertebrae", "thorax", "shoulder",
"arms", "hands", "pelvic", "legs", "foot")

####################################################################################
high_resolution <- c(
  "Zanclean", "Piacenzian",
  "Gelasian", "Calabrian", "Chibanian", "Tarantian",
  "Oldowan", "Acheulean", "Mousterian", "Aterian",
  "Aurignacian", "Gravettian", "Solutrean", "Magdalenian",
  "Natufian", "Kebaran", "Azilian", "Maglemosian",
  "Pre-Pottery Neolithic A", "Pre-Pottery Neolithic B", "Pottery Neolithic",
  "Chalcolithic",  # Added this line
  "Early Bronze Age", "Middle Bronze Age", "Late Bronze Age",
  "Early Iron Age", "Middle Iron Age", "Late Iron Age",
  "Medieval Period", "Early Modern Period", "Late Modern Period"
)

low_resolution <- c(
  rep("Pliocene", 2),
  rep("Lower Pleistocene", 2), "Middle Pleistocene", "Upper Pleistocene",
  rep("Lower Paleolithic", 2), rep("Middle Paleolithic", 2),
  rep("Upper Paleolithic", 4),
  rep("Epipaleolithic/Mesolithic", 4),
  rep("Neolithic", 3),
  "Chalcolithic",
  rep("Bronze Age", 3),
  rep("Iron Age", 3),
  rep("Modern", 3)
)

# Define time ranges for each period (in years before present)
time_ranges <- list(

  #"Lower Paleolithic" = c(3400000, 300000),
  "Middle Paleolithic" = c(300000, 50000),
  "Upper Paleolithic" = c(50000, 11700),
  "Epipaleolithic/Mesolithic" = c(15000, 5000),
  "Neolithic" = c(12000, 5000),
  "Chalcolithic" = c(7000, 3300),
  "Bronze Age" = c(5300, 1200),
  "Iron Age" = c(3200, 500),
  "Modern" = c(1500, 0),


  "Pliocene" = c(5333000, 2580000),
  "Lower Pleistocene" = c(2580000, 781000),
  "Middle Pleistocene" = c(781000, 126000),
  #"Middle Pleistocene (before 0.3 MA)" = c(781000, 126000),
  "Upper Pleistocene" = c(126000, 11700)
)
# Define high-resolution time ranges for each period (in years before present)
high_resolution_time_ranges <- list(
  "Zanclean" = c(5333000, 3600000),      # 5.333-3.6 MA
  "Piacenzian" = c(3600000, 2580000),    # 3.6-2.58 MA
  "Gelasian" = c(2580000, 1800000),      # 2.58-1.8 MA
  "Calabrian" = c(1800000, 773000),      # 1.8-0.773 MA
  "Chibanian" = c(773000, 126000),       # 773-126 ka
  "Tarantian" = c(126000, 11700),        # 126-11.7 ka
  "Oldowan" = c(2600000, 1700000),       # 2.6-1.7 MA
  "Acheulean" = c(1700000, 300000),      # 1.7-0.3 MA
  "Mousterian" = c(300000, 30000),       # 300-30 ka
  "Aterian" = c(145000, 30000),          # 145-30 ka
  "Aurignacian" = c(43000, 26000),       # 43-26 ka
  "Gravettian" = c(26000, 21000),        # 26-21 ka
  "Solutrean" = c(21000, 17000),         # 21-17 ka
  "Magdalenian" = c(17000, 11700),       # 17-11.7 ka
  "Natufian" = c(15000, 12500),          # 15-12.5 ka
  "Kebaran" = c(18000, 12500),           # 18-12.5 ka
  "Azilian" = c(11000, 9000),            # 11-9 ka
  "Maglemosian" = c(9000, 5800),         # 9-5.8 ka
  "Pre-Pottery Neolithic A" = c(10000, 9000),  # 10-9 ka
  "Pre-Pottery Neolithic B" = c(9000, 8500),   # 9-8.5 ka
  "Pottery Neolithic" = c(8500, 7000),         # 8.5-7 ka
  "Early Bronze Age" = c(5300 + 1950, 2100 + 1950),  # 3300-2100 BC
  "Middle Bronze Age" = c(2100 + 1950, 1550 + 1950), # 2100-1550 BC
  "Late Bronze Age" = c(1550 + 1950, 1200 + 1950),   # 1550-1200 BC
  "Early Iron Age" = c(1200 + 1950, 800 + 1950),     # 1200-800 BC
  "Middle Iron Age" = c(800 + 1950, 500 + 1950),     # 800-500 BC
  "Late Iron Age" = c(500 + 1950, 0),               # 500-0 BC
  "Medieval Period" = c(500, 1500),                 # 500-1500 AD
  "Early Modern Period" = c(1500, 1800),            # 1500-1800 AD
  "Late Modern Period" = c(1800, 0)                 # 1800 AD-Present
)
####################################################################################
hominin_species <- c(
  "Australopithecus anamensis",   # 4.2 - 3.9 million years ago
  "Australopithecus afarensis",   # 3.9 - 2.9 million years ago
  "Australopithecus africanus",   # 3.0 - 2.1 million years ago
  "Paranthropus aethiopicus",     # 2.7 - 2.3 million years ago
  "Homo habilis",                 # 2.8 - 1.5 million years ago
  "Homo rudolfensis",             # 2.4 - 1.9 million years ago
  "Paranthropus boisei",          # 2.3 - 1.2 million years ago
  "Paranthropus robustus",        # 2.0 - 1.2 million years ago
  "Homo ergaster",                # 1.9 - 1.4 million years ago
  "Homo erectus",                 # 1.9 million - 110,000 years ago
  "Homo antecessor",              # 1.2 million - 800,000 years ago
  "Homo heidelbergensis",         # 600,000 - 200,000 years ago
  "Neanderthals (Homo neanderthalensis)",  # 400,000 - 40,000 years ago
  "Denisovans",                   # 500,000 - 30,000 years ago
  "Homo naledi",                  # 335,000 - 236,000 years ago
  "Homo sapiens"                  # 300,000 years ago - present
)
####################################################################################
geological_context <- c(
  "Cave",
  "Sepulchral Cave",  # Included as a specific type of cave
  "Rockshelter",
  "Open air",
  "Surface disposal"
)
####################################################################################
age_category <- c(
  "Infant (0-2 years)",
  "Child (3-7 years)",
  "Adolescent (8-16 years)",
  "Subadult",  # General category if specific age is not available
  "Adult (17+ years)"
)
##########################################

##########################################
gender <- c(
  "Male",
  "Female",
  "Unknown" # Mixed groups or indeterminate
)
####################################################################################
accumulation_cause <- c(
  "Cannibalism",
  "Burial",
  "Collective burial",
  "Mass graves",  # Specific large-scale collective burials
  "Secondary position",  # Remains moved post-mortem
  "Surface disposal",  # Remains left exposed
  "Disposal",  # General category for any non-ceremonial discarding
  "Scavenged",  # Altered by animals post-mortem
  "Intentional accumulation",  # Human-driven collection
  "Funerary assemblage",  # Group of burial goods and remains
  "Cemetery",  # Organized burial area
  "Cuevas Sepulcrales",  # Sepulchral caves, specific burial sites
  "Transport or accumulation from carnivores",  # Non-human driven accumulation
  "Possible burial"  # Uncertain if burial context
)
####################################################################################
# Define the hierarchy for each section with bone counts
skeleton_hierarchy <- list(
  cranium <- list(
    "Level 1" = list(
      cranium = 1
    ),
  
    "Level 2" = list(
      neurocranium_bone = 1,
      splanchnocranium  = 1
    ),
  
    "Level 3" = list(
      neurocranium_bone = c(
        neurocranium_bone_indet = 0,
        frontal_bone  = 1,
        parietal_bone = 2,
        temporal      = 2,
        occipital     = 1,
        sphenoid      = 1,
        ethmoid       = 1
      ),
  
      splanchnocranium = c(
        splanchnocranium_indet = 0,
        maxilla               = 2,
        palatine_bone         = 2,
        zygomatic_bone        = 2,
        nasal_bone            = 2,
        lacrimal_bone         = 2,
        vomer_bone            = 1,
        inferior_nasal_concha = 2
      ),
  
      ossicles_of_the_middle_ear = 6,
      mandible = 1
    ),
  
    "Level 4" = list(
      neurocranium_bone = c(
        frontal_bone = 1,
  
        parietal_bone_indet = 0,
        parietal_bone_right = 1,
        parietal_bone_left  = 1,
  
        temporal_bone_indet = 0,
        temporal_right      = 1,
        temporal_left       = 1,
  
        occipital = 1,
        sphenoid  = 1,
        ethmoid   = 1
      ),
  
      splanchnocranium = c(
        maxilla       = 2,
        palatine_bone = 2,
  
        zygomatic_bone_indet = 0,
        zygomatic_bone_right = 1,
        zygomatic_bone_left  = 1,
  
        nasal_bone    = 2,
        lacrimal_bone = 2,
        vomer_bone    = 1,
        inferior_nasal_concha = 2
      ),
  
      ossicles_of_the_middle_ear = c(
        ossicles_of_the_middle_ear_indet = 0,
        malleus = 2,
        incus   = 2,
        stapes  = 2
      ),
  
      mandible = 1
    ),
  
    "Level 5" = list(
      neurocranium_bone = c(
        frontal_bone = 1,
  
        parietal_bone_indet = 0,
        parietal_bone_right = 1,
        parietal_bone_left  = 1,
  
        temporal_bone_indet = 0,
        temporal_right      = 1,
        temporal_left       = 1,
  
        occipital = 1,
        sphenoid  = 1,
        ethmoid   = 1
      ),
  
      splanchnocranium = c(
        maxilla       = 2,
        palatine_bone = 2,
  
        zygomatic_bone_indet = 0,
        zygomatic_bone_right = 1,
        zygomatic_bone_left  = 1,
  
        nasal_bone    = 2,
        lacrimal_bone = 2,
        vomer_bone    = 1,
        inferior_nasal_concha = 2
      ),
  
      ossicles_of_the_middle_ear = c(
        ossicles_of_the_middle_ear_indet = 0,
  
        malleus_indet = 0,
        malleus_right = 1,
        malleus_left  = 1,
  
        incus_indet = 0,
        incus_right = 1,
        incus_left  = 1,
  
        stapes_indet = 0,
        stapes_right = 1,
        stapes_left  = 1
      ),
  
      mandible = 1
    )
  )
  ,
  teeth <- list(
    "Level 1" = list(
      teeth = 32
    ),
  
    "Level 2" = list(
      deciduous_indet = 20,
      permanent       = 32
    ),
  
    "Level 3" = list(
      deciduous_indet = c(
        di1 = 4,
        di2 = 4,
        dc  = 4,
        dm1 = 4,
        dm2 = 4
      ),
  
      permanent = c(
        i1  = 4,
        i2  = 4,
        c   = 4,
        pm3 = 4,
        pm4 = 4,
        m1  = 4,
        m2  = 4,
        m3  = 4
      )
    ),
  
    "Level 4" = list(
      deciduous_indet = c(
        dl1_indet = 0,
        di1_superior = 2,
        dl1_inferior = 2,
  
        dl2_indet = 0,
        di2_superior = 2,
        di2_inferior = 2,
  
        dc_indet = 0,
        dc_superior = 2,
        dc_inferior = 2,
  
        dm1_indet = 0,
        dm1_superior = 2,
        dm1_inferior = 2,
  
        dm2_indet = 0,
        dm2_superior = 2,
        dm2_inferior = 2
      ),
  
      permanent = c(
        i1_indet = 0,
        i1_superior = 2,
        i1_inferior = 2,
  
        i2_indet = 0,
        i2_superior = 2,
        i2_inferior = 2,
  
        c_indet = 0,
        c_superior = 2,
        c_inferior = 2,
  
        pm3_indet = 0,
        pm3_superior = 2,
        pm3_inferior = 2,
  
        pm4_indet = 0,
        pm4_superior = 2,
        pm4_inferior = 2,
  
        m1_indet = 0,
        m1_superior = 2,
        m1_inferior = 2,
  
        m2_indet = 0,
        m2_superior = 2,
        m2_inferior = 2,
  
        m3_indet = 0,
        m3_superior = 2,
        m3_inferior = 2
      )
    ),
  
    "Level 5" = list(
      deciduous_indet = c(
        di1_superior_indet = 0,
        di1_superior_right = 1,
        di1_superior_left  = 1,
        dl1_inferior_indet = 0,
        di1_inferior_right = 1,
        di1_inferior_left  = 1,
  
        di2_superior_indet = 0,
        di2_superior_right = 1,
        di2_superior_left  = 1,
        di2_inferior_indet = 0,
        di2_inferior_right = 1,
        di2_inferior_left  = 1,
  
        dc_superior_indet = 0,
        dc_superior_right = 1,
        dc_superior_left  = 1,
        dc_inferior_indet = 0,
        dc_inferior_right = 1,
        dc_inferior_left  = 1,
  
        dm1_superior_indet = 0,
        dm1_superior_right = 1,
        dm1_superior_left  = 1,
        dm1_inferior_indet = 0,
        dm1_inferior_right = 1,
        dm1_inferior_left  = 1,
  
        dm2_superior_indet = 0,
        dm2_superior_right = 1,
        dm2_superior_left  = 1,
        dm2_inferior_indet = 0,
        dm2_inferior_right = 1,
        dm2_inferior_left  = 1
      ),
  
      permanent = c(
        i1_superior_indet = 0,
        i1_superior_right = 1,
        i1_superior_left  = 1,
        i1_inferior_indet = 0,
        i1_inferior_right = 1,
        i1_inferior_left  = 1,
  
        i2_superior_indet = 0,
        i2_superior_right = 1,
        i2_superior_left  = 1,
        i2_inferior_indet = 0,
        i2_inferior_right = 1,
        i2_inferior_left  = 1,
  
        c_superior_indet = 0,
        c_superior_right = 1,
        c_superior_left  = 1,
        c_inferior_indet = 0,
        c_inferior_right = 1,
        c_inferior_left  = 1,
  
        pm3_superior_indet = 0,
        pm3_superior_right = 1,
        pm3_superior_left  = 1,
        pm3_inferior_indet = 0,
        pm3_inferior_right = 1,
        pm3_inferior_left  = 1,
  
        pm4_superior_indet = 0,
        pm4_superior_right = 1,
        pm4_superior_left  = 1,
        pm4_inferior_indet = 0,
        pm4_inferior_right = 1,
        pm4_inferior_left  = 1,
  
        m1_superior_indet = 0,
        m1_superior_right = 1,
        m1_superior_left  = 1,
        m1_inferior_indet = 0,
        m1_inferior_right = 1,
        m1_inferior_left  = 1,
  
        m2_superior_indet = 0,
        m2_superior_right = 1,
        m2_superior_left  = 1,
        m2_inferior_indet = 0,
        m2_inferior_right = 1,
        m2_inferior_left  = 1,
  
        m3_superior_indet = 0,
        m3_superior_right = 1,
        m3_superior_left  = 1,
        m3_inferior_indet = 0,
        m3_inferior_right = 1,
        m3_inferior_left  = 1
      )
    )
  )
  
,
 # --- HYOID ------------------------------------------------------------
hyoid <- list(
  "Level 1" = list(
    hyoid = 1
  )
)
,
# --- VERTEBRAE --------------------------------------------------------
vertebrae <- list(
  "Level 1" = list(
    vertebrae = 24
  ),

  "Level 2" = list(
    vertebrae_indet = 0,
    cervical = 7,
    thoracic = 12,
    lumbar   = 5
  ),

  "Level 3" = list(
    cervical = c(
      cervical_indet = 0,
      c1_atlas = 1,
      c2_axis  = 1,
      c3 = 1,
      c4 = 1,
      c5 = 1,
      c6 = 1,
      c7 = 1
    ),

    thoracic = c(
      thoracic_indet = 0,
      t1  = 1,
      t2  = 1,
      t3  = 1,
      t4  = 1,
      t5  = 1,
      t6  = 1,
      t7  = 1,
      t8  = 1,
      t9  = 1,
      t10 = 1,
      t11 = 1,
      t12 = 1
    ),

    lumbar = c(
      lumbar_indet = 0,
      l1 = 1,
      l2 = 1,
      l3 = 1,
      l4 = 1,
      l5 = 1
    )
  )
)
,
# --- THORAX -----------------------------------------------------------
thorax <- list(
  "Level 1" = list(
    thorax = 25
  ),

  "Level 2" = list(
    thorax_indet = 0,
    sternum = 1,
    ribs    = 24
  ),

  "Level 3" = list(
    sternum = c(
      sternum = 1
    ),

    ribs = c(
      rib_indet      = 0,
      rib_fragments  = 0,
      ribs_right     = 12,
      ribs_left      = 12
    )
  ),

  "Level 4" = list(
    sternum = c(
      sternum = 1
    ),

    ribs = c(
      rib_1_indet  = 0, rib_1_right  = 1, rib_1_left  = 1,
      rib_2_indet  = 0, rib_2_right  = 1, rib_2_left  = 1,
      rib_3_indet  = 0, rib_3_right  = 1, rib_3_left  = 1,
      rib_4_indet  = 0, rib_4_right  = 1, rib_4_left  = 1,
      rib_5_indet  = 0, rib_5_right  = 1, rib_5_left  = 1,
      rib_6_indet  = 0, rib_6_right  = 1, rib_6_left  = 1,
      rib_7_indet  = 0, rib_7_right  = 1, rib_7_left  = 1,
      rib_8_indet  = 0, rib_8_right  = 1, rib_8_left  = 1,
      rib_9_indet  = 0, rib_9_right  = 1, rib_9_left  = 1,
      rib_10_indet = 0, rib_10_right = 1, rib_10_left = 1,
      rib_11_indet = 0, rib_11_right = 1, rib_11_left = 1,
      rib_12_indet = 0, rib_12_right = 1, rib_12_left = 1
    )
  )
)
,
# --- SHOULDER ---------------------------------------------------------
shoulder <- list(
  "Level 1" = list(
    shoulder = 4
  ),

  "Level 2" = list(
    shoulder_indet = 0,
    clavicle = 2,
    scapula  = 2
  ),

  "Level 3" = list(
    clavicle = c(
      clavicle_indet = 0,
      clavicle_right = 1,
      clavicle_left  = 1
    ),

    scapula = c(
      scapula_indet = 0,
      scapula_right = 1,
      scapula_left  = 1
    )
  )
)
,
# --- ARMS -------------------------------------------------------------
arms <- list(
  "Level 1" = list(
    arms = 6
  ),

  "Level 2" = list(
    arms_indet = 0,
    humerus = 2,
    radius  = 2,
    ulna    = 2
  ),

  "Level 3" = list(
    humerus = c(
      humerus_indet = 0,
      humerus_right = 1,
      humerus_left  = 1
    ),

    radius = c(
      radius_indet = 0,
      radius_right = 1,
      radius_left  = 1
    ),

    ulna = c(
      ulna_indet = 0,
      ulna_right = 1,
      ulna_left  = 1
    )
  )
)
,
# --- HANDS ------------------------------------------------------------
hands <- list(
  "Level 1" = list(
    hands = 54
  ),

  "Level 2" = list(
    hands_indet = 0,
    carpal      = 16,
    metacarpal  = 10,
    hand_phalanx = 28
  ),

  "Level 3" = list(
    carpal = c(
      carpal_indet = 0,
      carpal_right = 8,
      carpal_left  = 8
    ),

    metacarpal = c(
      metacarpal_indet = 0,
      metacarpal_right = 5,
      metacarpal_left  = 5
    ),

    hand_phalanx = c(
      hand_phalanx_indet     = 0,
      hand_phalanx_proximal  = 10,
      hand_phalanx_middle    = 8,
      hand_phalanx_distal    = 10
    )
  ),

  "Level 4" = list(
    carpal = list(
      carpal_right = c(
        carpal_right_indet = 0,
        trapezium_right   = 1,
        trapezoid_right   = 1,
        hamate_right      = 1,
        triquetrum_right  = 1,
        lunate_right      = 1,
        pisiform_right    = 1,
        capitate_right    = 1,
        scaphoid_right    = 1
      ),
      carpal_left = c(
        carpal_left_indet = 0,
        trapezium_left   = 1,
        trapezoid_left   = 1,
        hamate_left      = 1,
        triquetrum_left  = 1,
        lunate_left      = 1,
        pisiform_left    = 1,
        capitate_left    = 1,
        scaphoid_left    = 1
      )
    ),

    metacarpal = list(
      metacarpal_right = c(
        metacarpal_right_indet = 0,
        metacarpal_1_right = 1,
        metacarpal_2_right = 1,
        metacarpal_3_right = 1,
        metacarpal_4_right = 1,
        metacarpal_5_right = 1
      ),
      metacarpal_left = c(
        metacarpal_left_indet = 0,
        metacarpal_1_left = 1,
        metacarpal_2_left = 1,
        metacarpal_3_left = 1,
        metacarpal_4_left = 1,
        metacarpal_5_left = 1
      )
    ),

    hand_phalanx = list(
      hand_phalanx_proximal = c(
        hand_phalanx_proximal_indet = 0,
        hand_phalanx_right = 5,
        hand_phalanx_left  = 5
      ),
      hand_phalanx_middle = c(
        hand_phalanx_middle_indet = 0,
        hand_middle_right = 4,
        hand_middle_left  = 4
      ),
      hand_phalanx_distal = c(
        hand_phalanx_distal_indet = 0,
        hand_phalanx_distal_right = 5,
        hand_distal_left          = 5
      )
    )
  ),

  "Level 5" = list(
    hand_phalanx = list(
      hand_phalanx_proximal = c(
        hand_phalanx_proximal_right_indet = 0,
        hand_phalanx_proximal_1_right = 1,
        hand_phalanx_proximal_2_right = 1,
        hand_phalanx_proximal_3_right = 1,
        hand_phalanx_proximal_4_right = 1,
        hand_phalanx_proximal_5_right = 1,

        hand_phalanx_proximal_left_indet = 0,
        hand_phalanx_proximal_1_left = 1,
        hand_phalanx_proximal_2_left = 1,
        hand_phalanx_proximal_3_left = 1,
        hand_phalanx_proximal_4_left = 1,
        hand_phalanx_proximal_5_left = 1
      ),

      hand_phalanx_middle = c(
        hand_phalanx_middle_right_indet = 0,
        hand_phalanx_middle_2_right = 1,
        hand_phalanx_middle_3_right = 1,
        hand_phalanx_middle_4_right = 1,
        hand_phalanx_middle_5_right = 1,

        hand_phalanx_middle_left_indet = 0,
        hand_phalanx_middle_2_left = 1,
        hand_phalanx_middle_3_left = 1,
        hand_phalanx_middle_4_left = 1,
        hand_phalanx_middle_5_left = 1
      ),

      hand_phalanx_distal = c(
        hand_phalanx_distal_right_indet = 0,
        hand_phalanx_distal_right_1 = 1,
        hand_phalanx_distal_right_2 = 1,
        hand_phalanx_distal_right_3 = 1,
        hand_phalanx_distal_right_4 = 1,
        hand_phalanx_distal_right_5 = 1,

        hand_phalanx_distal_left_indet = 0,
        hand_phalanx_distal_left_1 = 1,
        hand_phalanx_distal_left_2 = 1,
        hand_phalanx_distal_left_3 = 1,
        hand_phalanx_distal_left_4 = 1,
        hand_phalanx_distal_left_5 = 1
      )
    )
  )
)


  ,
# --- PELVIC -----------------------------------------------------------
pelvic <- list(
  "Level 1" = list(
    pelvic = 4
  ),

  "Level 2" = list(
    pelvic_indet = 0,
    sacrum   = 1,
    coccyx   = 1,
    os_coxae = 2
  ),

  "Level 3" = list(
    sacrum = c(
      sacrum_indet = 0,
      s1 = 1, s2 = 1, s3 = 1, s4 = 1, s5 = 1
    ),

    coccyx = c(
      coccyx_indet = 0,
      cx1 = 1, cx2 = 1, cx3 = 1, cx4 = 1
    ),

    os_coxae = c(
      os_coxae_indet = 0,
      os_coxae_right = 1,
      os_coxae_left  = 1
    )
  ),

  "Level 4" = list(
    os_coxae = list(
      os_coxae_right = c(
        os_coxae_right_indet = 0,
        ilium_right   = 1,
        ischium_right = 1,
        pubis_right   = 1
      ),
      os_coxae_left = c(
        os_coxae_left_indet = 0,
        ilium_left   = 1,
        ischium_left = 1,
        pubis_left   = 1
      )
    )
  )
)
,
# --- LEGS -------------------------------------------------------------
legs <- list(
  "Level 1" = list(
    legs = 8
  ),

  "Level 2" = list(
    legs_indet = 0,
    femur   = 2,
    tibia   = 2,
    fibula  = 2,
    patella = 2
  ),

  "Level 3" = list(
    femur = c(
      femur_indet  = 0,
      femur_right  = 1,
      femur_left   = 1
    ),

    tibia = c(
      tibia_indet  = 0,
      tibia_right  = 1,
      tibia_left   = 1
    ),

    fibula = c(
      fibula_indet = 0,
      fibula_right = 1,
      fibula_left  = 1
    ),

    patella = c(
      patella_indet = 0,
      patella_right = 1,
      patella_left  = 1
    )
  )
)
,
# --- FOOT -------------------------------------------------------------
foot <- list(
  "Level 1" = list(
    foot = 52
  ),

  "Level 2" = list(
    foot_indet   = 0,
    tarsal       = 14,
    metatarsal   = 10,
    foot_phalanx = 28
  ),

  "Level 3" = list(
    tarsal = c(
      tarsal_indet = 0,
      tarsal_right = 7,
      tarsal_left  = 7
    ),

    metatarsal = c(
      metatarsal_indet = 0,
      metatarsal_right = 5,
      metatarsal_left  = 5
    ),

    foot_phalanx = c(
      foot_phalanx_indet    = 0,
      foot_phalanx_proximal = 10,
      foot_phalanx_middle   = 8,
      foot_phalanx_distal   = 10
    )
  ),

  "Level 4" = list(
    tarsal = list(
      tarsal_right = c(
        tarsal_right_indet = 0,
        talus_right = 1,
        calcaneous_right = 1,
        cuboid_right = 1,
        navicular_right = 1,
        lateral_cuneiform_right = 1,
        intermediate_cuneiform_right = 1,
        medial_cuneiform_right = 1
      ),
      tarsal_left = c(
        tarsal_left_indet = 0,
        talus_left = 1,
        calcaneous_left = 1,
        cuboid_left = 1,
        navicular_left = 1,
        lateral_cuneiform_left = 1,
        intermediate_cuneiform_left = 1,
        medial_cuneiform_left = 1
      )
    ),

    metatarsal = list(
      metatarsal_right = c(
        metatarsal_right_indet = 0,
        metatarsal_1_right = 1,
        metatarsal_2_right = 1,
        metatarsal_3_right = 1,
        metatarsal_4_right = 1,
        metatarsal_5_right = 1
      ),
      metatarsal_left = c(
        metatarsal_left_indet = 0,
        metatarsal_1_left = 1,
        metatarsal_2_left = 1,
        metatarsal_3_left = 1,
        metatarsal_4_left = 1,
        metatarsal_5_left = 1
      )
    ),

    foot_phalanx = list(
      foot_phalanx_proximal = c(
        foot_phalanx_proximal_indet = 0,
        foot_proximal_right = 5,
        foot_phalanx_left   = 5
      ),
      foot_phalanx_middle = c(
        foot_phalanx_middle_indet = 0,
        foot_middle_right = 4,
        foot_middle_left  = 4
      ),
      foot_phalanx_distal = c(
        foot_phalanx_distal_indet = 0,
        foot_phalanx_distal_right = 5,
        foot_distal_left          = 5
      )
    )
  ),

  "Level 5" = list(
    foot_phalanx = list(
      foot_phalanx_proximal = c(
        foot_phalanx_proximal_right_indet = 0,
        foot_phalanx_proximal_1_right = 1,
        foot_phalanx_proximal_2_right = 1,
        foot_phalanx_proximal_3_right = 1,
        foot_phalanx_proximal_4_right = 1,
        foot_phalanx_proximal_5_right = 1,

        foot_phalanx_proximal_left_indet = 0,
        foot_phalanx_proximal_1_left = 1,
        foot_phalanx_proximal_2_left = 1,
        foot_phalanx_proximal_3_left = 1,
        foot_phalanx_proximal_4_left = 1,
        foot_phalanx_proximal_5_left = 1
      ),

      foot_phalanx_middle = c(
        foot_phalanx_middle_right_indet = 0,
        foot_phalanx_middle_2_right = 1,
        foot_phalanx_middle_3_right = 1,
        foot_phalanx_middle_4_right = 1,
        foot_phalanx_middle_5_right = 1,

        foot_phalanx_middle_left_indet = 0,
        foot_phalanx_middle_2_left = 1,
        foot_phalanx_middle_3_left = 1,
        foot_phalanx_middle_4_left = 1,
        foot_phalanx_middle_5_left = 1
      ),

      foot_phalanx_distal = c(
        foot_phalanx_distal_right_indet = 0,
        foot_phalanx_distal_right_1 = 1,
        foot_phalanx_distal_right_2 = 1,
        foot_phalanx_distal_right_3 = 1,
        foot_phalanx_distal_right_4 = 1,
        foot_phalanx_distal_right_5 = 1,

        foot_phalanx_distal_left_indet = 0,
        foot_phalanx_distal_left_1 = 1,
        foot_phalanx_distal_left_2 = 1,
        foot_phalanx_distal_left_3 = 1,
        foot_phalanx_distal_left_4 = 1,
        foot_phalanx_distal_left_5 = 1
      )
    )
  )
)

)
############################################################################################
elements_data <- data.frame(
  ElementsOne = c(

    #Skull
    "Skull", "Neurocranium bone", "Frontal bone", "Parietal bone", "Parietal bone Right",
    "Parietal bone Left", "Temporal", "Temporal Right", "Temporal Left", "Occipital",
    "Sphenoid", "Ethmoid", "Schplancnocranium", "Maxilla", "Palatine bone",
    "Zygomatic bone", "Zygomatic bone Right", "Zygomatic bone Left", "Nasal bone",
    "Lacrimal bone", "Vomer bone", "Inferior nasal concha", "Ossicles of the Middle Ear",
    "Malleus", "Malleus Right", "Malleus Left", "Incus", "Incus Right", "Incus Left",
    "Stapes", "Stapes Right", "Stapes Left", "Mandible",

    #Hyoid
    "Hyoid",

    #Vertebrae
    "Vertebrae",
    "Cervical", "C1 Atlas", "C2 Axis", "C3", "C4", "C5", "C6", "C7", "Thoracic",
    "T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9", "T10", "T11", "T12",
    "Lumbar", "L1", "L2", "L3", "L4", "L5",

    #Thorax
    "Thorax", "Sternum", "Ribs",
    "Ribs Right", "Ribs Left", "Rib 1 Right", "Rib 1 Left", "Rib 2 Right",
    "Rib 2 Left", "Rib 3 Right", "Rib 3 Left", "Rib 4 Right", "Rib 4 Left",
    "Rib 5 Right", "Rib 5 Left", "Rib 6 Right", "Rib 6 Left", "Rib 7 Right",
    "Rib 7 Left", "Rib 8 Right", "Rib 8 Left", "Rib 9 Right", "Rib 9 Left",
    "Rib 10 Right", "Rib 10 Left", "Rib 11 Right", "Rib 11 Left", "Rib 12 Right",
    "Rib 12 Left",

    #Shoulder
    "Shoulder", "Clavicle", "Clavicle Right", "Clavicle Left",
    "Scapula", "Scapula Right", "Scapula Left",

    #Arms
    "Arms","Humerus", "Radius", "Ulna",
    "Humerus Right","Humerus Left","Radius Right","Radius Left","Ulna Right", "Ulna Left",

    #Hands
    "Hands",
    "Hand Carpal", "Hand Carpal Right", "Hand Carpal Left",
    "Hand Trapezium Right", "Hand Trapezium Left", "Hand Trapezoid Right", "Hand Trapezoid Left",
    "Hand Hamate Right", "Hand Hamate Left", "Hand Triquetrum Right", "Hand Triquetrum Left",
    "Hand Lunate Right", "Hand Lunate Left", "Hand Pisiform Right", "Hand Pisiform Left",
    "Hand Capitate Right", "Hand Capitate Left", "Hand Scaphoid Right", "Hand Scaphoid Left",
    "Hand Metacarpal", "Hand Metacarpal Right", "Hand Metacarpal Left", "Hand Metacarpal 1 Right",
    "Hand Metacarpal 1 Left", "Hand Metacarpal 2 Right", "Hand Metacarpal 2 Left",
    "Hand Metacarpal 3 Right", "Hand Metacarpal 3 Left", "Hand Metacarpal 4 Right",
    "Hand Metacarpal 4 Left", "Hand Metacarpal 5 Right", "Hand Metacarpal 5 Left",
    "Hand Phalanx", "Hand Phalanx Right", "Hand Phalanx Left",
    "Hand Proximal Right", "Hand Proximal Left", "Hand Middle Right",
    "Hand Middle Left", "Hand Distal Right", "Hand Distal Left",
    "Hand Proximal 1 Right", "Hand Proximal 2 Right", "Hand Proximal 3 Right",
    "Hand Proximal 4 Right", "Hand Proximal 5 Right", "Hand Proximal 1 Left",
    "Hand Proximal 2 Left", "Hand Proximal 3 Left", "Hand Proximal 4 Left",
    "Hand Proximal 5 Left", "Hand Middle 2 Right", "Hand Middle 3 Right",
    "Hand Middle 4 Right", "Hand Middle 5 Right", "Hand Middle 2 Left", "Hand Middle 3 Left",
    "Hand Middle 4 Left", "Hand Middle 5 Left", "Hand Distal 1 Right", "Hand Distal 2 Right",
    "Hand Distal 3 Right", "Hand Distal 4 Right", "Hand Distal 5 Right", "Hand Distal 1 Left",
    "Hand Distal 2 Left", "Hand Distal 3 Left", "Hand Distal 4 Left", "Hand Distal 5 Left",

    #Pelvic
    "Pelvic", "Sacrum", "S1", "S2", "S3", "S4", "S5", "Coccyx", "Cx1", "Cx2",
    "Cx3", "Cx4", "Os Coxae", "Ilium", "Ilium Right", "Ilium Left", "Ischium",
    "Ischium Right", "Ischium Left", "Pubis", "Pubis Right", "Pubis Left",


    #Legs
    "Legs",
    "Femur", "Femur Left", "Femur Right", "Tibia", "Tibia Left", "Tibia Right",
    "Fibula", "Fibula Left", "Fibula Right", "Patella", "Patella Left",
    "Patella Right",

    #Foot
    "Foot",
    "Foot Tarsal", "Foot Tarsal Right", "Foot Tarsal Left",
    "Foot Talus Right", "Foot Talus Left", "Foot Calcaneous Right", "Foot Calcaneous Left",
    "Foot Cuboid Right", "Foot Cuboid Left", "Foot Navicular Right", "Foot Navicular Left",
    "Foot Lateral cuneiform Right", "Foot Lateral cuneiform Left",
    "Foot Intermediate cuneiform Right", "Foot Intermediate cuneiform Left",
    "Foot Medial cuneiform Right", "Foot Medial cuneiform Left",
    "Foot Metatarsal", "Foot Metatarsal Right", "Foot Metatarsal Left",
    "Foot Metatarsal 1 Right", "Foot Metatarsal 1 Left",
    "Foot Metatarsal 2 Right", "Foot Metatarsal 2 Left",
    "Foot Metatarsal 3 Right", "Foot Metatarsal 3 Left",
    "Foot Metatarsal 4 Right", "Foot Metatarsal 4 Left",
    "Foot Metatarsal 5 Right", "Foot Metatarsal 5 Left",
    "Foot Phalanx", "Foot Phalanx Right", "Foot Phalanx Left",
    "Foot Proximal Right", "Foot Proximal Left",
    "Foot Middle Right", "Foot Middle Left",
    "Foot Distal Right", "Foot Distal Left",
    "Foot Proximal 1 Right", "Foot Proximal 2 Right",
    "Foot Proximal 3 Right", "Foot Proximal 4 Right", "Foot Proximal 5 Right",
    "Foot Proximal 1 Left", "Foot Proximal 2 Left", "Foot Proximal 3 Left",
    "Foot Proximal 4 Left", "Foot Proximal 5 Left",
    "Foot Middle 2 Right", "Foot Middle 3 Right",
    "Foot Middle 4 Right", "Foot Middle 5 Right",
    "Foot Middle 2 Left", "Foot Middle 3 Left", "Foot Middle 4 Left",
    "Foot Middle 5 Left",
    "Foot Distal 1 Right", "Foot Distal 2 Right", "Foot Distal 3 Right",
    "Foot Distal 4 Right", "Foot Distal 5 Right",
    "Foot Distal 1 Left", "Foot Distal 2 Left", "Foot Distal 3 Left",
    "Foot Distal 4 Left", "Foot Distal 5 Left"
  ),
  #Level = c( 1, 2, 3, 3, 4, 4, 3, 4, 4, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 1, 2, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 2, 3, 3, 2, 3, 3, 1, 2, 3, 3, 2, 3, 3, 2, 3, 3, 1,2,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,4,4,4,4,4,4,4,4,4,4,4,4,2,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5, 1, 2, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 1, 2, 3, 3, 2, 3, 3, 2, 3, 3, 2, 3, 3, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ),
  Level = c(
    #Cranium
    #1, 2, 4, 3, 4, 4, 3, 4, 4, 4, 4, 4, 2, 4, 4, 3, 4, 4, 4, 4, 4, 4, 2, 3, 4, 4, 3, 4, 4, 3, 4, 4, 4,
    2, 3 ,5, 4, 5, 5, 4, 5, 5, 5, 5, 5, 3, 5, 5, 4, 5, 5, 5, 5, 5, 5, 3, 4, 5, 5, 4, 5, 5, 4, 5, 5, 5,

    #Hyoid
    1,
    #Vertebrae
    1, 2, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3,
    #Thorax
    1, 4, 2, 3, 3, 4,4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,

    #Shoulder
    1, 2, 3, 3, 2, 3, 3,

    #Arms
    1,  # Arms
    2,  # Humerus
    2,  # Radius
    2,  # Ulna
    3,  # Humerus Right
    3,  # Humerus Left
    3,  # Radius Right
    3,  # Radius Left
    3,  # Ulna Right
    3,   # Ulna Left

    #Hands
    1,
    2,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5, # Hand Carpal
    2,3,3,5,5,5,5,5,5,5,5,5,5, # Hand Metacarpal
    2,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5, #Hand Phalanx
    #Pelvic
    1,2,4,4,4,4,4,2,4,4,4,4, 2, 3, 4, 4, 3, 4, 4,3,4,4,
    #Leg
    1, 2, 3, 3, 2, 3, 3, 2, 3, 3, 2, 3, 3,
    #Foot
    1, 2, 3, 3, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
    2, 3, 3, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
    2, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
  ),

  Bone_Count = c(
    #Cranium
    1,8,1,2,1,1,2,1,1,1,1,1,14,2,2,2,1,1,2,2, 1,2,6,2,1,1,2,1,1,2,1,1,1,
    #Hyoid
    1,
    #Vertebrae
    19,7,1,1, 1,1,1,1,1,12,1,1,1,1,1,1,1,1,1,1,1,1,5,1,1,1,1,1,
    #Thorax
    25,1,24,1,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    #Shoulder
    4, 2, 1, 1, 2, 1, 1,
    #Arms
    6,  # Arms
    2,  # Humerus
    2,  # Radius
    2,  # Ulna
    1,  # Humerus Right
    1,  # Humerus Left
    1,  # Radius Right
    1,  # Radius Left
    1,  # Ulna Right
    1,   # Ulna Left
    #Hands
    54,
    16,8,8,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, # Hand Carpal
    10,5,5,1,1,1,1,1,1,1,1,1,1, # Hand Metacarpal
    28,14,14,5,5,4,4,5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, #Hand Phalanx
    #Pelvic
    4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 2,1, 1,2,1,1,
    #Leg
    8, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1,
    #Foot
    52,
    14, 7, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    10, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    28, 14, 14, 5, 5, 4, 4, 5, 5, 1,1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1,1



  ),
  Skeleton_Section = c(
    "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull", "Skull",
    "Hyoid",
    "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae", "Vertebrae",
    "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax", "Thorax",
    "Shoulder", "Shoulder", "Shoulder", "Shoulder", "Shoulder", "Shoulder", "Shoulder",
    "Arms", "Arms", "Arms", "Arms", "Arms", "Arms", "Arms", "Arms", "Arms", "Arms",
    "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Hands", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic","Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic", "Pelvic",
    "Legs", "Legs", "Legs", "Legs", "Legs", "Legs", "Legs", "Legs", "Legs", "Legs", "Legs", "Legs", "Legs",
    "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot", "Foot")
)



####### mappings ####
category_mappings = list(



  #### Skull 4
  category_mappings_skull_3_to_1 <- list(
    Skull = c("Neurocranium bone", "Schplancnocranium", "Ossicles of the Middle Ear", "Mandible")
    ),


  category_mappings_skull_4_to_1 <- list(
    Skull = c( "Frontal bone" , "Parietal bone", "Temporal" , "Occipital" , "Sphenoid" , "Ethmoid",
        "Maxilla" , "Palatine bone" , "Zygomatic bone" , "Nasal bone", "Lacrimal bone" , "Vomer bone" , "Inferior nasal concha" ,
        "Malleus" , "Incus" , "Stapes" , "Mandible")
    ),

    category_mappings_skull_5_to_1 <- list(
    Skull = c( "Frontal bone" , "Parietal bone Right" , "Parietal bone Left" , "Temporal Right" , "Temporal Left" , "Occipital" , "Sphenoid" , "Ethmoid" ,  "Maxilla" , "Palatine bone" , "Zygomatic bone Right" , "Zygomatic bone Left" , "Nasal bone" , "Lacrimal bone" , "Vomer bone" , "Inferior nasal concha","Malleus Right" , "Malleus Left" , "Incus Right" , "Incus Left" , "Stapes Right" , "Stapes Left" ,      "Mandible")),


  category_mappings_skull_4_to_3 <- list(
    Neurocranium.bone = c("Frontal bone" , "Parietal bone", "Temporal" , "Occipital" , "Sphenoid", "Ethmoid" ),
    Schplancnocranium = c("Maxilla" , "Palatine bone" , "Zygomatic bone", "Nasal bone", "Lacrimal bone" , "Vomer bone" , "Inferior nasal concha" ),
    Ossicles.of.the.Middle.Ear = c("Malleus", "Incus" , "Stapes"),
    Mandible = c("Mandible") ),


  category_mappings_skull_5_to_3 <- list(
      Neurocranium.bone = c("Frontal bone", "Parietal bone Right" , "Parietal bone Left" , "Temporal Right" , "Temporal Left", "Occipital" , "Sphenoid" , "Ethmoid" ),
      Schplancnocranium = c("Maxilla" , "Palatine bone" , "Zygomatic bone Right", "Zygomatic bone Left" , "Nasal bone", "Lacrimal bone" , "Vomer bone" , "Inferior nasal concha" ),
      Ossicles.of.the.Middle_Ear = c("Malleus Right", "Malleus Left", "Incus Right" , "Incus Left" , "Stapes Right" , "Stapes Left"),
      Mandible = c("Mandible") ),



  # Skull level 4 to 3 mapping, now 5 -> 4
  category_mappings_skull_5_to_4 <- list(
    Frontal.bone = c("Frontal bone"),
    Parietal.bone = c("Parietal bone Right", "Parietal bone Left"),
    Temporal = c("Temporal Right", "Temporal Left"),
    Occipital = c("Occipital"),
    Sphenoid = c("Sphenoid"),
    Ethmoid = c("Ethmoid"),
    Maxilla = c("Maxilla"),
    Palatine.bone = c("Palatine bone"),
    Zygomatic.bone = c("Zygomatic bone Right", "Zygomatic bone Left"),
    Nasal.bone = c("Nasal bone"),
    Lacrimal.bone = c("Lacrimal bone"),
    Vomer.bone = c("Vomer bone"),
    Inferior.nasal.concha = c("Inferior nasal concha"),
    Malleus = c("Malleus Right", "Malleus Left"),
    Incus = c("Incus Right", "Incus Left"),
    Stapes = c("Stapes Right", "Stapes Left"),
    Mandible = c("Mandible")
  ),

  category_mappings_skull_2_to_1 <- list(
    Skull = c("Skull","Mandible")
  ),

  category_mappings_skull_3_to_2 <- list(
    Skull = c("Neurocranium bone", "Schplancnocranium", "Ossicles of the Middle Ear"),
    Mandible = c("Mandible")
  ),

  category_mappings_skull_4_to_2 <- list(
    Skull = c( "Frontal bone" , "Parietal bone", "Temporal" , "Occipital" , "Sphenoid" , "Ethmoid",
    "Maxilla" , "Palatine bone" , "Zygomatic bone" , "Nasal bone", "Lacrimal bone" , "Vomer bone" , "Inferior nasal concha" ,
    "Malleus" , "Incus" , "Stapes"),
    Mandible = c("Mandible")
  ),

  category_mappings_skull_5_to_2 <- list(
    Skull = c("Frontal bone" , "Parietal bone Right" , "Parietal bone Left" , "Temporal Right" , "Temporal Left" ,
              "Occipital" , "Sphenoid" , "Ethmoid" ,  "Maxilla" , "Palatine bone" , "Zygomatic bone Right" , "Zygomatic bone Left" ,
              "Nasal bone" , "Lacrimal bone" , "Vomer bone" , "Inferior nasal concha", "Malleus Right" , "Malleus Left" , "Incus Right" ,
              "Incus Left" , "Stapes Right" , "Stapes Left" ),
    Mandible = c("Mandible")
  ),



  #Hyoid 1


  #### Vertebrae 3
  category_mappings_vertebrae_2_to_1 <- list(
    Vertebrae = c("Cervical", "Thoracic", "Lumbar")
  ),
  category_mappings_vertebrae_3_to_1 <- list(
    Vertebrae = c(
      "C1 Atlas", "C2 Axis", "C3", "C4", "C5", "C6", "C7",
      "T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9", "T10", "T11", "T12",
      "L1", "L2", "L3", "L4", "L5"
    )
  ),
  category_mappings_vertebrae_3_to_2 <- list(
    Cervical = c("C1 Atlas", "C2 Axis", "C3", "C4", "C5", "C6", "C7"),
    Thoracic = c("T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9", "T10", "T11", "T12"),
    Lumbar = c("L1", "L2", "L3", "L4", "L5")
  ),

  #Shoulder 3
  category_mappings_shoulder_2_to_1 <- list(
    Shoulder = c("Clavicle", "Scapula")
  ),
  category_mappings_shoulder_3_to_1 <- list(
    Shoulder = c("Clavicle Right", "Clavicle Left", "Scapula Right", "Scapula Left")
  ),
  category_mappings_shoulder_3_to_2 <- list(
    Clavicle = c("Clavicle Right", "Clavicle Left"),
    Scapula = c("Scapula Right", "Scapula Left")
  ),

  #Arms 3
  category_mappings_arms_2_to_1 <- list(
    Arms = c("Humerus", "Radius", "Ulna")
  ),
  category_mappings_arms_3_to_1 <- list(
    Arms = c("Humerus Right", "Humerus Left", "Radius Right", "Radius Left", "Ulna Right", "Ulna Left")
  ),

  category_mappings_arms_3_to_2 <- list(
    Humerus = c("Humerus Right", "Humerus Left"),
    Radius = c("Radius Right", "Radius Left"),
    Ulna = c("Ulna Right", "Ulna Left")
  ),

  #Hands 5
  category_mappings_hands_2_to_1 <- list(
    Hands = c("Hand Carpal", "Hand Metacarpal", "Hand Phalanx")
  ),

  category_mappings_hands_3_to_1 <- list(
    Hands = c(
      "Hand Carpal Right", "Hand Carpal Left",
      "Hand Metacarpal Right", "Hand Metacarpal Left",
      "Hand Phalanx Right", "Hand Phalanx Left"
    )
  ),


  category_mappings_hands_4_to_1 <- list(
    Hands = c(
      "Hand Trapezium Right", "Hand Trapezium Left",
      "Hand Trapezoid Right", "Hand Trapezoid Left",
      "Hand Hamate Right", "Hand Hamate Left",
      "Hand Triquetrum Right", "Hand Triquetrum Left",
      "Hand Lunate Right", "Hand Lunate Left",
      "Hand Pisiform Right", "Hand Pisiform Left",
      "Hand Capitate Right", "Hand Capitate Left",
      "Hand Scaphoid Right", "Hand Scaphoid Left",
      "Hand Metacarpal 1 Right", "Hand Metacarpal 1 Left",
      "Hand Metacarpal 2 Right", "Hand Metacarpal 2 Left",
      "Hand Metacarpal 3 Right", "Hand Metacarpal 3 Left",
      "Hand Metacarpal 4 Right", "Hand Metacarpal 4 Left",
      "Hand Metacarpal 5 Right", "Hand Metacarpal 5 Left",
      "Hand Proximal Right",
      "Hand Proximal Left",
      "Hand Middle Right",
      "Hand Middle Left",
      "Hand Distal Right",
      "Hand Distal Left"
    )
  ),


  category_mappings_hands_3_to_2 <- list(
    Hand.Carpal = c("Hand Carpal Right", "Hand Carpal Left"),
    Hand.Metacarpal = c("Hand Metacarpal Right", "Hand Metacarpal Left"),
    Hand.Phalanx = c("Hand Phalanx Right", "Hand Phalanx Left")
  )
  ,

  category_mappings_hands_4_to_2 <- list(
    Hand.Carpal = c(
      "Hand Trapezium Right", "Hand Trapezium Left",
      "Hand Trapezoid Right", "Hand Trapezoid Left",
      "Hand Hamate Right", "Hand Hamate Left",
      "Hand Triquetrum Right", "Hand Triquetrum Left",
      "Hand Lunate Right", "Hand Lunate Left",
      "Hand Pisiform Right", "Hand Pisiform Left",
      "Hand Capitate Right", "Hand Capitate Left",
      "Hand Scaphoid Right", "Hand Scaphoid Left"
    ),
    Hand.Metacarpal = c(
      "Hand Metacarpal 1 Right", "Hand Metacarpal 1 Left",
      "Hand Metacarpal 2 Right", "Hand Metacarpal 2 Left",
      "Hand Metacarpal 3 Right", "Hand Metacarpal 3 Left",
      "Hand Metacarpal 4 Right", "Hand Metacarpal 4 Left",
      "Hand Metacarpal 5 Right", "Hand Metacarpal 5 Left"
    ),
    Hand.Phalanx = c(
      "Hand Proximal Right",
      "Hand Proximal Left",
      "Hand Middle Right",
      "Hand Middle Left",
      "Hand Distal Right",
      "Hand Distal Left"
    )
  ),
  category_mappings_hands_4_to_3 <- list(
    Hand.Carpal.Right = c(
      "Hand Trapezium Right", "Hand Trapezoid Right", "Hand Hamate Right",
      "Hand Triquetrum Right", "Hand Lunate Right", "Hand Pisiform Right",
      "Hand Capitate Right", "Hand Scaphoid Right"
    ),
    Hand.Carpal.Left = c(
      "Hand Trapezium Left", "Hand Trapezoid Left", "Hand Hamate Left",
      "Hand Triquetrum Left", "Hand Lunate Left", "Hand Pisiform Left",
      "Hand Capitate Left", "Hand Scaphoid Left"
    ),
    Hand.Metacarpal.Right = c(
      "Hand Metacarpal 1 Right", "Hand Metacarpal 2 Right", "Hand Metacarpal 3 Right",
      "Hand Metacarpal 4 Right", "Hand Metacarpal 5 Right"
    ),
    Hand.Metacarpal.Left = c(
      "Hand Metacarpal 1 Left", "Hand Metacarpal 2 Left", "Hand Metacarpal 3 Left",
      "Hand Metacarpal 4 Left", "Hand Metacarpal 5 Left"
    ),
    Hand.Phalanx.Right = c(
      "Hand Proximal Right", "Hand Middle Right", "Hand Distal Right"
    ),
    Hand.Phalanx.Left = c(
      "Hand Proximal Left", "Hand Middle Left", "Hand Distal Left"
    )
  )

  ,
  #Pelvic 4 only upto 3
  category_mappings_pelvic_2_to_1 <- list(
    Pelvic = c("Sacrum", "Coccyx", "Os Coxae (Innominate)")
  ),
  category_mappings_pelvic_3_to_1 <- list(
    Pelvic = c("S1", "S2", "S3", "S4", "S5", "Cx1", "Cx2", "Cx3", "Cx4", "Ilium Right", "Ilium Left", "Ischium Right", "Ischium Left", "Pubis Right", "Pubis Left")
  ),
  category_mappings_pelvic_3_to_2 <- list(
    Sacrum = c("S1", "S2", "S3", "S4", "S5"),
    Coccyx = c("Cx1", "Cx2", "Cx3", "Cx4"),
    Os.Coxae = c("Ilium Right", "Ilium Left", "Ischium Right", "Ischium Left", "Pubis Right", "Pubis Left")
  ),




  category_mappings_legs_2_to_1 <- list(
    Legs = c("Femur", "Tibia", "Fibula", "Patella")
  ),


  category_mappings_legs_3_to_1 <- list(
    Legs = c("Femur Left", "Femur Right", "Tibia Left", "Tibia Right", "Fibula Left", "Fibula Right", "Patella Left", "Patella Right")
  ),
  category_mappings_legs_3_to_2 <- list(
    Femur = c("Femur Left", "Femur Right"),
    Tibia = c("Tibia Left", "Tibia Right"),
    Fibula = c("Fibula Left", "Fibula Right"),
    Patella = c("Patella Left", "Patella Right")
  ),
  ### thorax 4
  # Thorax hierarchical mappings based on levels
  category_mappings_thorax_4_to_3 <- list(

    Sternum = c("Sternum"),
    Ribs.Left = c("Rib 1 Left",  "Rib 2 Left",
                  "Rib 3 Left", "Rib 4 Left",
                  "Rib 5 Left", "Rib 6 Left",
                  "Rib 7 Left",  "Rib 8 Left",
                  "Rib 9 Left", "Rib 10 Left",
                  "Rib 11 Left", "Rib 12 Left"),

    Ribs.Right = c( "Rib 1 Right", "Rib 2 Right", "Rib 3 Right",  "Rib 4 Right",
                    "Rib 5 Right",  "Rib 6 Right","Rib 7 Right", "Rib 8 Right",
                    "Rib 9 Right",  "Rib 10 Right", "Rib 11 Right", "Rib 12 Right"
                  )


  ),

  category_mappings_thorax_4_to_2 <- list(
    Sternum = c("Sternum"),
    Ribs = c(
      "Rib 1 Left", "Rib 1 Right", "Rib 2 Left", "Rib 2 Right",
      "Rib 3 Left", "Rib 3 Right", "Rib 4 Left", "Rib 4 Right",
      "Rib 5 Left", "Rib 5 Right", "Rib 6 Left", "Rib 6 Right",
      "Rib 7 Left", "Rib 7 Right", "Rib 8 Left", "Rib 8 Right",
      "Rib 9 Left", "Rib 9 Right", "Rib 10 Left", "Rib 10 Right",
      "Rib 11 Left", "Rib 11 Right", "Rib 12 Left", "Rib 12 Right"
    )

  ),

  category_mappings_thorax_4_to_1 <- list(
    Thorax = c(
      "Sternum", "Rib 1 Left", "Rib 1 Right", "Rib 2 Left", "Rib 2 Right",
      "Rib 3 Left", "Rib 3 Right", "Rib 4 Left", "Rib 4 Right",
      "Rib 5 Left", "Rib 5 Right", "Rib 6 Left", "Rib 6 Right",
      "Rib 7 Left", "Rib 7 Right", "Rib 8 Left", "Rib 8 Right",
      "Rib 9 Left", "Rib 9 Right", "Rib 10 Left", "Rib 10 Right",
      "Rib 11 Left", "Rib 11 Right", "Rib 12 Left", "Rib 12 Right"
    )
  ),

  category_mappings_thorax_3_to_2 <- list(
    Sternum = "Sternum",
    Ribs = c("Ribs Left", "Ribs Right")
  ),

  category_mappings_thorax_3_to_1 <- list(
    Thorax = c("Sternum", "Ribs Left", "Ribs Right")
  )
  ,
  category_mappings_thorax_2_to_1 <- list(
    Thorax = c("Sternum", "Ribs")
  )
  ,

  category_mappings_hands_5_to_1 <- list(
    Hands = c(
      "Hand Trapezium Right", "Hand Trapezium Left",
      "Hand Trapezoid Right", "Hand Trapezoid Left",
      "Hand Hamate Right", "Hand Hamate Left",
      "Hand Triquetrum Right", "Hand Triquetrum Left",
      "Hand Lunate Right", "Hand Lunate Left",
      "Hand Pisiform Right", "Hand Pisiform Left",
      "Hand Capitate Right", "Hand Capitate Left",
      "Hand Scaphoid Right", "Hand Scaphoid Left",
      "Hand Metacarpal 1 Right", "Hand Metacarpal 1 Left",
      "Hand Metacarpal 2 Right", "Hand Metacarpal 2 Left",
      "Hand Metacarpal 3 Right", "Hand Metacarpal 3 Left",
      "Hand Metacarpal 4 Right", "Hand Metacarpal 4 Left",
      "Hand Metacarpal 5 Right", "Hand Metacarpal 5 Left",
      "Hand Proximal 1 Right", "Hand Proximal 2 Right", "Hand Proximal 3 Right", "Hand Proximal 4 Right", "Hand Proximal 5 Right",
      "Hand Proximal 1 Left", "Hand Proximal 2 Left", "Hand Proximal 3 Left", "Hand Proximal 4 Left", "Hand Proximal 5 Left",
      "Hand Middle 2 Right", "Hand Middle 3 Right", "Hand Middle 4 Right", "Hand Middle 5 Right",
      "Hand Middle 2 Left", "Hand Middle 3 Left", "Hand Middle 4 Left", "Hand Middle 5 Left",
      "Hand Distal 1 Right", "Hand Distal 2 Right", "Hand Distal 3 Right", "Hand Distal 4 Right", "Hand Distal 5 Right",
      "Hand Distal 1 Left", "Hand Distal 2 Left", "Hand Distal 3 Left", "Hand Distal 4 Left", "Hand Distal 5 Left"
    )
  ),


  category_mappings_hands_5_to_2 <- list(
    Hand.Carpal = c(
      "Hand Trapezium Right", "Hand Trapezium Left",
      "Hand Trapezoid Right", "Hand Trapezoid Left",
      "Hand Hamate Right", "Hand Hamate Left",
      "Hand Triquetrum Right", "Hand Triquetrum Left",
      "Hand Lunate Right", "Hand Lunate Left",
      "Hand Pisiform Right", "Hand Pisiform Left",
      "Hand Capitate Right", "Hand Capitate Left",
      "Hand Scaphoid Right", "Hand Scaphoid Left"
    ),
    Hand.Metacarpal = c(
      "Hand Metacarpal 1 Right", "Hand Metacarpal 1 Left",
      "Hand Metacarpal 2 Right", "Hand Metacarpal 2 Left",
      "Hand Metacarpal 3 Right", "Hand Metacarpal 3 Left",
      "Hand Metacarpal 4 Right", "Hand Metacarpal 4 Left",
      "Hand Metacarpal 5 Right", "Hand Metacarpal 5 Left"
    ),
    Hand.Phalanx = c(
      "Hand Proximal 1 Right", "Hand Proximal 2 Right", "Hand Proximal 3 Right", "Hand Proximal 4 Right", "Hand Proximal 5 Right",
      "Hand Proximal 1 Left", "Hand Proximal 2 Left", "Hand Proximal 3 Left", "Hand Proximal 4 Left", "Hand Proximal 5 Left",
      "Hand Middle 2 Right", "Hand Middle 3 Right", "Hand Middle 4 Right", "Hand Middle 5 Right",
      "Hand Middle 2 Left", "Hand Middle 3 Left", "Hand Middle 4 Left", "Hand Middle 5 Left",
      "Hand Distal 1 Right", "Hand Distal 2 Right", "Hand Distal 3 Right", "Hand Distal 4 Right", "Hand Distal 5 Right",
      "Hand Distal 1 Left", "Hand Distal 2 Left", "Hand Distal 3 Left", "Hand Distal 4 Left", "Hand Distal 5 Left"
    )
  ),
  category_mappings_hands_5_to_4 <- list(
    Hand.Trapezium.Right = c("Hand Trapezium Right"),
    Hand.Trapezium.Left = c("Hand Trapezium Left"),
    Hand.Trapezoid.Right = c("Hand Trapezoid Right"),
    Hand.Trapezoid.Left = c("Hand Trapezoid Left"),
    Hand.Hamate.Right = c("Hand Hamate Right"),
    Hand.Hamate.Left = c("Hand Hamate Left"),
    Hand.Triquetrum.Right = c("Hand Triquetrum Right"),
    Hand.Triquetrum.Left = c("Hand Triquetrum Left"),
    Hand.Lunate.Right = c("Hand Lunate Right"),
    Hand.Lunate.Left = c("Hand Lunate Left"),
    Hand.Pisiform.Right = c("Hand Pisiform Right"),
    Hand.Pisiform.Left = c("Hand Pisiform Left"),
    Hand.Capitate.Right = c("Hand Capitate Right"),
    Hand.Capitate.Left = c("Hand Capitate Left"),
    Hand.Scaphoid.Right = c("Hand Scaphoid Right"),
    Hand.Scaphoid.Left = c("Hand Scaphoid Left"),

    Hand.Metacarpal.1.Right = c("Hand Metacarpal 1 Right"),
    Hand.Metacarpal.1.Left = c("Hand Metacarpal 1 Left"),
    Hand.Metacarpal.2.Right = c("Hand Metacarpal 2 Right"),
    Hand.Metacarpal.2.Left = c("Hand Metacarpal 2 Left"),
    Hand.Metacarpal.3.Right = c("Hand Metacarpal 3 Right"),
    Hand.Metacarpal.3.Left = c("Hand Metacarpal 3 Left"),
    Hand.Metacarpal.4.Right = c("Hand Metacarpal 4 Right"),
    Hand.Metacarpal.4.Left = c("Hand Metacarpal 4 Left"),
    Hand.Metacarpal.5.Right = c("Hand Metacarpal 5 Right"),
    Hand.Metacarpal.5.Left = c("Hand Metacarpal 5 Left"),

    Hand.Proximal.Right = c(
      "Hand Proximal 1 Right", "Hand Proximal 2 Right", "Hand Proximal 3 Right",
      "Hand Proximal 4 Right", "Hand Proximal 5 Right"
    ),
    Hand.Proximal.Left = c(
      "Hand Proximal 1 Left", "Hand Proximal 2 Left", "Hand Proximal 3 Left",
      "Hand Proximal 4 Left", "Hand Proximal 5 Left"
    ),
    Hand.Middle.Right = c(
      "Hand Middle 2 Right", "Hand Middle 3 Right", "Hand Middle 4 Right",
      "Hand Middle 5 Right"
    ),
    Hand.Middle.Left = c(
      "Hand Middle 2 Left", "Hand Middle 3 Left", "Hand Middle 4 Left",
      "Hand Middle 5 Left"
    ),
    Hand.Distal.Right = c(
      "Hand Distal 1 Right", "Hand Distal 2 Right", "Hand Distal 3 Right",
      "Hand Distal 4 Right", "Hand Distal 5 Right"
    ),
    Hand.Distal.Left = c(
      "Hand Distal 1 Left", "Hand Distal 2 Left", "Hand Distal 3 Left",
      "Hand Distal 4 Left", "Hand Distal 5 Left"
    )
  )
,
category_mappings_hands_5_to_3 <- list(
  Hand.Carpal.Right = c(
    "Hand Trapezium Right", "Hand Trapezoid Right", "Hand Hamate Right",
    "Hand Triquetrum Right", "Hand Lunate Right", "Hand Pisiform Right",
    "Hand Capitate Right", "Hand Scaphoid Right"
  ),
  Hand.Carpal.Left = c(
    "Hand Trapezium Left", "Hand Trapezoid Left", "Hand Hamate Left",
    "Hand Triquetrum Left", "Hand Lunate Left", "Hand Pisiform Left",
    "Hand Capitate Left", "Hand Scaphoid Left"
  ),
  Hand.Metacarpal.Right = c(
    "Hand Metacarpal 1 Right", "Hand Metacarpal 2 Right", "Hand Metacarpal 3 Right",
    "Hand Metacarpal 4 Right", "Hand Metacarpal 5 Right"
  ),
  Hand.Metacarpal.Left = c(
    "Hand Metacarpal 1 Left", "Hand Metacarpal 2 Left", "Hand Metacarpal 3 Left",
    "Hand Metacarpal 4 Left", "Hand Metacarpal 5 Left"
  ),
  Hand.Phalanx.Right = c(
    "Hand Proximal 1 Right", "Hand Proximal 2 Right", "Hand Proximal 3 Right",
    "Hand Proximal 4 Right", "Hand Proximal 5 Right", "Hand Middle 2 Right",
    "Hand Middle 3 Right", "Hand Middle 4 Right", "Hand Middle 5 Right",
    "Hand Distal 1 Right", "Hand Distal 2 Right", "Hand Distal 3 Right",
    "Hand Distal 4 Right", "Hand Distal 5 Right"
  ),
  Hand.Phalanx.Left = c(
    "Hand Proximal 1 Left", "Hand Proximal 2 Left", "Hand Proximal 3 Left",
    "Hand Proximal 4 Left", "Hand Proximal 5 Left", "Hand Middle 2 Left",
    "Hand Middle 3 Left", "Hand Middle 4 Left", "Hand Middle 5 Left",
    "Hand Distal 1 Left", "Hand Distal 2 Left", "Hand Distal 3 Left",
    "Hand Distal 4 Left", "Hand Distal 5 Left"
  )
)

,
  category_mappings_pelvic_2_to_1 <- list(
    Pelvic = c("Sacrum", "Coccyx", "Os Coxae")
  ),

  category_mappings_pelvic_3_to_1 <- list(
    Pelvic = c("S1", "S2", "S3", "S4", "S5", "Cx1", "Cx2", "Cx3", "Cx4", "Ilium", "Ischium", "Pubis")
  ),

  category_mappings_pelvic_4_to_1 <- list(
    Pelvic = c(
      "S1", "S2", "S3", "S4", "S5",
      "Cx1", "Cx2", "Cx3", "Cx4",
      "Ilium Right", "Ilium Left", "Ischium Right", "Ischium Left", "Pubis Right", "Pubis Left"
    )
  )
  ,


  category_mappings_pelvic_3_to_2 <- list(
    Sacrum = c("S1", "S2", "S3", "S4", "S5"),
    Coccyx = c("Cx1", "Cx2", "Cx3", "Cx4"),
    Os.Coxae = c("Ilium", "Ischium", "Pubis")
  ),
  category_mappings_pelvic_4_to_2 <- list(
    Sacrum = c("S1", "S2", "S3", "S4", "S5"),
    Coccyx = c("Cx1", "Cx2", "Cx3", "Cx4"),
    Os.Coxae = c("Ilium Right", "Ilium Left", "Ischium Right", "Ischium Left", "Pubis Right", "Pubis Left")
  )
  ,

  category_mappings_pelvic_4_to_3 <- list(
    Ilium = c("Ilium Right", "Ilium Left"),
    Ischium = c("Ischium Right", "Ischium Left"),
    Pubis = c("Pubis Right", "Pubis Left")
  )
  ,


  category_mappings_foot_4_to_3 <- list(
    Foot.Tarsal.Right = c(
      "Foot Talus Right", "Foot Calcaneous Right", "Foot Cuboid Right",
      "Foot Navicular Right", "Foot Lateral cuneiform Right",
      "Foot Intermediate cuneiform Right", "Foot Medial cuneiform Right"
    ),
    Foot.Tarsal.Left = c(
      "Foot Talus Left", "Foot Calcaneous Left", "Foot Cuboid Left",
      "Foot Navicular Left", "Foot Lateral cuneiform Left",
      "Foot Intermediate cuneiform Left", "Foot Medial cuneiform Left"
    ),
    Foot.Metatarsal.Right = c(
      "Foot Metatarsal 1 Right", "Foot Metatarsal 2 Right", "Foot Metatarsal 3 Right",
      "Foot Metatarsal 4 Right", "Foot Metatarsal 5 Right"
    ),
    Foot.Metatarsal.Left = c(
      "Foot Metatarsal 1 Left", "Foot Metatarsal 2 Left", "Foot Metatarsal 3 Left",
      "Foot Metatarsal 4 Left", "Foot Metatarsal 5 Left"
    ),
    Foot.Phalanx.Right = c(
      "Foot Proximal Right", "Foot Middle Right", "Foot Distal Right"
    ),
    Foot.Phalanx.Left = c(
      "Foot Proximal Left", "Foot Middle Left", "Foot Distal Left"
    )
  )
  ,



  category_mappings_foot_5_to_3 <- list(
    Foot.Tarsal.Right = c(
      "Foot Talus Right", "Foot Calcaneous Right", "Foot Cuboid Right",
      "Foot Navicular Right", "Foot Lateral cuneiform Right",
      "Foot Intermediate cuneiform Right", "Foot Medial cuneiform Right"
    ),
    Foot.Tarsal.Left = c(
      "Foot Talus Left", "Foot Calcaneous Left", "Foot Cuboid Left",
      "Foot Navicular Left", "Foot Lateral cuneiform Left",
      "Foot Intermediate cuneiform Left", "Foot Medial cuneiform Left"
    ),
    Foot.Metatarsal.Right = c(
      "Foot Metatarsal 1 Right", "Foot Metatarsal 2 Right", "Foot Metatarsal 3 Right",
      "Foot Metatarsal 4 Right", "Foot Metatarsal 5 Right"
    ),
    Foot.Metatarsal.Left = c(
      "Foot Metatarsal 1 Left", "Foot Metatarsal 2 Left", "Foot Metatarsal 3 Left",
      "Foot Metatarsal 4 Left", "Foot Metatarsal 5 Left"
    ),
    Foot.Phalanx.Right = c(
      "Foot Proximal 1 Right", "Foot Proximal 2 Right", "Foot Proximal 3 Right",
      "Foot Proximal 4 Right", "Foot Proximal 5 Right", "Foot Middle 2 Right",
      "Foot Middle 3 Right", "Foot Middle 4 Right", "Foot Middle 5 Right",
      "Foot Distal 1 Right", "Foot Distal 2 Right", "Foot Distal 3 Right",
      "Foot Distal 4 Right", "Foot Distal 5 Right"
    ),
    Foot.Phalanx.Left = c(
      "Foot Proximal 1 Left", "Foot Proximal 2 Left", "Foot Proximal 3 Left",
      "Foot Proximal 4 Left", "Foot Proximal 5 Left", "Foot Middle 2 Left",
      "Foot Middle 3 Left", "Foot Middle 4 Left", "Foot Middle 5 Left",
      "Foot Distal 1 Left", "Foot Distal 2 Left", "Foot Distal 3 Left",
      "Foot Distal 4 Left", "Foot Distal 5 Left"
    )
  )

  ,


  category_mappings_foot_5_to_4 <- list(
    Foot.Talus.Right = c("Foot Talus Right"),
    Foot.Talus.Left = c("Foot Talus Left"),
    Foot.Calcaneous.Right = c("Foot Calcaneous Right"),
    Foot.Calcaneous.Left = c("Foot Calcaneous Left"),
    Foot.Cuboid.Right = c("Foot Cuboid Right"),
    Foot.Cuboid.Left = c("Foot Cuboid Left"),
    Foot.Navicular.Right = c("Foot Navicular Right"),
    Foot.Navicular.Left = c("Foot Navicular Left"),
    Foot.Lateral.cuneiform.Right = c("Foot Lateral cuneiform Right"),
    Foot.Lateral.cuneiform.Left = c("Foot Lateral cuneiform Left"),
    Foot.Intermediate.cuneiform.Right = c("Foot Intermediate cuneiform Right"),
    Foot.Intermediate.cuneiform.Left = c("Foot Intermediate cuneiform Left"),
    Foot.Medial.cuneiform.Right = c("Foot Medial cuneiform Right"),
    Foot.Medial.cuneiform.Left = c("Foot Medial cuneiform Left"),

    Foot.Metatarsal.1.Right = c("Foot Metatarsal 1 Right"),
    Foot.Metatarsal.1.Left = c("Foot Metatarsal 1 Left"),
    Foot.Metatarsal.2.Right = c("Foot Metatarsal 2 Right"),
    Foot.Metatarsal.2.Left = c("Foot Metatarsal 2 Left"),
    Foot.Metatarsal.3.Right = c("Foot Metatarsal 3 Right"),
    Foot.Metatarsal.3.Left = c("Foot Metatarsal 3 Left"),
    Foot.Metatarsal.4.Right = c("Foot Metatarsal 4 Right"),
    Foot.Metatarsal.4.Left = c("Foot Metatarsal 4 Left"),
    Foot.Metatarsal.5.Right = c("Foot Metatarsal 5 Right"),
    Foot.Metatarsal.5.Left = c("Foot Metatarsal 5 Left"),

    Foot.Proximal.Right = c(
      "Foot Proximal 1 Right", "Foot Proximal 2 Right", "Foot Proximal 3 Right",
      "Foot Proximal 4 Right", "Foot Proximal 5 Right"
    ),
    Foot.Proximal.Left = c(
      "Foot Proximal 1 Left", "Foot Proximal 2 Left", "Foot Proximal 3 Left",
      "Foot Proximal 4 Left", "Foot Proximal 5 Left"
    ),
    Foot.Middle.Right = c(
      "Foot Middle 2 Right", "Foot Middle 3 Right", "Foot Middle 4 Right",
      "Foot Middle 5 Right"
    ),
    Foot.Middle.Left = c(
      "Foot Middle 2 Left", "Foot Middle 3 Left", "Foot Middle 4 Left",
      "Foot Middle 5 Left"
    ),
    Foot.Distal.Right = c(
      "Foot Distal 1 Right", "Foot Distal 2 Right", "Foot Distal 3 Right",
      "Foot Distal 4 Right", "Foot Distal 5 Right"
    ),
    Foot.Distal.Left = c(
      "Foot Distal 1 Left", "Foot Distal 2 Left", "Foot Distal 3 Left",
      "Foot Distal 4 Left", "Foot Distal 5 Left"
    )
  )
  ,


  category_mappings_foot_2_to_1 <- list(
    Foot = c("Foot Tarsal", "Foot Metatarsal", "Foot Phalanx")
  ),

  category_mappings_foot_3_to_1 <- list(
    Foot = c(
      "Foot Tarsal Right", "Foot Tarsal Left",
      "Foot Metatarsal Right", "Foot Metatarsal Left",
      "Foot Phalanx Right", "Foot Phalanx Left"
    )
  ),

  category_mappings_foot_4_to_1 <- list(
    Foot = c(
      "Foot Talus Right", "Foot Talus Left",
      "Foot Calcaneous Right", "Foot Calcaneous Left",
      "Foot Cuboid Right", "Foot Cuboid Left",
      "Foot Navicular Right", "Foot Navicular Left",
      "Foot Lateral cuneiform Right", "Foot Lateral cuneiform Left",
      "Foot Intermediate cuneiform Right", "Foot Intermediate cuneiform Left",
      "Foot Medial cuneiform Right", "Foot Medial cuneiform Left",
      "Foot Metatarsal 1 Right", "Foot Metatarsal 1 Left",
      "Foot Metatarsal 2 Right", "Foot Metatarsal 2 Left",
      "Foot Metatarsal 3 Right", "Foot Metatarsal 3 Left",
      "Foot Metatarsal 4 Right", "Foot Metatarsal 4 Left",
      "Foot Metatarsal 5 Right", "Foot Metatarsal 5 Left",
      "Foot Proximal Right",
      "Foot Proximal Left",
      "Foot Middle Right",
      "Foot Middle Left",
      "Foot Distal Right",
      "Foot Distal Left"
    )
  ),

  category_mappings_foot_3_to_2 <- list(
    Foot.Tarsal = c("Foot Tarsal Right", "Foot Tarsal Left"),
    Foot.Metatarsal = c("Foot Metatarsal Right", "Foot Metatarsal Left"),
    Foot.Phalanx = c("Foot Phalanx Right", "Foot Phalanx Left")
  ),

  category_mappings_foot_4_to_2 <- list(
    Foot.Tarsal = c(
      "Foot Talus Right", "Foot Talus Left",
      "Foot Calcaneous Right", "Foot Calcaneous Left",
      "Foot Cuboid Right", "Foot Cuboid Left",
      "Foot Navicular Right", "Foot Navicular Left",
      "Foot Lateral cuneiform Right", "Foot Lateral cuneiform Left",
      "Foot Intermediate cuneiform Right", "Foot Intermediate cuneiform Left",
      "Foot Medial cuneiform Right", "Foot Medial cuneiform Left"
    ),
    Foot.Metatarsal = c(
      "Foot Metatarsal 1 Right", "Foot Metatarsal 1 Left",
      "Foot Metatarsal 2 Right", "Foot Metatarsal 2 Left",
      "Foot Metatarsal 3 Right", "Foot Metatarsal 3 Left",
      "Foot Metatarsal 4 Right", "Foot Metatarsal 4 Left",
      "Foot Metatarsal 5 Right", "Foot Metatarsal 5 Left"
    ),
    Foot.Phalanx = c(
      "Foot Proximal Right",
      "Foot Proximal Left",
      "Foot Middle Right",
      "Foot Middle Left",
      "Foot Distal Right",
      "Foot Distal Left"
    )
  ),


  category_mappings_foot_5_to_1 <- list(
    Foot = c(
      "Foot Talus Right", "Foot Talus Left",
      "Foot Calcaneous Right", "Foot Calcaneous Left",
      "Foot Cuboid Right", "Foot Cuboid Left",
      "Foot Navicular Right", "Foot Navicular Left",
      "Foot Lateral cuneiform Right", "Foot Lateral cuneiform Left",
      "Foot Intermediate cuneiform Right", "Foot Intermediate cuneiform Left",
      "Foot Medial cuneiform Right", "Foot Medial cuneiform Left",
      "Foot Metatarsal 1 Right", "Foot Metatarsal 1 Left",
      "Foot Metatarsal 2 Right", "Foot Metatarsal 2 Left",
      "Foot Metatarsal 3 Right", "Foot Metatarsal 3 Left",
      "Foot Metatarsal 4 Right", "Foot Metatarsal 4 Left",
      "Foot Metatarsal 5 Right", "Foot Metatarsal 5 Left",
      "Foot Proximal 1 Right", "Foot Proximal 2 Right", "Foot Proximal 3 Right", "Foot Proximal 4 Right", "Foot Proximal 5 Right",
      "Foot Proximal 1 Left", "Foot Proximal 2 Left", "Foot Proximal 3 Left", "Foot Proximal 4 Left", "Foot Proximal 5 Left",
      "Foot Middle 2 Right", "Foot Middle 3 Right", "Foot Middle 4 Right", "Foot Middle 5 Right",
      "Foot Middle 2 Left", "Foot Middle 3 Left", "Foot Middle 4 Left", "Foot Middle 5 Left",
      "Foot Distal 1 Right", "Foot Distal 2 Right", "Foot Distal 3 Right", "Foot Distal 4 Right", "Foot Distal 5 Right",
      "Foot Distal 1 Left", "Foot Distal 2 Left", "Foot Distal 3 Left", "Foot Distal 4 Left", "Foot Distal 5 Left"
    )
  ),
  category_mappings_foot_5_to_2 <- list(
    Foot.Tarsal = c(
      "Foot Talus Right", "Foot Talus Left",
      "Foot Calcaneous Right", "Foot Calcaneous Left",
      "Foot Cuboid Right", "Foot Cuboid Left",
      "Foot Navicular Right", "Foot Navicular Left",
      "Foot Lateral cuneiform Right", "Foot Lateral cuneiform Left",
      "Foot Intermediate cuneiform Right", "Foot Intermediate cuneiform Left",
      "Foot Medial cuneiform Right", "Foot Medial cuneiform Left"
    ),
    Foot.Metatarsal = c(
      "Foot Metatarsal 1 Right", "Foot Metatarsal 1 Left",
      "Foot Metatarsal 2 Right", "Foot Metatarsal 2 Left",
      "Foot Metatarsal 3 Right", "Foot Metatarsal 3 Left",
      "Foot Metatarsal 4 Right", "Foot Metatarsal 4 Left",
      "Foot Metatarsal 5 Right", "Foot Metatarsal 5 Left"
    ),
    Foot.Phalanx = c(
      "Foot Proximal 1 Right", "Foot Proximal 2 Right", "Foot Proximal 3 Right", "Foot Proximal 4 Right", "Foot Proximal 5 Right",
      "Foot Proximal 1 Left", "Foot Proximal 2 Left", "Foot Proximal 3 Left", "Foot Proximal 4 Left", "Foot Proximal 5 Left",
      "Foot Middle 2 Right", "Foot Middle 3 Right", "Foot Middle 4 Right", "Foot Middle 5 Right",
      "Foot Middle 2 Left", "Foot Middle 3 Left", "Foot Middle 4 Left", "Foot Middle 5 Left",
      "Foot Distal 1 Right", "Foot Distal 2 Right", "Foot Distal 3 Right", "Foot Distal 4 Right", "Foot Distal 5 Right",
      "Foot Distal 1 Left", "Foot Distal 2 Left", "Foot Distal 3 Left", "Foot Distal 4 Left", "Foot Distal 5 Left"
    )
  )


  )

  ######### recal MNE ########

  category_hierarchy <- list(

    #Skull 4 6 6
    "Skull_4_to_2" = category_mappings_skull_4_to_2, # 5_3
    "Skull_4_to_1" = category_mappings_skull_4_to_1, # 5_1
    "Skull_3_to_2" = category_mappings_skull_3_to_2, # 4_3
    "Skull_3_to_1" = category_mappings_skull_3_to_1, # 4_1
    "Skull_2_to_1" = category_mappings_skull_2_to_1, # 3_1
    "Skull_4_to_3" = category_mappings_skull_4_to_3, # 5_4
    "Skull_5_to_1" = category_mappings_skull_5_to_1, # 2_1
    "Skull_5_to_2" = category_mappings_skull_5_to_2, # 3_2
    "Skull_5_to_3" = category_mappings_skull_5_to_3, # 4_2
    "Skull_5_to_4" = category_mappings_skull_5_to_4, # 5_2


  #Vertebrae 3  3 3
    "Vertebrae_2_to_1" = category_mappings_vertebrae_2_to_1,
    "Vertebrae_3_to_1" = category_mappings_vertebrae_3_to_1,
    "Vertebrae_3_to_2" = category_mappings_vertebrae_3_to_2,

    #Thorax 4  6 6

    "Thorax_4_to_3" = category_mappings_thorax_4_to_3,
    "Thorax_4_to_2" = category_mappings_thorax_4_to_2,
    "Thorax_4_to_1" = category_mappings_thorax_4_to_1,
    "Thorax_3_to_2" = category_mappings_thorax_3_to_2,
    "Thorax_3_to_1" = category_mappings_thorax_3_to_1,
    "Thorax_2_to_1" = category_mappings_thorax_2_to_1,




    #Shoulder 3 3 3
    "Shoulder_2_to_1" = category_mappings_shoulder_2_to_1,
    "Shoulder_3_to_1" = category_mappings_shoulder_3_to_1,
    "Shoulder_3_to_2" = category_mappings_shoulder_3_to_2,

    #Arms 3 3 3
    "Arms_2_to_1" = category_mappings_arms_2_to_1,
    "Arms_3_to_1" = category_mappings_arms_3_to_1,
    "Arms_3_to_2" = category_mappings_arms_3_to_2,

    #Hands 5 10 10
    "Hands_2_to_1" = category_mappings_hands_2_to_1,
    "Hands_3_to_1" = category_mappings_hands_3_to_1,
    "Hands_4_to_1" = category_mappings_hands_4_to_1,
    "Hands_3_to_2" = category_mappings_hands_3_to_2,
    "Hands_4_to_2" = category_mappings_hands_4_to_2,
    "Hands_5_to_1" = category_mappings_hands_5_to_1,
    "Hands_5_to_2" = category_mappings_hands_5_to_2,
    "Hands_4_to_3" = category_mappings_hands_4_to_3,
    "Hands_5_to_3" = category_mappings_hands_5_to_3,
    "Hands_5_to_4" = category_mappings_hands_5_to_4,

    #Pelvic 4 6 6
    "Pelvic_2_to_1" = category_mappings_pelvic_2_to_1,
    "Pelvic_3_to_1" = category_mappings_pelvic_3_to_1,
    "Pelvic_3_to_2" = category_mappings_pelvic_3_to_2,
    "Pelvic_4_to_1" = category_mappings_pelvic_4_to_1,
    "Pelvic_4_to_2" = category_mappings_pelvic_4_to_2,
    "Pelvic_4_to_3" = category_mappings_pelvic_4_to_3,

    #Leg 3 3 3
    "Legs_2_to_1" = category_mappings_legs_2_to_1,
    "Legs_3_to_1" = category_mappings_legs_3_to_1,
    "Legs_3_to_2" = category_mappings_legs_3_to_2,

    #Foot 5 10 10
    "Foot_2_to_1" = category_mappings_foot_2_to_1,
    "Foot_3_to_1" = category_mappings_foot_3_to_1,
    "Foot_4_to_1" = category_mappings_foot_4_to_1,
    "Foot_3_to_2" = category_mappings_foot_3_to_2,
    "Foot_4_to_2" = category_mappings_foot_4_to_2,
    "Foot_5_to_1" = category_mappings_foot_5_to_1,
    "Foot_5_to_2" = category_mappings_foot_5_to_2,
    "Foot_4_to_3" = category_mappings_foot_4_to_3,
    "Foot_5_to_3" = category_mappings_foot_5_to_3,
    "Foot_5_to_4" = category_mappings_foot_5_to_4

  )
  

    