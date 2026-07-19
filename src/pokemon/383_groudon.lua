local get_boosting_joker_count = function()
  local count = 0
  if not G.jokers then return count end
  for _, v in ipairs(G.jokers.cards) do
    if (pokermon.is_type(v, 'Fire') or pokermon.is_type(v, 'Earth')) then
      count = count + 1
    end
  end
  return count
end

-- Groudon 383
local groudon = {
  name = "groudon",
  config = { extra = { Xmult_multi = 0.5, Xmult_multi2 = 1 } },
  loc_vars = function(self, info_queue, card)
    local ex = card.ability.extra
    local total_xmult = ex.Xmult_multi * get_boosting_joker_count() + ex.Xmult_multi2
    return { vars = { ex.Xmult_multi, total_xmult } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Earth",
  gen = 3,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and SMODS.has_no_rank(context.other_card) then
      return {
        Xmult = card.ability.extra.Xmult_multi * get_boosting_joker_count() + card.ability.extra.Xmult_multi2
      }
    end
  end,
}

-- Primal Groudon 383-1
local primal_groudon = {
  name = "primal_groudon",
  rarity = "agar_primal",
  cost = 30,
  stage = "Primal",
  ptype = "Earth",
  gen = 3,
  aux_poke = true, -- Required for Transformation
  calculate = function(self, card, context)
    -- Disable Chips
    if context.final_scoring_step and not G.GAME.primordial_sea then
      chips = 1
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.desolate_land = true
    if G.hand and G.hand.cards then
      G.hand:parse_highlighted() -- For immediate feedback on the Poker Hand chip values
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not next(SMODS.find_card('j_agar_primal_groudon')) then
      G.GAME.desolate_land = false
      if G.hand and G.hand.cards then
        G.hand:parse_highlighted()
      end
    end
    for _, orb in pairs(SMODS.find_card("c_agar_redorb", true)) do
      if orb.ability.extra.active then
        orb.ability.extra.active = false
        break
      end
    end
  end,
}

local init = function()
  AG.hookbeforefunc(_G, 'update_hand_text', function(config, vals)
    if G.GAME.desolate_land and not G.GAME.primordial_sea and vals.chips and vals.chips ~= 0 then
      vals.chips = 1
    end
  end)
end

return {
  config_key = "groudon",
  -- init = init,
  list = { groudon } --, primal_groudon }
}
