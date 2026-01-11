local luxuryball = {
  name = "luxuryball",
  key = "luxuryball",
  set = "Spectral",
  pos = { x = 4, y = 1 },
  config = { extra = { money_mod = 8 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_mod } }
  end,
  atlas = "AgarmonsConsumables",
  cost = 4,
  pokeball = true,
  hidden = true,
  soul_set = "Item",
  soul_rate = .01333,
  unlocked = true,
  discovered = true,
  can_use = function(self, card)
    return #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        SMODS.add_card { key = get_random_poke_key_options { rarity = 'Rare', key_append = 'luxuryball' } }
        card:juice_up(0.3, 0.5)
        ease_dollars(-card.ability.extra.money_mod, true)
        return true
      end
    }))
    delay(0.6)
  end,
  designer = "Maelmc",
}

return {
  config_key = "luxuryball",
  list = { luxuryball },
}
