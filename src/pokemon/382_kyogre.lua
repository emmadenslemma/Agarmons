-- Kyogre 382
local kyogre = {
  name = "kyogre",
  config = { extra = { chip_req = 30, Xmult_multi = 1.75 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local hierophant_name_text = localize { type = 'name_text', set = 'Tarot', key = 'c_heirophant' }
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'holding', vars = { hierophant_name_text } }
      info_queue[#info_queue+1] = G.P_CENTERS.c_heirophant
    end
    return { vars = { hierophant_name_text, card.ability.extra.chip_req, card.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 3,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and poke_total_chips(context.other_card) >= card.ability.extra.chip_req then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      local hierophant = SMODS.add_card { key = 'c_heirophant' }
      SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot }, hierophant)
    end
  end,
}

-- Primal Kyogre 382-1
local primal_kyogre = {
  name = "primal_kyogre",
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
  end,
  rarity = "agar_primal",
  cost = 30,
  stage = "Primal",
  ptype = "Water",
  gen = 3,
  aux_poke = true, -- Required for Transformation
  calculate = function(self, card, context)
    if context.before and not G.GAME.desolate_land then
      mult = 1
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.primordial_sea = true
    if G.hand and G.hand.cards then
      G.hand:parse_highlighted() -- For immediate feedback on the Poker Hand mult values
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not next(SMODS.find_card('j_agar_primal_kyogre')) then
      G.GAME.primordial_sea = false
      if G.hand and G.hand.cards then
        G.hand:parse_highlighted()
      end
    end
    for _, orb in pairs(SMODS.find_card("c_agar_blueorb", true)) do
      if orb.ability.extra.active then
        orb.ability.extra.active = false
        break
      end
    end
  end,
}

local init = function()
  AG.hookbeforefunc(_G, 'update_hand_text', function(config, vals)
    if G.GAME.primordial_sea and not G.GAME.desolate_land and vals.mult ~= 0 then
      vals.mult = 1
    end
  end)
end

return {
  config_key = "kyogre",
  init = init,
  list = { kyogre, primal_kyogre }
}
