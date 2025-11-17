-- Grookey 810
local grookey = {
  name = "grookey",
  config = { extra = { h_size = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.h_size } }
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Grass",
  gen = 8,
  starter = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end
}

-- Thwackey 811
local thwackey = {
  name = "thwackey",
  config = { extra = { h_size = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.h_size } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Grass",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end
}

-- Rillaboom 812
local rillaboom = {
  name = "rillaboom",
  config = { extra = { h_size = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.h_size } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Grass",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end,
  gmax = "gmax_rillaboom"
}

-- G-Max Rillaboom 812-1
local gmax_rillaboom = {
  name = "gmax_rillaboom",
  config = { extra = {} },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Rillaboom",
    text = {
      "{C:inactive}Does nothing (yet!)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Grass",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

return {
  enabled = agarmons_config.scorbunny,
  list = { grookey, thwackey, rillaboom, gmax_rillaboom }
}
