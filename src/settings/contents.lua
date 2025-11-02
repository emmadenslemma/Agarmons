return {
  pages = {
    {
      title = function() return localize("agar_regular_pokemon1") end,
      tiles = {
        { list = { "j_agar_torkoal" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_torkoal" } end, config_key = "torkoal" },
        { list = { "j_agar_bagon", "j_agar_shelgon", "j_agar_salamence", "j_agar_mega_salamence" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_bagon" } end, config_key = "bagon" },
        { list = { "j_agar_dewpider", "j_agar_araquanid" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_dewpider" } end, config_key = "dewpider" },
        { list = { "j_agar_sandygast", "j_agar_palossand" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_sandygast" } end, config_key = "sandygast" },
        { list = { "j_agar_pyukumuku" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_pyukumuku" } end, config_key = "pyukumuku" },
        { list = { "j_agar_sinistea", "j_agar_polteageist" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_sinistea" } end, config_key = "sinistea" },
      }
    },
    {
      title = function() return localize("agar_regular_pokemon2") end,
      tiles = {
        { list = { "j_agar_frigibax", "j_agar_arctibax", "j_agar_baxcalibur" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_frigibax" } end, config_key = "frigibax" },
        { list = { "j_agar_poltchageist", "j_agar_sinistcha" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_poltchageist" } end, config_key = "poltchageist" },
        { list = { "j_agar_gmax_charizard", "j_agar_gmax_butterfree", "j_agar_gmax_machamp" }, label = function() return localize("agar_gigantamaxing") end, config_key = "gmax" },
        { list = { "j_agar_mega_dragonite", "j_agar_mega_victreebel" }, label = function() return localize("agar_new_megas") end, config_key = "new_megas" },
      }
    },
    {
      title = function() return localize("agar_legendary_pokemon1") end,
      tiles = {
        { list = { "j_agar_kyogre", "j_agar_primal_kyogre" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_kyogre" } end, config_key = "kyogre" },
        { list = { "j_agar_groudon", "j_agar_primal_groudon" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_groudon" } end, config_key = "groudon" },
        { list = { "j_agar_uxie", "j_agar_mesprit", "j_agar_azelf" }, label = function() return localize("agar_lake_trio") end, config_key = "lake_trio" },
        { list = { "j_agar_dialga" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_dialga" } end, config_key = "dialga" },
        { list = { "j_agar_palkia" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_palkia" } end, config_key = "palkia" },
        { list = { "j_agar_regigigas" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_regigigas" } end, config_key = "regigigas" },
      }
    },
    {
      title = function() return localize("agar_legendary_pokemon2") end,
      tiles = {
        { list = { "j_agar_arceus" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_arceus" } end, config_key = "arceus" },
        { list = { "j_agar_xerneas" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_xerneas" } end, config_key = "xerneas" },
        { list = { "j_agar_yveltal" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_yveltal" } end, config_key = "yveltal" },
        { list = { "j_agar_cosmog", "j_agar_cosmoem", "j_agar_solgaleo", "j_agar_lunala" }, label = function() return localize("agar_lunala_and_solgaleo") end, config_key = "cosmog" },
      }
    },
  }
}
