local def_list = {}

def_list["j_agar_torkoal"] = {
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = localize { type = "name_text", set = "Enhanced", key = "m_mult" }
  end,
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    return SMODS.has_enhancement(playing_card, "m_mult") and
        joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
  end
}

def_list["j_agar_spheal"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.MULT },
}

def_list["j_agar_sealeo"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.MULT },
}

def_list["j_agar_walrein"] = {
  text = {
    { text = "+", colour = G.C.MULT },
    { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    { text = " " },
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
      },
      border_colour = G.C.MULT
    },
  },
}

def_list["j_agar_groudon"] = {
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

def_list["j_agar_kyogre"] = {
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

return {
  name = "Agarmons Gen 3 JokerDisplay Definitions",
  dict = def_list
}
