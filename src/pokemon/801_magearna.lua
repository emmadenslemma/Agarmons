-- Magearna 801
local magearna = {
  name = "magearna",
  config = { extra = { Xmult = 1, Xmult_mod = 1 } },
  loc_txt = {
    name = "Magerna",
    text = {
      "Gains {C:white,X:mult}X#1#{} Mult when",
      "a Joker is destroyed",
      "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    if context.joker_type_destroyed and not context.blueprint then
      card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
      return {
        message = localize('agar_soul_heart')
      }
    end
  end,
}

return {
  config_key = "magearna",
  list = { magearna }
}
