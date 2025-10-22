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
      -- Okay so turns out becoming a playing card gets us rendered as a playing card,
      -- and that crashes the game when it finds out we're not a real playing card.
      -- We should probably become a real playing card because not being a playing card
      -- crashes the game when it tries to find out if our hand is a Flush.
      -- card.set_sprites = function() end
      card:set_base(G.P_CARDS['D_2']) -- 2 of Diamonds won't be shown bc Stunfisk is a Hazard card anyways
      card:set_ability(G.P_CENTERS['m_agar_stunfisk'])
      -- We're a playing card now.
      G.playing_card = (G.playing_card and G.playing_card + 1) or 1
      card.playing_card = G.playing_card
      table.insert(G.playing_cards, card)
      -- We're in the deck now.
      card:set_card_area(G.deck)
      card.area:emplace(card)

      -- Removing cards messes with the Joker calculating, which works off indexes, so we delay it
      G.E_MANAGER:add_event(Event({
        func = function()
          G.jokers:remove_card(card)
          return true
        end
      }))
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
      -- SMODS.add_card()
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
  end
}

local init = function()
  SMODS.Enhancement {
    key = "stunfisk",
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
      return { vars = {} }
    end,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
    weight = 0,
    no_collection = true,
    in_pool = function(self, args) return false end,
    calculate = function(self, card, context)
      if context.check_enhancement and context.other_card == card then
        return { m_poke_hazard = true }
      end
    end,
  }

  G.E_MANAGER:add_event(Event({
    func = function()
      G.P_CENTERS['m_agar_stunfisk'].atlas = G.P_CENTERS['j_agar_stunfisk'].atlas
      G.P_CENTERS['m_agar_stunfisk'].pos = G.P_CENTERS['j_agar_stunfisk'].pos
      return true
    end
  }))

  local calculate_ref = SMODS.current_mod.calculate
  SMODS.current_mod.calculate = function(self, context)
    if calculate_ref then
      calculate_ref(self, context)
    end
    if context.end_of_round and not context.individual and not context.repetition then
      -- TODO: Loop through G.hand and G.discard as well
      for _, card in ipairs(G.deck.cards) do
        if SMODS.has_enhancement(card, 'm_agar_stunfisk') then
          -- These are all set on creation - we may not need to touch them?
          card.states.collide.can = true
          card.states.hover.can = true
          card.states.drag.can = true
          card.states.click.can = true
          -- `front` is the playing card graphic and we have to get rid of it manually
          card.children.front = nil

          card:set_ability(G.P_CENTERS['j_agar_stunfisk'])

          card.config.card = {}
          card.config.card_key = nil
          -- card.base = {}

          G.playing_card = math.max((G.playing_card and G.playing_card - 1) or 0, 0)
          card.playing_card = nil
          -- TODO: Look into Card:remove() [line:4752] on how to make this save.
          -- Currently breaks if you reload a save immediately after entering the shop.
          for i, playing_card in ipairs(G.playing_cards) do
            if playing_card == card then
              table.remove(G.playing_cards, i)
              break
            end
          end

          -- Once again removing cards mid loop causes problems, so we delay it
          G.E_MANAGER:add_event(Event({
            func = function()
              -- We have to remove the card from the deck before adding it to jokers,
              -- otherwise highlighting breaks for some reason.
              -- Don't ask.
              G.deck:remove_card(card)
              card:set_card_area(G.jokers)
              card.area:emplace(card)
              return true
            end
          }))
        end
      end
    end
  end
end

return {
  enabled = agarmons_config.stunfisk or false,
  init = init,
  list = { stunfisk, galarian_stunfisk }
}
