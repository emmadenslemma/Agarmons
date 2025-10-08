-- G-Max Blastoise 009
local gmax_blastoise = {
  name = "gmax_blastoise",
  pos = { x = 14, y = 6 },
  soul_pos = { x = 15, y = 6 },
  config = { extra = {} },
  loc_txt = {
    name = "Gigantamax Blastoise",
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
  ptype = "Water",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

local init = function()
  AGAR.GMAX.evos["j_poke_blastoise"] = "j_agar_gmax_blastoise"
end

return {
  name = "Agarmons G-Max Blastoise",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_blastoise }
}
