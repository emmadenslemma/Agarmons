local adamantcrystal = AG.legendary_orb {
  name = "adamantcrystal",
  key = "adamantcrystal",
  pos = { x = 4, y = 0 },
  loc_txt = {
    name = "Adamant Crystal",
    text = {
      "Transform {C:attention}Dialga{} into",
      "its {C:attention}Origin Forme",
      "{C:inactive}(Usable once per round)",
    }
  },
  atlas = "AgarmonsConsumables",

  agar_base_key = "j_agar_dialga",
  agar_form_key = "j_agar_dialga_origin",
}

return {
  can_load = agarmons_config.dialga,
  list = { adamantcrystal }
}
