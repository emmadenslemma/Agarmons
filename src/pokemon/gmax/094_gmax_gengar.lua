-- G-Max Gengar 094
local gmax_gengar = {
  name = "gmax_gengar",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_multi = 1.5, gengar_rounds = 5, trigger = false } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Gengar",
    text = {
      "All {C:dark_edition}Negative{} Jokers",
      "give {X:mult,C:white}X#3#{} Mult",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Psychic",
  gen = 1,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "gengar_rounds", "trigger" },
  calculate = function(self, card, context)
    if context.other_joker
        and context.other_joker.edition and context.other_joker.edition.negative then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
    -- Apply Gengar's base effect
    return SMODS.Joker.obj_table.j_poke_gengar.calculate(self, card, context)
  end,
}

local init = function()
  pokermon.add_family { "gengar", "gmax_gengar" }

  SMODS.Joker:take_ownership("poke_gengar",
    { gmax = "gmax_gengar", poke_custom_values_to_keep = { "gengar_rounds", "trigger" } }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_gengar }
}
