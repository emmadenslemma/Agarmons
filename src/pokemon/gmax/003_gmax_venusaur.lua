-- G-Max Venusaur 003
local gmax_venusaur = {
  name = "gmax_venusaur",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_mod = 0.5, h_size = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Venusaur",
    text = {
      "{C:white,X:mult}X#3#{} Mult for each",
      "card held in hand",
      "{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive} Mult)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local current_Xmult = center.ability.extra.Xmult_mod * (G.hand and (#G.hand.cards - #G.hand.highlighted) or 0)
    return { vars = { center.ability.extra.Xmult_mod, current_Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Grass",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local current_Xmult = card.ability.extra.Xmult_mod * (G.hand and #G.hand.cards or 0)
      if current_Xmult > 1 then
        return {
          Xmult = current_Xmult,
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.P_CENTERS.j_poke_venusaur.add_to_deck(self, card, from_debuff)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.P_CENTERS.j_poke_venusaur.remove_from_deck(self, card, from_debuff)
  end,
}

local init = function()
  AG.append_to_family("venusaur", "gmax_venusaur", true)
  AG.gmax.disable_method_during_evolve("j_poke_venusaur", "add_to_deck")
  AG.gmax.disable_method_during_evolve("j_poke_venusaur", "remove_from_deck")

  SMODS.Joker:take_ownership('poke_venusaur', { gmax = "gmax_venusaur" }, true)
end

return {
  name = "Agarmons G-Max Venusaur",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_venusaur }
}
