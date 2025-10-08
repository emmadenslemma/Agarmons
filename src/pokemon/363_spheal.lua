-- Spheal 363
local spheal = {
  name = "spheal",
  config = { extra = { mult = 0, mult_mod = 2 }, evo_rqmt = 12 },
  loc_txt = {
    name = "Spheal",
    text = {
      "Gain {C:mult}+#1#{} Mult per",
      "{C:attention}reroll{} in the shop",
      "{C:inactive}(Evolves at {C:mult}+#2#{C:inactive} / +#3# Mult)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.mult_mod, center.ability.extra.mult, center.ability.evo_rqmt } }
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
        message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.mult } },
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
  loc_txt = {
    name = "Sealeo",
    text = {
      "Gain {C:mult}+#1#{} Mult per",
      "{C:attention}reroll{} in the shop",
      "{C:inactive}(Evolves at {C:mult}+#2#{C:inactive} / +#3# Mult)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.mult_mod, center.ability.extra.mult, center.ability.evo_rqmt } }
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
        message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.mult } },
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
  loc_txt = {
    name = "Walrein",
    text = {
      "Gain {C:mult}+#1#{} Mult per",
      "{C:attention}reroll{} in the shop",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:green}#5# in #6#{} chance to",
      "gain {X:mult,C:white}X#3#{} instead",
      "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult, {X:mult,C:white}X#4#{C:inactive} Mult)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local num, dem = SMODS.get_probability_vars(center, center.ability.extra.num, center.ability.extra.dem, "walrein")
    return { vars = { center.ability.extra.mult_mod, center.ability.extra.mult, center.ability.extra.Xmult_mod, center.ability.extra.Xmult, num, dem } }
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
          message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.Xmult } },
          colour = G.C.MULT,
          sound = "tarot1",
        }
      else
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
        return {
          message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.mult } },
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
  name = "Agarmons Spheal Evo Line",
  enabled = agarmons_config.spheal or false,
  list = { spheal, sealeo, walrein }
}
