-- G-Max Eevee 133
local gmax_eevee = {
  name = "gmax_eevee",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult = 1.33 } },
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 8,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.other_joker then
      for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        for _, joker in ipairs(area.cards) do
          if joker == context.other_joker then
            return {
              Xmult = card.ability.extra.Xmult,
            }
          end
          if is_type(joker, get_type(context.other_joker)) then return end
        end
      end
    end
  end,
}

local init = function()
  pokermon.add_to_family("eevee", "gmax_eevee")

  SMODS.Joker:take_ownership("poke_eevee", { gmax = "gmax_eevee" }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_eevee }
}
