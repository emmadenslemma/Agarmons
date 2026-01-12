-- Cresselia 488
local cresselia = {
  name = "cresselia",
  loc_txt = {
    name = "Cresselia",
    text = {
      "Scoring order is reversed",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 4,
}

return {
  config_key = "cresselia",
  list = { cresselia }
}
