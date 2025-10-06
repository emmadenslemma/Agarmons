-- G-Max Pikachu 025
local gmax_pikachu = {
  name = "gmax_pikachu",
  base_key = "j_poke_pikachu",
  pos = { x = 4, y = 7 },
  soul_pos = { x = 5, y = 7 },
  config = { extra = {} },
  loc_txt = {
    name = "Gigantamax Pikachu",
    text = {
      "{C:inactive}Wait, it doesn't do anything?"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Lightning",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        message = localize("agar_gmax_volt_crash_ex"),
      }
    end
  end,
}

return {
  name = "Agarmons G-Max Pikachu",
  enabled = agarmons_config.gmax or false,
  list = { gmax_pikachu }
}
