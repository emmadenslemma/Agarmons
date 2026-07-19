local redorb = AG.legendary_orb {
  name = "redorb",
  key = "redorb",
  pos = { x = 2, y = 0 },
  loc_txt = {
    name = "Red Orb",
    text = {
      "Awaken {C:attention}Groudon{}'s",
      "true potential",
      "{C:inactive}(Usable once per round)",
    },
  },
  atlas = "AgarmonsConsumables",

  agar_base_key = "j_agar_groudon",
  agar_form_key = "j_agar_primal_groudon",
}

return {
  can_load = false, -- agarmons_config.groudon,
  list = { redorb }
}
