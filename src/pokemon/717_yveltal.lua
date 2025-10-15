local energy = AGAR.ENERGY

-- Yveltal 717
local yveltal = {
  name = "yveltal",
  config = { extra = { energy_limit_mod = 1, energy_mod = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = 'Other', key = 'energize' }
    end
    return { vars = { center.ability.extra.energy_limit_mod, center.ability.extra.energy_mod } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dark",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Energize new Dark type Jokers
    if context.card_added and context.cardarea == G.jokers
        and not context.card.ability.consumeable then
      energy.increase(context.card, card.ability.extra.energy_mod)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    energy.increase_limit(card.ability.extra.energy_limit_mod)
    energy.increase_all("Dark", card.ability.extra.energy_mod)
    energy.increase(card, "Dark", card.ability.extra.energy_mod, true)
  end,
  remove_from_deck = function(self, card, from_debuff)
    energy.decrease_limit(card.ability.extra.energy_limit_mod)
    energy.decrease_all("Fairy", card.ability.extra.energy_mod)
  end,
}

return {
  name = "Agarmons Yveltal",
  enabled = agarmons_config.yveltal or false,
  list = { yveltal }
}
