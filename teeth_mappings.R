#### TEETH
# Level 2 -> Level 1
category_mappings_teeth_2_to_1 <- list(
  teeth = c("deciduous", "permanent")
)

# Level 3 -> Level 1
category_mappings_teeth_3_to_1 <- list(
  teeth = c(
      "deciduous_indet", "di1", "di2", "dc", "dm1", "dm2", "permanent_indet", "i1", "i2", "c", "pm3", "pm4",
      "m1", "m2", "m3"
    )
)

# Level 4 -> Level 1
category_mappings_teeth_4_to_1 <- list(
  teeth = c(
      "deciduous_indet", "dl1_indet", "di1_superior", "dl1_inferior", "dl2_indet", "di2_superior",
      "dl2_inferior", "dc_indet", "dc_superior", "dc_inferior", "dm1_indet", "dm1_superior", "dm1_inferior",
      "dm2_indet", "dm2_superior", "dm2_inferior", "permanent_indet", "i1_indet", "i1_superior",
      "i1_inferior", "i2_indet", "i2_superior", "i2_inferior", "c_indet", "c_superior", "c_inferior",
      "pm3_indet", "pm3_superior", "pm3_inferior", "pm4_indet", "pm4_superior", "pm4_inferior", "m1_indet",
      "m1_superior", "m1_inferior", "m2_indet", "m2_superior", "m2_inferior", "m3_indet", "m3_superior",
      "m3_inferior"
    )
)

# Level 5 -> Level 1
category_mappings_teeth_5_to_1 <- list(
  teeth = c(
      "deciduous_indet", "dl1_indet", "di1_superior_indet", "di1_superior_right", "di1_superior_left",
      "dl1_inferior_indet", "dl1_inferior_right", "dl1_inferior_left", "dl2_indet", "di2_superior_indet",
      "di2_superior_right", "di2_superior_left", "di2_inferior_indet", "di2_inferior_right",
      "di2_inferior_left", "dc_indet", "dc_superior_indet", "dc_superior_right", "dc_superior_left",
      "dc_inferior_indet", "dc_inferior_right", "dc_inferior_left", "dm1_indet", "dm1_superior_indet",
      "dm1_superior_left", "dm1_superior_right", "dm1_inferior_indet", "dm1_inferior_right",
      "dm1_inferior_left", "dm2_indet", "dm2_superior_indet", "dm2_superior_right", "dm2_superior_left",
      "dm2_inferior_indet", "dm2_inferior_right", "dm2_inferior_left", "permanent_indet", "i1_indet",
      "i1_superior_indet", "i1_superior_right", "i1_superior_left", "i1_inferior_indet", "i1_inferior_right",
      "i1_inferior_left", "i2_indet", "i2_superior_indet", "i2_superior_right", "i2_superior_left",
      "i2_inferior_indet", "i2_inferior_right", "i2_inferior_left", "c_indet", "c_superior_indet",
      "c_superior_right", "c_superior_left", "c_inferior_indet", "c_inferior_right", "c_inferior_left",
      "pm3_indet", "pm3_superior_indet", "pm3_superior_right", "pm3_superior_left", "pm3_inferior_indet",
      "pm3_inferior_right", "pm3_inferior_left", "pm4_indet", "pm4_superior_indet", "pm4_superior_right",
      "pm4_superior_left", "pm4_inferior_indet", "pm4_inferior_right", "pm4_inferior_left", "m1_indet",
      "m1_superior_indet", "m1_superior_right", "m1_superior_left", "m1_inferior_indet", "m1_inferior_right",
      "m1_inferior_left", "m2_indet", "m2_superior_indet", "m2_superior_right", "m2_superior_left",
      "m2_inferior_indet", "m2_inferior_right", "m2_inferior_left", "m3_indet", "m3_superior_indet",
      "m3_superior_right", "m3_superior_left", "m3_inferior_indet", "m3_inferior_right", "m3_inferior_left"
    )
)

# Level 3 -> Level 2
category_mappings_teeth_3_to_2 <- list(
  deciduous = c("deciduous_indet", "di1", "di2", "dc", "dm1", "dm2"),
  permanent = c("permanent_indet", "i1", "i2", "c", "pm3", "pm4", "m1", "m2", "m3")
)

# Level 4 -> Level 2
category_mappings_teeth_4_to_2 <- list(
  deciduous = c(
        "deciduous_indet", "dl1_indet", "di1_superior", "dl1_inferior", "dl2_indet", "di2_superior",
        "dl2_inferior", "dc_indet", "dc_superior", "dc_inferior", "dm1_indet", "dm1_superior", "dm1_inferior",
        "dm2_indet", "dm2_superior", "dm2_inferior"
      ),
  permanent = c(
        "permanent_indet", "i1_indet", "i1_superior", "i1_inferior", "i2_indet", "i2_superior", "i2_inferior",
        "c_indet", "c_superior", "c_inferior", "pm3_indet", "pm3_superior", "pm3_inferior", "pm4_indet",
        "pm4_superior", "pm4_inferior", "m1_indet", "m1_superior", "m1_inferior", "m2_indet", "m2_superior",
        "m2_inferior", "m3_indet", "m3_superior", "m3_inferior"
      )
)

# Level 5 -> Level 2
category_mappings_teeth_5_to_2 <- list(
  deciduous = c(
        "deciduous_indet", "dl1_indet", "di1_superior_indet", "di1_superior_right", "di1_superior_left",
        "dl1_inferior_indet", "dl1_inferior_right", "dl1_inferior_left", "dl2_indet", "di2_superior_indet",
        "di2_superior_right", "di2_superior_left", "di2_inferior_indet", "di2_inferior_right",
        "di2_inferior_left", "dc_indet", "dc_superior_indet", "dc_superior_right", "dc_superior_left",
        "dc_inferior_indet", "dc_inferior_right", "dc_inferior_left", "dm1_indet", "dm1_superior_indet",
        "dm1_superior_left", "dm1_superior_right", "dm1_inferior_indet", "dm1_inferior_right",
        "dm1_inferior_left", "dm2_indet", "dm2_superior_indet", "dm2_superior_right", "dm2_superior_left",
        "dm2_inferior_indet", "dm2_inferior_right", "dm2_inferior_left"
      ),
  permanent = c(
        "permanent_indet", "i1_indet", "i1_superior_indet", "i1_superior_right", "i1_superior_left",
        "i1_inferior_indet", "i1_inferior_right", "i1_inferior_left", "i2_indet", "i2_superior_indet",
        "i2_superior_right", "i2_superior_left", "i2_inferior_indet", "i2_inferior_right", "i2_inferior_left",
        "c_indet", "c_superior_indet", "c_superior_right", "c_superior_left", "c_inferior_indet",
        "c_inferior_right", "c_inferior_left", "pm3_indet", "pm3_superior_indet", "pm3_superior_right",
        "pm3_superior_left", "pm3_inferior_indet", "pm3_inferior_right", "pm3_inferior_left", "pm4_indet",
        "pm4_superior_indet", "pm4_superior_right", "pm4_superior_left", "pm4_inferior_indet",
        "pm4_inferior_right", "pm4_inferior_left", "m1_indet", "m1_superior_indet", "m1_superior_right",
        "m1_superior_left", "m1_inferior_indet", "m1_inferior_right", "m1_inferior_left", "m2_indet",
        "m2_superior_indet", "m2_superior_right", "m2_superior_left", "m2_inferior_indet",
        "m2_inferior_right", "m2_inferior_left", "m3_indet", "m3_superior_indet", "m3_superior_right",
        "m3_superior_left", "m3_inferior_indet", "m3_inferior_right", "m3_inferior_left"
      )
)

# Level 4 -> Level 3
category_mappings_teeth_4_to_3 <- list(
  deciduous_indet = c("deciduous_indet"),
  di1 = c("dl1_indet", "di1_superior", "dl1_inferior"),
  di2 = c("dl2_indet", "di2_superior", "dl2_inferior"),
  dc = c("dc_indet", "dc_superior", "dc_inferior"),
  dm1 = c("dm1_indet", "dm1_superior", "dm1_inferior"),
  dm2 = c("dm2_indet", "dm2_superior", "dm2_inferior"),
  permanent_indet = c("permanent_indet"),
  i1 = c("i1_indet", "i1_superior", "i1_inferior"),
  i2 = c("i2_indet", "i2_superior", "i2_inferior"),
  c = c("c_indet", "c_superior", "c_inferior"),
  pm3 = c("pm3_indet", "pm3_superior", "pm3_inferior"),
  pm4 = c("pm4_indet", "pm4_superior", "pm4_inferior"),
  m1 = c("m1_indet", "m1_superior", "m1_inferior"),
  m2 = c("m2_indet", "m2_superior", "m2_inferior"),
  m3 = c("m3_indet", "m3_superior", "m3_inferior")
)

# Level 5 -> Level 3
category_mappings_teeth_5_to_3 <- list(
  deciduous_indet = c("deciduous_indet"),
  di1 = c(
        "dl1_indet", "di1_superior_indet", "di1_superior_right", "di1_superior_left", "dl1_inferior_indet",
        "dl1_inferior_right", "dl1_inferior_left"
      ),
  di2 = c(
        "dl2_indet", "di2_superior_indet", "di2_superior_right", "di2_superior_left", "di2_inferior_indet",
        "di2_inferior_right", "di2_inferior_left"
      ),
  dc = c(
        "dc_indet", "dc_superior_indet", "dc_superior_right", "dc_superior_left", "dc_inferior_indet",
        "dc_inferior_right", "dc_inferior_left"
      ),
  dm1 = c(
        "dm1_indet", "dm1_superior_indet", "dm1_superior_left", "dm1_superior_right", "dm1_inferior_indet",
        "dm1_inferior_right", "dm1_inferior_left"
      ),
  dm2 = c(
        "dm2_indet", "dm2_superior_indet", "dm2_superior_right", "dm2_superior_left", "dm2_inferior_indet",
        "dm2_inferior_right", "dm2_inferior_left"
      ),
  permanent_indet = c("permanent_indet"),
  i1 = c(
        "i1_indet", "i1_superior_indet", "i1_superior_right", "i1_superior_left", "i1_inferior_indet",
        "i1_inferior_right", "i1_inferior_left"
      ),
  i2 = c(
        "i2_indet", "i2_superior_indet", "i2_superior_right", "i2_superior_left", "i2_inferior_indet",
        "i2_inferior_right", "i2_inferior_left"
      ),
  c = c(
        "c_indet", "c_superior_indet", "c_superior_right", "c_superior_left", "c_inferior_indet",
        "c_inferior_right", "c_inferior_left"
      ),
  pm3 = c(
        "pm3_indet", "pm3_superior_indet", "pm3_superior_right", "pm3_superior_left", "pm3_inferior_indet",
        "pm3_inferior_right", "pm3_inferior_left"
      ),
  pm4 = c(
        "pm4_indet", "pm4_superior_indet", "pm4_superior_right", "pm4_superior_left", "pm4_inferior_indet",
        "pm4_inferior_right", "pm4_inferior_left"
      ),
  m1 = c(
        "m1_indet", "m1_superior_indet", "m1_superior_right", "m1_superior_left", "m1_inferior_indet",
        "m1_inferior_right", "m1_inferior_left"
      ),
  m2 = c(
        "m2_indet", "m2_superior_indet", "m2_superior_right", "m2_superior_left", "m2_inferior_indet",
        "m2_inferior_right", "m2_inferior_left"
      ),
  m3 = c(
        "m3_indet", "m3_superior_indet", "m3_superior_right", "m3_superior_left", "m3_inferior_indet",
        "m3_inferior_right", "m3_inferior_left"
      )
)

# Level 5 -> Level 4
category_mappings_teeth_5_to_4 <- list(
  deciduous_indet = c("deciduous_indet"),
  dl1_indet = c("dl1_indet"),
  di1_superior = c("di1_superior_indet", "di1_superior_right", "di1_superior_left"),
  dl1_inferior = c("dl1_inferior_indet", "dl1_inferior_right", "dl1_inferior_left"),
  dl2_indet = c("dl2_indet"),
  di2_superior = c("di2_superior_indet", "di2_superior_right", "di2_superior_left"),
  dl2_inferior = c("di2_inferior_indet", "di2_inferior_right", "di2_inferior_left"),
  dc_indet = c("dc_indet"),
  dc_superior = c("dc_superior_indet", "dc_superior_right", "dc_superior_left"),
  dc_inferior = c("dc_inferior_indet", "dc_inferior_right", "dc_inferior_left"),
  dm1_indet = c("dm1_indet"),
  dm1_superior = c("dm1_superior_indet", "dm1_superior_left", "dm1_superior_right"),
  dm1_inferior = c("dm1_inferior_indet", "dm1_inferior_right", "dm1_inferior_left"),
  dm2_indet = c("dm2_indet"),
  dm2_superior = c("dm2_superior_indet", "dm2_superior_right", "dm2_superior_left"),
  dm2_inferior = c("dm2_inferior_indet", "dm2_inferior_right", "dm2_inferior_left"),
  permanent_indet = c("permanent_indet"),
  i1_indet = c("i1_indet"),
  i1_superior = c("i1_superior_indet", "i1_superior_right", "i1_superior_left"),
  i1_inferior = c("i1_inferior_indet", "i1_inferior_right", "i1_inferior_left"),
  i2_indet = c("i2_indet"),
  i2_superior = c("i2_superior_indet", "i2_superior_right", "i2_superior_left"),
  i2_inferior = c("i2_inferior_indet", "i2_inferior_right", "i2_inferior_left"),
  c_indet = c("c_indet"),
  c_superior = c("c_superior_indet", "c_superior_right", "c_superior_left"),
  c_inferior = c("c_inferior_indet", "c_inferior_right", "c_inferior_left"),
  pm3_indet = c("pm3_indet"),
  pm3_superior = c("pm3_superior_indet", "pm3_superior_right", "pm3_superior_left"),
  pm3_inferior = c("pm3_inferior_indet", "pm3_inferior_right", "pm3_inferior_left"),
  pm4_indet = c("pm4_indet"),
  pm4_superior = c("pm4_superior_indet", "pm4_superior_right", "pm4_superior_left"),
  pm4_inferior = c("pm4_inferior_indet", "pm4_inferior_right", "pm4_inferior_left"),
  m1_indet = c("m1_indet"),
  m1_superior = c("m1_superior_indet", "m1_superior_right", "m1_superior_left"),
  m1_inferior = c("m1_inferior_indet", "m1_inferior_right", "m1_inferior_left"),
  m2_indet = c("m2_indet"),
  m2_superior = c("m2_superior_indet", "m2_superior_right", "m2_superior_left"),
  m2_inferior = c("m2_inferior_indet", "m2_inferior_right", "m2_inferior_left"),
  m3_indet = c("m3_indet"),
  m3_superior = c("m3_superior_indet", "m3_superior_right", "m3_superior_left"),
  m3_inferior = c("m3_inferior_indet", "m3_inferior_right", "m3_inferior_left")
)
