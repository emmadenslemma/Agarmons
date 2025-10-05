-- Frigibax 996
local frigibax = {
  name = "frigibax",
  config = { extra = { Xmult_multi = 1.1, five_of_a_kinds = 0 }, evo_rqmt = 5 },
  loc_txt = {
    name = "Frigibax",
    text = {
      "If played hand is a",
      "{C:attention,E:1}Five of a Kind",
      "All played cards give",
      "{X:mult,C:white}X#1#{} Mult when scored",
      "{C:inactive,s:0.8}(Evolves after playing {C:attention,s:0.8}#2#{C:inactive,s:0.8} Five of a Kinds)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult_multi, math.max(0, self.config.evo_rqmt - center.ability.extra.five_of_a_kinds) } }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Dragon",
  gen = 9,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.scoring_hand and context.scoring_name == "Five of a Kind" then
      if context.before and context.cardarea == G.jokers and not context.blueprint then
        card.ability.extra.five_of_a_kinds = card.ability.extra.five_of_a_kinds + 1
      end
      if context.individual and context.cardarea == G.play then
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
    end
    return scaling_evo(self, card, context, "j_agar_arctibax", card.ability.extra.five_of_a_kinds, self.config.evo_rqmt)
  end,
  -- in_pool = function(self)
  --   return G.GAME.hands["Five of a Kind"].played > 0 and pokemon_in_pool(self)
  -- end,
}

-- Arctibax 997
local arctibax = {
  name = "arctibax",
  config = { extra = { Xmult_multi = 1.3, five_of_a_kinds = 0 }, evo_rqmt = 5 },
  loc_txt = {
    name = "Arctibax",
    text = {
      "If played hand is a",
      "{C:attention,E:1}Five of a Kind",
      "All played cards give",
      "{X:mult,C:white}X#1#{} Mult when scored",
      "{C:inactive,s:0.8}(Evolves after playing {C:attention,s:0.8}#2#{C:inactive,s:0.8} Five of a Kinds)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult_multi, math.max(0, self.config.evo_rqmt - center.ability.extra.five_of_a_kinds) } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Dragon",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.scoring_hand and context.scoring_name == "Five of a Kind" then
      if context.before and context.cardarea == G.jokers and not context.blueprint then
        card.ability.extra.five_of_a_kinds = card.ability.extra.five_of_a_kinds + 1
      end
      if context.individual and context.cardarea == G.play then
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
    end
    return scaling_evo(self, card, context, "j_agar_baxcalibur", card.ability.extra.five_of_a_kinds, self.config.evo_rqmt)
  end,
}

-- Baxcalibur 998
local baxcalibur = {
  name = "baxcalibur",
  config = { extra = { Xmult_multi = 1.5, chips_per_retrigger = 1000 } },
  loc_txt = {
    name = "Baxcalibur",
    text = {
      "If played hand is a",
      "{C:attention,E:1}Five of a Kind",
      "All played cards give",
      "{X:mult,C:white}X#1#{} Mult when scored",
      "{br:2}ERROR - CONTACT STEAK",
      "Also retrigger every",
      "card once per {C:chips}#2#{} of",
      "that card's total chips",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult_multi, center.ability.extra.chips_per_retrigger } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Dragon",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.scoring_hand and context.scoring_name == "Five of a Kind" then
      if context.individual and context.cardarea == G.play then
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
      if context.repetition and context.cardarea == G.play then
        local chips = poke_total_chips(context.other_card)
        local retriggers = math.floor(chips / card.ability.extra.chips_per_retrigger)
        if retriggers ~= 0 then
          return {
            repetitions = retriggers
          }
        end
      end
    end
  end,
}

local init = function()
  pokermon.add_family { "frigibax", "arctibax", "baxcalibur" }
end

return {
  name = "Agarmons Frigibax Evo Line",
  enabled = agarmons_config.frigibax or false,
  init = init,
  list = { frigibax, arctibax, baxcalibur }
}
