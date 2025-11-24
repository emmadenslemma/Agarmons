local uberdeck = {
  name = "uberdeck",
  key = "uberdeck",
  atlas = "AgarmonsBacks",
  pos = { x = 2, y = 0 },
  config = { hands = -1 },
  loc_vars = function(self)
    return { vars = { self.config.hands } }
  end,
  apply = function(self)
    G.P_CENTERS['p_agar_uber_pack'].config = { extra = 3, choose = 1 }
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 1.8,
      blocking = false,
      func = function()
        AG.pack_utils.open_fake_pack('p_agar_uber_pack')
        return true
      end
    }))
  end,
}

local ubersleeve = {
  name = "ubersleeve",
  key = "ubersleeve",
  atlas = "AgarmonsSleeves",
  pos = { x = 2, y = 0 },
  loc_vars = function(self)
    local key = self.key
    local vars = {}

    if self.get_current_deck_key() == "b_agar_uberdeck" then
      self.config = {}
      key = key .. "_alt"
    else
      self.config = { hands = -1 }
      vars = { self.config.hands }
    end

    return { key = key, vars = vars }
  end,
  apply = function(self)
    CardSleeves.Sleeve.apply(self)
    if self.get_current_deck_key() == "b_agar_uberdeck" then
      -- Is this the most robust way of doing this? Of course not. But it works
      G.P_CENTERS['p_agar_uber_pack'].config = { extra = 5, choose = 2 }
    else
      G.P_CENTERS['p_agar_uber_pack'].config = { extra = 3, choose = 1 }
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1.8,
        blocking = false,
        func = function()
          AG.pack_utils.open_fake_pack('p_agar_uber_pack')
          return true
        end
      }))
    end
  end,
}

return {
  enabled = true,
  list = { uberdeck },
  sleeves = { ubersleeve },
}
