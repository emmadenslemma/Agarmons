-- Sandygast 769
local sandygast = {
  name = "sandygast",
  config = { extra = { chips = 0, chip_mod = 3 }, evo_rqmt = 60 },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local suit = G.GAME.current_round.sandygast_suit or "Spades"
    return { vars = { center.ability.extra.chip_mod, localize(suit, "suits_singular"), center.ability.extra.chips, center.ability.evo_rqmt, colours = { G.C.SUITS[suit] } } }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Psychic",
  gen = 7,
  blueprint_compat = true,
  perishable_compat = false,
  calculate = function(self, card, context)
    if context.discard and not context.blueprint and not context.other_card.debuff
        and context.other_card:is_suit(G.GAME.current_round.sandygast_suit) then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.CHIPS
      }
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
      }
    end
    return scaling_evo(self, card, context, "j_agar_palossand", card.ability.extra.chips, self.config.evo_rqmt)
  end,
}

-- Palossand 770
local palossand = {
  name = "palossand",
  config = { extra = { chips = 0, chip_mod = 4 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local suit = G.GAME.current_round.sandygast_suit or "Spades"
    return { vars = { center.ability.extra.chip_mod, localize(suit, "suits_singular"), center.ability.extra.chips, colours = { G.C.SUITS[suit] } } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Psychic",
  gen = 7,
  blueprint_compat = true,
  perishable_compat = false,
  calculate = function(self, card, context)
    if context.discard and not context.blueprint and not context.other_card.debuff
        and context.other_card:is_suit(G.GAME.current_round.sandygast_suit) then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.CHIPS
      }
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
      }
    end
  end,
}

local init = function()
  local reset_game_globals_ref = SMODS.current_mod.reset_game_globals

  SMODS.current_mod.reset_game_globals = function(run_start)
    if reset_game_globals_ref then
      reset_game_globals_ref(run_start)
    end
    local sandygast_suits = {}
    for _, v in ipairs({ "Spades", "Hearts", "Clubs", "Diamonds" }) do
      if v ~= G.GAME.current_round.sandygast_suit then sandygast_suits[#sandygast_suits + 1] = v end
    end
    local sandygast_card = pseudorandom_element(sandygast_suits, pseudoseed("sandygast" .. G.GAME.round_resets.ante))
    G.GAME.current_round.sandygast_suit = sandygast_card
  end
end

return {
  name = "Agarmons Sandygast Evo Line",
  enabled = agarmons_config.sandygast or false,
  init = init,
  list = { sandygast, palossand }
}
