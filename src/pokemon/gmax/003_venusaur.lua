-- G-Max Venusaur 003
local gmax_venusaur = {
  name = "gmax_venusaur",
  pos = { x = 12, y = 6 },
  soul_pos = { x = 13, y = 6 },
  config = { extra = {} },
  loc_txt = {
    name = "Gigantamax Venusaur",
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
  ptype = "Grass",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

local init = function()
  AGAR.GMAX.evos["j_poke_venusaur"] = "j_agar_gmax_venusaur"
end

return {
  name = "Agarmons G-Max Venusaur",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_venusaur }
}
