-- Kyurem 646
local kyurem = {
  name = "kyurem",
  config = { extra = {} },
  loc_txt = {
    name = "Kyurem",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 5,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  fuses = {
    { with = "j_agar_reshiram", into = "j_agar_kyurem_white" },
    { with = "j_agar_zekrom", into = "j_agar_kyurem_black" },
  }
}

-- White Kyurem 646-1
local kyurem_white = {
  name = "kyurem_white",
  config = { extra = {} },
  loc_txt = {
    name = "White Kyurem",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 5,
  aux_poke = true,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
  end,
  in_pool = function(self)
    return false
  end
}

-- Black Kyurem 646-2
local kyurem_black = {
  name = "kyurem_black",
  config = { extra = {} },
  loc_txt = {
    name = "Black Kyurem",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 5,
  aux_poke = true,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
  end,
  in_pool = function(self)
    return false
  end
}

return {
  config_key = "kyurem",
  list = { kyurem, kyurem_white, kyurem_black }
}
