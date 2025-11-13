-- Calyrex 898
local calyrex = {
  name = "calyrex",
  pos = { x = 10, y = 10, },
  soul_pos = { x = 11, y = 10, },
  config = { extra = { Xmult_multi = 1.75 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 8,
  atlas = "AtlasJokersBasicGen08",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        (context.other_card:get_id() == 11 or context.other_card:get_id() == 12) then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
}

return {
  enabled = agarmons_config.calyrex or false,
  list = { calyrex }
}
