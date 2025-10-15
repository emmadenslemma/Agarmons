-- Poltchageist 1012
local poltchageist = {
  name = "poltchageist",
  config = { extra = { rounds = 5 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.rounds } }
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Grass",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    return level_evo(self, card, context, "j_agar_sinistcha")
  end,
}

-- Sinistcha 1013
local sinistcha = {
  name = "sinistcha",
  config = { extra = {} },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.rounds } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Grass",
  gen = 10,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

return {
  enabled = agarmons_config.sinistea or false,
  list = { poltchageist, sinistcha }
}
