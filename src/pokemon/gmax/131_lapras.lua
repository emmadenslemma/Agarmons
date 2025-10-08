-- G-Max Lapras 131
local gmax_lapras = {
  name = "gmax_lapras",
  pos = { x = 14, y = 7 },
  soul_pos = { x = 15, y = 7 },
  config = { extra = {} },
  loc_txt = {
    name = "Gigantamax Lapras",
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
  AGAR.GMAX.evos["j_poke_lapras"] = "j_agar_gmax_lapras"
end

return {
  name = "Agarmons G-Max Lapras",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_lapras }
}
