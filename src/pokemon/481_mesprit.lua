-- Mesprit 481
local mesprit = {
  name = "mesprit",
  config = { extra = { scry = 5, num = 1, dem = 3 } },
  loc_txt = {
    name = "Mesprit",
    text = {
      "{C:purple}+#1# Foresight",
      "Each {C:attention}Mult Card{} held in",
      "hand has a {C:green}#2# in #3#{} chance",
      "to create a {C:dark_edition}Negative {C:tarot}Tarot{}",
      "card at end of round",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}Foreseen{} cards trigger",
      "held in hand effects",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local num, dem = SMODS.get_probability_vars(center, center.ability.extra.num, center.ability.extra.dem, "mesprit")
    return { vars = { center.ability.extra.scry, num, dem } }
  end,
  designer = "CBMX",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 4,
  enhancement_gate = "m_mult",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and context.cardarea == G.hand and context.individual
        and SMODS.has_enhancement(context.other_card, "m_mult")
        and SMODS.pseudorandom_probability(card, "mesprit", card.ability.extra.num, card.ability.extra.dem, "mesprit") then
      G.E_MANAGER:add_event(Event({
        func = (function()
          SMODS.add_card { set = "Tarot", edition = "e_negative" }
          return true
        end)
      }))
      return {
        message = localize("k_plus_tarot"),
        colour = G.C.SECONDARY_SET.Tarot,
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
  list = { mesprit }
}
