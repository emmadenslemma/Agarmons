-- G-Max Urshifu Rapid Strike Style 892
local gmax_urshifu_rapid_strike = {
  name = "gmax_urshifu_rapid_strike",
  agar_inject_prefix = "Gem",
  config = { extra = { Xmult_mod = 0.1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Urshifu Rapid Strike",
    text = {
      "Scored cards give {X:mult,C:white} X#3# {} Mult",
      "for every {C:chips}5 chips{} they have",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod } }
  end,
  rarity = "agar_gmax",
  cost = 30,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 8,
  designer = "Gem",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.end_of_round then
      local total_chips = poke_total_chips(context.other_card)
      local Xmult = (total_chips) * (card.ability.extra.Xmult_mod) / 5 + 1
      if Xmult > 0 then
        return {
          x_mult = Xmult,
          card = card
        }
      end
    end
  end,
}

local init = function()
  AG.append_to_family("urshifu_rapid_strike", "gmax_urshifu_rapid_strike")

  SMODS.Joker:take_ownership("j_Gem_urshifu_rapid_strike", { gmax = "gmax_urshifu_rapid_strike" }, true)
end

return {
  can_load = (SMODS.Mods["GemPokermon"] or {}).can_load and Gem_config.Kubfu and agarmons_config.gmax,
  init = init,
  list = { gmax_urshifu_rapid_strike }
}
