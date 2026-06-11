local filter = AG.list_utils.filter

local get_diamond_count = function()
  return #filter(G.playing_cards or {}, function(card) return card:is_suit('Diamonds') end)
end

-- Diancie 719
local diancie = {
  name = "diancie",
  config = { extra = { money_mod = 1, hazard_level = 1, hazard_max = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = { set = 'Other', key = 'hazard_level', vars = pokermon.get_hazard_level_vars() }
    info_queue[#info_queue+1] = G.P_CENTERS.m_poke_hazard
    return { vars = { card.ability.extra.money_mod, get_diamond_count() * card.ability.extra.money_mod } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Fairy",
  gen = 6,
  blueprint_compat = false,
  add_to_deck = function(self, card, from_debuff)
    pokermon.change_hazard_max(card.ability.extra.hazard_max)
    pokermon.change_hazard_level(card.ability.extra.hazard_level)
  end,
  remove_from_deck = function(self, card, from_debuff)
    pokermon.change_hazard_max(-card.ability.extra.hazard_max)
    pokermon.change_hazard_level(-card.ability.extra.hazard_level)
  end,
  calc_dollar_bonus = function(self, card)
    local money = get_diamond_count() * card.ability.extra.money_mod
    if money > 0 then
      return money
    end
  end
}

AG.hookafterfunc(Card, 'is_suit', function(self, suit, bypass_debuff, flush_calc)
  return suit == 'Diamonds'
      and (flush_calc or (not self.debuff or bypass_debuff))
      and next(SMODS.find_card('j_agar_diancie'))
      and SMODS.has_no_suit(self)
end)

return {
  config_key = "diancie",
  list = { diancie }
}
