-- Scorbunny 813
local scorbunny = {
  name = "scorbunny",
  config = { extra = { d_size = 1, mult = 0, mult_mod = 1, discarded_cards = 0 }, evo_rqmt = 75 },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size, center.ability.extra.mult_mod, center.ability.extra.mult, center.ability.extra.discarded_cards, self.config.evo_rqmt } }
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
      return scaling_evo(self, card, context, "j_agar_raboot", card.ability.extra.discarded_cards, self.config.evo_rqmt)
          or {
            message = localize('k_reset'),
            colour = G.C.MULT,
          }
    end
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
  config = { extra = { d_size = 1, mult = 0, mult_mod = 2, discarded_cards = 0 }, evo_rqmt = 75 },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size, center.ability.extra.mult_mod, center.ability.extra.mult, center.ability.extra.discarded_cards, self.config.evo_rqmt } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Fire",
  gen = 8,
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
      return scaling_evo(self, card, context, "j_agar_cinderace", card.ability.extra.discarded_cards, self.config.evo_rqmt)
          or {
            message = localize('k_reset'),
            colour = G.C.MULT,
          }
    end
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
  config = { extra = { d_size = 1, mult = 0, mult_mod = 2, Xmult = 1, Xmult_mod = 0.1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.d_size, center.ability.extra.mult_mod, center.ability.extra.Xmult_mod, center.ability.extra.mult, center.ability.extra.Xmult } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Fire",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
        Xmult = card.ability.extra.Xmult,
      }
    end
    if context.pre_discard then
      local discard_amount = #context.full_hand
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * discard_amount
      card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * discard_amount
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT,
      }
    end
    if context.end_of_round and context.cardarea == G.jokers then
      card.ability.extra.mult = 0
      card.ability.extra.Xmult = 1
      return {
        message = localize('k_reset'),
        colour = G.C.MULT,
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not AG.gmax.evolving then
      G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
      ease_discard(card.ability.extra.d_size)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not AG.gmax.evolving then
      G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
      ease_discard(-card.ability.extra.d_size)
    end
  end,
  gmax = "gmax_cinderace"
}

-- G-Max Cinderace 815-1
local gmax_cinderace = {
  name = "gmax_cinderace",
  config = { extra = { d_size = 1 } },
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
  add_to_deck = function(self, card, from_debuff)
    if not AG.gmax.evolving then
      G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
      ease_discard(card.ability.extra.d_size)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not AG.gmax.evolving then
      G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
      ease_discard(-card.ability.extra.d_size)
    end
  end,
}

return {
  enabled = agarmons_config.scorbunny,
  list = { scorbunny, raboot, cinderace, gmax_cinderace }
}
