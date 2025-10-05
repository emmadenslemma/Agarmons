-- G-Max Machamp 068
local gmax_machamp = {
  name = "gmax_machamp",
  base_key = "j_poke_machamp",
  pos = { x = 8, y = 7 },
  soul_pos = { x = 9, y = 7 },
  config = { extra = { Xmult_mod = 0.5, hands = 4, discards = 4 } },
  loc_txt = {
    name = "Gigantamax Machamp",
    text = {
      "#1#",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:white,X:mult}X#2#{} per hand left",
      "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)"
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
  ptype = "Fighting",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local current_Xmult = card.ability.extra.Xmult_mod * G.GAME.current_round.hands_left
      return {
        message = localize("agar_gmax_chi_strike_ex"),
        Xmult = current_Xmult,
      }
    end
  end,
  -- `add_to/remove_from_deck` Stolen from Machamp to keep your hands during dynamax
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
    ease_discard(-card.ability.extra.discards)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
    ease_discard(card.ability.extra.discards)
  end
}

local init = function()
  -- edit get_family_keys to let us insert gmax into existing families
  -- for _, family in pairs(pokermon.family) do
  --   if family[1] == "machop" then
  --     family[#family + 1] = "gmax_machamp"
  --     break
  --   end
  -- end
end

return {
  name = "Agarmons G-Max Machamp",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_machamp }
}
