local cosmog_in_pool = function(self)
  local suits_found = false
  for _, v in pairs(G.playing_cards) do
    if v:is_suit("Hearts", true) or v:is_suit("Clubs", true) then
      suits_found = true
      break
    end
  end
  return suits_found and pokemon_in_pool(self)
end

local get_suit_percent = function(suit, changed_cards, to_be_removed)
  local suit_count = 0
  local total_deck = #G.playing_cards
  for _, v in pairs(G.playing_cards) do
    if v:is_suit(suit, true) then
      suit_count = suit_count + 1
    end
  end
  -- This doesn't account for cards immediately getting destroyed with no event, but we're just gonna assume they don't exist
  if changed_cards then
    for _, v in pairs(changed_cards) do
      deck_mod = to_be_removed and -1 or 1
      total_deck = total_deck + deck_mod
      if v:is_suit(suit, true) then
        suit_count = suit_count + deck_mod
      end
    end
  end
  return suit_count / total_deck
end

-- Cosmog 789
local cosmog = {
  name = "cosmog",
  pos = { x = 0, y = 0 },
  soul_pos = { x = 1, y = 0 },
  config = { extra = { rounds = 4 } },
  loc_txt = {
    name = "Cosmog",
    text = {
      "Applies {C:attention}Splash",
      "{C:inactive,s:0.8}(Evolves after {C:attention,s:0.8}#1#{C:inactive,s:0.8} rounds)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = "Joker", key = "j_splash", config = {} }
    end
    local ret = { vars = { center.ability.extra.rounds } }
    if G.GAME.modifiers.nebby then
      ret.key = "j_agar_nebby"
    end
    return ret
  end,
  rarity = 4,
  cost = 10,
  stage = "Basic",
  ptype = "Psychic",
  atlas = "AgarmonsJokers",
  gen = 7,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    return level_evo(self, card, context, "j_agar_cosmoem")
  end,
  -- in_pool = cosmog_in_pool,
  add_to_deck = function(self, card, from_debuff)
    if G.GAME.modifiers.nebby then
      card.ability.extra.rounds = 12
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if G.GAME.modifiers.nebby then
      G.STATE = G.STATES.GAME_OVER
      G.STATE_COMPLETE = false
    end
  end,
}

-- Cosmoem 790
local cosmoem = {
  name = "cosmoem",
  pos = { x = 2, y = 0 },
  soul_pos = { x = 3, y = 0 },
  config = { extra = { suit_sun = "Hearts", suit_moon = "Clubs" } },
  loc_txt = {
    name = "Cosmoem",
    text = {
      "{C:inactive}Evolves when deck is",
      "{C:attention}>50% {C:hearts}#1#{C:inactive} or {C:clubs}#2#",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local ret = { vars = { localize(center.ability.extra.suit_sun, "suits_plural"), localize(center.ability.extra.suit_moon, "suits_plural") } }
    if G.GAME.modifiers.nebby then
      ret.key = "j_agar_nebby_cosmoem"
    end
    return ret
  end,
  rarity = 4,
  cost = 15,
  stage = "One",
  ptype = "Psychic",
  atlas = "AgarmonsJokers",
  gen = 7,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    local deck_size = #G.playing_cards
    return deck_suit_evo(self, card, context, "j_agar_solgaleo", card.ability.extra.suit_sun, .5 + .5 / deck_size)
        or deck_suit_evo(self, card, context, "j_agar_lunala", card.ability.extra.suit_moon, .5 + .5 / deck_size)
  end,
  -- in_pool = cosmog_in_pool,
  remove_from_deck = function(self, card, from_debuff)
    if G.GAME.modifiers.nebby then
      G.STATE = G.STATES.GAME_OVER
      G.STATE_COMPLETE = false
    end
  end,
}

-- Solgaleo 791
local solgaleo = {
  name = "solgaleo",
  config = { extra = { Xmult_multi = 1.5, suit = "Hearts", half_active = false, full_active = false } },
  loc_txt = {
    name = "Solgaleo",
    text = {
      "If first played hand is all {C:hearts}#1#{},",
      "turn 3 cards held in hand to {C:hearts}#1#{}",
      "{C:inactive,s:0.8}if deck is {C:attention,s:0.8}50% {C:hearts,s:0.8}#1#",
      "{V:1}Played {V:2}#2#{V:1} cards give {C:white,B:3}X#3#{V:1} Mult when scored",
      "{C:inactive,s:0.8}if deck is {C:attention,s:0.8}100% {C:hearts,s:0.8}#1#",
      "{V:4}Disables effect of every {V:5}Boss Blind",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local ret = {
      vars = {
        localize(center.ability.extra.suit, "suits_plural"),
        localize(center.ability.extra.suit, "suits_singular"),
        center.ability.extra.Xmult_multi,
        colours = {
          center.ability.extra.half_active and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.half_active and G.C.SUITS.Hearts or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.half_active and G.C.MULT or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.full_active and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.full_active and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
        }
      }
    }
    if G.GAME.modifiers.nebby then
      ret.key = "j_agar_nebby_solgaleo"
    end
    return ret
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local suit = card.ability.extra.suit
    -- On the first hand of round, turn 3 cards into Hearts.
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    if context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint then -- Add Hearts requirement later
      local hand_cards = {}
      local conv_cards = {}
      for _, v in pairs(G.hand.cards) do
        hand_cards[#hand_cards + 1] = v
      end
      pseudoshuffle(hand_cards, pseudoseed("solgaleo"))
      local limit = math.min(3, #hand_cards)
      for i = 1, limit do
        conv_cards[#conv_cards + 1] = hand_cards[i]
      end
      for i = 1, limit do
        SMODS.change_base(conv_cards[i], suit)
        conv_cards[i]:juice_up()
      end
    end
    -- Update Suit counts
    if not context.blueprint then
      local suit_percent
      if context.setting_blind then
        suit_percent = get_suit_percent(suit)
      end
      if context.before then
        suit_percent = get_suit_percent(suit)
      end
      if context.remove_playing_cards then
        suit_percent = get_suit_percent(suit, context.removed, true)
      end
      if context.playing_card_added then
        suit_percent = get_suit_percent(suit, context.cards, false)
      end
      if suit_percent then
        card.ability.extra.half_active = suit_percent >= 0.5
        card.ability.extra.full_active = suit_percent == 1
      end
    end
    -- Apply reliable Bloodstone effect at 50% Hearts
    if context.individual and context.cardarea == G.play
        and card.ability.extra.half_active and context.other_card:is_suit(suit) then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
    -- Do something at 100% Hearts
    if card.ability.extra.full_active then
      -- Stolen from Vanilla Remade (and Mega Gyarados)
      if context.setting_blind and not context.blueprint and context.blind.boss and not card.getting_sliced then -- I don't know what getting sliced is and I'm too scared to ask
        G.E_MANAGER:add_event(Event({
          func = function()
            G.E_MANAGER:add_event(Event({
              func = function()
                G.GAME.blind:disable()
                play_sound('timpani')
                delay(0.4)
                return true
              end
            }))
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
            return true
          end
        }))
        return nil, true -- This is for Joker retrigger purposes
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    local suit_percent = get_suit_percent(card.ability.extra.suit)
    card.ability.extra.half_active = suit_percent >= 0.5
    card.ability.extra.full_active = suit_percent == 1
  end,
  remove_from_deck = function(self, card, from_debuff)
    if G.GAME.modifiers.nebby then
      G.STATE = G.STATES.GAME_OVER
      G.STATE_COMPLETE = false
    end
  end,
}

-- Lunala 792
local lunala = {
  name = "lunala",
  config = { extra = { Xmult_multi = 1.5, suit = "Clubs", half_active = false, full_active = false, scry = 5 } },
  loc_txt = {
    name = "Lunala",
    text = {
      "If first played hand is all {C:clubs}#1#{},",
      "turn 3 cards held in hand to {C:clubs}#1#{}",
      "{C:inactive,s:0.8}if deck is {C:attention,s:0.8}50% {C:clubs,s:0.8}#1#",
      "{V:1}Each {V:2}#2#{V:1} Card held in hand gives {C:white,B:3}X#3#{V:1} Mult",
      "{C:inactive,s:0.8}if deck is {C:attention,s:0.8}100% {C:clubs,s:0.8}#1#",
      "{V:4}+#4# Foresight",
      "{V:5}Foreseen{V:6} cards trigger held",
      "{V:6}in hand effects",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local ret = {
      vars = {
        localize(center.ability.extra.suit, "suits_plural"),
        localize(center.ability.extra.suit, "suits_singular"),
        center.ability.extra.Xmult_multi,
        center.ability.extra.scry,
        colours = {
          center.ability.extra.half_active and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.half_active and G.C.SUITS.Clubs or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.half_active and G.C.MULT or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.full_active and G.C.PURPLE or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.full_active and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
          center.ability.extra.full_active and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
        }
      }
    }
    if G.GAME.modifiers.nebby then
      ret.key = "j_agar_nebby_lunala"
    end
    return ret
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local suit = card.ability.extra.suit
    -- On the first hand of round, turn 3 cards into Clubs.
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    if context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint then
      local all_suits = true
      for _, v in pairs(context.full_hand) do
        if not v:is_suit(suit) then
          all_suits = false
          break
        end
      end

      if all_suits then
        -- Code stolen from Raikou
        local hand_cards = {}
        local conv_cards = {}
        for _, v in pairs(G.hand.cards) do
          hand_cards[#hand_cards + 1] = v
        end
        pseudoshuffle(hand_cards, pseudoseed("lunala"))
        local limit = math.min(3, #hand_cards)
        for i = 1, limit do
          conv_cards[#conv_cards + 1] = hand_cards[i]
        end
        for i = 1, limit do
          SMODS.change_base(conv_cards[i], suit)
          conv_cards[i]:juice_up()
        end
      end
    end
    -- Update Suit counts
    local was_full_active = card.ability.extra.full_active
    if not context.blueprint then
      local suit_percent
      if context.before then
        suit_percent = get_suit_percent(suit)
      end
      if context.remove_playing_cards then
        suit_percent = get_suit_percent(suit, context.removed, true)
      end
      if context.playing_card_added then
        suit_percent = get_suit_percent(suit, context.cards, false)
      end
      if suit_percent then
        card.ability.extra.half_active = suit_percent >= 0.5
        card.ability.extra.full_active = suit_percent == 1
      end
    end
    -- Apply Baron effect at 50% Clubs
    if context.individual and context.cardarea == G.hand and not context.end_of_round
        and card.ability.extra.half_active and context.other_card:is_suit(suit) then
      if context.other_card.debuff then
        return {
          message = localize("k_debuffed"),
          colour = G.C.RED
        }
      else
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
    end
    -- Apply Scry at 100% Clubs
    if card.ability.extra.full_active then
      if not was_full_active then
        G.GAME.scry_amount = (G.GAME.scry_amount or 0) + card.ability.extra.scry
      end
    else
      if was_full_active then
        G.GAME.scry_amount = math.max(0, (G.GAME.scry_amount or 0) - card.ability.extra.scry)
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    local suit_percent = get_suit_percent(card.ability.extra.suit)
    card.ability.extra.half_active = suit_percent >= 0.5
    card.ability.extra.full_active = suit_percent == 1
    if card.ability.extra.full_active then
      G.GAME.scry_amount = (G.GAME.scry_amount or 0) + card.ability.extra.scry
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.full_active then
      G.GAME.scry_amount = math.max(0, (G.GAME.scry_amount or 0) - card.ability.extra.scry)
    end
    if G.GAME.modifiers.nebby then
      G.STATE = G.STATES.GAME_OVER
      G.STATE_COMPLETE = false
    end
  end,
}

local init = function()
  local applies_splash_ref = applies_splash
  function applies_splash()
    return applies_splash_ref() or
        next(SMODS.find_card("j_agar_cosmog"))
  end
end

return {
  name = "Agarmons Cosmog Evo Line",
  enabled = agarmons_config.cosmog or false,
  init = init,
  list = { cosmog, cosmoem, solgaleo, lunala }
}
