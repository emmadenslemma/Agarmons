-- Hatenna 856
local hatenna = {
  name = "hatenna",
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
    return level_evo(self, card, context, "j_agar_hattrem")
  end,
}

-- Hattrem 857
local hattrem = {
  name = "hattrem",
  config = { extra = { rounds = 5 } },
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
    return level_evo(self, card, context, "j_agar_hatterene")
  end,
}

-- Hatterene 858
local hatterene = {
  name = "hatterene",
  config = { extra = {} },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Psychic",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

return {
  can_load = false,
  config_key = "hatenna",
  list = { hatenna, hattrem, hatterene }
}
