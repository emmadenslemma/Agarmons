local uberdeck = {
  name = "uberdeck",
  key = "uberdeck",
  atlas = "AgarmonsBacks",
  pos = { x = 2, y = 0 },
  config = { joker_slot = -1 },
  loc_vars = function(self)
    return { vars = { self.config.joker_slot } }
  end,
  apply = function(self)
  end,
}

local ubersleeve = {
  name = "ubersleeve",
  key = "ubersleeve",
  atlas = "AgarmonsSleeves",
  pos = { x = 2, y = 0 },
  config = { joker_slot = -1 },
  loc_vars = function(self)
    local key = self.key
    if self.get_current_deck_key() == "b_agar_uberdeck" then
      key = self.key .. "_alt"
    end
    return { key = key, vars = { self.config.joker_slot } }
  end,
  apply = function(self)
    CardSleeves.Sleeve.apply(self)
  end,
}

return {
  enabled = true,
  list = { uberdeck },
  sleeves = { ubersleeve },
}
