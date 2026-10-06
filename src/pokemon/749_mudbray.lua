-- Mudbray 749
local mudbray = {
  name = "mudbray",
  config = { extra = { mult_mod = 1, rounds = 5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Earth",
  gen = 7,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0)
          + card.ability.extra.mult_mod
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT,
      }
    end
    return pokermon.level_evo(self, card, context, 'j_agar_mudsdale')
  end,
}

-- Mudsdale 750
local mudsdale = {
  name = "mudsdale",
  config = { extra = { mult_mod = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult_mod * #pokermon.find_pokemon_type('Earth') } }
  end,
  rarity = "poke_safari",
  cost = 7,
  stage = "Basic",
  ptype = "Earth",
  gen = 7,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local mult_gain = card.ability.extra.mult_mod * #pokermon.find_pokemon_type('Earth')
      if mult_gain > 0 then
        context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + mult_gain
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT,
        }
      end
    end
  end,
}

return {
  config_key = "mudbray",
  list = { mudbray, mudsdale }
}
