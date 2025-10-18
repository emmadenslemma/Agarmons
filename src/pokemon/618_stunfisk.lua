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
    if context.setting_blind then
      -- -- We're a playing card now.
      -- -- Okay so turns out becoming a playing card gets us rendered as a playing card,
      -- -- and that crashes the game when it finds out we're not a real playing card.
      -- -- We should probably become a real playing card because not being a playing card
      -- -- crashes the game when it tries to find out if our hand is a Flush.
      -- G.playing_card = (G.playing_card and G.playing_card + 1) or 1
      -- card.playing_card = G.playing_card
      -- table.insert(G.playing_cards, card)

      -- We're in the deck now.
      card.area = G.deck
      card.area:emplace(card)
    end
  end,
}

return {
  enabled = agarmons_config.stunfisk or false,
  list = { stunfisk }
}
