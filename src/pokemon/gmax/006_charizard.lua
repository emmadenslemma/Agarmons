-- G-Max Charizard 006
local gmax_charizard = {
  name = "gmax_charizard",
  inject_prefix = "poke",
  pos = { x = 0, y = 7 },
  soul_pos = { x = 1, y = 7 },
  config = { extra = { Xmult_mod = 1, d_size = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Charizard",
    text = {
      "{C:white,X:mult}X#3#{} Mult per discard",
      "used this round",
      "{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive} Mult)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local current_Xmult = center.ability.extra.Xmult_mod * G.GAME.current_round.discards_used
    return { vars = { center.ability.extra.Xmult_mod, current_Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Fire",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
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
  AG.append_to_family("charizard", "gmax_charizard", true)
  AG.gmax.evos["j_poke_charizard"] = "j_poke_gmax_charizard"
  AG.gmax.disable_method_during_evolve("j_poke_blastoise", "add_to_deck")
  AG.gmax.disable_method_during_evolve("j_poke_blastoise", "remove_from_deck")

  SMODS.Joker:take_ownership("poke_charizard", { gmax = "gmax_charizard" }, true)
end

return {
  name = "Agarmons G-Max Charizard",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_charizard }
}
