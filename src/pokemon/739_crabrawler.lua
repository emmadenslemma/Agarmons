-- Crabrawler 719
local crabrawler = {
  name = "crabrawler",
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_icestone
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Fighting",
  gen = 7,
  item_req = 'icestone',
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
      return {
        mult = context.other_card.base.nominal
      }
    end
    return pokermon.item_evo(self, card, context, 'j_agar_crabominable')
  end,
}

local crabominable = {
  name = "crabominable",
  rarity = "poke_safari",
  cost = 7,
  stage = "One",
  ptype = "Water",
  gen = 7,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
      local enhancements = SMODS.get_enhancements(context.other_card) or {}
      local factor = (enhancements['m_glass'] or enhancements['m_wild']) and 3 or 1
      return {
        mult = context.other_card.base.nominal * factor
      }
    end
  end,
}

return {
  config_key = "crabrawler",
  list = { crabrawler, crabominable }
}
