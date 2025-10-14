return {
  pages = {
    {
      title = "Regular Pokémon 1/2",
      tiles = {
        { list = { "torkoal" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_torkoal" } end, config_key = "torkoal" },
        { list = { "spheal", "sealeo", "walrein" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_spheal" } end, config_key = "spheal" },
        { list = { "bagon", "shelgon", "salamence", "mega_salamence" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_bagon" } end, config_key = "bagon" },
        { list = { "dewpider", "araquanid" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_dewpider" } end, config_key = "dewpider" },
        { list = { "sandygast", "palossand" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_sandygast" } end, config_key = "sandygast" },
        { list = { "pyukumuku" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_pyukumuku" } end, config_key = "pyukumuku" },
      }
    },
    {
      title = "Regular Pokémon 2/2",
      tiles = {
        { list = { "frigibax", "arctibax", "baxcalibur" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_frigibax" } end, config_key = "frigibax" },
      }
    },
    {
      title = "Legendary Pokémon",
      tiles = {
        { list = { "kyogre", "primal_kyogre" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_kyogre" } end, config_key = "kyogre" },
        { list = { "groudon", "primal_groudon" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_groudon" } end, config_key = "groudon" },
        { list = { "uxie", "mesprit", "azelf" }, label = function() return localize("agar_lake_trio") end, config_key = "lake_trio" },
        { list = { "dialga" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_dialga" } end, config_key = "dialga" },
        { list = { "palkia" }, label = function() return localize { type = "name_text", set = "Joker", key = "j_agar_palkia" } end, config_key = "palkia" },
        { list = { "cosmog", "cosmoem", "solgaleo", "lunala" }, label = function() return localize("agar_lunala_and_solgaleo") end, config_key = "cosmog" },
      }
    },
  }
}
