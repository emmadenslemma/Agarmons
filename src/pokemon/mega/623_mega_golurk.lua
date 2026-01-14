-- Mega Golurk 623-1
local mega_golurk = {
  name = "mega_golurk",
  agar_inject_prefix = "poke",
  pos = { x = 0, y = 4 },
  soul_pos = { x = 1, y = 4 },
  config = { extra = { hazard_level = 1, Xmult_multi = 1.75, dem = 6 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.dem)
    return { vars = { card.ability.extra.hazard_level, card.ability.extra.Xmult_multi, num, dem } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Psychic",
  gen = 5,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round
        and SMODS.has_enhancement(context.other_card, 'm_poke_hazard') then
      if context.other_card.debuff then
        return {
          message = localize('k_debuffed'),
          colour = G.C.RED,
        }
      else
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
    end
    if context.destroy_card and context.cardarea == G.hand
        and not context.destroy_card.debuff
        and SMODS.has_enhancement(context.destroy_card, 'm_poke_hazard')
        and SMODS.pseudorandom_probability(card, 'megolurk', 1, card.ability.extra.dem) then
      return {
        remove = true
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    poke_change_hazard_level(card.ability.extra.hazard_level)
  end,
  remove_from_deck = function(self, card, from_debuff)
    poke_change_hazard_level(-card.ability.extra.hazard_level)
  end,
  designer = "Gem",
}

local function init()
  pokermon.add_family { "golurk", "mega_golurk" }
  SMODS.Joker:take_ownership("poke_golurk", { megas = { "mega_golurk" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_golurk }
}
