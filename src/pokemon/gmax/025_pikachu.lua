-- G-Max Pikachu 025
local gmax_pikachu = {
  name = "gmax_pikachu",
  inject_prefix = "poke",
  config = { extra = { money_mod = 2 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Pikachu",
    text = {
      "Every hand gives {C:money}$#3#{} for",
      "every {C:money}$1{} you are from",
      "the interest cap",
      "{C:inactive}(Currently {C:money}$#4#{C:inactive})",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local interest_gap = math.ceil((G.GAME.interest_cap - G.GAME.dollars) / 5)
    local current_dollars = center.ability.extra.money_mod * math.max(interest_gap, 0)
    return { vars = { center.ability.extra.money_mod, current_dollars } }
  end,
  rarity = "agar_gmax",
  cost = 8,
  stage = "Gigantamax",
  ptype = "Lightning",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      local interest_gap = math.ceil((G.GAME.interest_cap - G.GAME.dollars) / 5)
      if interest_gap > 0 then
        return {
          dollars = interest_gap * card.ability.extra.money_mod,
        }
      end
    end
  end,
}

local init = function()
  AG.append_to_family("pikachu", "gmax_pikachu")
  AG.gmax.evos["j_poke_pikachu"] = "j_poke_gmax_pikachu"
end

return {
  name = "Agarmons G-Max Pikachu",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_pikachu }
}
