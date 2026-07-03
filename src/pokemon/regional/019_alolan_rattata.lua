-- Alolan Rattata 19-1
local alolan_rattata = {
  name = "alolan_rattata",
  config = { extra = { retriggers = 1, rounds = 5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.retriggers, card.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Dark",
  gen = 7,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1)
        and (context.other_card == G.hand.cards[1]
          or context.other_card == G.hand.cards[2]) then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
    return pokermon.level_evo(self, card, context, 'j_agar_alolan_raticate')
  end,
}

-- Alolan Raticate 20-1
local alolan_raticate = {
  name = "alolan_raticate",
  config = { extra = { retriggers = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.retriggers } }
  end,
  rarity = "poke_safari",
  cost = 7,
  stage = "One",
  ptype = "Dark",
  gen = 7,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1)
        and (context.other_card == G.hand.cards[1]
          or context.other_card == G.hand.cards[2]
          or context.other_card == G.hand.cards[3]) then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
  end,
}

return {
  config_key = 'alolan_rattata',
  list = { alolan_rattata, alolan_raticate }
}
