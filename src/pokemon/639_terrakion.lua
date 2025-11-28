-- Terrakion 639
local terrakion = {
  name = "terrakion",
  config = { extra = { Xmult = 1, Xmult_mod = 0.5, destroy_mod = 2 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local key = pokermon_config.pokemon_aprilfools and (self.key .. '_aprilfools') or self.key
    return { key = key, vars = { center.ability.extra.destroy_mod, center.ability.extra.Xmult_mod, center.ability.extra.Xmult } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Earth",
  gen = 5,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
      local cards = {}
      local deck = AG.list_utils.copy(G.deck.cards)
      table.sort(deck, function(a, b) return a:get_nominal() < b:get_nominal() end)
      local stones = 0
      for i = 1, math.min(card.ability.extra.destroy_mod, #deck) do
        cards[i] = deck[i]
        if SMODS.has_enhancement(cards[i], 'm_stone') then
          stones = stones + 1
        end
      end
      if #cards > 0 then
        SMODS.destroy_cards(cards, nil, nil, true)
        if stones > 0 then
          card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * stones
          return {
            message = localize('agar_rock_smash_ex'),
            colour = G.C.MULT,
          }
        else
          return {
            message = localize(pokermon_config.pokemon_aprilfools and 'agar_double_kick_ex' or 'agar_rock_slide_ex')
          }
        end
      end
    end
  end,
}

return {
  can_load = false,
  enabled = false, -- agarmons_config.terrakion or false,
  list = { terrakion }
}
