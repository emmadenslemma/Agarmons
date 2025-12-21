-- Mega Raichu X 026-2
local mega_raichu_x = {
  name = "mega_raichu_x",
  agar_inject_prefix = "poke",
  pos = { x = 2, y = 9 },
  soul_pos = { x = 3, y = 9 },
  config = { extra = {} },
  loc_txt = {
    name = "Mega Raichu X",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Lightning",
  gen = 1,
  atlas = "AtlasJokersSeriesAGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  artist = "MyDude_YT",
}

-- Mega Raichu Y 026-2
local mega_raichu_y = {
  name = "mega_raichu_y",
  agar_inject_prefix = "poke",
  pos = { x = 4, y = 9 },
  soul_pos = { x = 5, y = 9 },
  loc_txt = {
    name = "Mega Raichu Y",
    text = {
      "Interest has no cap",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Lightning",
  gen = 1,
  atlas = "AtlasJokersSeriesAGen01",
  artist = "MyDude_YT",
}

local function init()
  -- AG.append_to_family("raichu", "mega_raichu_x", true)
  AG.append_to_family("raichu", "mega_raichu_y", true)
  SMODS.Joker:take_ownership("poke_raichu", { megas = { --[["mega_raichu_x",]] "mega_raichu_y" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { --[[mega_raichu_x,]] mega_raichu_y },
  family = {},
}
