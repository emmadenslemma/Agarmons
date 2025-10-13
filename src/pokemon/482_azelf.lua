-- Azelf 482
local azelf = {
  name = "azelf",
  config = { extra = { scry = 5, Xmult_multi = 2 } },
  loc_txt = {
    name = "Azelf",
    text = {
      "{C:purple}+#1# Foresight",
      "Each {C:attention}Bonus Card{} held",
      "in hand gives {C:white,X:mult}X#2#{}",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}Foreseen{} cards trigger",
      "held in hand effects",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.scry, center.ability.extra.Xmult_multi } }
  end,
  designer = "CBMX",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 4,
  enhancement_gate = "m_bonus",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round
        and SMODS.has_enhancement(context.other_card, "m_bonus") then
      if context.other_card.debuff then
        return {
          message = localize("k_debuffed"),
          colour = G.C.RED
        }
      else
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.scry_amount = (G.GAME.scry_amount or 0) + card.ability.extra.scry
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.scry_amount = math.max(0, (G.GAME.scry_amount or 0) - card.ability.extra.scry)
  end,
}

return {
  enabled = agarmons_config.lake_trio or false,
  list = { azelf }
}
