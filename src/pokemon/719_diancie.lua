local filter = AG.list_utils.filter

local get_diamond_count = function()
  return #filter(G.playing_cards or {}, function(card) return card:is_suit('Diamonds') end)
end

-- Diancie 719
local diancie = {
  name = "diancie",
  config = { extra = { money_mod = 1 } },
  loc_txt = {
    name = "Diancie",
    text = {
      "{C:attention}Suitless{} cards are",
      "considered {C:diamonds}Diamonds",
      "{br:2}ERROR - CONTACT STEAK",
      "Earn {C:money}$#1#{} at end of round",
      "for every {C:diamonds}Diamond{} card",
      "in your full deck",
      "{C:inactive}(Currently {C:money}$#2#{C:inactive})",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.money_mod, get_diamond_count() * card.ability.extra.money_mod } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Fairy",
  gen = 6,
  blueprint_compat = false,
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
