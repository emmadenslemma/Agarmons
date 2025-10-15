-- G-Max Charizard 006
local gmax_charizard = {
  name = "gmax_charizard",
  pos = { x = 0, y = 7 },
  soul_pos = { x = 1, y = 7 },
  config = { extra = { Xmult = 1, Xmult_mod = 0.5, d_size = 1 } },
  loc_txt = {
    name = "Gigantamax Charizard",
    text = {
      "Gains {C:white,X:mult}X#3#{} per discard",
      "used this round",
      "{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive} Mult)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local current_Xmult = center.ability.extra.Xmult + center.ability.extra.Xmult_mod * G.GAME.current_round.discards_used
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
      local current_Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * G.GAME.current_round.discards_used
      if current_Xmult > 1 then
        return {
          Xmult = current_Xmult,
        }
      end
    end
  end,
  -- `add_to/remove_from_deck` Stolen from regular Charizard to keep your discard during dynamax
  add_to_deck = SMODS.Joker.obj_table.j_poke_charizard.add_to_deck,
  remove_from_deck = SMODS.Joker.obj_table.j_poke_charizard.remove_from_deck,
}

local init = function()
  AGAR.GMAX.evos["j_poke_charizard"] = "j_agar_gmax_charizard"
end

return {
  name = "Agarmons G-Max Charizard",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_charizard }
}
