local nebby = {
  object_type = "Challenge",
  key = "nebby",
  rules = {
    custom = {
      { id = "nebby" },
    },
  },
  jokers = {
    { id = "j_agar_cosmog" },
  },
  restrictions = {
    banned_cards = {
      { id = "j_poke_pokedex", ids = { "j_ring_master" } },
      { id = "j_poke_ruins_of_alph", ids = { "j_invisible" } },
      {
        id = "j_poke_jirachi",
        ids = {
          "j_poke_jirachi_banker",
          "j_poke_jirachi_booster",
          "j_poke_jirachi_power",
          "j_poke_jirachi_invis",
          "j_poke_jirachi_fixer",
        }
      },
      { id = "c_ankh" },
    },
  },
}

local calculate_ref = SMODS.current_mod.calculate

SMODS.current_mod.calculate = function(self, context)
  if calculate_ref then
    calculate_ref(self, context)
  end
  if G.GAME.modifiers.nebby then
    if context.first_hand_drawn
        and not SMODS.find_card('j_agar_cosmog')[1]
        and not SMODS.find_card('j_agar_cosmoem')[1]
        and not SMODS.find_card('j_agar_lunala')[1]
        and not SMODS.find_card('j_agar_solgaleo')[1] then
      G.STATE = G.STATES.GAME_OVER
      G.STATE_COMPLETE = false
    end
    if (context.selling_card or context.joker_type_destroyed)
        and (context.card.config.center.key == 'j_agar_cosmog'
          or context.card.config.center.key == 'j_agar_cosmoem'
          or context.card.config.center.key == 'j_agar_lunala'
          or context.card.config.center.key == 'j_agar_solgaleo') then
      G.STATE = G.STATES.GAME_OVER
      G.STATE_COMPLETE = false
    end
  end
end

return {
  name = "Agarmons Nebby Challenge",
  enabled = agarmons_config.cosmog or false,
  list = { nebby }
}
