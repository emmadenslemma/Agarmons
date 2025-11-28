-- Alolan Raichu 26-1
local alolan_raichu = {
  name = "alolan_raichu",
  agar_inject_prefix = "poke",
  config = { extra = { chips = 0, chip_mod = 1, per_money = 2 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.chip_mod, center.ability.extra.per_money, center.ability.extra.chips } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Psychic",
  gen = 7,
  designer = "Hasmed",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.chips > 0 then
      return {
        chips = card.ability.extra.chips
      }
    end
    if context.money_altered then
      local amount_spent = context.amount
      if (SMODS.Mods["Talisman"] or {}).can_load then amount_spent = to_number(amount_spent) end
      if context.amount < 0 then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod / card.ability.extra.per_money * (-amount_spent) * (#find_pokemon_type("Lightning") > 0 and 2 or 1)
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.CHIPS,
        }
      end
    end
  end,
}

local init = function()
  AG.append_to_family("raichu", "alolan_raichu")

  G.E_MANAGER:add_event(Event({
    func = function()
      AG.hookafterfunc(G.P_CENTERS.j_poke_pikachu, 'calculate', function(self, card, context)
        return type_evo(self, card, context, "j_poke_alolan_raichu", "psychic")
      end)
      return true
    end
  }))
end

return {
  enabled = agarmons_config.alolan_raichu or false,
  init = init,
  list = { alolan_raichu }
}
