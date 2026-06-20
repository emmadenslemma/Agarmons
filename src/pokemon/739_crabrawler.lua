-- Crabrawler 719
local crabrawler = {
  name = "crabrawler",
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.c_poke_icestone
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Fighting",
  gen = 7,
  item_req = 'icestone',
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not SMODS.has_no_rank(context.other_card) then
      return {
        chips = context.other_card.base.nominal
      }
    end
    return pokermon.item_evo(self, card, context, 'j_agar_crabominable')
  end,
}

local crabominable = {
  name = "crabominable",
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
  end,
  rarity = "poke_safari",
  cost = 7,
  stage = "One",
  ptype = "Fighting",
  gen = 7,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not SMODS.has_no_rank(context.other_card) then
      return {
        chips = context.other_card.base.nominal * 3
      }
    end
    if context.check_enhancement and SMODS.has_enhancement(context.other_card, 'm_glass') then
      return {
        m_wild = true
      }
    end
  end,
}

return {
  config_key = "crabrawler",
  list = { crabrawler, crabominable }
}
