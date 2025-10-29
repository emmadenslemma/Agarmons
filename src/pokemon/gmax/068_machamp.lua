-- G-Max Machamp 068
local gmax_machamp = {
  name = "gmax_machamp",
  pos = { x = 8, y = 7 },
  soul_pos = { x = 9, y = 7 },
  config = { extra = { Xmult = 1.5, hands = 4, discards = 4 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Machamp",
    text = {
      "{C:white,X:mult}X#3#{} Mult, doubles after",
      "every hand played",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Fighting",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main
        and card.ability.extra.Xmult > 1 then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    if context.after and context.cardarea == G.jokers and not context.blueprint
        and card.ability.extra.turns_left > 1 then
      card.ability.extra.Xmult = card.ability.extra.Xmult * 2
    end
  end,
  -- `add_to/remove_from_deck` Stolen from regular Machamp to keep your hands during dynamax
  add_to_deck = SMODS.Joker.obj_table.j_poke_machamp.add_to_deck,
  remove_from_deck = SMODS.Joker.obj_table.j_poke_machamp.remove_from_deck,
}

local init = function()
  AGAR.GMAX.evos["j_poke_machamp"] = "j_agar_gmax_machamp"
  -- edit get_family_keys to let us insert gmax into existing families
  -- for _, family in pairs(pokermon.family) do
  --   if family[1] == "machop" then
  --     family[#family + 1] = "gmax_machamp"
  --     break
  --   end
  -- end
end

return {
  name = "Agarmons G-Max Machamp",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_machamp }
}
