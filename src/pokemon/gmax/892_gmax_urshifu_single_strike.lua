-- G-Max Urshifu Single Strike Style 892
local gmax_urshifu_single_strike = {
  name = "gmax_urshifu_single_strike",
  agar_inject_prefix = "Gem",
  config = { extra = { Xmult1 = 7, Xmult2 = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Urshifu Single Strike",
    text = {
      "{X:mult,C:white} X#3# {} Mult",
      "Gains {X:mult,C:white} X#4# {} Mult when a discard is used.",
      "Loses a third when a hand is played",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult1, card.ability.extra.Xmult2 } }
  end,
  rarity = "agar_gmax",
  cost = 30,
  stage = "Gigantamax",
  ptype = "Dark",
  gen = 8,
  designer = "Gem",
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Increase xmult when a discard is used
    if context.pre_discard and not context.blueprint then
      card.ability.extra.Xmult1 = card.ability.extra.Xmult1 + card.ability.extra.Xmult2
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.RED,
        delay = 0.45,
        card = card
      }
    end

    -- Give Xmult
    if context.cardarea == G.jokers and context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult1
      }
    end

    -- Lose a third of your xmult when hand is played
    if context.after and not context.blueprint then
      card.ability.extra.Xmult1 = card.ability.extra.Xmult1 * (2 / 3)
    end
  end,
}

local init = function()
  pokermon.add_family { "urshifu_single_strike", "gmax_urshifu_single_strike" }

  SMODS.Joker:take_ownership("Gem_urshifu_single_strike", { gmax = "gmax_urshifu_single_strike" }, true)
end

return {
  can_load = (SMODS.Mods["GemPokermon"] or {}).can_load and Gem_config.Kubfu and agarmons_config.gmax,
  init = init,
  list = { gmax_urshifu_single_strike }
}
