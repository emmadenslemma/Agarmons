-- Cresselia 488
local cresselia = {
  name = "cresselia",
  config = { extra = { Xmult_multi = 3 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 4,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and context.other_card == context.scoring_hand[1] then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.modifiers.trick_room = true
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not next(SMODS.find_card('j_agar_cresselia'))
        and not G.GAME.selected_back_key.key == 'b_agar_reverseddeck' then -- key.key???
      G.GAME.modifiers.trick_room = false
    end
  end,
}

return {
  config_key = "cresselia",
  list = { cresselia }
}
