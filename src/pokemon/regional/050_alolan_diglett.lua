local any = AG.list_utils.any

-- Alolan Diglett 50-1
local alolan_diglett = {
  name = "alolan_diglett",
  config = { extra = { chips = 40, mult = 6, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Metal",
  gen = 7,
  calculate = function(self, card, context)
    if context.joker_main then
      local score_chips = any(context.scoring_hand, function(c) return c:get_id() == 8 or c:get_id() == 9 or c:get_id() == 10 end)
      local score_mult = next(context.poker_hands['Three of a Kind'])

      if score_chips and score_mult then
        return {
          message = localize('poke_dig_ex'),
          chip_mod = card.ability.extra.chips,
          mult_mod = card.ability.extra.mult,
        }
      else
        return {
          chips = score_chips and card.ability.extra.chips,
          mult = score_mult and card.ability.extra.mult,
        }
      end
    end
    return pokermon.level_evo(self, card, context, 'j_agar_alolan_dugtrio')
  end,
}

-- Alolan Dugtrio 51-1
local alolan_dugtrio = {
  name = "alolan_dugtrio",
  config = { extra = { chips = 80, Xmult = 1.75 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult, card.ability.extra.chips } }
  end,
  rarity = 2,
  cost = 6,
  stage = "One",
  ptype = "Metal",
  gen = 7,
  calculate = function(self, card, context)
    if context.joker_main then
      local score_chips = any(context.scoring_hand, function(c) return c:get_id() == 8 or c:get_id() == 9 or c:get_id() == 10 end)
      local score_Xmult = next(context.poker_hands['Three of a Kind'])

      if score_chips and score_Xmult then
        return {
          message = localize('poke_dig_ex'),
          chip_mod = card.ability.extra.chips,
          Xmult_mod = card.ability.extra.Xmult,
        }
      else
        return {
          chips = score_chips and card.ability.extra.chips,
          Xmult = score_Xmult and card.ability.extra.Xmult,
        }
      end
    end
  end,
}

return {
  config_key = 'alolan_diglett',
  list = { alolan_diglett, alolan_dugtrio }
}
