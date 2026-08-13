local any = AG.list_utils.any
local is_queen = function(c) return c:get_id() == 12 end

local combee = {
  name = "combee",
  config = { extra = { queens_promoted = 0 } },
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Grass",
  gen = 4,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.change_rank and context.new_rank == 12
        and (context.old_rank == 11 or context.old_rank == 13) then
      card.ability.extra.queens_promoted = card.ability.extra.queens_promoted + 1
    end
    return pokermon.scaling_evo(self, card, context, 'j_agar_vespiquen', card.ability.extra.queens_promoted, 1)
  end
}

local vespiquen = {
  name = "vespiquen",
  config = { extra = { retriggers = 1 } },
  rarity = "poke_safari",
  cost = 7,
  stage = "One",
  ptype = "Grass",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play
        and any(context.scoring_hand, is_queen)
        and (context.other_card:is_suit('Diamonds')
          or context.other_card:is_suit('Spades')) then -- Wait why are we checking both?
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
