local toedscool = {
  name = "toedscool",
  config = { extra = { mult_mod = 4, rounds = 5 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        context.other_card:get_id() == 4 then
      return {
        mult = card.ability.extra.mult_mod
      }
    end
    return level_evo(self, card, context, 'j_agar_toedscruel')
  end
}

local toedscruel = {
  name = "toedscruel",
  config = { extra = { mult_mod = 8 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod } }
  end,
  rarity = "poke_safari",
  cost = 6,
  stage = "One",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        context.other_card:get_id() == 4 then
      return {
        mult = card.ability.extra.mult_mod
      }
    end
  end
}

return {
  config_key = "toedscool",
  list = { toedscool, toedscruel }
}
