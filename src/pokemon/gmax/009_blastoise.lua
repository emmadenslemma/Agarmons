-- G-Max Blastoise 009
local gmax_blastoise = {
  name = "gmax_blastoise",
  inject_prefix = "poke",
  config = { extra = { Xmult_mod = 1, hands = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Blastoise",
    text = {
      "{C:white,X:mult}X#3#{} Mult for each",
      "remaining hand",
      "{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive} Mult)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local current_Xmult = center.ability.extra.Xmult_mod * G.GAME.current_round.hands_left
    return { vars = { center.ability.extra.Xmult_mod, current_Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local current_Xmult = card.ability.extra.Xmult_mod * G.GAME.current_round.hands_left
      if current_Xmult > 1 then
        return {
          Xmult = current_Xmult,
        }
      end
    end
  end,
  -- `add/remove_from_deck` from regular Blastoise to keep extra hand
  add_to_deck = SMODS.Joker.obj_table.j_poke_blastoise.add_to_deck,
  remove_from_deck = SMODS.Joker.obj_table.j_poke_blastoise.remove_from_deck,
}

local init = function()
  AG.append_to_family("blastoise", "gmax_blastoise")
  AG.gmax.evos["j_poke_blastoise"] = "j_poke_gmax_blastoise"
end

return {
  name = "Agarmons G-Max Blastoise",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_blastoise }
}
