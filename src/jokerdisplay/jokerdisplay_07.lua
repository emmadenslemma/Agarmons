local def_list = {}

-- def_list["j_agar_dewpider"] = {
--   text = {
--     { text = "+" },
--     { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" },
--   },
--   text_config = { colour = G.C.CHIPS },
--   calc_function = function(card)
--     local chips = card.ability.extra.chips
--     local text, _, scoring_hand = JokerDisplay.evaluate_hand()

--     if text ~= "Unknown" then
--       for _, scoring_card in pairs(scoring_hand) do
--         if SMODS.has_enhancement(scoring_card, "m_poke_hazard") then
--           chips = chips * 2
--           break
--         end
--       end
--     end

--     card.joker_display_values.chips = chips
--   end
-- }

-- def_list["j_agar_araquanid"] = {
--   text = {
--     { text = "+" },
--     { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" },
--   },
--   text_config = { colour = G.C.CHIPS },
--   calc_function = function(card)
--     local chips = card.ability.extra.chips
--     local text, _, scoring_hand = JokerDisplay.evaluate_hand()

--     if text ~= "Unknown" then
--       for _, scoring_card in pairs(scoring_hand) do
--         if SMODS.has_enhancement(scoring_card, "m_poke_hazard") then
--           chips = chips * 3
--           break
--         end
--       end
--     end

--     card.joker_display_values.chips = chips
--   end
-- }

def_list["j_agar_sandygast"] = {
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

def_list["j_agar_palossand"] = {
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

def_list["j_agar_pyukumuku"] = {
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

return {
  name = "Agarmons Gen 7 JokerDisplay Definitions",
  dict = def_list
}
