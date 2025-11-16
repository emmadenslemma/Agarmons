-- Scorbunny 813
local scorbunny = {
  name = "scorbunny",
  config = { extra = { d_size = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size } }
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Fire",
  gen = 8,
  starter = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
    ease_discard(card.ability.extra.d_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
  end,
}

-- Raboot 814
local raboot = {
  name = "raboot",
  config = { extra = { d_size = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Fire",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
    ease_discard(card.ability.extra.d_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
  end,
}

-- Cinderace 815
local cinderace = {
  name = "cinderace",
  config = { extra = { d_size = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Fire",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
    ease_discard(card.ability.extra.d_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
  end,
}

-- G-Max Cinderace 815-1
local gmax_cinderace = {
  name = "gmax_cinderace",
  config = { extra = {} },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Cinderace",
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
  ptype = "Fire",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

local function init()
  AG.gmax.evos["j_agar_cinderace"] = "j_agar_gmax_cinderace"
end

return {
  enabled = agarmons_config.scorbunny,
  init = init,
  list = { scorbunny, raboot, cinderace, gmax_cinderace }
}
