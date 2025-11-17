-- G-Max Snorlax 143
local gmax_snorlax = {
  name = "gmax_snorlax",
  inject_prefix = "poke",
  config = { extra = { Xmult_mod = 0.2, Xmult = 1, selection_limit_mod = 2 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Snorlax",
    text = {
      "{C:white,X:mult}X#3#{} Mult",
      "{C:attention}+#4#{} card selection limit",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult, center.ability.extra.selection_limit_mod } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "Xmult" },
  -- Add Regular Snorlax's scoring effect
  calculate = SMODS.Joker.obj_table.j_poke_snorlax.calculate,
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
  AG.gmax.evos["j_poke_snorlax"] = "j_poke_gmax_snorlax"
  G.E_MANAGER:add_event(Event({
    func = function()
      G.P_CENTERS["j_poke_snorlax"].poke_custom_values_to_keep = G.P_CENTERS["j_poke_snorlax"].poke_custom_values_to_keep or {}
      table.insert(G.P_CENTERS["j_poke_snorlax"].poke_custom_values_to_keep, "Xmult")
      return true
    end
  }))
end

return {
  name = "Agarmons G-Max Snorlax",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_snorlax }
}
