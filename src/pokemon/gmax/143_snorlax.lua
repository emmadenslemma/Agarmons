-- G-Max Snorlax 143
local gmax_snorlax = {
  name = "gmax_snorlax",
  pos = { x = 2, y = 8 },
  soul_pos = { x = 3, y = 8 },
  config = { extra = { Xmult_mod = 0.2, Xmult = 1, no_holding = true } },
  loc_txt = {
    name = "Gigantamax Snorlax",
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
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  poke_custom_values_to_keep = { "no_holding" },
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
end

return {
  name = "Agarmons G-Max Snorlax",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_snorlax }
}
