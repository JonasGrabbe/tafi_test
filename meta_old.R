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
  Skull = list(
    "Level 1" = list("Skull" = 1),
    "Level 2" = list("Skull" = 1, "Mandible" = 1),
    "Level 3" = list(
      "Neurocranium bone" = 8,
      "Schplancnocranium" = 14,
      "Ossicles of the Middle Ear" = 6,
      "Mandible" = 1
    ),
    "Level 4" = list(
      Neurocranium_bone = c("Frontal bone" = 1, "Parietal bone" = 2, "Temporal" = 2, "Occipital" = 1, "Sphenoid" = 1, "Ethmoid" = 1),
      Schplancnocranium = c("Maxilla" = 2, "Palatine bone" = 2, "Zygomatic bone" = 2, "Nasal bone" = 2, "Lacrimal bone" = 2, "Vomer bone" = 1, "Inferior nasal concha" = 2),
      Ossicles_of_the_Middle_Ear = c("Malleus" = 2, "Incus" = 2, "Stapes" = 2),
      "Mandible" = 1
    ),
    "Level 5" = list(
      Neurocranium_bone = c("Frontal bone" = 1, "Parietal bone Right" = 1, "Parietal bone Left" = 1, "Temporal Right" = 1, "Temporal Left" = 1, "Occipital" = 1, "Sphenoid" = 1, "Ethmoid" = 1),
      Schplancnocranium = c("Maxilla" = 1, "Palatine bone" = 1, "Zygomatic bone Right" = 1, "Zygomatic bone Left" = 1, "Nasal bone" = 1, "Lacrimal bone" = 1, "Vomer bone" = 1, "Inferior nasal concha" = 1),
      Ossicles_of_the_Middle_Ear = c("Malleus Right" = 1, "Malleus Left" = 1, "Incus Right" = 1, "Incus Left" = 1, "Stapes Right" = 1, "Stapes Left" = 1),
      "Mandible" = 1
    )
  ),
  Hyoid = list(
    "Level 1" = list("Hyoid" = 1)
  ),
  Vertebrae = list(
    "Level 1" = list("Vertebrae" = 19),
    "Level 2" = list(
      "Cervical" = 7,
      "Thoracic" = 12,
      "Lumbar" = 5
    ),
    "Level 3" = list( # reverse order
      Lumbar = c("L1" = 1, "L2" = 1, "L3" = 1, "L4" = 1, "L5" = 1),
      Thoracic = c("T1" = 1, "T2" = 1, "T3" = 1, "T4" = 1, "T5" = 1, "T6" = 1, "T7" = 1, "T8" = 1, "T9" = 1, "T10" = 1, "T11" = 1, "T12" = 1),
      Cervical = c("C1 Atlas" = 1, "C2 Axis" = 1, "C3" = 1, "C4" = 1, "C5" = 1, "C6" = 1, "C7" = 1)
    )
  ),
  Thorax = list(
    "Level 1" = list("Thorax" = 25),
    "Level 2" = list(
      "Sternum" = 1,
      "Ribs" = 24
    ),
    "Level 3" = list(
      Sternum = c("Sternum" = 1),
      Ribs = c("Ribs Left" = 12, "Ribs Right" = 12)
    ),
    "Level 4" = list(
      Sternum = c("Sternum" = 1),
      Ribs = c(
        "Rib 1 Left" = 1, "Rib 1 Right" = 1,
        "Rib 2 Left" = 1, "Rib 2 Right" = 1,
        "Rib 3 Left" = 1, "Rib 3 Right" = 1,
        "Rib 4 Left" = 1, "Rib 4 Right" = 1,
        "Rib 5 Left" = 1, "Rib 5 Right" = 1,
        "Rib 6 Left" = 1, "Rib 6 Right" = 1,
        "Rib 7 Left" = 1, "Rib 7 Right" = 1,
        "Rib 8 Left" = 1, "Rib 8 Right" = 1,
        "Rib 9 Left" = 1, "Rib 9 Right" = 1,
        "Rib 10 Left" = 1, "Rib 10 Right" = 1,
        "Rib 11 Left" = 1, "Rib 11 Right" = 1,
        "Rib 12 Left" = 1, "Rib 12 Right" = 1
      )
    )
  ),
  Shoulder = list(
    "Level 1" = list("Shoulder" = 4),
    "Level 2" = list(
      "Clavicle" = 2,
      "Scapula" = 2
    ),
    "Level 3" = list(
      Clavicle = c("Clavicle Right" = 1, "Clavicle Left" = 1),
      Scapula = c("Scapula Right" = 1, "Scapula Left" = 1)
    )
  ),
  Arms = list(
    "Level 1" = list("Arms" = 6),
    "Level 2" = list(
      "Humerus" = 2,
      "Radius" = 2,
      "Ulna" = 2
    ),
    "Level 3" = list(
      Humerus = c("Humerus Right" = 1, "Humerus Left" = 1),
      Radius = c("Radius Right" = 1, "Radius Left" = 1),
      Ulna = c("Ulna Right" = 1, "Ulna Left" = 1)
    )
  ),
  Hands = list(
    "Level 1" = list("Hands" = 54),

    "Level 2" = list(
      "Hand Carpal" = 16,
      "Hand Metacarpal" = 10,
      "Hand Phalanx" = 28
    ),

    "Level 3" = list(
      "Hand Carpal" = c("Hand Carpal Right" = 8, "Hand Carpal Left" = 8),
      "Hand Metacarpal" = c("Hand Metacarpal Right" = 5, "Hand Metacarpal Left" = 5),
      "Hand Phalanx" = c("Hand Phalanx Right" = 14, "Hand Phalanx Left" = 14)
    ),

    "Level 4" = list(
      "Hand Carpal" = c(
        "Hand Trapezium Right" = 1, "Hand Trapezium Left" = 1,
        "Hand Trapezoid Right" = 1, "Hand Trapezoid Left" = 1,
        "Hand Hamate Right" = 1, "Hand Hamate Left" = 1,
        "Hand Triquetrum Right" = 1, "Hand Triquetrum Left" = 1,
        "Hand Lunate Right" = 1, "Hand Lunate Left" = 1,
        "Hand Pisiform Right" = 1, "Hand Pisiform Left" = 1,
        "Hand Capitate Right" = 1, "Hand Capitate Left" = 1,
        "Hand Scaphoid Right" = 1, "Hand Scaphoid Left" = 1
      ),
      "Hand Metacarpal" = c(
        "Hand Metacarpal 1 Right" = 1, "Hand Metacarpal 1 Left" = 1,
        "Hand Metacarpal 2 Right" = 1, "Hand Metacarpal 2 Left" = 1,
        "Hand Metacarpal 3 Right" = 1, "Hand Metacarpal 3 Left" = 1,
        "Hand Metacarpal 4 Right" = 1, "Hand Metacarpal 4 Left" = 1,
        "Hand Metacarpal 5 Right" = 1, "Hand Metacarpal 5 Left" = 1
      ),
      "Hand Phalanx" = c(
        "Hand Proximal Right" = 5, "Hand Proximal Left" = 5,
        "Hand Middle Right" = 4, "Hand Middle Left" = 4,
        "Hand Distal Right" = 5, "Hand Distal Left" = 5
      )
    ),

    "Level 5" = list(
      "Hand Carpal" = c(
        "Hand Trapezium Right" = 1, "Hand Trapezium Left" = 1,
        "Hand Trapezoid Right" = 1, "Hand Trapezoid Left" = 1,
        "Hand Hamate Right" = 1, "Hand Hamate Left" = 1,
        "Hand Triquetrum Right" = 1, "Hand Triquetrum Left" = 1,
        "Hand Lunate Right" = 1, "Hand Lunate Left" = 1,
        "Hand Pisiform Right" = 1, "Hand Pisiform Left" = 1,
        "Hand Capitate Right" = 1, "Hand Capitate Left" = 1,
        "Hand Scaphoid Right" = 1, "Hand Scaphoid Left" = 1
      ),
      "Hand Metacarpal" = c(
        "Hand Metacarpal 1 Right" = 1, "Hand Metacarpal 1 Left" = 1,
        "Hand Metacarpal 2 Right" = 1, "Hand Metacarpal 2 Left" = 1,
        "Hand Metacarpal 3 Right" = 1, "Hand Metacarpal 3 Left" = 1,
        "Hand Metacarpal 4 Right" = 1, "Hand Metacarpal 4 Left" = 1,
        "Hand Metacarpal 5 Right" = 1, "Hand Metacarpal 5 Left" = 1
      ),
      "Hand Phalanx" = c(
        "Hand Proximal 1 Right" = 1, "Hand Proximal 2 Right" = 1, "Hand Proximal 3 Right" = 1, "Hand Proximal 4 Right" = 1, "Hand Proximal 5 Right" = 1,
        "Hand Proximal 1 Left" = 1, "Hand Proximal 2 Left" = 1, "Hand Proximal 3 Left" = 1, "Hand Proximal 4 Left" = 1, "Hand Proximal 5 Left" = 1,
        "Hand Middle 2 Right" = 1, "Hand Middle 3 Right" = 1, "Hand Middle 4 Right" = 1, "Hand Middle 5 Right" = 1,
        "Hand Middle 2 Left" = 1, "Hand Middle 3 Left" = 1, "Hand Middle 4 Left" = 1, "Hand Middle 5 Left" = 1,
        "Hand Distal 1 Right" = 1, "Hand Distal 2 Right" = 1, "Hand Distal 3 Right" = 1, "Hand Distal 4 Right" = 1, "Hand Distal 5 Right" = 1,
        "Hand Distal 1 Left" = 1, "Hand Distal 2 Left" = 1, "Hand Distal 3 Left" = 1, "Hand Distal 4 Left" = 1, "Hand Distal 5 Left" = 1
      )
    )
  )

  ,
  Pelvic = list(
    "Level 1" = list("Pelvic" = 4),
    "Level 2" = list(
      "Sacrum" = 1,
      "Coccyx" = 1,
      "Os Coxae" = 2
    ),
    "Level 3" = list(
      Sacrum = c("S1" = 1, "S2" = 1, "S3" = 1, "S4" = 1, "S5" = 1),
      Coccyx = c("Cx1" = 1, "Cx2" = 1, "Cx3" = 1, "Cx4" = 1),
      Os_Coxae = c("Ilium" = 2,  "Ischium" = 2,"Pubis" = 2)
    ),
    "Level 4" = list(
      Sacrum = c("S1" = 1, "S2" = 1, "S3" = 1, "S4" = 1, "S5" = 1),
      Coccyx = c("Cx1" = 1, "Cx2" = 1, "Cx3" = 1, "Cx4" = 1),
      Os_Coxae = c("Ilium Right" = 1, "Ilium Left" = 1, "Ischium Right" = 1, "Ischium Left" = 1, "Pubis Right" = 1, "Pubis Left" = 1)


  )),
  Legs = list(
    "Level 1" = list("Legs" = 8),
    "Level 2" = list(
      "Femur" = 2,
      "Tibia" = 2,
      "Fibula" = 2,
      "Patella" = 2
    ),
    "Level 3" = list(
      Femur = c("Femur Left" = 1, "Femur Right" = 1),
      Tibia = c("Tibia Left" = 1, "Tibia Right" = 1),
      Fibula = c("Fibula Left" = 1, "Fibula Right" = 1),
      Patella = c("Patella Left" = 1, "Patella Right" = 1)
    )
  ),
  Foot = list(
    "Level 1" = list("Foot" = 52),

    "Level 2" = list(
      "Foot Tarsal" = 14,
      "Foot Metatarsal" = 10,
      "Foot Phalanx" = 28
    ),

    "Level 3" = list(
      "Foot Tarsal" = c("Foot Tarsal Right" = 7, "Foot Tarsal Left" = 7),
      "Foot Metatarsal" = c("Foot Metatarsal Right" = 5, "Foot Metatarsal Left" = 5),
      "Foot Phalanx" = c("Foot Phalanx Right" = 14, "Foot Phalanx Left" = 14)
    ),

    "Level 4" = list(
      Tarsal = c(
        "Foot Talus Right" = 1, "Foot Talus Left" = 1,
        "Foot Calcaneous Right" = 1, "Foot Calcaneous Left" = 1,
        "Foot Cuboid Right" = 1, "Foot Cuboid Left" = 1,
        "Foot Navicular Right" = 1, "Foot Navicular Left" = 1,
        "Foot Lateral cuneiform Right" = 1, "Foot Lateral cuneiform Left" = 1,
        "Foot Intermediate cuneiform Right" = 1, "Foot Intermediate cuneiform Left" = 1,
        "Foot Medial cuneiform Right" = 1, "Foot Medial cuneiform Left" = 1
      ),
      Foot_Metatarsal = c(
        "Foot Metatarsal 1 Right" = 1, "Foot Metatarsal 1 Left" = 1,
        "Foot Metatarsal 2 Right" = 1, "Foot Metatarsal 2 Left" = 1,
        "Foot Metatarsal 3 Right" = 1, "Foot Metatarsal 3 Left" = 1,
        "Foot Metatarsal 4 Right" = 1, "Foot Metatarsal 4 Left" = 1,
        "Foot Metatarsal 5 Right" = 1, "Foot Metatarsal 5 Left" = 1
      ),
      Foot_Phalanx = c(
        "Foot Proximal Right" = 5, "Foot Proximal Left" = 5,
        "Foot Middle Right" = 4, "Foot Middle Left" = 4,
        "Foot Distal Right" = 5, "Foot Distal Left" = 5
      )
    ),

    "Level 5" = list(
      Tarsal = c(
        "Foot Talus Right" = 1, "Foot Talus Left" = 1,
        "Foot Calcaneous Right" = 1, "Foot Calcaneous Left" = 1,
        "Foot Cuboid Right" = 1, "Foot Cuboid Left" = 1,
        "Foot Navicular Right" = 1, "Foot Navicular Left" = 1,
        "Foot Lateral cuneiform Right" = 1, "Foot Lateral cuneiform Left" = 1,
        "Foot Intermediate cuneiform Right" = 1, "Foot Intermediate cuneiform Left" = 1,
        "Foot Medial cuneiform Right" = 1, "Foot Medial cuneiform Left" = 1
      ),
      Foot_Metatarsal = c(
        "Foot Metatarsal 1 Right" = 1, "Foot Metatarsal 1 Left" = 1,
        "Foot Metatarsal 2 Right" = 1, "Foot Metatarsal 2 Left" = 1,
        "Foot Metatarsal 3 Right" = 1, "Foot Metatarsal 3 Left" = 1,
        "Foot Metatarsal 4 Right" = 1, "Foot Metatarsal 4 Left" = 1,
        "Foot Metatarsal 5 Right" = 1, "Foot Metatarsal 5 Left" = 1
      ),
      Foot_Phalanx = c(
        "Foot Proximal 1 Right" = 1, "Foot Proximal 2 Right" = 1, "Foot Proximal 3 Right" = 1, "Foot Proximal 4 Right" = 1, "Foot Proximal 5 Right" = 1,
        "Foot Proximal 1 Left" = 1, "Foot Proximal 2 Left" = 1, "Foot Proximal 3 Left" = 1, "Foot Proximal 4 Left" = 1, "Foot Proximal 5 Left" = 1,
        "Foot Middle 2 Right" = 1, "Foot Middle 3 Right" = 1, "Foot Middle 4 Right" = 1, "Foot Middle 5 Right" = 1,
        "Foot Middle 2 Left" = 1, "Foot Middle 3 Left" = 1, "Foot Middle 4 Left" = 1, "Foot Middle 5 Left" = 1,
        "Foot Distal 1 Right" = 1, "Foot Distal 2 Right" = 1, "Foot Distal 3 Right" = 1, "Foot Distal 4 Right" = 1, "Foot Distal 5 Right" = 1,
        "Foot Distal 1 Left" = 1, "Foot Distal 2 Left" = 1, "Foot Distal 3 Left" = 1, "Foot Distal 4 Left" = 1, "Foot Distal 5 Left" = 1
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
    Skull = c("Frontal bone" , "Parietal bone Right" , "Parietal bone Left" , "Temporal Right" , "Temporal Left" , "Occipital" , "Sphenoid" , "Ethmoid" ,  "Maxilla" , "Palatine bone" , "Zygomatic bone Right" , "Zygomatic bone Left" , "Nasal bone" , "Lacrimal bone" , "Vomer bone" , "Inferior nasal concha", "Malleus Right" , "Malleus Left" , "Incus Right" , "Incus Left" , "Stapes Right" , "Stapes Left" ),
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
    Ribs = c(
      "Rib 1 Left", "Rib 1 Right", "Rib 2 Left", "Rib 2 Right",
      "Rib 3 Left", "Rib 3 Right", "Rib 4 Left", "Rib 4 Right",
      "Rib 5 Left", "Rib 5 Right", "Rib 6 Left", "Rib 6 Right",
      "Rib 7 Left", "Rib 7 Right", "Rib 8 Left", "Rib 8 Right",
      "Rib 9 Left", "Rib 9 Right", "Rib 10 Left", "Rib 10 Right",
      "Rib 11 Left", "Rib 11 Right", "Rib 12 Left", "Rib 12 Right"
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
    "Skull_5_to_1" = category_mappings_hands_5_to_1, # 2_1
    "Skull_5_to_2" = category_mappings_hands_5_to_2, # 3_2
    "Skull_5_to_3" = category_mappings_hands_5_to_3, # 4_2
    "Skull_5_to_4" = category_mappings_hands_5_to_4, # 5_2
  
   
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
