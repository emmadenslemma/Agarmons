-- G-Max Snorlax 143
local gmax_snorlax = {
  name = "gmax_snorlax",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_mod = 0.2, Xmult = 1, selection_limit_mod = 2 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Snorlax",
    text = {
      "{C:white,X:mult}X#3#{} Mult",
      "{C:attention}+#4#{} card selection limit",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult, card.ability.extra.selection_limit_mod } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "Xmult" },
  calculate = function(self, card, context)
    -- Add Regular Snorlax's scoring effect
    return G.P_CENTERS.j_poke_snorlax.calculate(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    SMODS.change_play_limit(card.ability.extra.selection_limit_mod)
    SMODS.change_discard_limit(card.ability.extra.selection_limit_mod)
  end,
  remove_from_deck = function(self, card, from_debuff)
    SMODS.change_play_limit(-card.ability.extra.selection_limit_mod)
    SMODS.change_discard_limit(-card.ability.extra.selection_limit_mod)
    if not G.GAME.before_play_buffer then
      G.hand:unhighlight_all()
    end
  end,
}

local init = function()
  AG.append_to_family("snorlax", "gmax_snorlax", true)
  AG.gmax.disable_method_during_evolve("j_poke_snorlax", "add_to_deck")

  SMODS.Joker:take_ownership("poke_snorlax", { gmax = "gmax_snorlax", poke_custom_values_to_keep = { "Xmult" } }, true)

  if not (SMODS.Mods['PokermonMaelmc'] or {}).can_load then
    SMODS.PokerHand:take_ownership("Five of a Kind", {
      modify_display_text = function(self, cards, scoring_hand)
        if #scoring_hand == 6 then
          return "Six of a Kind"
        elseif #scoring_hand == 7 then
          return "Seven of a Kind"
        end
      end
    }, true)
    SMODS.PokerHand:take_ownership("Flush Five", {
      modify_display_text = function(self, cards, scoring_hand)
        if #scoring_hand == 6 then
          return "Flush Six"
        elseif #scoring_hand == 7 then
          return "Flush Seven"
        end
      end
    }, true)
  end
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_snorlax }
}
