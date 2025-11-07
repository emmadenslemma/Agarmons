-- G-Max Melmetal 809
local gmax_melmetal = {
  name = "gmax_melmetal",
  pos = { x = 8, y = 5 },
  soul_pos = { x = 9, y = 5 },
  config = { extra = { draw_mod = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Melmetal",
    text = {
      "Every hand played draws {C:attention}#3#{} card for",
      "every {C:white,X:metal}Metal{} card you have",
      "{C:inactive,s:0.8}(Includes Jokers and Energy cards)",
      "{C:inactive}(Currently #4# #5#)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local metal_cards = find_other_poke_or_energy_type(center, "Metal", true)
    return {
      vars = {
        center.ability.extra.draw_mod,
        center.ability.extra.draw_mod * metal_cards,
        metal_cards == 1 and localize("cards_singular") or localize("cards_plural")
      }
    }
  end,
  rarity = "agar_gmax",
  cost = 30,
  stage = "Gigantamax",
  ptype = "Metal",
  gen = 7,
  atlas = "AtlasJokersBasicGen07",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local cards_to_draw = card.ability.extra.draw_mod * find_other_poke_or_energy_type(card, "Metal", true)
      if cards_to_draw > 0 then
        card_eval_status_text(card, "extra", nil, nil, nil, {
          message = localize("agar_gmax_meltdown_ex"),
          colour = G.C.RARITY["agar_gmax"],
        })
        G.FUNCS.draw_from_deck_to_hand(cards_to_draw)
      end
    end
  end,
}

local init = function()
  AGAR.GMAX.evos["j_sonfive_melmetal"] = "j_agar_gmax_melmetal"
  AGAR.FAMILY_UTILS.init_gmax(gmax_melmetal)
end

return {
  name = "Agarmons G-Max Melmetal",
  enabled = (SMODS.Mods["SonfivesPokermonPlus"] or {}).can_load and sonfive_config.Meltan and agarmons_config.gmax or false,
  init = init,
  list = { gmax_melmetal }
}
