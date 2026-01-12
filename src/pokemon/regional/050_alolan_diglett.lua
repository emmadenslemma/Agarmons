local calculate_3oak_effect = function(self, card, context)
  local hand_cards = AG.list_utils.shallow_copy(G.hand.cards)
  pseudoshuffle(hand_cards, pseudoseed('alodiglet'))

  if hand_cards[1] then
    juice_flip_table(card, hand_cards, false, 1)

    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        hand_cards[1]:set_ability('m_steel')
        return true
      end
    }))

    juice_flip_table(card, hand_cards, true, 1)

    return {
      message = localize('poke_dig_ex'),
      colour = G.ARGS.LOC_COLOURS.metal,
    }
  end
end

-- Alolan Diglett 50-1
local alolan_diglett = {
  name = "alolan_diglett",
  config = { extra = { mult = 8, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.rounds } }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and next(context.poker_hands['Three of a Kind']) then
      return calculate_3oak_effect(self, card, context)
    end
    if context.joker_main then
      local score_mult = AG.list_utils.any(context.scoring_hand,
        function(c) return c:get_id() == 8 or c:get_id() == 9 or c:get_id() == 10 end)

      return score_mult and {
        mult = card.ability.extra.mult,
      }
    end
    return level_evo(self, card, context, 'j_agar_alolan_dugtrio')
  end,
}

-- Alolan Dugtrio 51-1
local alolan_dugtrio = {
  name = "alolan_dugtrio",
  config = { extra = { Xmult = 2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and next(context.poker_hands['Three of a Kind']) then
      return calculate_3oak_effect(self, card, context)
    end
    if context.joker_main then
      local score_mult = AG.list_utils.any(context.scoring_hand,
        function(c) return c:get_id() == 8 or c:get_id() == 9 or c:get_id() == 10 end)

      return {
        Xmult = score_mult and card.ability.extra.Xmult,
      }
    end
  end,
}

return {
  config_key = 'alolan_diglett',
  list = { alolan_diglett, alolan_dugtrio }
}
