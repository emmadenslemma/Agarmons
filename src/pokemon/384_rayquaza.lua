-- Rayquaza 384
local rayquaza = {
  name = "rayquaza",
  soul_pos = { x = 17, y = 25 },
  config = { extra = {} },
  loc_txt = {
    name = "Rayquaza",
    text = {
      "{C:inactive}Does nothing (yet!)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = 'Other', key = 'mega_poke' }
    end
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
  pos = { x = 6, y = 7 },
  soul_pos = { x = 7, y = 7 },
  config = { extra = {} },
  loc_txt = {
    name = "Mega Rayquaza",
    text = {
      "{C:inactive}Does nothing (yet!)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = "poke_mega",
  cost = 30,
  stage = "Mega",
  ptype = "Dragon",
  gen = 3,
  atlas = "AtlasJokersBasicGen03",
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

local init = function()
  pokermon.add_family { "rayquaza", "mega_rayquaza" }
end

return {
  name = "Agarmons Rayquaza",
  enabled = agarmons_config.rayquaza or false,
  init = init,
  list = { rayquaza, mega_rayquaza }
}
