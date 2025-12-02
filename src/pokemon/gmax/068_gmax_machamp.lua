-- G-Max Machamp 068
local gmax_machamp = {
  name = "gmax_machamp",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_multi = 2, hands = 4, discards = 4 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Machamp",
    text = {
      "Gain {C:blue}+#3#{} Hands this round",
      "{br:2.5}ERROR - CONTACT STEAK",
      "If played hand is exactly",
      "{C:attention}4{} cards, played cards give",
      "{C:white,X:mult}X#4#{} Mult when scored",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.hands, card.ability.extra.Xmult_multi } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Fighting",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and #context.full_hand == 4 then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    ease_hands_played(card.ability.extra.hands)
    G.P_CENTERS.j_poke_machamp.add_to_deck(self, card, from_debuff)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.P_CENTERS.j_poke_machamp.remove_from_deck(self, card, from_debuff)
  end
}

local init = function()
  AG.append_to_family("machamp", "gmax_machamp", true)
  AG.gmax.disable_method_during_evolve("j_poke_machamp", "add_to_deck")
  AG.gmax.disable_method_during_evolve("j_poke_machamp", "remove_from_deck")

  SMODS.Joker:take_ownership("poke_machamp", { gmax = "gmax_machamp" }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_machamp }
}
