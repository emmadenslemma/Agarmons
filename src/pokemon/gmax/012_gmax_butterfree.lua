-- G-Max Butterfree 012
local gmax_butterfree = {
  name = "gmax_butterfree",
  agar_inject_prefix = "poke",
  config = { extra = { mult = 100 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Butterfree",
    text = {
      "{C:mult}+#3# Mult"
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
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

  SMODS.Joker:take_ownership("poke_butterfree", { gmax = "gmax_butterfree" }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_butterfree }
}
