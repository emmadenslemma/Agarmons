local any = AG.list_utils.any
local is_queen = function(c) return c:get_id() == 12 end

local combee = {
  name = "combee",
  config = { extra = { queens_promoted = 0 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.c_agar_honey
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Grass",
  gen = 4,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and context.other_card:get_id() == 12
        and SMODS.has_enhancement(context.other_card, 'm_poke_flower') then
      card.ability.extra.queens_promoted = card.ability.extra.queens_promoted + 1
    end
    return pokermon.scaling_evo(self, card, context, 'j_agar_vespiquen', card.ability.extra.queens_promoted, 1)
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      pokermon.create_consumeable('c_agar_honey')
    end
  end,
}

local vespiquen = {
  name = "vespiquen",
  config = { extra = { retriggers = 1 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_poke_flower
  end,
  rarity = "poke_safari",
  cost = 7,
  stage = "One",
  ptype = "Grass",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play
        and any(context.scoring_hand, is_queen)
        and SMODS.has_enhancement(context.other_card, 'm_poke_flower') then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
  end
}

local init = function()
  AG.hookbeforefunc(SMODS, 'smeared_check', function(card, suit)
    return (next(SMODS.find_card('j_agar_combee')) or next(SMODS.find_card('j_agar_vespiquen')))
        and ((card.base.suit == 'Diamonds' and suit == 'Spades')
          or (card.base.suit == 'Spades' and suit == 'Diamonds'))
  end)
end

return {
  config_key = "combee",
  init = init,
  list = { combee, vespiquen }
}
