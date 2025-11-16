-- G-Max Butterfree 012
local gmax_butterfree = {
  name = "gmax_butterfree",
  inject_prefix = "poke",
  config = { extra = { mult = 100 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Butterfree",
    text = {
      "{C:mult}+#3# Mult"
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
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
      }
    end
  end,
}

local init = function()
  AG.append_to_family("butterfree", "gmax_butterfree", true)
  AG.gmax.evos["j_poke_butterfree"] = "j_poke_gmax_butterfree"
end

return {
  name = "Agarmons G-Max Butterfree",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_butterfree }
}
