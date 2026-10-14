local any = AG.list_utils.any

-- Klawf 950
local klawf = {
  name = "klawf",
  config = { extra = { Xmult = 3 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Earth",
  gen = 9,
  calculate = function(self, card, context)
    if context.joker_main
        and any(context.scoring_hand, function(c) return c:get_id() == 7 end)
        and any(context.scoring_hand, function(c) return c:get_id() == 11 end) then
      return {
        xmult = card.ability.extra.Xmult
      }
    end
  end,
}

return {
  config_key = "klawf",
  list = { klawf }
}
