-- Kyogre 382
local kyogre = {
  name = "kyogre",
  soul_pos = { x = 13, y = 25 },
  config = { extra = { Xmult_multi = 2.4 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
    end
    return { vars = { center.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 3,
  enhancement_gate = 'm_bonus',
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Create Bonus cards
    -- if context.before and context.cardarea == G.jokers and not context.blueprint then
    --   for _, v in pairs(context.scoring_hand) do
    --     if v.config.center == G.P_CENTERS.c_base then
    --       v:set_ability(G.P_CENTERS.m_bonus)
    --       G.E_MANAGER:add_event(Event({
    --         func = function()
    --           v:juice_up()
    --           return true
    --         end
    --       }))
    --       break
    --     end
    --   end
    -- end
    -- 2X Bonus cards
    if context.individual and context.cardarea == G.play
        and SMODS.has_enhancement(context.other_card, "m_bonus") then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
}

-- Primal Kyogre 382-1
local primal_kyogre = {
  name = "primal_kyogre",
  pos = { x = 4, y = 7 },
  soul_pos = { x = 5, y = 7 },
  config = { extra = { Xchips_multi = 3, retriggers = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
    end
    return { vars = { center.ability.extra.Xchips_multi } }
  end,
  rarity = "agar_primal",
  cost = 30,
  stage = "Primal",
  ptype = "Water",
  atlas = "AtlasJokersBasicGen03",
  gen = 3,
  aux_poke = true, -- Required for Transformation
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Disable Mult
    if context.final_scoring_step then
      if next(SMODS.find_card("j_agar_primal_groudon")) then
        return {
          message = localize("agar_primordial_sea_ex"),
          colour = G.C.BLUE,
          sound = "timpani",
        }
      else
        mult = 1
        update_hand_text({ delay = 0 }, { mult = mult, chips = hand_chips })

        return {
          message = localize("agar_primordial_sea_ex"),
          colour = G.C.BLUE,
          sound = "gong",
        }
      end
    end
    -- 3X Bonus cards
    if context.individual and context.cardarea == G.play
        and SMODS.has_enhancement(context.other_card, "m_bonus") then
      return {
        x_chips = card.ability.extra.Xchips_multi
      }
    end
    -- Retrigger Water type Jokers
    if context.retrigger_joker_check
        and context.other_card ~= card and is_type(context.other_card, "Water") then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    for _, orb in pairs(SMODS.find_card("c_agar_blueorb", true)) do
      if orb.ability.extra.active then
        orb.ability.extra.active = false
        break
      end
    end
  end,
}

return {
  name = "Agarmons Kyogre",
  enabled = agarmons_config.kyogre or false,
  list = { kyogre, primal_kyogre }
}
