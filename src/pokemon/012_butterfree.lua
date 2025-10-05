-- G-Max Butterfree 012
local gmax_butterfree = {
  name = "gmax_butterfree",
  base_key = "j_poke_butterfree",
  pos = { x = 2, y = 7 },
  soul_pos = { x = 3, y = 7 },
  config = { extra = { mult = 120 } },
  loc_txt = {
    name = "Gigantamax Butterfree",
    text = {
      "#1#",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:mult}+#2# Mult"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.mult } }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Grass",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        message = localize("agar_gmax_befuddle_ex"),
        mult = card.ability.extra.mult
      }
    end
  end,
}

return {
  name = "Agarmons G-Max Butterfree",
  enabled = agarmons_config.gmax or false,
  list = { gmax_butterfree }
}
