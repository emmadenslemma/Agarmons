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
    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1]
        and not SMODS.has_no_rank(context.other_card) then
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
    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1]
        and not SMODS.has_no_rank(context.other_card) then
      local enhancements = SMODS.get_enhancements(context.other_card) or {}
      local factor = (enhancements['m_glass'] or enhancements['m_wild']) and 3 or 1
      return {
        mult = context.other_card.base.nominal * factor
      }
    end
  end,
  megas = { "mega_crabominable" },
}

local mega_crabominable = {
  name = "mega_crabominable",
  config = { extra = { Xmult_multi = 0.2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = "poke_mega",
  cost = 10,
  stage = "Mega",
  ptype = "Water",
  gen = 7,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and not SMODS.has_no_rank(context.other_card)
        and (SMODS.has_enhancement(context.other_card, 'm_glass')
          or SMODS.has_enhancement(context.other_card, 'm_wild')) then
      local other_glass_wilds = 0

      for _, v in ipairs(context.scoring_hand) do
        if v == context.other_card then break end
        if SMODS.has_enhancement(v, 'm_glass') or SMODS.has_enhancement(v, 'm_wild') then
          other_glass_wilds = other_glass_wilds + 1
        end
        if other_glass_wilds >= 2 then return end
      end

      return {
        xmult = 1 + card.ability.extra.Xmult_multi * context.other_card.base.nominal
      }
    end
  end,
}

return {
  config_key = "crabrawler",
  list = { crabrawler, crabominable, mega_crabominable }
}
