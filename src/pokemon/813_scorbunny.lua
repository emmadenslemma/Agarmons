-- Scorbunny 813
local scorbunny = {
  name = "scorbunny",
  config = { extra = { d_size = 2, hands = 1, mult = 0, mult_mod = 1, discarded_cards = 0 }, evo_rqmt = 100 },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size, center.ability.extra.hands, center.ability.extra.mult_mod, center.ability.extra.mult, center.ability.extra.discarded_cards, self.config.evo_rqmt } }
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Fire",
  gen = 8,
  starter = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
    if context.pre_discard then
      local discard_amount = #context.full_hand
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * discard_amount
      card.ability.extra.discarded_cards = card.ability.extra.discarded_cards + discard_amount
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT,
      }
    end
    if context.end_of_round and context.cardarea == G.jokers then
      card.ability.extra.mult = 0
    end
    return scaling_evo(self, card, context, "j_agar_raboot", card.ability.extra.discarded_cards, self.config.evo_rqmt)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
    ease_discard(card.ability.extra.d_size)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
}

-- Raboot 814
local raboot = {
  name = "raboot",
  config = { extra = { d_size = 2, hands = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size, center.ability.extra.hands } }
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
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
}

-- Cinderace 815
local cinderace = {
  name = "cinderace",
  config = { extra = { d_size = 2, hands = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size, center.ability.extra.hands } }
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
    if not AG.gmax.evolving then
      G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
      ease_discard(card.ability.extra.d_size)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
      local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
      if to_decrease > 0 then
        ease_hands_played(-to_decrease)
      end
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not AG.gmax.evolving then
      G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
      ease_discard(-card.ability.extra.d_size)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
      if not from_debuff then
        ease_hands_played(card.ability.extra.hands)
      end
    end
  end,
  gmax = "gmax_cinderace"
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

return {
  enabled = agarmons_config.scorbunny,
  list = { scorbunny, raboot, cinderace, gmax_cinderace }
}
