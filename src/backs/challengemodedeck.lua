local challengemodedeck = {
  name = "challengemodedeck",
  key = "challengemodedeck",
  atlas = "AgarmonsBacks",
  pos = { x = 1, y = 0 },
  config = {
    joker_slot = -1,
    consumable_slot = -1,
    shop_size = -1,
    voucher_limit = -1,
    booster_limit = -1,
    hands = -1,
    discards = -1,
    hand_size = -1,
  },
  loc_vars = function(self)
    return {
      vars = {
        self.config.joker_slot,
        self.config.consumable_slot,
        self.config.shop_size,
        self.config.voucher_limit,
        self.config.booster_limit,
        self.config.hands,
        self.config.discards,
        self.config.hand_size,
      }
    }
  end,
  apply = function(self)
    G.GAME.starting_params.vouchers_in_shop = G.GAME.starting_params.vouchers_in_shop + self.config.voucher_limit
    G.E_MANAGER:add_event(Event({
      func = function()
        change_shop_size(self.config.shop_size)
        SMODS.change_voucher_limit(self.config.voucher_limit)
        SMODS.change_booster_limit(self.config.booster_limit)
        return true
      end
    }))
  end,
}

local challengemodesleeve = {
  name = "challengemodesleeve",
  key = "challengemodesleeve",
  atlas = "AgarmonsSleeves",
  pos = { x = 1, y = 0 },
  config = {
    joker_slot = -1,
    consumable_slot = -1,
    shop_size = -1,
    voucher_limit = -1,
    booster_limit = -1,
    hands = -1,
    discards = -1,
    hand_size = -1,
  },
  loc_vars = function(self)
    local key = self.key
    if self.get_current_deck_key() == "b_agar_challengemodedeck" then
      key = self.key .. "_alt"
    end
    return {
      key = key,
      vars = {
        self.config.joker_slot,
        self.config.consumable_slot,
        self.config.shop_size,
        self.config.voucher_limit,
        self.config.booster_limit,
        self.config.hands,
        self.config.discards,
        self.config.hand_size,
      }
    }
  end,
  apply = function(self)
    CardSleeves.Sleeve.apply(self)
    G.GAME.starting_params.vouchers_in_shop = G.GAME.starting_params.vouchers_in_shop + self.config.voucher_limit
    G.E_MANAGER:add_event(Event({
      func = function()
        change_shop_size(self.config.shop_size)
        SMODS.change_voucher_limit(self.config.voucher_limit)
        SMODS.change_booster_limit(self.config.booster_limit)
        return true
      end
    }))
  end,
}

return {
  enabled = true,
  list = { challengemodedeck },
  sleeves = { challengemodesleeve },
}
