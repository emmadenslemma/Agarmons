-- Terrakion 639
local terrakion = {
  name = "terrakion",
  config = { extra = { destroy_mod = 2 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local key = pokermon_config.pokemon_aprilfools and (self.key .. '_aprilfools') or self.key
    return { key = key, vars = { center.ability.extra.destroy_mod } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Earth",
  gen = 5,
  calculate = function(self, card, context)
    if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
      local cards = {}
      local deck = AG.list_utils.copy(G.deck.cards)
      table.sort(deck, function (a, b) return a:get_nominal() < b:get_nominal() end)
      for i = 1, math.min(card.ability.extra.destroy_mod, #deck) do
        cards[i] = deck[i]
      end
      if #cards > 0 then
        SMODS.destroy_cards(cards, nil, nil, true)
        return {
          message = localize(pokermon_config.pokemon_aprilfools and 'agar_double_kick_ex' or 'agar_rock_smash_ex')
        }
      end
    end
  end,
}

return {
  enabled = agarmons_config.terrakion or false,
  list = { terrakion }
}
