local luxuryball = {
  name = "luxuryball",
  key = "luxuryball",
  set = "Spectral",
  pos = { x = 4, y = 1 },
  atlas = "AgarmonsConsumables",
  cost = 4,
  pokeball = true,
  hidden = true,
  soul_set = "Item",
  soul_rate = .008,
  can_use = function(self, card)
    return #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        SMODS.add_card({ set = 'Joker', key = get_random_poke_key_options { rarity = 'Rare', key_append = 'luxuryball' } })
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    delay(0.6)
  end,
}

return {
  config_key = "luxuryball",
  list = { luxuryball },
}
