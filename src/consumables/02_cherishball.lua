local cherishball = {
  name = "cherishball",
  key = "cherishball",
  set = "Spectral",
  pos = { x = 5, y = 1 },
  soul_pos = { x = 5, y = 2 },
  atlas = "AgarmonsConsumables",
  cost = 4,
  pokeball = true,
  hidden = true,
  soul_set = "Item",
  soul_rate = .0015,
  can_use = function(self, card)
    return #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        SMODS.add_card({
          set = 'Joker',
          attributes = { 'mythical' }
        })
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    delay(0.6)
  end,
}

return {
  config_key = "cherishball",
  list = { cherishball },
}
