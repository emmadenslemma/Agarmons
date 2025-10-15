-- Torkoal 324
local torkoal = {
  name = "torkoal",
  config = { extra = { retriggers = 1, Xmult_mod = 0.1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    end
    local Xmult_total = 1
    if G.deck and G.deck.cards then
      for _, card in pairs(G.deck.cards) do
        if SMODS.has_enhancement(card, 'm_mult') then
          Xmult_total = Xmult_total + center.ability.extra.Xmult_mod
        end
      end
    end
    return { vars = { center.ability.extra.Xmult_mod, Xmult_total } }
  end,
  rarity = 3,
  cost = 7,
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
    if context.joker_main then
      local Xmult_total = 1
      for _, card_in_deck in pairs(G.deck.cards) do
        if SMODS.has_enhancement(card_in_deck, 'm_mult') then
          Xmult_total = Xmult_total + card.ability.extra.Xmult_mod
        end
      end
      return {
        Xmult = Xmult_total
      }
    end
  end,
}

return {
  name = "Agarmons Torkoal",
  enabled = agarmons_config.torkoal or false,
  list = { torkoal }
}
