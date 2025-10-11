-- Sinistea 856
local sinistea = {
  name = "sinistea",
  config = { extra = { rounds = 5 } },
  loc_txt = {
    name = "Sinistea",
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
    return level_evo(self, card, context, "j_agar_polteageist")
  end,
}

-- Polteageist 857
local polteageist = {
  name = "polteageist",
  config = { extra = {} },
  loc_txt = {
    name = "Polteageist",
    text = {
      "{C:inactive}Does nothing (yet!)",
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
  end,
}

local init = function()
  pokermon.add_family { "sinistea", "polteageist" }
end

return {
  name = "Agarmons Sinistea Evo Line",
  enabled = agarmons_config.sinistea or false,
  init = init,
  list = { sinistea, polteageist }
}
