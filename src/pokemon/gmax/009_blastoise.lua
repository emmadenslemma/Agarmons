-- G-Max Blastoise 009
local gmax_blastoise = {
  name = "gmax_blastoise",
  pos = { x = 14, y = 6 },
  soul_pos = { x = 15, y = 6 },
  config = { extra = { hands = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Blastoise",
    text = {
      "Every hand played",
      "gives {C:blue}+#3#{} hand"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.hands } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      ease_hands_played(card.ability.extra.hands)

      return {
        message = localize("agar_gmax_cannonade_ex"),
        colour = G.C.RARITY["agar_gmax"],
      }
    end
  end,
  -- `add/remove_from_deck` from regular Blastoise to keep extra hand
  add_to_deck = SMODS.Joker.obj_table.j_poke_blastoise.add_to_deck,
  remove_from_deck = SMODS.Joker.obj_table.j_poke_blastoise.remove_from_deck,
}

local init = function()
  AGAR.GMAX.evos["j_poke_blastoise"] = "j_agar_gmax_blastoise"
end

return {
  name = "Agarmons G-Max Blastoise",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_blastoise }
}
