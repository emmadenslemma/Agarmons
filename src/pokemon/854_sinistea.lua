-- Sinistea 856
local sinistea = {
  name = "sinistea",
  config = { extra = { rounds = 5 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Psychic",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    return level_evo(self, card, context, "j_agar_polteageist")
  end,
}

-- Polteageist 857
local polteageist = {
  name = "polteageist",
  config = { extra = {} },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.rounds } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Psychic",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

return {
  enabled = agarmons_config.sinistea or false,
  list = { sinistea, polteageist }
}
