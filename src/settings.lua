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
          create_toggle { label = localize("agar_enable_torkoal"), ref_table = agarmons_config, ref_value = "torkoal" },
          create_toggle { label = localize("agar_enable_spheal"), ref_table = agarmons_config, ref_value = "spheal" },
          create_toggle { label = localize("agar_enable_bagon"), ref_table = agarmons_config, ref_value = "bagon" },
          create_toggle { label = localize("agar_enable_sandygast"), ref_table = agarmons_config, ref_value = "sandygast" },
          create_toggle { label = localize("agar_enable_dewpider"), ref_table = agarmons_config, ref_value = "dewpider" },
          create_toggle { label = localize("agar_enable_pyukumuku"), ref_table = agarmons_config, ref_value = "pyukumuku" },
          -- create_toggle { label = localize("agar_enable_hatenna"), ref_table = agarmons_config, ref_value = "hatenna" },
          create_toggle { label = localize("agar_enable_frigibax"), ref_table = agarmons_config, ref_value = "frigibax" },
          create_toggle { label = localize("agar_enable_kyogre"), ref_table = agarmons_config, ref_value = "kyogre" },
          create_toggle { label = localize("agar_enable_groudon"), ref_table = agarmons_config, ref_value = "groudon" },
          -- create_toggle { label = localize("agar_enable_rayquaza"), ref_table = agarmons_config, ref_value = "rayquaza" },
          create_toggle { label = localize("agar_enable_dialga"), ref_table = agarmons_config, ref_value = "dialga" },
          create_toggle { label = localize("agar_enable_palkia"), ref_table = agarmons_config, ref_value = "palkia" },
          create_toggle { label = localize("agar_enable_cosmog"), ref_table = agarmons_config, ref_value = "cosmog" },
          create_toggle { label = localize("agar_enable_gmax"), ref_table = agarmons_config, ref_value = "gmax" },
        },
      },
    },
  }
end
