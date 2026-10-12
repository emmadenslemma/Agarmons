local get_suit_percent = function(suit)
  local suit_count = 0
  local total_deck = #G.playing_cards
  for _, v in pairs(G.playing_cards) do
    if v:is_suit(suit, true) then
      suit_count = suit_count + 1
    end
  end
  return suit_count / total_deck
end

local update_eclipse_state = function(card)
  if type(card.ability.extra) ~= 'table' or not card.ability.extra.suit then return end
  local suit_percent = get_suit_percent(card.ability.extra.suit)
  local half_active = suit_percent >= 0.5
  local full_active = suit_percent == 1

  -- Lunala Scry effect
  if card.ability.extra.scry then
    if full_active and not card.ability.extra.full_active then
      G.GAME.poke_scry_amount = (G.GAME.poke_scry_amount or 0) + card.ability.extra.scry
    end
    if not full_active and card.ability.extra.full_active then
      G.GAME.poke_scry_amount = math.max(0, (G.GAME.poke_scry_amount or 0) - card.ability.extra.scry)
    end
  end

  card.ability.extra.half_active = half_active
  card.ability.extra.full_active = full_active
end

-- Cosmog 789
local cosmog = {
  name = "cosmog",
  config = { extra = { rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = "Joker", key = "j_splash", config = {} }
    end
    return { vars = { card.ability.extra.rounds } }
  end,
  rarity = 4,
  cost = 10,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 7,
  no_collection = true,
  blueprint_compat = false,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.modify_scoring_hand then
      return {
        add_to_hand = true
      }
    end
    return pokermon.level_evo(self, card, context, "j_agar_cosmoem")
  end,
  in_pool = function(self)
    return false
  end,
}

-- Cosmoem 790
local cosmoem = {
  name = "cosmoem",
  config = { extra = { suit_sun = "Hearts", suit_moon = "Clubs", sun_suit_scored = 0, moon_suit_scored = 0 }, evo_rqmt = 20 },
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        math.min(self.config.evo_rqmt - card.ability.extra.sun_suit_scored, 0),
        localize(card.ability.extra.suit_sun, "suits_singular"),
        math.min(self.config.evo_rqmt - card.ability.extra.moon_suit_scored, 0),
        localize(card.ability.extra.suit_moon, "suits_singular"),
      }
    }
  end,
  rarity = 4,
  cost = 15,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 7,
  no_collection = true,
  blueprint_compat = false,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card:is_suit(card.ability.extra.suit_sun) then
        card.ability.extra.sun_suit_scored = card.ability.extra.sun_suit_scored + 1
      end
      if context.other_card:is_suit(card.ability.extra.suit_moon) then
        card.ability.extra.moon_suit_scored = card.ability.extra.moon_suit_scored + 1
      end
    end
    return pokermon.scaling_evo(self, card, context, 'j_agar_solgaleo', card.ability.extra.sun_suit_scored,
          self.config.evo_rqmt)
        or pokermon.scaling_evo(self, card, context, 'j_agar_lunala', card.ability.extra.moon_suit_scored,
          self.config.evo_rqmt)
  end,
  in_pool = function(self)
    return false
  end,
}

-- Solgaleo 791
local solgaleo = {
  name = "solgaleo",
  config = { extra = { Xmult_multi = 1.5, suit = "Hearts", half_active = false, full_active = false } },
  loc_vars = function(self, info_queue, card)
    update_eclipse_state(card)
    local ret = {
      vars = {
        localize(card.ability.extra.suit, "suits_plural"),
        localize(card.ability.extra.suit, "suits_singular"),
        card.ability.extra.Xmult_multi,
        colours = {
          card.ability.extra.half_active and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.half_active and G.C.SUITS.Hearts or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.half_active and G.C.MULT or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.full_active and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.full_active and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
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
    if context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint
        and AG.list_utils.all(context.full_hand, function(c) return c:is_suit(suit) end) then
      local hand_cards = {}
      local conv_cards = {}
      for _, v in pairs(G.hand.cards) do
        hand_cards[#hand_cards+1] = v
      end
      pseudoshuffle(hand_cards, pseudoseed("solgaleo"))
      local limit = math.min(3, #hand_cards)
      for i = 1, limit do
        conv_cards[#conv_cards+1] = hand_cards[i]
      end
      for i = 1, limit do
        assert(SMODS.change_base(conv_cards[i], suit))
        conv_cards[i]:juice_up()
      end
    end
    -- Update Eclipse state
    if (context.setting_blind or context.before or context.after) and not context.blueprint then
      update_eclipse_state(card)
    end
    if (context.change_suit or context.remove_playing_cards or context.playing_cards_added) and not context.blueprint then
      AG.defer(function()
        AG.defer(function()
          update_eclipse_state(card)
        end)
      end)
    end
    -- Apply reliable Bloodstone effect at 50% Hearts
    if context.individual and context.cardarea == G.play then
      if card.ability.extra.half_active and context.other_card:is_suit(suit) then
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
    end
    -- Do something at 100% Hearts
    if context.setting_blind and not context.blueprint and context.blind.boss and not card.getting_sliced then
      if card.ability.extra.full_active then
        AG.defer(function()
          AG.defer(function()
            G.GAME.blind:disable()
            play_sound('timpani')
            delay(0.4)
          end)
          SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
        end)
        return nil, true -- This is for Joker retrigger purposes (not that we have any yet)
      end
    end
  end,
}

-- Lunala 792
local lunala = {
  name = "lunala",
  config = { extra = { Xmult_multi = 1.5, suit = "Clubs", half_active = false, full_active = false, scry = 5 } },
  loc_vars = function(self, info_queue, card)
    update_eclipse_state(card)
    local ret = {
      vars = {
        localize(card.ability.extra.suit, "suits_plural"),
        localize(card.ability.extra.suit, "suits_singular"),
        card.ability.extra.Xmult_multi,
        card.ability.extra.scry,
        colours = {
          card.ability.extra.half_active and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.half_active and G.C.SUITS.Clubs or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.half_active and G.C.MULT or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.full_active and G.C.PURPLE or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.full_active and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
          card.ability.extra.full_active and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
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
    if context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint
        and AG.list_utils.all(context.full_hand, function(c) return c:is_suit(suit) end) then
      local hand_cards = {}
      local conv_cards = {}
      for _, v in pairs(G.hand.cards) do
        hand_cards[#hand_cards+1] = v
      end
      pseudoshuffle(hand_cards, pseudoseed("lunala"))
      local limit = math.min(3, #hand_cards)
      for i = 1, limit do
        conv_cards[#conv_cards+1] = hand_cards[i]
      end
      for i = 1, limit do
        assert(SMODS.change_base(conv_cards[i], suit))
        conv_cards[i]:juice_up()
      end
    end
    -- Update Eclipse state
    if (context.setting_blind or context.before or context.after) and not context.blueprint then
      update_eclipse_state(card)
    end
    if (context.change_suit or context.remove_playing_cards or context.playing_cards_added) and not context.blueprint then
      AG.defer(function()
        AG.defer(function()
          update_eclipse_state(card)
        end)
      end)
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
  end,
  add_to_deck = function(self, card, from_debuff)
    update_eclipse_state(card)
  end,
  remove_from_deck = function(self, card, from_debuff)
    update_eclipse_state(card)
    if card.ability.extra.full_active then
      G.GAME.poke_scry_amount = math.max(0, (G.GAME.poke_scry_amount or 0) - card.ability.extra.scry)
    end
  end,
}

return {
  config_key = "cosmog",
  list = { cosmog, cosmoem, solgaleo, lunala }
}
