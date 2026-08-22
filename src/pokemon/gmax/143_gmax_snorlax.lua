-- G-Max Snorlax 143
local gmax_snorlax = {
  name = "gmax_snorlax",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_mod = 0.2, Xmult = 1, selection_limit_mod = 2 } },
  loc_vars = function(self, info_queue, card)
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
    -- Add new Poker Hand names
    if context.evaluate_poker_hand then
      if context.scoring_name == 'Flush Five' then
        local count = #context.poker_hands['Flush Five'][1]
        if count == 6 then return { replace_display_name = localize('agar_flush_six') } end
        if count == 7 then return { replace_display_name = localize('agar_flush_seven') } end
        if count == 8 then return { replace_display_name = localize('agar_flush_eight') } end
        if count == 9 then return { replace_display_name = localize('agar_flush_nine') } end
      end
      if context.scoring_name == 'Five of a Kind' then
        local count = #context.poker_hands['Five of a Kind'][1]
        if count == 6 then return { replace_display_name = localize('agar_six_of_a_kind') } end
        if count == 7 then return { replace_display_name = localize('agar_seven_of_a_kind') } end
        if count == 8 then return { replace_display_name = localize('agar_eight_of_a_kind') } end
        if count == 9 then return { replace_display_name = localize('agar_nine_of_a_kind') } end
      end
    end
    -- Add Regular Snorlax's scoring effect
    return G.P_CENTERS['j_poke_snorlax']:calculate(card, context)
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
  pokermon.add_family { "snorlax", "gmax_snorlax" }
  AG.gmax.disable_method_during_evolve("j_poke_snorlax", "add_to_deck")

  SMODS.Joker:take_ownership("poke_snorlax", { gmax = "gmax_snorlax", poke_custom_values_to_keep = { "Xmult" } }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_snorlax }
}
