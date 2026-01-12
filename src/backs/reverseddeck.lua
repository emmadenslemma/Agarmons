local reverseddeck = {
  name = "reverseddeck",
  key = "reverseddeck",
  atlas = "AgarmonsBacks",
  pos = { x = 3, y = 0 },
  apply = function(self, back)
    G.GAME.modifiers.trick_room = true
  end,
}

local reversedsleeve = {
  name = "reversedsleeve",
  key = "reversedsleeve",
  atlas = "AgarmonsSleeves",
  pos = { x = 3, y = 0 },
  loc_vars = function(self)
    if self.get_current_deck_key() == "b_agar_reverseddeck" then
      return { key = self.key .. "_alt" }
    end
  end,
  apply = function(self)
    CardSleeves.Sleeve.apply(self)
    G.GAME.modifiers.trick_room = true
  end,
}

return {
  list = { reverseddeck },
  sleeves = { reversedsleeve },
}
