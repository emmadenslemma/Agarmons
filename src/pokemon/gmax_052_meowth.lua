-- G-Max Meowth 052
local gmax_meowth = {
  name = "gmax_meowth",
  pos = { x = 6, y = 7 },
  soul_pos = { x = 7, y = 7 },
  config = { extra = {} },
  loc_txt = {
    name = "Gigantamax Meowth",
    text = {}
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        message = localize("agar_gmax_gold_rush_ex"),
      }
    end
  end,
}

local init = function()
  GMAX.evos["j_poke_meowth"] = "j_agar_gmax_meowth"
end

return {
  name = "Agarmons G-Max Meowth",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_meowth }
}
