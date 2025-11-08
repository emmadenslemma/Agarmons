local def_list = {}

def_list["dewpider"] = {
  text = {
    { text = "+" },
    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.MULT },
  calc_function = function(card)
    local mult = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()

    if text ~= "Unknown" then
      for _, scoring_card in pairs(scoring_hand) do
        if SMODS.has_enhancement(scoring_card, "m_poke_hazard") then
          mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
        end
      end
    end

    card.joker_display_values.mult = mult
  end
}

def_list["araquanid"] = {
  text = {
    { text = "+", colour = G.C.MULT },
    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    { text = " " },
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
      },
      border_colour = G.C.MULT
    },
  },
  calc_function = function(card)
    local mult = 0
    local hazard_cards = {}
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()

    if text ~= "Unknown" then
      for _, scoring_card in pairs(scoring_hand) do
        if SMODS.has_enhancement(scoring_card, "m_poke_hazard") then
          mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          table.insert(hazard_cards, scoring_card)
        end
      end
    end

    local first_hazard = JokerDisplay.calculate_leftmost_card(hazard_cards)

    card.joker_display_values.mult = mult
    card.joker_display_values.Xmult = first_hazard
        and card.ability.extra.Xmult_multi ^ JokerDisplay.calculate_card_triggers(first_hazard, scoring_hand)
        or 1
  end
}

def_list["sandygast"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.CHIPS },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "sandygast_suit" },
    { text = ")" }
  },
  calc_function = function(card)
    card.joker_display_values.sandygast_suit = localize(G.GAME.current_round.sandygast_suit, 'suits_singular')
  end,
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[2] then
      reminder_text.children[2].config.colour = lighten(G.C.SUITS[G.GAME.current_round.sandygast_suit], 0.35)
    end
    return false
  end
}

def_list["palossand"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.CHIPS },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "sandygast_suit" },
    { text = ")" }
  },
  calc_function = function(card)
    card.joker_display_values.sandygast_suit = localize(G.GAME.current_round.sandygast_suit, 'suits_singular')
  end,
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[2] then
      reminder_text.children[2].config.colour = lighten(G.C.SUITS[G.GAME.current_round.sandygast_suit], 0.35)
    end
    return false
  end
}

def_list["pyukumuku"] = {
  text = {
    { text = "+", colour = G.C.CHIPS },
    { ref_table = "card.ability.extra.stored", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
    { text = " " },
    { text = "+", colour = G.C.MULT },
    { ref_table = "card.ability.extra.stored", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    { text = " " },
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.ability.extra.stored", ref_value = "Xmult", retrigger_type = "exp" }
      },
      border_colour = G.C.MULT
    },
    { text = " " },
    { text = "+$", colour = G.C.GOLD },
    { ref_table = "card.ability.extra.stored", ref_value = "money", retrigger_type = "mult", colour = G.C.GOLD },
  },
}

def_list["cosmog"] = {}

def_list["cosmoem"] = {}

def_list["lunala"] = {}

def_list["solgaleo"] = {}

return {
  dict = def_list
}
