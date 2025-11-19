local gmaxdeck = {
  name = "gmaxdeck",
  key = "gmaxdeck",
  atlas = "AgarmonsBacks",
  pos = { x = 0, y = 0 },
  config = { consumables = { "c_agar_dynamaxband" }, booster_limit = -1 },
  loc_vars = function(self)
    return { vars = { localize { type = "name_text", set = "Spectral", key = "c_agar_dynamaxband" }, self.config.booster_limit } }
  end,
  apply = function(self)
    G.E_MANAGER:add_event(Event({
      func = function()
        SMODS.change_booster_limit(self.config.booster_limit)
        return true
      end
    }))
  end,
}

local gmaxsleeve = {
  name = "gmaxsleeve",
  key = "gmaxsleeve",
  atlas = "AgarmonsSleeves",
  pos = { x = 0, y = 0 },
  config = { booster_limit = -1 },
  loc_vars = function(self)
    local key = self.key
    if self.get_current_deck_key() == "b_agar_gmaxdeck" then
      key = self.key .. "_alt"
    end
    return { key = key, vars = { localize { type = "name_text", set = "Spectral", key = "c_agar_dynamaxband" }, self.config.booster_limit } }
  end,
  apply = function(self)
    CardSleeves.Sleeve.apply(self)
    G.E_MANAGER:add_event(Event({
      func = function()
        if self.get_current_deck_key() == "b_agar_gmaxdeck" then
          SMODS.find_card("c_agar_dynamaxband")[1]:set_edition({ negative = true }, true)
        else
          SMODS.add_card { key = "c_agar_dynamaxband" }
          SMODS.change_booster_limit(self.config.booster_limit)
        end
        return true
      end
    }))
  end,
}

return {
  enabled = agarmons_config.gmax,
  list = { gmaxdeck },
  sleeves = { gmaxsleeve },
}
