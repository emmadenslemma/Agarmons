local reverseddeck = {
  name = "reverseddeck",
  key = "reverseddeck",
  atlas = "AgarmonsBacks",
  pos = { x = 3, y = 0 },
  apply = function(self, back)
    G.GAME.modifiers.trick_room = true
  end,
}

return {
  list = { reverseddeck },
  sleeves = {},
}
