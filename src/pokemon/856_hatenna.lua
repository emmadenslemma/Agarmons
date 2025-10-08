-- Hatenna 856
local hatenna = {
  name = "hatenna",
  config = { extra = { rounds = 5 } },
  loc_txt = {
    name = "Hatenna",
    text = {
      "{C:inactive}Does nothing (yet!)",
      "{C:inactive,s:0.8}(Evolves after {C:attention,s:0.8}#1#{C:inactive,s:0.8} rounds)",
    }
  },
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
  loc_txt = {
    name = "Hattrem",
    text = {
      "{C:inactive}Does nothing (yet!)",
      "{C:inactive,s:0.8}(Evolves after {C:attention,s:0.8}#1#{C:inactive,s:0.8} rounds)",
    }
  },
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
  loc_txt = {
    name = "Hatterene",
    text = {
      "{C:inactive}Does nothing (yet!)",
    }
  },
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
  name = "Agarmons Hatenna Evo Line",
  enabled = agarmons_config.hatenna or false,
  list = { hatenna, hattrem, hatterene }
}
