-- Calyrex 898
local calyrex = {
  name = "calyrex",
  config = { extra = { Xmult_multi = 1.75 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        (context.other_card:get_id() == 11 or context.other_card:get_id() == 12) then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  fuses = {
    { with = "j_agar_glastrier", into = "j_agar_calyrex_ice" },
    { with = "j_agar_spectrier", into = "j_agar_calyrex_shadow" },
  }
}

-- Calyrex Ice Rider 898-1
local calyrex_ice = {
  name = "calyrex_ice",
  config = { extra = { Xmult_multi = 1.75 } },
  loc_txt = {
    name = "Calyrex Ice Rider",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 8,
  no_collection = true,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        (context.other_card:get_id() == 11 or context.other_card:get_id() == 12) then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function(self)
    return false
  end
}

-- Calyrex Shadow Rider 898-2
local calyrex_shadow = {
  name = "calyrex_shadow",
  config = { extra = { Xmult_multi = 1.75 } },
  loc_txt = {
    name = "Calyrex Shadow Rider",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 8,
  no_collection = true,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        (context.other_card:get_id() == 11 or context.other_card:get_id() == 12) then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function(self)
    return false
  end
}

return {
  config_key = "calyrex",
  list = { calyrex, calyrex_ice, calyrex_shadow }
}
