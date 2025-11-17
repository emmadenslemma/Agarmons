-- G-Max Machamp 068
local gmax_machamp = {
  name = "gmax_machamp",
  inject_prefix = "poke",
  config = { extra = { Xmult = 1.5, hands = 4, discards = 4 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Machamp",
    text = {
      "Gain {C:blue}+#3#{} additional Hands",
      "this round",
      "{C:white,X:mult}X#4#{} Mult, doubles after",
      "every hand played",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.hands, center.ability.extra.Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Fighting",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main
        and card.ability.extra.Xmult > 1 then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    if context.after and context.cardarea == G.jokers and not context.blueprint
        and card.ability.extra.turns_left > 1 then
      card.ability.extra.Xmult = card.ability.extra.Xmult * 2
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    ease_hands_played(card.ability.extra.hands)
    ease_hands_played(card.ability.extra.hands)
  end,
  remove_from_deck = function(self, card, from_debuff)
    ease_hands_played(-card.ability.extra.hands)
  end
}

local init = function()
  AG.append_to_family("machamp", "gmax_machamp", true)
  AG.gmax.evos["j_poke_machamp"] = "j_poke_gmax_machamp"
  SMODS.Joker:take_ownership('poke_machamp', {
    gmax = "gmax_machamp",
    remove_from_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
      G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
      if AG.gmax.evolving then
        ease_hands_played(-card.ability.extra.hands)
      else
        local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
        if to_decrease > 0 then
          ease_hands_played(-to_decrease)
        end
      end
      ease_discard(card.ability.extra.discards)
    end
  }, true)
end

return {
  name = "Agarmons G-Max Machamp",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_machamp }
}
