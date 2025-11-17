-- Sobble 816
local sobble = {
  name = "sobble",
  config = { extra = { hands = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.hands } }
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Water",
  gen = 8,
  starter = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
}

-- Drizzile 817
local drizzile = {
  name = "drizzile",
  config = { extra = { hands = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.hands } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Water",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
}

-- Inteleon 818
local inteleon = {
  name = "inteleon",
  config = { extra = { hands = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.hands } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Water",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
  gmax = "gmax_inteleon"
}

-- G-Max Inteleon 818-1
local gmax_inteleon = {
  name = "gmax_inteleon",
  config = { extra = {} },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Inteleon",
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
  ptype = "Water",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

return {
  enabled = agarmons_config.sobble,
  list = { sobble, drizzile, inteleon, gmax_inteleon }
}
