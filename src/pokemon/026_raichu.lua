-- Alolan Raichu 26-1
local alolan_raichu = {
  name = "alolan_raichu",
  inject_prefix = "poke",
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
    if context.money_altered and context.amount < 0 then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod / card.ability.extra.per_money * (-context.amount) * (#find_pokemon_type("Lightning") > 0 and 2 or 1)
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.CHIPS,
      }
    end
  end,
}

local init = function()
  AG.append_to_family("raichu", "alolan_raichu")

  SMODS.Joker:take_ownership("poke_pikachu", {
    calculate = function(self, card, context)
      return item_evo(self, card, context, "j_poke_raichu")
          or type_evo(self, card, context, "j_poke_alolan_raichu", "psychic")
    end
  }, true)
end

return {
  enabled = agarmons_config.alolan_raichu or false,
  init = init,
  list = { alolan_raichu }
}
