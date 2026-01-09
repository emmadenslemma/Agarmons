-- Mega Skarmory 227-1
local mega_skarmory = {
  name = "mega_skarmory",
  agar_inject_prefix = "poke",
  pos = { x = 0, y = 3 },
  soul_pos = { x = 1, y = 3 },
  config = { extra = { hazard_level = 1, hazard_max = 1, Xmult_multi = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    -- Yes, these should be toggled with detailed_tooltips, but this is for consistency with Pokermon
    info_queue[#info_queue+1] = { set = 'Other', key = 'hazard_level', vars = poke_get_hazard_level_vars() }
    info_queue[#info_queue+1] = G.P_CENTERS.m_poke_hazard
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = G.P_CENTERS.m_steel
      info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    end
    return { vars = { card.ability.extra.hazard_level, card.ability.extra.hazard_max, card.ability.extra.Xmult_multi } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Metal",
  gen = 1,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        SMODS.has_enhancement(context.other_card, 'm_poke_hazard') then
      local gold_or_steel_count = #AG.list_utils.filter(
        G.hand.cards,
        function(hand_card)
          return SMODS.has_enhancement(hand_card, 'm_steel')
              or SMODS.has_enhancement(hand_card, 'm_gold')
        end
      )
      local Xmult = gold_or_steel_count * card.ability.extra.Xmult_multi

      if Xmult > 1 then
        return {
          Xmult = Xmult,
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    poke_change_hazard_max(card.ability.extra.hazard_max)
    poke_change_hazard_level(card.ability.extra.hazard_level)
  end,
  remove_from_deck = function(self, card, from_debuff)
    poke_change_hazard_max(-card.ability.extra.hazard_max)
    poke_change_hazard_level(-card.ability.extra.hazard_level)
  end,
}

local function init()
  poke_add_to_family("skarmory", "mega_skarmory")
  SMODS.Joker:take_ownership("poke_skarmory", { megas = { "mega_skarmory" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_skarmory }
}
