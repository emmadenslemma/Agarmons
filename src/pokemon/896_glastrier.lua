-- Glastrier 896
local glastrier = {
  name = "glastrier",
  config = { extra = {} },
  loc_txt = {
    name = "Glastrier",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  fuses = { with = "j_agar_calyrex", into = "j_agar_calyrex_ice" }
}

return {
  can_load = false,
  config_key = "calyrex",
  list = { glastrier }
}
