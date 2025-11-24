local open_uber_pack = function()
  AG.skip_booster_animation = true
  G.E_MANAGER:add_event(Event({
    func = function()
      local booster = SMODS.create_card { key = 'p_agar_uber_pack', area = G.play }
      booster.states.visible = false
      booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
      booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
      booster.T.w = G.CARD_W * 1.27
      booster.T.h = G.CARD_H * 1.27
      booster.cost = 0
      booster.from_tag = true
      G.FUNCS.use_card({ config = { ref_table = booster } })
      G.E_MANAGER:add_event(Event({
        func = function()
          AG.skip_booster_animation = false
          return true
        end
      }))
      return true
    end
  }))
end

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
      func = function()
        G.E_MANAGER:add_event(Event({
          func = function()
            open_uber_pack()
            return true
          end
        }))
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
        func = function()
          G.E_MANAGER:add_event(Event({
            func = function()
              open_uber_pack()
              return true
            end
          }))
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
