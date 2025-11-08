local def_list = {}

def_list["mega_victreebel"] = {
  reminder_text = {
    { text = "(2,4,6,8,10)" },
  },
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if held_in_hand then return 0 end
    return SMODS.in_scoring(playing_card, scoring_hand)
        and poke_is_even(playing_card)
        and joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card)
        or 0
  end,
}

def_list["mega_starmie"] = {
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS["Diamonds"], 0.35) },
    { text = ")" }
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = localize("Diamonds", 'suits_plural')
  end,
}

def_list["mega_dragonite"] = {
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if held_in_hand then return 0 end
    return #JokerDisplay.current_hand == 1
        and joker_card.ability.extra.retriggers * ((G.jokers and G.jokers.cards and #G.jokers.cards or 1) - 1) * JokerDisplay.calculate_joker_triggers(joker_card)
        or 0
  end,
  calc_function = function(card)
    card.joker_display_values.localized_text = localize("High Card", "poker_hands")
  end,
}

return {
  dict = def_list
}
