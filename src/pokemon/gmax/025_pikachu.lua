-- G-Max Pikachu 025
local gmax_pikachu = {
  name = "gmax_pikachu",
  pos = { x = 4, y = 7 },
  soul_pos = { x = 5, y = 7 },
  config = { extra = { money = 1 } },
  loc_txt = {
    name = "Gigantamax Pikachu",
    text = {
      "Every hand gives {C:money}$#3#{} for",
      "every {C:money}$1{} you are from",
      "the interest cap {C:inactive}[$#4#]",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local interest_gap = math.ceil((G.GAME.interest_cap - G.GAME.dollars) / 5)
    return { vars = { center.ability.extra.money, interest_gap < 0 and interest_gap or 0 } }
  end,
  rarity = "agar_gmax",
  cost = 8,
  stage = "Gigantamax",
  ptype = "Lightning",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local interest_gap = math.ceil((G.GAME.interest_cap - G.GAME.dollars) / 5)
      if interest_gap > 0 then
        return {
          dollars = interest_gap * card.ability.extra.money,
        }
      end
    end
  end,
}

local init = function()
  GMAX.evos["j_poke_pikachu"] = "j_agar_gmax_pikachu"
end

return {
  name = "Agarmons G-Max Pikachu",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_pikachu }
}
