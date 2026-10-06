-- Veluza 976
local veluza = {
  name = "veluza",
  config = { extra = { discards = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.discards } }
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Water",
  gen = 9,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      local hands_left = G.GAME.current_round.hands_left + (G.poke_hands_buffer or 0)
      local hands_lost = math.floor(hands_left / 2)
      if hands_lost > 0 then
        pokermon.ease_hands_played(-hands_lost)
        ease_discard(hands_lost * card.ability.extra.discards)
      end
    end
  end,
}

return {
  config_key = "veluza",
  list = { veluza }
}
