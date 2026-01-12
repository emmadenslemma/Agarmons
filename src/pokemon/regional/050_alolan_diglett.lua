-- Alolan Diglett 50-1
local alolan_diglett = {
  name = "alolan_diglett",
  config = { extra = { chips = 60, mult = 4, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.rounds } }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local score_chips = next(context.poker_hands['Three of a Kind'])
      local score_mult = AG.list_utils.any(context.scoring_hand,
        function(c) return c:get_id() == 8 or c:get_id() == 9 or c:get_id() == 10 end)

      return {
        message = score_chips and score_mult and localize('poke_dig_ex'),
        chip_mod = score_chips and card.ability.extra.chips,
        mult_mod = score_mult and card.ability.extra.mult,
      }
    end
    return level_evo(self, card, context, 'j_agar_alolan_dugtrio')
  end,
}

-- Alolan Dugtrio 51-1
local alolan_dugtrio = {
  name = "alolan_dugtrio",
  config = { extra = { chips = 120, Xmult = 1.5 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.Xmult } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local score_chips = next(context.poker_hands['Three of a Kind'])
      local score_mult = AG.list_utils.any(context.scoring_hand,
        function(c) return c:get_id() == 8 or c:get_id() == 9 or c:get_id() == 10 end)

      return {
        message = score_chips and score_mult and localize('poke_dig_ex'),
        chip_mod = score_chips and card.ability.extra.chips,
        Xmult_mod = score_mult and card.ability.extra.Xmult,
      }
    end
  end,
}

return {
  config_key = 'alolan_diglett',
  list = { alolan_diglett, alolan_dugtrio }
}
