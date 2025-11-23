AG.pack_utils = {}

-- Note: `context.ending_booster` is still called even if you remove the skip button, but nothing in Pokermon uses it currently

function AG.pack_utils.open_fake_pack(key)
  if G.shop and not G.shop.alignment.offset.py then
    G.shop.alignment.offset.py = G.shop.alignment.offset.y
    G.shop.alignment.offset.y = G.ROOM.T.y + 29
  end
  if G.blind_select and not G.blind_select.alignment.offset.py then
    G.blind_select.alignment.offset.py = G.blind_select.alignment.offset.y
    G.blind_select.alignment.offset.y = G.ROOM.T.y + 39
  end
  if G.round_eval and not G.round_eval.alignment.offset.py then
    G.round_eval.alignment.offset.py = G.round_eval.alignment.offset.y
    G.round_eval.alignment.offset.y = G.ROOM.T.y + 29
  end

  G.GAME.PACK_INTERRUPT = G.STATE
  G.STATE_COMPLETE = false
  booster_obj = G.P_CENTERS[key]
  G.STATE = G.STATES.SMODS_BOOSTER_OPENED
  SMODS.OPENED_BOOSTER = {
    config = { center = booster_obj },
    ability = copy_table(booster_obj.config),
    label = booster_obj.name
  }
  G.GAME.pack_choices = SMODS.OPENED_BOOSTER.ability.choose
  G.GAME.pack_size = SMODS.OPENED_BOOSTER.ability.extra

  -- TODO: How much do I need to delay this for G.pack_cards to exist?
  -- also I need to spawn the cards much closer to the cardarea
  -- also I need to spawn the cards one at a time
  G.E_MANAGER:add_event(Event({
    blocking = false,
    trigger = 'after',
    delay = 0.4,
    func = function()
      for i = 1, G.GAME.pack_size do
        local card = booster_obj:create_card(nil, i)
        card.T.x = G.pack_cards.T.x
        card.T.y = G.pack_cards.T.y
        card:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.5 * G.SETTINGS.GAMESPEED)
        G.pack_cards:emplace(card)
      end
      return true
    end
  }))
end
