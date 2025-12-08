local drampa = {
  name = "drampa",
  config = { extra = { boosters = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.boosters } }
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Dragon",
  gen = 7,
  add_to_deck = function(self, card, from_debuff)
    -- to stop adding boosters when mega evolving/devolving
    G.GAME.modifiers.extra_boosters = (G.GAME.modifiers.extra_boosters or 0) + card.ability.extra.boosters
  end,
  remove_from_deck = function(self, card, from_debuff)
    SMODS.change_booster_limit(-card.ability.extra.boosters)
  end,
  designer = "CBMX",
  megas = { "mega_drampa" },
}

local mega_drampa = {
  name = "mega_drampa",
  pos = { x = 8, y = 2 },
  soul_pos = { x = 9, y = 2 },
  config = { extra = { boosters = 1, booster_choice_mod = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.boosters, card.ability.extra.booster_choice_mod } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Dragon",
  gen = 7,
  atlas = "AgarmonsJokers",
  add_to_deck = function(self, card, from_debuff)
    G.GAME.modifiers.extra_boosters = (G.GAME.modifiers.extra_boosters or 0) + card.ability.extra.boosters
    G.GAME.modifiers.booster_choice_mod =
        (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.booster_choice_mod
  end,
  remove_from_deck = function(self, card, from_debuff)
    SMODS.change_booster_limit(-card.ability.extra.boosters)
    G.GAME.modifiers.booster_choice_mod =
        math.max(0, (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra.booster_choice_mod)
  end,
  artist = "KingOfThe-X-Roads",
  designer = "Gem",
}

return {
  config_key = "drampa",
  list = { drampa, mega_drampa }
}
