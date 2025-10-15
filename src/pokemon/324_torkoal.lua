-- Torkoal 324
local torkoal = {
  name = "torkoal",
  config = { extra = { retriggers = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    end
    return { vars = {} }
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Fire",
  gen = 3,
  enhancement_gate = 'm_mult',
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition
        and (context.cardarea == G.play
          or (context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1)))
        and SMODS.has_enhancement(context.other_card, 'm_mult') then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
  end,
}

return {
  name = "Agarmons Torkoal",
  enabled = agarmons_config.torkoal or false,
  list = { torkoal }
}
