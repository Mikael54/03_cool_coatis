# Author: Ore Solanke
# Date: October 2025
# Script: pp_regress.R
# Description: EcolArchives Linear Regression Plotting and LM analysis


rm(list=ls())

## load required packages
packages<-c('tidyr', 'dplyr', 'ggplot2', 'ggthemes')
lapply(packages, require, character.only=TRUE)

## load in data 
eco.df <-read.csv("../data/EcolArchives-E089-51-D1.csv")
#glimpse(eco.df)

## set factors 
eco.df$Type.of.feeding.interaction <- as.factor(eco.df$Type.of.feeding.interaction)
eco.df$Location <- as.factor(eco.df$Location)
eco.df$Predator.lifestage <- as.factor(eco.df$Predator.lifestage)

## convert units mg to g 
eco.df$Prey.mass[eco.df$Prey.mass.unit == "mg"] <- eco.df$Prey.mass[eco.df$Prey.mass.unit == "mg"] / 1000
eco.df$Prey.mass.unit[eco.df$Prey.mass.unit == "mg"] <- "g"

## linear regression considering three variables 

location_eco_reg <- eco.df %>% 
  group_by(Location, Type.of.feeding.interaction, Predator.lifestage) %>% 
  
  reframe ({ location_interation_lm <- lm(log10(Prey.mass) ~ log10(Predator.mass), data=.)
    
    loc_lm_summary <- summary(location_interation_lm)

    tibble(
      slope = coef(location_interation_lm)[2],
      intercept = coef(location_interation_lm)[1],
      R_squared = sqrt(loc_lm_summary$r.squared),
      F_statistic = loc_lm_summary$fstatistic,
      p_value = loc_lm_summary$coefficients[2, 4])})


write.csv(location_eco_reg, "../results/pp_regress_location_results.csv")
