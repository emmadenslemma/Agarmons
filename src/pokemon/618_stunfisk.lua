local function hide_stunfisk(card)
  if card.config.center.key == 'j_agar_stunfisk' then
    card:set_base(G.P_CARDS['D_2']) -- 2 of Diamonds won't be shown bc Stunfisk is a rankless card anyways
    card:set_ability(G.P_CENTERS['m_agar_stunfisk'])
  elseif card.config.center.key == 'j_agar_galarian_stunfisk' then
    card:set_base(G.P_CARDS['C_2'])
    card:set_ability(G.P_CENTERS['m_agar_galarian_stunfisk'])
  end
  -- Becoming a playing card
  G.playing_card = (G.playing_card and G.playing_card + 1) or 1
  card.playing_card = G.playing_card
  table.insert(G.playing_cards, card)

  -- Removing cards messes with the Joker calculating, which works off indexes, so we delay it
  G.E_MANAGER:add_event(Event({
    func = function()
      -- We have to remove it from jokers before adding it to deck, otherwise
      -- it doesn't properly combine with the pile
      G.jokers:remove_card(card)
      G.deck:emplace(card)
      return true
    end
  }))
end

local function rescue_stunfisk()
  for _, card in ipairs(G.deck.cards) do
    local center_key =
        (SMODS.has_enhancement(card, 'm_agar_stunfisk') and 'j_agar_stunfisk')
        or (SMODS.has_enhancement(card, 'm_agar_galarian_stunfisk') and 'j_agar_galarian_stunfisk')

    if center_key then
      -- `front` is the playing card graphic and we have to get rid of it manually
      card.children.front = nil

      card:set_ability(G.P_CENTERS[center_key])

      card.config.card = {}
      card.config.card_key = nil

      G.playing_card = math.max((G.playing_card and G.playing_card - 1) or 0, 0)
      -- `playing_card` is what decides whether we're a playing card when reloading a save
      card.playing_card = nil
      for i, playing_card in ipairs(G.playing_cards) do
        if playing_card == card then
          table.remove(G.playing_cards, i)
          break
        end
      end

      G.E_MANAGER:add_event(Event({
        func = function()
          -- We have to remove the card from the deck before adding it to jokers,
          -- otherwise highlighting breaks.
          G.deck:remove_card(card)
          G.jokers:emplace(card)
          return true
        end
      }))
    end
  end
end

-- Stunfisk 618
local stunfisk = {
  name = "stunfisk",
  config = { extra = {} },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Lightning",
  gen = 5,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint and not card.getting_sliced then
      hide_stunfisk(card)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
  end
}

-- Galarian Stunfisk 618-1
local galarian_stunfisk = {
  name = "galarian_stunfisk",
  pos = { x = 6, y = 8 },
  config = { extra = {} },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Metal",
  atlas = "AtlasJokersBasicGen05",
  gen = 8,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint and not card.getting_sliced then
      hide_stunfisk(card)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
  end
}

local init = function()
  local convert_random_cards = function(amount, enhancement, seed)
    local unenhanced_cards = {}
    for _, hand_card in pairs(G.hand.cards) do
      if hand_card.config.center == G.P_CENTERS['c_base'] then
        table.insert(unenhanced_cards, hand_card)
      end
    end
    pseudoshuffle(unenhanced_cards, pseudoseed(seed))
    local limit = math.min(amount, #unenhanced_cards)
    for i = 1, limit do
      unenhanced_cards[i]:set_ability(G.P_CENTERS[enhancement], nil, true)
      unenhanced_cards[i]:juice_up()
    end
  end

  SMODS.Enhancement {
    key = "stunfisk",
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
    weight = 0,
    no_collection = true,
    in_pool = function(self) return false end,
    calculate = function(self, card, context)
      if context.hand_drawn then
        for _, drawn_card in ipairs(context.hand_drawn) do
          if drawn_card == card then
            convert_random_cards(3, 'm_gold', 'stunfisk')
            return {
              message = localize('k_upgrade_ex'),
              colour = G.C.GOLD,
            }
          end
        end
      end
    end,
  }

  SMODS.Enhancement {
    key = "galarian_stunfisk",
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
    weight = 0,
    no_collection = true,
    in_pool = function(self) return false end,
    calculate = function(self, card, context)
      if context.hand_drawn then
        for _, drawn_card in ipairs(context.hand_drawn) do
          if drawn_card == card then
            convert_random_cards(3, 'm_steel', 'galarian_stunfisk')
            return {
              message = localize('k_upgrade_ex'),
              colour = G.C.GREEN,
            }
          end
        end
      end
    end,
  }

  G.E_MANAGER:add_event(Event({
    func = function()
      G.P_CENTERS['m_agar_stunfisk'].atlas = G.P_CENTERS['j_agar_stunfisk'].atlas
      G.P_CENTERS['m_agar_stunfisk'].pos = G.P_CENTERS['j_agar_stunfisk'].pos
      G.P_CENTERS['m_agar_galarian_stunfisk'].atlas = G.P_CENTERS['j_agar_galarian_stunfisk'].atlas
      G.P_CENTERS['m_agar_galarian_stunfisk'].pos = G.P_CENTERS['j_agar_galarian_stunfisk'].pos
      return true
    end
  }))

  local evaluate_round_ref = G.FUNCS.evaluate_round
  function G.FUNCS.evaluate_round(...)
    rescue_stunfisk()
    return evaluate_round_ref(...)
  end
end

return {
  enabled = agarmons_config.stunfisk or false,
  init = init,
  list = { stunfisk, galarian_stunfisk }
}
