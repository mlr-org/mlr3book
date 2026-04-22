# Adapted from https://github.com/topepo/AmesHousing/blob/master/R/make_ames.R

library(tidyverse)

ten_point = c(
  "Very_Excellent",
  "Excellent",
  "Very_Good",
  "Good",
  "Above_Average",
  "Average",
  "Below_Average",
  "Fair",
  "Poor",
  "Very_Poor"
)
five_point = c(
  "Excellent",
  "Good",
  "Typical",
  "Fair",
  "Poor"
)

n = nrow(AmesHousing::ames_raw)

ames = AmesHousing::ames_raw %>%
    # Rename variables with spaces or begin with numbers.
    # SalePrice would be inconsistently named so change that too.
    dplyr::rename_with(
      ~ gsub(' ', '_', .),
      dplyr::contains(' '),
    ) %>%
    dplyr::rename(
      Sale_Price = SalePrice,
      Three_season_porch = `3Ssn_Porch`,
      Year_Remod_Add = `Year_Remod/Add`,
      First_Flr_SF = `1st_Flr_SF`,
      Second_Flr_SF = `2nd_Flr_SF`,
      Year_Sold = Yr_Sold
    ) %>%
    # Remove leading zeros
    dplyr::mutate(
      MS_SubClass = as.character(as.integer(MS_SubClass))
    ) %>%
    # Make more meaningful factor levels for some variables
    dplyr::mutate(
      MS_SubClass =
        dplyr::recode_factor(
          factor(MS_SubClass),
          '20' = 'One_Story_1946_and_Newer_All_Styles',
          '30' = 'One_Story_1945_and_Older',
          '40' = 'One_Story_with_Finished_Attic_All_Ages',
          '45' = 'One_and_Half_Story_Unfinished_All_Ages',
          '50' = 'One_and_Half_Story_Finished_All_Ages',
          '60' = 'Two_Story_1946_and_Newer',
          '70' = 'Two_Story_1945_and_Older',
          '75' = 'Two_and_Half_Story_All_Ages',
          '80' = 'Split_or_Multilevel',
          '85' = 'Split_Foyer',
          '90' = 'Duplex_All_Styles_and_Ages',
          '120' = 'One_Story_PUD_1946_and_Newer',
          '150' = 'One_and_Half_Story_PUD_All_Ages',
          '160' = 'Two_Story_PUD_1946_and_Newer',
          '180' = 'PUD_Multilevel_Split_Level_Foyer',
          '190' = 'Two_Family_conversion_All_Styles_and_Ages'
        )
    ) %>%
    dplyr::mutate(
      MS_Zoning =
        dplyr::recode_factor(
          factor(MS_Zoning),
          'A' = 'Agriculture',
          'C' = 'Commercial',
          'FV' = 'Floating_Village_Residential',
          'I' = 'Industrial',
          'RH' = 'Residential_High_Density',
          'RL' = 'Residential_Low_Density',
          'RP' = 'Residential_Low_Density_Park',
          'RM' = 'Residential_Medium_Density',
          'A (agr)' = 'A_agr',
          'C (all)' = 'C_all',
          'I (all)' = 'I_all'
        )
    ) %>%
    dplyr::mutate(
      Lot_Shape =
        dplyr::recode_factor(
          factor(Lot_Shape),
          'Reg' = 'Regular',
          'IR1' = 'Slightly_Irregular',
          'IR2' = 'Moderately_Irregular',
          'IR3' = 'Irregular'
        )
    ) %>%
    dplyr::mutate(Bldg_Type =
                    dplyr::recode_factor(factor(Bldg_Type),
                                         '1Fam' = 'OneFam',
                                         '2fmCon' = 'TwoFmCon')) %>%
    # Change some factor levels so that they make valid R variable names
    dplyr::mutate(
      House_Style =  gsub("^1.5", "One_and_Half_", House_Style),
      House_Style =  gsub("^1", "One_", House_Style),
      House_Style =  gsub("^2.5", "Two_and_Half_", House_Style),
      House_Style =  gsub("^2", "Two_", House_Style),
      House_Style = factor(House_Style)
    ) %>%
    dplyr::mutate(Garage_Type =
                    dplyr::recode(Garage_Type,
                                  '2Types' = 'More_Than_Two_Types')) %>%
    mutate(
      Overall_Qual =
        dplyr::recode(
          Overall_Qual,
          `10` = "Very_Excellent",
          `9` = "Excellent",
          `8` = "Very_Good",
          `7` = "Good",
          `6` = "Above_Average",
          `5` = "Average",
          `4` = "Below_Average",
          `3` = "Fair",
          `2` = "Poor",
          `1` = "Very_Poor"
        )
    ) %>%
    mutate(
      Overall_Cond =
        dplyr::recode(
          Overall_Cond,
          `10` = "Very_Excellent",
          `9` = "Excellent",
          `8` = "Very_Good",
          `7` = "Good",
          `6` = "Above_Average",
          `5` = "Average",
          `4` = "Below_Average",
          `3` = "Fair",
          `2` = "Poor",
          `1` = "Very_Poor"
        )
    ) %>%
    mutate(
      Exter_Qual =
        dplyr::recode(
          Exter_Qual,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor"
        )
    ) %>%
    mutate(
      Exter_Cond =
        dplyr::recode(
          Exter_Cond,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor"
        )
    ) %>%
    mutate(
      Bsmt_Qual =
        dplyr::recode(
          Bsmt_Qual,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor"
        )
    ) %>%
    mutate(
      Bsmt_Cond =
        dplyr::recode(
          Bsmt_Cond,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor"
        )
    ) %>%
    mutate(
      Heating_QC =
        dplyr::recode(
          Heating_QC,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor"
        )
    ) %>%
    mutate(
      Kitchen_Qual =
        dplyr::recode(
          Kitchen_Qual,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor"
        )
    ) %>%
    mutate(
      Fireplace_Qu =
        dplyr::recode(
          Fireplace_Qu,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor",
        )
    ) %>%
    mutate(
      Garage_Qual =
        dplyr::recode(
          Garage_Qual,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor",
        )
    ) %>%
    mutate(
      Garage_Cond =
        dplyr::recode(
          Garage_Cond,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor"
        )
    ) %>%
    mutate(
      Pool_QC =
        dplyr::recode(
          Pool_QC,
          "Ex" = "Excellent",
          "Gd" = "Good",
          "TA" = "Typical",
          "Fa" = "Fair",
          "Po" = "Poor"
        )
    ) %>%
    mutate(
      Neighborhood =
        dplyr::recode(
          Neighborhood,
          "Blmngtn" = "Bloomington_Heights",
          "Bluestem" = "Bluestem",
          "BrDale" = "Briardale",
          "BrkSide" = "Brookside",
          "ClearCr" = "Clear_Creek",
          "CollgCr" = "College_Creek",
          "Crawfor" = "Crawford",
          "Edwards" = "Edwards",
          "Gilbert" = "Gilbert",
          "Greens" = "Greens",
          "GrnHill" = "Green_Hills",
          "IDOTRR" = "Iowa_DOT_and_Rail_Road",
          "Landmrk" = "Landmark",
          "MeadowV" = "Meadow_Village",
          "Mitchel" = "Mitchell",
          "NAmes" = "North_Ames",
          "NoRidge" = "Northridge",
          "NPkVill" = "Northpark_Villa",
          "NridgHt" = "Northridge_Heights",
          "NWAmes" = "Northwest_Ames",
          "OldTown" = "Old_Town",
          "SWISU" = "South_and_West_of_Iowa_State_University",
          "Sawyer" = "Sawyer",
          "SawyerW" = "Sawyer_West",
          "Somerst" = "Somerset",
          "StoneBr" = "Stone_Brook",
          "Timber" = "Timberland",
          "Veenker" = "Veenker",
          "Hayden Lake" = "Hayden_Lake"
        )
    ) %>%
    mutate(
      Alley =
        dplyr::recode(
          Alley,
          "Grvl" = "Gravel",
          "Pave" = "Paved"
        )
    ) %>%
    mutate(
      Paved_Drive =
        dplyr::recode(
          Paved_Drive,
          "Y" = "Paved",
          "P" = "Partial_Pavement",
          "N" = "Dirt_Gravel"
        )
    )   %>%
    mutate(
      Fence =
        dplyr::recode(
          Fence,
          "GdPrv" = "Good_Privacy",
          "MnPrv" = "Minimum_Privacy",
          "GdWo" = "Good_Wood",
          "MnWw" = "Minimum_Wood_Wire"
        )
    )   %>%
    # Convert everything else to factors
    dplyr::mutate(
      Alley = factor(Alley),
      Bsmt_Qual = factor(Bsmt_Qual),
      Bsmt_Cond = factor(Bsmt_Cond),
      Central_Air = factor(Central_Air),
      Condition_1 = factor(Condition_1),
      Condition_2 = factor(Condition_2),
      Electrical = factor(Electrical),
      Exter_Cond = factor(Exter_Cond),
      Exter_Qual = factor(Exter_Qual),
      Exterior_1st = factor(Exterior_1st),
      Exterior_2nd = factor(Exterior_2nd),
      Fence = factor(Fence),
      Fireplace_Qu = factor(Fireplace_Qu),
      Foundation = factor(Foundation),
      Functional = factor(Functional),
      Garage_Cond = factor(Garage_Cond),
      Garage_Finish = factor(Garage_Finish),
      Garage_Qual = factor(Garage_Qual),
      Garage_Type = factor(Garage_Type),
      Heating = factor(Heating),
      Heating_QC = factor(Heating_QC),
      Kitchen_Qual = factor(Kitchen_Qual),
      Land_Contour = factor(Land_Contour),
      Land_Slope = factor(Land_Slope),
      Lot_Config = factor(Lot_Config),
      Mas_Vnr_Type = factor(Mas_Vnr_Type),
      Misc_Feature = factor(Misc_Feature),
      Paved_Drive = factor(Paved_Drive),
      Pool_QC = factor(Pool_QC),
      Roof_Matl = factor(Roof_Matl),
      Roof_Style = factor(Roof_Style),
      Sale_Condition = factor(Sale_Condition),
      Sale_Type = factor(Sale_Type),
      Street = factor(Street),
      Utilities = factor(Utilities),
      Overall_Qual = factor(Overall_Qual, levels = rev(ten_point)),
      Overall_Cond = factor(Overall_Cond, levels = rev(ten_point)),
      Bsmt_Exposure = factor(Bsmt_Exposure),
      BsmtFin_Type_1 = factor(BsmtFin_Type_1),
      BsmtFin_Type_2 = factor(BsmtFin_Type_2),
      Neighborhood = factor(Neighborhood)
    ) %>%
    dplyr::mutate(Misc_Feature_2 = factor(rep("Othr", times = n))) %>%
    dplyr::mutate(Condition_3 = Condition_2) %>%
    dplyr::mutate(Lot_Area_m2 = 0.092903 * Lot_Area) %>%
    dplyr::select(-Order,-PID,-Kitchen_Qual) %>%
    dplyr::select(order(colnames(.))) %>%
    dplyr::relocate(Sale_Price)

write.csv(ames, file = "data/ames_dirty.csv", row.names = FALSE)
