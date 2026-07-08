-- G-Max Charizard 006
local gmax_charizard = {
  name = "gmax_charizard",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_mod = 1, d_size = 1 } },
  loc_vars = function(self, info_queue, card)
    local current_Xmult = card.ability.extra.Xmult_mod * G.GAME.current_round.discards_used
    return { vars = { card.ability.extra.Xmult_mod, current_Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Fire",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local current_Xmult = card.ability.extra.Xmult_mod * G.GAME.current_round.discards_used
      if current_Xmult > 1 then
        return {
          Xmult = current_Xmult,
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.P_CENTERS.j_poke_charizard.add_to_deck(self, card, from_debuff)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.P_CENTERS.j_poke_charizard.remove_from_deck(self, card, from_debuff)
  end,
}

local init = function()
  pokermon.add_family { "charizard", "gmax_charizard" }
  AG.gmax.disable_method_during_evolve("j_poke_blastoise", "add_to_deck")
  AG.gmax.disable_method_during_evolve("j_poke_blastoise", "remove_from_deck")

  SMODS.Joker:take_ownership("poke_charizard", { gmax = "gmax_charizard" }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_charizard }
}
