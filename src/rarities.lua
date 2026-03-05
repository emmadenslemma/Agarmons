SMODS.Rarity {
  key = "primal",
  default_weight = 0,
  badge_colour = HEX("874E4F"),
  pools = { ["Joker"] = true },
}

SMODS.Rarity {
  key = "gmax",
  default_weight = 0,
  badge_colour = HEX("FF589E"),
  pools = { ["Joker"] = true },
}

pokermon.add_stage("Gigantamax")
pokermon.add_stage("Primal", "Legendary")
pokermon.add_stage("Eternamax", "Legendary")
