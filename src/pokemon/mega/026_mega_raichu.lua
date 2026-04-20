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
  config = { extra = { hands = 1, per_interest = 5 } },
  loc_txt = {
    name = "Mega Raichu X",
    text = {
      "Earn interest when",
      "hand is played",
      "{br:2}ERROR - CONTACT STEAK",
      "When {C:attention}Blind{} is selected,",
      "gain {C:blue}+#1#{} hand for every",
      "{C:money}$#2#{} of interest you have",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.hands, card.ability.extra.per_interest } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Lightning",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind then
      AG.defer(function()
        local hands = math.floor(card.ability.extra.hands * get_current_interest() / card.ability.extra.per_interest)
        if hands > 0 then
          ease_hands_played(hands)
          SMODS.calculate_effect({ message = localize { type = 'variable', key = 'a_hands', vars = { hands } } }, card)
        end
      end)
      return nil, true
    end
    if context.before then
      local interest = G.GAME.interest_amount * get_current_interest()
      G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + interest
      AG.defer(function()
        G.GAME.dollar_buffer = 0
      end)
      return {
        dollars = ease_poke_dollars(card, "mega_raichu_x", interest, true)
      }
    end
  end,
  designer = "Catzzadilla and Emma",
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
  blueprint_compat = false,
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
