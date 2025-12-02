-- Spheal 363
local spheal = {
  name = "spheal",
  config = { extra = { mult = 0, mult_mod = 2 }, evo_rqmt = 12 },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult, card.ability.evo_rqmt } }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Water",
  gen = 3,
  blueprint_compat = true,
  perishable_compat = false,
  calculate = function(self, card, context)
    if context.reroll_shop and not context.blueprint then
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
      return {
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
        colour = G.C.MULT,
      }
    end
    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
    return scaling_evo(self, card, context, "j_agar_sealeo", card.ability.extra.mult, self.config.evo_rqmt)
  end,
}

-- Sealeo 364
local sealeo = {
  name = "sealeo",
  config = { extra = { mult = 0, mult_mod = 3 }, evo_rqmt = 30 },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult, card.ability.evo_rqmt } }
  end,
  rarity = "poke_safari",
  cost = 9,
  stage = "One",
  ptype = "Water",
  gen = 3,
  blueprint_compat = true,
  perishable_compat = false,
  calculate = function(self, card, context)
    if context.reroll_shop and not context.blueprint then
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
      return {
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
        colour = G.C.MULT,
      }
    end
    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
    return scaling_evo(self, card, context, "j_agar_walrein", card.ability.extra.mult, self.config.evo_rqmt)
  end,
}

-- Walrein 365
local walrein = {
  name = "walrein",
  config = { extra = { mult = 0, mult_mod = 3, Xmult = 1, Xmult_mod = .15, num = 1, dem = 4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "walrein")
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult, card.ability.extra.Xmult_mod, card.ability.extra.Xmult, num, dem } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Water",
  gen = 3,
  blueprint_compat = true,
  perishable_compat = false,
  calculate = function(self, card, context)
    if context.reroll_shop and not context.blueprint then
      if SMODS.pseudorandom_probability(card, "walrein", card.ability.extra.num, card.ability.extra.dem, "walrein") then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          colour = G.C.MULT,
          sound = "tarot1",
        }
      else
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
        return {
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
          colour = G.C.MULT,
        }
      end
    end
    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
        Xmult = card.ability.extra.Xmult,
      }
    end
  end,
}

return {
  can_load = false,
  config_key = "spheal",
  list = { spheal, sealeo, walrein }
}
