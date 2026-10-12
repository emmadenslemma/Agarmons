-- Bombirdier 962
local bombirdier = {
  name = "bombirdier",
  config = { extra = { draw_req = 15, cards_drawn = 0 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.draw_req, card.ability.extra.cards_drawn } }
  end,
  rarity = 2,
  cost = 7,
  stage = "Basic",
  ptype = "Dark",
  gen = 9,
  blueprint_compat = false,
  calculate = function(self, card, context)
    local ex = card.ability.extra

    if context.hand_drawn then
      ex.cards_drawn = ex.cards_drawn + #context.hand_drawn
    end

    if context.end_of_round and context.game_over == false and context.main_eval then
      local item_count = math.floor(ex.cards_drawn / ex.draw_req)
      ex.cards_drawn = 0

      if item_count > 0 then
        card:juice_up()
        for _ = 1, item_count do
          pokermon.create_consumeable({ set = 'poke_item' })
        end
      end
    end
  end,
}

return {
  config_key = "bombirdier",
  list = { bombirdier }
}
