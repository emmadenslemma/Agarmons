-- Groudon 383
local groudon = {
  name = "groudon",
  config = { extra = { Xmult_multi = 2.4 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    end
    return { vars = { center.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Earth",
  gen = 3,
  enhancement_gate = 'm_mult',
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Create Mult cards
    -- if context.before and context.cardarea == G.jokers and not context.blueprint then
    --   for _, v in pairs(context.scoring_hand) do
    --     if v.config.center == G.P_CENTERS.c_base then
    --       v:set_ability(G.P_CENTERS.m_mult)
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
    -- 2X Mult cards
    if context.individual and context.cardarea == G.play
        and SMODS.has_enhancement(context.other_card, "m_mult") then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
}

-- Primal Groudon 383-1
local primal_groudon = {
  name = "primal_groudon",
  config = { extra = { Xmult_multi = 3, retriggers = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    end
    return { vars = { center.ability.extra.Xmult_multi } }
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
    -- 3X Mult cards
    if context.individual and context.cardarea == G.play
        and SMODS.has_enhancement(context.other_card, "m_mult") then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
    -- Retrigger Fire type Jokers
    if context.retrigger_joker_check
        and context.other_card ~= card and is_type(context.other_card, "Fire") then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    for _, orb in pairs(SMODS.find_card("c_agar_redorb", true)) do
      if orb.ability.extra.active then
        orb.ability.extra.active = false
        break
      end
    end
  end,
}

return {
  name = "Agarmons Groudon",
  enabled = agarmons_config.groudon or false,
  list = { groudon, primal_groudon }
}
