-- G-Max Gengar 094
local gmax_gengar = {
  name = "gmax_gengar",
  pos = { x = 10, y = 7 },
  soul_pos = { x = 11, y = 7 },
  config = { extra = { Xmult_multi = 1.5, gengar_rounds = 5, trigger = false } },
  loc_txt = {
    name = "Gigantamax Gengar",
    text = {
      "All {C:dark_edition}Negative{} Jokers",
      "give {X:mult,C:white} X#3# {} Mult",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult_multi } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Psychic",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
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
  AGAR.GMAX.evos["j_poke_gengar"] = "j_agar_gmax_gengar"
end

return {
  name = "Agarmons G-Max Gengar",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_gengar }
}
