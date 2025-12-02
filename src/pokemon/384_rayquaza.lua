-- Rayquaza 384
local rayquaza = {
  name = "rayquaza",
  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dragon",
  gen = 3,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  megas = { "mega_rayquaza" },
}

-- Mega Rayquaza 384-1
local mega_rayquaza = {
  name = "mega_rayquaza",
  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = "poke_mega",
  cost = 30,
  stage = "Mega",
  ptype = "Dragon",
  gen = 3,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

return {
  can_load = false,
  config_key = "rayquaza",
  list = { rayquaza, mega_rayquaza }
}
