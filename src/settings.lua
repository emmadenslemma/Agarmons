-- local create_pokemon_toggle = function(pokemon)
--   local key = "j_agar_" .. pokemon
--   return {
--     n = G.UIT.R,
--     nodes = {
--       {
--         n = G.UIT.O,
--         config = {
--           object = Card(0, 0, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[key])
--         },
--       },
--       create_toggle {
--         label = localize { type = "name_text", set = "Joker", key = key },
--         ref_table = agarmons_config,
--         ref_value = pokemon,
--       },
--     },
--   }
-- end

SMODS.current_mod.config_tab = function()
  return
  {
    n = G.UIT.ROOT,
    config = { colour = G.C.CLEAR },
    nodes = {
      {
        n = G.UIT.C,
        config = { align = "cm" },
        nodes = {
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_torkoal" }, ref_table = agarmons_config, ref_value = "torkoal" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_spheal" }, ref_table = agarmons_config, ref_value = "spheal" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_bagon" }, ref_table = agarmons_config, ref_value = "bagon" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_sandygast" }, ref_table = agarmons_config, ref_value = "sandygast" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_dewpider" }, ref_table = agarmons_config, ref_value = "dewpider" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_pyukumuku" }, ref_table = agarmons_config, ref_value = "pyukumuku" },
          -- create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_hatenna" }, ref_table = agarmons_config, ref_value = "hatenna" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_frigibax" }, ref_table = agarmons_config, ref_value = "frigibax" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_kyogre" }, ref_table = agarmons_config, ref_value = "kyogre" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_groudon" }, ref_table = agarmons_config, ref_value = "groudon" },
          -- create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_rayquaza" }, ref_table = agarmons_config, ref_value = "rayquaza" },
          create_toggle { label = localize { type = "name_text", set = "Joker", key = "j_agar_cosmog" }, ref_table = agarmons_config, ref_value = "cosmog" },
          -- create_toggle { label = localize("k_agar_gmax"), ref_table = agarmons_config, ref_value = "gmax" },
        },
      },
    },
  }
end
