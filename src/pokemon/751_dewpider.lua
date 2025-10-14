-- Dewpider 751
local dewpider = {
  name = "dewpider",
  config = { extra = { hazards = 4, mult = 8, rounds = 4 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue + 1] = { set = 'Other', key = 'poke_hazards', vars = { center.ability.extra.hazards } }
    info_queue[#info_queue + 1] = G.P_CENTERS.m_poke_hazard
    return { vars = { center.ability.extra.hazards, center.ability.extra.mult, center.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Water",
  gen = 7,
  blueprint_compat = true,
  hazard_poke = true,
  calculate = function(self, card, context)
    if context.setting_blind then
      poke_set_hazards(card.ability.extra.hazards)
    end
    if context.individual and context.cardarea == G.play
        and SMODS.has_enhancement(context.other_card, "m_poke_hazard") then
      return {
        mult = card.ability.extra.mult
      }
    end
    return level_evo(self, card, context, "j_agar_araquanid")
  end,
}

-- Araquanid 752
local araquanid = {
  name = "araquanid",
  config = { extra = { hazards = 4, mult = 8, Xmult = 2 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue + 1] = { set = 'Other', key = 'poke_hazards', vars = { center.ability.extra.hazards } }
    info_queue[#info_queue + 1] = G.P_CENTERS.m_poke_hazard
    return { vars = { center.ability.extra.hazards, center.ability.extra.mult, center.ability.extra.Xmult } }
  end,
  rarity = 2,
  cost = 5,
  stage = "One",
  ptype = "Water",
  gen = 7,
  blueprint_compat = true,
  hazard_poke = true,
  calculate = function(self, card, context)
    if context.setting_blind then
      poke_set_hazards(card.ability.extra.hazards)
    end
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
          Xmult = card.ability.extra.Xmult
        }
      else
        return {
          mult = card.ability.extra.mult
        }
      end
    end
  end,
}

return {
  name = "Agarmons Dewpider Evo Line",
  enabled = agarmons_config.dewpider or false,
  list = { dewpider, araquanid }
}
