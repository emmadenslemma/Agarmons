local def_list = {}

def_list["torkoal"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
      },
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    return SMODS.has_enhancement(playing_card, "m_mult") and
        joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
  end,
  calc_function = function(card)
    local Xmult = 1
    if G.deck and G.deck.cards then
      for _, card_in_deck in pairs(G.deck.cards) do
        if SMODS.has_enhancement(card_in_deck, 'm_mult') then
          Xmult = Xmult + card.ability.extra.Xmult_mod
        end
      end
    end
    card.joker_display_values.Xmult = Xmult
    card.joker_display_values.localized_text = localize { type = "name_text", set = "Enhanced", key = "m_mult" }
  end,
}

def_list["bagon"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.CHIPS },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = localize("Straight", "poker_hands")
  end,
}

def_list["shelgon"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.CHIPS },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = localize("Straight", "poker_hands")
  end,
}

def_list["salamence"] = {
  text = {
    { text = "+", colour = G.C.CHIPS },
    { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
    { text = " " },
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
      },
      border_colour = G.C.MULT
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.Xmult = 1 + card.ability.extra.straights * card.ability.extra.Xmult_mod
    card.joker_display_values.localized_text = localize("Straight", "poker_hands")
  end,
}

def_list["mega_salamence"] = {
  text = {
    { text = "+", colour = G.C.CHIPS },
    { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
    { text = " " },
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
      },
      border_colour = G.C.MULT
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.Xmult = 1 + card.ability.extra.straights * card.ability.extra.Xmult_mod
    card.joker_display_values.localized_text = localize("Straight", "poker_hands")
  end,
}

def_list["groudon"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
      },
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    local count = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()

    if text ~= "Unknown" then
      for _, scoring_card in pairs(scoring_hand) do
        if SMODS.has_enhancement(scoring_card, "m_mult") then
          count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
        end
      end
    end

    card.joker_display_values.Xmult = card.ability.extra.Xmult_multi ^ count
    card.joker_display_values.localized_text = localize { type = "name_text", set = "Enhanced", key = "m_mult" }
  end
}

def_list["primal_groudon"] = {}

def_list["kyogre"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
      },
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    local count = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()

    if text ~= "Unknown" then
      for _, scoring_card in pairs(scoring_hand) do
        if SMODS.has_enhancement(scoring_card, "m_bonus") then
          count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
        end
      end
    end

    card.joker_display_values.Xmult = card.ability.extra.Xmult_multi ^ count
    card.joker_display_values.localized_text = localize { type = "name_text", set = "Enhanced", key = "m_bonus" }
  end
}

def_list["primal_kyogre"] = {}

return {
  name = "Agarmons Gen 3 JokerDisplay Definitions",
  dict = def_list
}
