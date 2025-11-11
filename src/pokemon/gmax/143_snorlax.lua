-- G-Max Snorlax 143
local gmax_snorlax = {
  name = "gmax_snorlax",
  config = { extra = { Xmult_mod = 0.2, Xmult = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Snorlax",
    text = {
      "{C:white,X:mult}X#3#{} Mult",
      "All Jokers give Mult equal",
      "to twice their sell value",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "Xmult" },
  calculate = function(self, card, context)
    if context.other_joker then
      return {
        mult = context.other_joker.sell_cost * 2
      }
    end
    -- Apply Snorlax's base effect
    return SMODS.Joker.obj_table.j_poke_snorlax.calculate(self, card, context)
  end,
}

local init = function()
  AGAR.GMAX.evos["j_poke_snorlax"] = "j_agar_gmax_snorlax"
  AGAR.FAMILY_UTILS.init_gmax(gmax_snorlax)
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
