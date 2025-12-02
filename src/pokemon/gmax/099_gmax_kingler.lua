-- G-Max Kingler 099
local gmax_kingler = {
  name = "gmax_kingler",
  agar_inject_prefix = "poke",
  config = { extra = { chips = 16 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Kingler",
    text = {
      "Played face cards permanently",
      "gain {C:chips}+#3#{} chips when scored",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and context.other_card:is_face() then
      context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.CHIPS
      }
    end
  end,
}

local init = function()
  AG.append_to_family("kingler", "gmax_kingler", true)

  SMODS.Joker:take_ownership("poke_kingler", { gmax = "gmax_kingler" }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_kingler }
}
