-- G-Max Charizard 012
local gmax_charizard = {
  name = "gmax_charizard",
  pos = { x = 0, y = 7 },
  soul_pos = { x = 1, y = 7 },
  config = { extra = {} },
  loc_txt = {
    name = "Gigantamax Charizard",
    text = {}
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Fire",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        message = localize("agar_gmax_wildfire_ex"),
      }
    end
  end,
}

local init = function()
  GMAX.evos["j_poke_charizard"] = "j_agar_gmax_charizard"
end

return {
  name = "Agarmons G-Max Charizard",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_charizard }
}
