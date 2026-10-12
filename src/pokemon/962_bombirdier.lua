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
  calculate = function(self, card, context)
    local ex = card.ability.extra

    if context.hand_drawn and not context.blueprint then
      ex.cards_drawn = ex.cards_drawn + #context.hand_drawn
    end

    if context.end_of_round and context.game_over == false and context.main_eval then
      local item_count = math.floor(ex.cards_drawn / ex.draw_req)
      if item_count > 0 then
        for _ = 1, item_count do
          if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            SMODS.add_card({ set = 'poke_item' })
            AG.defer(function()
              G.GAME.consumeable_buffer = 0
            end)
          end
        end

        if not context.blueprint then
          AG.defer(function()
            ex.cards_drawn = 0
          end)
        end

        return {
          message = localize('poke_plus_pokeitem'),
          colour = G.C.SECONDARY_SET.poke_item
        }
      end
    end
  end,
}

return {
  config_key = "bombirdier",
  list = { bombirdier }
}
