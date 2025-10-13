-- Uxie 480
local uxie = {
  name = "uxie",
  config = { extra = { scry = 5, Xmult = 1, Xmult_mod = 1, gold_cards_triggered = 0 }, trigger_rqmt = 11 },
  loc_txt = {
    name = "Uxie",
    text = {
      "{C:purple}+#1# Foresight",
      "Gains {C:white,X:mult}X#2#{} Mult every {C:attention}#3# {C:inactive}[#4#]",
      "{C:attention}Gold{} cards triggered",
      "{C:inactive}(Currently {C:white,X:mult}X#5#{C:inactive} Mult)",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}Foreseen{} cards trigger",
      "held in hand effects",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {
      vars = {
        center.ability.extra.scry,
        center.ability.extra.Xmult_mod,
        self.config.trigger_rqmt,
        self.config.trigger_rqmt - center.ability.extra.gold_cards_triggered,
        center.ability.extra.Xmult,
      }
    }
  end,
  designer = "CBMX",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 4,
  enhancement_gate = "m_gold",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and context.end_of_round
        and SMODS.has_enhancement(context.other_card, "m_gold") and not context.blueprint then
      card.ability.extra.gold_cards_triggered = card.ability.extra.gold_cards_triggered + 1
      if card.ability.extra.gold_cards_triggered == self.config.trigger_rqmt then
        card.ability.extra.gold_cards_triggered = 0
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
        SMODS.calculate_effect({ message = localize("k_upgrade_ex"), colour = G.C.MULT }, card)
      end
    end
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
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
  list = { uxie }
}
