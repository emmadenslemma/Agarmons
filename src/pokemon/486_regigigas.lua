-- Regigigas 486
local regigigas = {
  name = "regigigas",
  config = { extra = { slow_start_rounds = 5, Xmult = 5 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult, self.config.extra.slow_start_rounds, math.max(center.ability.extra.slow_start_rounds, 0) } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Colorless",
  gen = 4,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if card.ability.extra.slow_start_rounds > 0 then
      card:set_debuff(true)
    end
  end
}

local init = function()
  local set_debuff_ref = SMODS.current_mod.set_debuff
  SMODS.current_mod.set_debuff = function(card)
    local ret = false
    if set_debuff_ref then
      ret = set_debuff_ref(card)
    end

    if not ret
        and card.config.center_key == "j_agar_regigigas"
        and card.ability.extra.slow_start_rounds < 0 then
      ret = true
    end

    return ret
  end

  local calculate_ref = SMODS.current_mod.calculate
  SMODS.current_mod.calculate = function(self, context)
    if calculate_ref then
      calculate_ref(self, context)
    end
    if context.end_of_round and not context.individual and not context.repetition then
      for _, card in pairs(G.jokers.cards) do
        if card.config.center_key == "j_agar_regigigas" then
          card.ability.extra.slow_start_rounds = math.max(card.ability.extra.slow_start_rounds - 1, 0)
          if card.ability.extra.slow_start_rounds == 0 then
            card:set_debuff(false)
            SMODS.calculate_effect({ message = localize("k_active_ex") }, card)
          end
        end
      end
    end
  end
end

return {
  enabled = agarmons_config.regigigas or false,
  init = init,
  list = { regigigas }
}
