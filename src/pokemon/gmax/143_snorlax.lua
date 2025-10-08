-- G-Max Snorlax 143
local gmax_snorlax = {
  name = "gmax_snorlax",
  pos = { x = 2, y = 8 },
  soul_pos = { x = 3, y = 8 },
  config = { extra = { Xmult = 1 } },
  loc_txt = {
    name = "Gigantamax Snorlax",
    text = {
      "{C:inactive}Does nothing (yet!)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
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
