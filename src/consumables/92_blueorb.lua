local blueorb = AG.legendary_orb {
  name = "blueorb",
  key = "blueorb",
  pos = { x = 3, y = 0 },
  loc_txt = {
    name = "Blue Orb",
    text = {
      "Awaken {C:attention}Kyogre{}'s",
      "true potential",
      "{C:inactive}(Usable once per round)",
    }
  },
  atlas = "AgarmonsConsumables",

  agar_base_key = "j_agar_kyogre",
  agar_form_key = "j_agar_primal_kyogre",
}

return {
  can_load = agarmons_config.kyogre,
  list = { blueorb }
}
