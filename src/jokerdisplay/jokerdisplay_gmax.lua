local def_list = {}

def_list["gmax_venusaur"] = {}

def_list["gmax_charizard"] = {}

def_list["gmax_blastoise"] = {}

def_list["gmax_butterfree"] = {
  text = {
    { text = "+" },
    { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.MULT }
}

def_list["gmax_pikachu"] = {}

def_list["gmax_meowth"] = {}

def_list["gmax_machamp"] = {}

def_list["gmax_gengar"] = {
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
    { text = "x" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.EDITION },
    { text = ")" },
  },
  calc_function = function(card)
    local count = 0
    if G.jokers then
      for _, joker_card in ipairs(G.jokers.cards) do
        if joker_card.edition and joker_card.edition.negative then
          count = count + 1
        end
      end
    end
    card.joker_display_values.count = count
    card.joker_display_values.localized_text = localize { type = "name_text", set = "Edition", key = "e_negative" }
  end,
  mod_function = function(card, mod_joker)
    return { x_mult = (card.edition and card.edition.negative and mod_joker.ability.extra.Xmult_multi ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
  end
}

def_list["gmax_kingler"] = {}

def_list["gmax_lapras"] = {}

def_list["gmax_eevee"] = {}

def_list["gmax_snorlax"] = {}

def_list["gmax_melmetal"] = {}

return {
  dict = def_list
}
