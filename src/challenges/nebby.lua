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

return {
  name = "Agarmons Nebby Challenge",
  enabled = agarmons_config.cosmog or false,
  list = { nebby }
}
