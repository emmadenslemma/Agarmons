local originball = {
  name = "originball",
  key = "originball",
  set = "Item",
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_agar_arceus', config = {} }
  end,
  pos = { x = 2, y = 1 },
  atlas = "AgarmonsConsumables",
  cost = 4,
  hidden = true,
  soul_set = "Tarot",
  soul_rate = .001,
  pokeball = true,
  can_use = function(self, card)
    if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
      return true
    else
      return false
    end
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        local arceus = SMODS.create_card { key = "j_agar_arceus" }
        arceus:add_to_deck()
        G.jokers:emplace(arceus)
        return true
      end
    }))
    delay(0.6)
  end
}

return {
  enabled = agarmons_config.arceus,
  list = { originball }
}
