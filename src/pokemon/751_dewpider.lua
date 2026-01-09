-- Dewpider 751
local dewpider = {
  name = "dewpider",
  config = { extra = { hazard_level = 1, mult = 8, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = { set = 'Other', key = 'hazard_level', vars = poke_get_hazard_level_vars() }
    info_queue[#info_queue+1] = G.P_CENTERS.m_poke_hazard
    return { vars = { card.ability.extra.hazard_level, card.ability.extra.mult, card.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Water",
  gen = 7,
  blueprint_compat = true,
  hazard_poke = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and SMODS.has_enhancement(context.other_card, "m_poke_hazard") then
      return {
        mult = card.ability.extra.mult
      }
    end
    return level_evo(self, card, context, "j_agar_araquanid")
  end,
  add_to_deck = function(self, card, from_debuff)
    poke_change_hazard_level(card.ability.extra.hazard_level)
  end,
  remove_from_deck = function(self, card, from_debuff)
    poke_change_hazard_level(-card.ability.extra.hazard_level)
  end,
}

-- Araquanid 752
local araquanid = {
  name = "araquanid",
  config = { extra = { hazard_level = 1, mult = 8, Xmult_multi = 2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = { set = 'Other', key = 'hazard_level', vars = poke_get_hazard_level_vars() }
    info_queue[#info_queue+1] = G.P_CENTERS.m_poke_hazard
    return { vars = { card.ability.extra.hazard_level, card.ability.extra.mult, card.ability.extra.Xmult_multi } }
  end,
  rarity = 2,
  cost = 5,
  stage = "One",
  ptype = "Water",
  gen = 7,
  blueprint_compat = true,
  hazard_poke = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and SMODS.has_enhancement(context.other_card, "m_poke_hazard") then
      local first_hazard
      for _, scoring_card in ipairs(context.scoring_hand) do
        if SMODS.has_enhancement(scoring_card, "m_poke_hazard") then
          first_hazard = scoring_card
          break
        end
      end
      if context.other_card == first_hazard then
        return {
          mult = card.ability.extra.mult,
          Xmult = card.ability.extra.Xmult_multi
        }
      else
        return {
          mult = card.ability.extra.mult
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    poke_change_hazard_level(card.ability.extra.hazard_level)
  end,
  remove_from_deck = function(self, card, from_debuff)
    poke_change_hazard_level(-card.ability.extra.hazard_level)
  end,
}

return {
  config_key = "dewpider",
  list = { dewpider, araquanid }
}
