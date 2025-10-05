-- Dewpider 751
local dewpider = {
  name = "dewpider",
  config = { extra = { hazards = 4, chips = 45, rounds = 4 } },
  loc_txt = {
    name = "Dewpider",
    text = {
      "{C:purple}+#1# Hazards{}, {C:chips}+#2#{} Chips",
      "Doubled if played hand",
      "contains a {C:attention}Hazard{} card",
      "{C:inactive,s:0.8}(Evolves after {C:attention,s:0.8}#3#{C:inactive,s:0.8} rounds)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue + 1] = { set = 'Other', key = 'poke_hazards', vars = { center.ability.extra.hazards } }
    info_queue[#info_queue + 1] = G.P_CENTERS.m_poke_hazard
    return { vars = { center.ability.extra.hazards, center.ability.extra.chips, center.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Water",
  gen = 7,
  blueprint_compat = true,
  hazard_poke = true,
  calculate = function(self, card, context)
    if context.setting_blind then
      poke_set_hazards(card.ability.extra.hazards)
    end
    if context.joker_main then
      for _, v in pairs(context.scoring_hand) do
        if SMODS.has_enhancement(v, "m_poke_hazard") then
          return {
            message = localize("poke_water_bubble_ex"),
            chips = card.ability.extra.chips * 2,
            colour = G.C.CHIPS,
          }
        end
      end

      return {
        chips = card.ability.extra.chips
      }
    end
    return level_evo(self, card, context, "j_agar_araquanid")
  end,
}

-- Araquanid 752
local araquanid = {
  name = "araquanid",
  config = { extra = { hazards = 4, chips = 60 } },
  loc_txt = {
    name = "Araquanid",
    text = {
      "{C:purple}+#1# Hazards{}, {C:chips}+#2#{} Chips",
      "Tripled if played hand",
      "contains a {C:attention}Hazard{} card",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue + 1] = { set = 'Other', key = 'poke_hazards', vars = { center.ability.extra.hazards } }
    info_queue[#info_queue + 1] = G.P_CENTERS.m_poke_hazard
    return { vars = { center.ability.extra.hazards, center.ability.extra.chips } }
  end,
  rarity = 2,
  cost = 5,
  stage = "One",
  ptype = "Water",
  gen = 7,
  blueprint_compat = true,
  hazard_poke = true,
  calculate = function(self, card, context)
    if context.setting_blind then
      poke_set_hazards(card.ability.extra.hazards)
    end
    if context.joker_main then
      for _, v in pairs(context.scoring_hand) do
        if SMODS.has_enhancement(v, "m_poke_hazard") then
          return {
            message = localize("poke_water_bubble_ex"),
            chips = card.ability.extra.chips * 3,
            colour = G.C.CHIPS,
          }
        end
      end

      return {
        chips = card.ability.extra.chips
      }
    end
  end,
}

local init = function()
  pokermon.add_family { "dewpider", "araquanid" }
end

return {
  name = "Agarmons Dewpider Evo Line",
  enabled = agarmons_config.dewpider or false,
  init = init,
  list = { dewpider, araquanid }
}
