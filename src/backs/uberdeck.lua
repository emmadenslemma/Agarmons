local open_uber_pack = function()
  local size = G.P_CENTERS['p_agar_uber_pack'].config.extra
  G.pack_cards = CardArea(
    G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
    math.max(1, math.min(size, 5)) * G.CARD_W * 1.1,
    1.05 * G.CARD_H,
    {
      card_limit = size,
      type = 'consumeable',
      highlight_limit = 1,
      negative_info = true
    }
  )
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
  config = { joker_slot = -1, scaling_mod = 0.5 },
  loc_vars = function(self)
    return { vars = { self.config.joker_slot, self.config.scaling_mod } }
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
  calculate = function(self, back, context)
    if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
      G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling + self.config.scaling_mod
    end
  end
}

local ubersleeve = {
  name = "ubersleeve",
  key = "ubersleeve",
  atlas = "AgarmonsSleeves",
  pos = { x = 2, y = 0 },
  config = { joker_slot = -1, scaling_mod = 0.5 },
  loc_vars = function(self)
    local key = self.key

    if self.get_current_deck_key() == "b_agar_uberdeck" then
      key = key .. "_alt"
    end

    return { key = key, vars = { self.config.joker_slot, self.config.scaling_mod } }
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
  calculate = function(self, sleeve, context)
    if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
      G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling + self.config.scaling_mod
    end
  end,
}

return {
  list = { uberdeck },
  sleeves = { ubersleeve },
}
