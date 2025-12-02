-- G-Max Melmetal 809
local gmax_melmetal = {
  name = "gmax_melmetal",
  agar_inject_prefix = "sonfive",
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
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local metal_cards = find_other_poke_or_energy_type(card, "Metal", true)
    return {
      vars = {
        card.ability.extra.draw_mod,
        card.ability.extra.draw_mod * metal_cards,
        metal_cards == 1 and localize("cards_singular") or localize("cards_plural")
      }
    }
  end,
  rarity = "agar_gmax",
  cost = 30,
  stage = "Gigantamax",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      local cards_to_draw = card.ability.extra.draw_mod * find_other_poke_or_energy_type(card, "Metal", true)
      if cards_to_draw > 0 then
        SMODS.calculate_effect({ message = localize("agar_gmax_meltdown_ex"), colour = G.C.RARITY["agar_gmax"] }, card)
        G.FUNCS.draw_from_deck_to_hand(cards_to_draw)
      end
    end
  end,
}

local init = function()
  AG.append_to_family("melmetal", "gmax_melmetal", true)

  SMODS.Joker:take_ownership("sonfive_melmetal", { gmax = "gmax_melmetal" }, true)
end

return {
  can_load = (SMODS.Mods["SonfivesPokermonPlus"] or {}).can_load and agarmons_config.gmax,
  init = init,
  list = { gmax_melmetal }
}
