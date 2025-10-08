-- G-Max Kingler 099
local gmax_kingler = {
  name = "gmax_kingler",
  pos = { x = 12, y = 7 },
  soul_pos = { x = 13, y = 7 },
  config = { extra = {  } },
  loc_txt = {
    name = "Gigantamax Kingler",
    text = {
      "{C:inactive}Does nothing (yet!)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

local init = function()
  AGAR.GMAX.evos["j_poke_kingler"] = "j_agar_gmax_kingler"
end

return {
  name = "Agarmons G-Max Kingler",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_kingler }
}
