local function get_current_interest()
  local interest_levels = math.floor(G.GAME.dollars / 5)
  -- Talisman gets weird about calculating with infinity, so we have to handle uncapped interest explicitly
  if AG.effects.uncap_interest() then
    return interest_levels
  end
  local interest_cap = G.GAME.interest_cap / 5
  return math.min(interest_levels, interest_cap)
end

-- Mega Raichu X 026-2
local mega_raichu_x = {
  name = "mega_raichu_x",
  agar_inject_prefix = "poke",
  pos = { x = 2, y = 9 },
  soul_pos = { x = 3, y = 9 },
  config = { extra = { Xmult_mod = 0.5, per_interest = 1 } },
  loc_txt = {
    name = "Mega Raichu X",
    text = {
      "{C:white,X:mult}X#1#{} Mult for every",
      "{C:money}$#2#{} of interest you have",
      "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)",
    }
  },
  get_x_mult = function(self, card)
    local interest_mod = get_current_interest() / card.ability.extra.per_interest
    local Xmult_mod = card.ability.extra.Xmult_mod
    return 1 + Xmult_mod * interest_mod
  end,
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.per_interest, self:get_x_mult(card) } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Lightning",
  gen = 1,
  atlas = "AtlasJokersSeriesAGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = self:get_x_mult(card)
      }
    end
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
  pokermon.add_family { "raichu", "mega_raichu_x", "mega_raichu_y" }
  SMODS.Joker:take_ownership("poke_raichu", { megas = { "mega_raichu_x", "mega_raichu_y" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_raichu_x, mega_raichu_y },
  family = {},
}
