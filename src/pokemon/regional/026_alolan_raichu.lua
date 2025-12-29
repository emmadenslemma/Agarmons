-- Alolan Raichu 26-1
local alolan_raichu = {
  name = "alolan_raichu",
  agar_inject_prefix = "poke",
  config = { extra = { chips = 0, chip_mod = 1, per_money = 2, money = 2, money_mod = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chip_mod, card.ability.extra.per_money, card.ability.extra.chips, card.ability.extra.money, card.ability.extra.money_mod } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Psychic",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind then
      local lightning_jokers = #find_pokemon_type("Lightning")
      local amount = card.ability.extra.money + lightning_jokers * card.ability.extra.money_mod
      card:juice_up()
      ease_poke_dollars(card, "alolan_raichu", amount)
    end
    if context.joker_main and card.ability.extra.chips > 0 then
      return {
        chips = card.ability.extra.chips
      }
    end
    if context.money_altered and context.from_shop then
      local amount_spent = context.amount
      if (SMODS.Mods["Talisman"] or {}).can_load then amount_spent = to_number(amount_spent) end
      if amount_spent < 0 then
        card.ability.extra.chips = card.ability.extra.chips +
            card.ability.extra.chip_mod / card.ability.extra.per_money * (-amount_spent)
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

  AG.hookafterfunc(SMODS.Joker.obj_table.j_poke_pikachu, 'calculate', function(self, card, context)
    return type_evo(self, card, context, "j_poke_alolan_raichu", "psychic")
  end)
end

return {
  config_key = 'alolan_raichu',
  init = init,
  list = { alolan_raichu }
}
