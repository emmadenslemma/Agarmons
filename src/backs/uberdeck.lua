local uberdeck = {
  name = "uberdeck",
  key = "uberdeck",
  atlas = "AgarmonsBacks",
  pos = { x = 2, y = 0 },
  config = { scaling = 3 },
  apply = function(self)
    G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) * self.config.scaling
  end,
}

local ubersleeve = {
  name = "ubersleeve",
  key = "ubersleeve",
  atlas = "AgarmonsSleeves",
  pos = { x = 2, y = 0 },
  config = { scaling = 3 },
  loc_vars = function(self)
    local key = self.key
    if self.get_current_deck_key() == "b_agar_uberdeck" then
      key = self.key .. "_alt"
    end
    return { key = key }
  end,
  apply = function(self)
    CardSleeves.Sleeve.apply(self)

    local scaling = self.config.scaling

    if self.get_current_deck_key() == "b_agar_gmaxdeck" then
      scaling = scaling * 2
    end

    G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + scaling
  end,
}

return {
  enabled = true,
  list = { uberdeck },
  sleeves = { ubersleeve },
}
