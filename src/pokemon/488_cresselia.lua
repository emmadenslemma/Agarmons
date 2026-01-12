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
  add_to_deck = function(self, card, from_debuff)
    G.GAME.trick_room = true
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not next(SMODS.find_card('j_agar_cresselia')) then
      G.GAME.trick_room = false
    end
  end,
}

local init = function()
  AG.hookaroundfunc(SMODS, 'get_card_areas', function(orig, ...)
    local t = orig(...)
    if G.GAME.trick_room then
      t = AG.list_utils.rev(t)
    end
    return t
  end)
end

return {
  config_key = "cresselia",
  init = init,
  list = { cresselia }
}
