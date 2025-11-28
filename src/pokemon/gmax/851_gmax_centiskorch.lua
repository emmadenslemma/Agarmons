-- G-Max Centiskorch 851
local gmax_centiskorch = {
  name = "gmax_centiskorch",
  agar_inject_prefix = "Gem",
  config = { extra = { mult = 0, mult_mod = 4 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Centiskorch",
    text = {
      "If played hand has {C:attention}5{} scoring",
      "cards, played cards permanently",
      "gain {C:mult}+#3#{} Mult when scored",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.mult_mod } }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Fire",
  gen = 8,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "mult" },
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and #context.scoring_hand == 5 then
      context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult_mod
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT
      }
    end
  end,
}

local init = function()
  AG.append_to_family("centiskorch", "gmax_centiskorch", true)

  SMODS.Joker:take_ownership("Gem_centiskorch", { gmax = "gmax_centiskorch", poke_custom_values_to_keep = { "mult" } }, true)
end

return {
  can_load = (SMODS.Mods["GemPokermon"] or {}).can_load and Gem_config.Sizzlipede and agarmons_config.gmax,
  init = init,
  list = { gmax_centiskorch }
}
