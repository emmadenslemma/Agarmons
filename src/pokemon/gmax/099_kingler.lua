-- G-Max Kingler 099
local gmax_kingler = {
  name = "gmax_kingler",
  inject_prefix = "poke",
  config = { extra = { chips = 16 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Kingler",
    text = {
      "Played face cards permanently",
      "get {C:chips}+#3#{} chips when scored",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.chips } }
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
  AG.append_to_family("kingler", "gmax_kingler")
  AG.gmax.evos["j_poke_kingler"] = "j_poke_gmax_kingler"
end

return {
  name = "Agarmons G-Max Kingler",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_kingler }
}
