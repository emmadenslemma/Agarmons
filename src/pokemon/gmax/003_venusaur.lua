-- G-Max Venusaur 003
local gmax_venusaur = {
  name = "gmax_venusaur",
  pos = { x = 12, y = 6 },
  soul_pos = { x = 13, y = 6 },
  config = { extra = { draw_mod = 3 } },
  loc_txt = {
    name = "Gigantamax Venusaur",
    text = {
      "Every hand played",
      "draws {C:attention}+#3#{} cards"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.draw_mod } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Grass",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers then
      card_eval_status_text(card, "extra", nil, nil, nil, {
        message = localize("agar_gmax_vine_lash_ex"),
        colour = G.C.RARITY["agar_gmax"]
      })
      G.FUNCS.draw_from_deck_to_hand(card.ability.extra.draw_mod)
    end
  end,
}

local init = function()
  AGAR.GMAX.evos["j_poke_venusaur"] = "j_agar_gmax_venusaur"
end

return {
  name = "Agarmons G-Max Venusaur",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_venusaur }
}
