-- G-Max Charizard 012
local gmax_charizard = {
  name = "gmax_charizard",
  base_key = "j_poke_charizard",
  pos = { x = 0, y = 7 },
  soul_pos = { x = 1, y = 7 },
  config = { extra = {  } },
  loc_txt = {
    name = "Gigantamax Charizard",
    text = {
      "#1#",
      "{br:2}ERROR - CONTACT STEAK",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {  } }
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

return {
  name = "Agarmons G-Max Charizard",
  enabled = agarmons_config.gmax or false,
  list = { gmax_charizard }
}
