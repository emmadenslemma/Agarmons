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

poke_add_stage("Gigantamax")
poke_add_stage("Primal", "Legendary")
poke_add_stage("Eternamax", "Legendary")
