-- Groudon 383
local groudon = {
  name = "groudon",
  config = { extra = { mult_req = 4, Xmult_multi = 1.75 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local empress_name_text = localize { type = 'name_text', set = 'Tarot', key = 'c_empress' }
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'holding', vars = { empress_name_text } }
      info_queue[#info_queue+1] = G.P_CENTERS.c_empress
    end
    return { vars = { empress_name_text, card.ability.extra.mult_req, card.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Earth",
  gen = 3,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and poke_total_mult(context.other_card) >= card.ability.extra.mult_req then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      local empress = SMODS.add_card { key = 'c_empress' }
      SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot }, empress)
    end
  end,
}

-- Primal Groudon 383-1
local primal_groudon = {
  name = "primal_groudon",
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
  end,
  rarity = "agar_primal",
  cost = 30,
  stage = "Primal",
  ptype = "Earth",
  gen = 3,
  aux_poke = true, -- Required for Transformation
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Disable Chips
    if context.final_scoring_step then
      if next(SMODS.find_card("j_agar_primal_kyogre")) then
        return {
          message = localize("agar_desolate_land_ex"),
          colour = G.C.RED,
          sound = "timpani",
        }
      else
        hand_chips = 1
        update_hand_text({ delay = 0 }, { mult = mult, chips = hand_chips })

        return {
          message = localize("agar_desolate_land_ex"),
          colour = G.C.RED,
          sound = "gong",
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    AG.effects.desolate_land = true
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not next(SMODS.find_card('j_agar_primal_groudon')) then
      AG.effects.desolate_land = false
    end
    for _, orb in pairs(SMODS.find_card("c_agar_redorb", true)) do
      if orb.ability.extra.active then
        orb.ability.extra.active = false
        break
      end
    end
  end,
}

return {
  config_key = "groudon",
  list = { groudon, primal_groudon }
}
