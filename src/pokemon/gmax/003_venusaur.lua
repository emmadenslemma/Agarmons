-- G-Max Venusaur 003
local gmax_venusaur = {
  name = "gmax_venusaur",
  pos = { x = 12, y = 6 },
  soul_pos = { x = 13, y = 6 },
  config = { extra = { Xmult_multi = 1.5, h_size = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Venusaur",
    text = {
      "Each {C:attention}#3#{} held in hand",
      "gives {C:white,X:mult}X#4#{} Mult",
      "{C:inactive,s:0.8}(Rank changes every round){}",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { localize(G.GAME.current_round.bulb1card and G.GAME.current_round.bulb1card.rank or "Ace", 'ranks'), center.ability.extra.Xmult_multi } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Grass",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand
        and context.other_card:get_id() == G.GAME.current_round.bulb1card.id then
      if context.other_card.debuff then
        return {
          message = localize("k_debuffed"),
          colour = G.C.RED
        }
      else
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
    end
  end,
  -- `add_to/remove_from_deck` Stolen from regular Venusaur to keep your +1 hand size during dynamax
  add_to_deck = SMODS.Joker.obj_table.j_poke_venusaur.add_to_deck,
  remove_from_deck = SMODS.Joker.obj_table.j_poke_venusaur.remove_from_deck,
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
