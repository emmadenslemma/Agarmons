local honey = {
  name = "honey",
  key = "honey",
  set = "poke_item",
  config = { max_highlighted = 1, extra = { bonus_growth = 3 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_poke_seed
    return { vars = { card.ability.max_highlighted, card.ability.extra.bonus_growth } }
  end,
  pos = { x = 2, y = 2 },
  atlas = "AgarmonsConsumables",
  cost = 4,
  unlocked = true,
  discovered = true,
  use = function(self, card, area, copier)
    pokermon.set_spoon_item(card)
    pokermon.juice_flip(card)
    for _, other_card in ipairs(G.hand.highlighted) do
      if SMODS.has_enhancement(other_card, 'm_poke_seed') then
        other_card.temp_level = other_card.ability.extra.level
        other_card.ability.extra.level = other_card.ability.extra.level + card.ability.extra.bonus_growth
        if other_card.ability.extra.level >= other_card.ability.extra.level_max then
          other_card:set_ability(G.P_CENTERS.m_poke_flower, nil, true)
        else
          AG.defer(function()
            other_card.temp_level = other_card.ability.extra.level
            other_card.config.center:set_sprites(other_card)
          end)
        end
      else
        other_card:set_ability(G.P_CENTERS.m_poke_seed, nil, true)
      end
    end
    pokermon.juice_flip(card, true)
    pokermon.unhighlight_cards()
  end,
  in_pool = function(self)
    return true
  end
}

return {
  config_key = "combee",
  list = { honey },
}
