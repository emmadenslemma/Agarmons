local filter = AG.list_utils.filter

-- G-Max Kingler 099
local gmax_kingler = {
  name = "gmax_kingler",
  agar_inject_prefix = "poke",
  config = { extra = { card_chip_multi = 2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.e_foil
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 1,
  calculate = function(self, card, context)
    if context.before then
      local eligible_kings = filter(context.scoring_hand, function(scoring_card)
        return scoring_card:get_id() == 13
            and not (scoring_card.edition and scoring_card.edition.foil)
      end)

      if #eligible_kings > 0 then
        for _, king in ipairs(eligible_kings) do
          king:set_edition('e_foil', true)
        end

        return {
          message = localize("agar_gmax_foam_burst_ex"),
          colour = G.C.RARITY["agar_gmax"]
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    AG.effects.add_crab_chip_multiplier(card.ability.extra.card_chip_multi)
  end,
  remove_from_deck = function(self, card, from_debuff)
    AG.effects.remove_crab_chip_multiplier(card.ability.extra.card_chip_multi)
  end,
}

local init = function()
  pokermon.add_family { "kingler", "gmax_kingler" }

  SMODS.Joker:take_ownership("poke_kingler", { gmax = "gmax_kingler" }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_kingler }
}
