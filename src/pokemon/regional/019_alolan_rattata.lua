-- Alolan Rattata 19-1
local alolan_rattata = {
  name = "alolan_rattata",
  config = { extra = { retriggers = 1, bonus_retriggers = 1, rounds = 5 } },
  loc_vars = function(self, info_queue, card)
    local ex = card.ability.extra
    return { vars = { ex.retriggers, ex.retriggers + ex.bonus_retriggers, ex.rounds } }
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Dark",
  gen = 7,
  weight = 10 / 3,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
      return {
        repetitions = card.ability.extra.retriggers
            + card.ability.extra.bonus_retriggers
            * math.floor(pseudorandom('agar_hawaii_rat') * 2)
      }
    end
    return pokermon.level_evo(self, card, context, 'j_agar_alolan_raticate')
  end,
}

-- Alolan Raticate 20-1
local alolan_raticate = {
  name = "alolan_raticate",
  config = { extra = { retriggers = 1, bonus_retriggers = 2 } },
  loc_vars = function(self, info_queue, card)
    local ex = card.ability.extra
    return { vars = { ex.retriggers, ex.retriggers + ex.bonus_retriggers } }
  end,
  rarity = "poke_safari",
  cost = 7,
  stage = "One",
  ptype = "Dark",
  gen = 7,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
      return {
        repetitions = card.ability.extra.retriggers
            + card.ability.extra.bonus_retriggers
            * math.floor(pseudorandom('agar_hawaii_rat') * 2)
      }
    end
  end,
}

return {
  config_key = 'alolan_rattata',
  list = { alolan_rattata, alolan_raticate }
}
