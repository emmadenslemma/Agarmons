-- Yveltal 717
local yveltal = {
  name = "yveltal",
  config = { extra = { energy_limit_mod = 1, energy_mod = 1, Xmult = 1.5 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'energize' }
      info_queue[#info_queue+1] = G.P_CENTERS.c_death
    end
    return { vars = { card.ability.extra.energy_limit_mod, card.ability.extra.energy_mod, card.ability.extra.Xmult } }
  end,
  designer = "Eternalnacho",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dark",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    -- Stolen from Vanilla Remade Ceremonial Dagger
    if context.setting_blind and not context.blueprint and not card.getting_sliced then
      local my_pos = nil
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then
          my_pos = i
          break
        end
      end
      if my_pos and G.jokers.cards[my_pos + 1] and not SMODS.is_eternal(G.jokers.cards[my_pos + 1], card) and not G.jokers.cards[my_pos + 1].getting_sliced then
        local sliced_card = G.jokers.cards[my_pos + 1]
        sliced_card.getting_sliced = true
        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
        G.E_MANAGER:add_event(Event({
          func = function()
            G.GAME.joker_buffer = 0
            card:juice_up(0.8, 0.8)
            sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
            play_sound('slice1', 0.96 + math.random() * 0.08)
            return true
          end
        }))
        -- Summon Death
        -- From Vanilla Remade 8 Ball
        G.E_MANAGER:add_event(Event({
          func = function()
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
              G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
              SMODS.add_card { set = 'Tarot', key = 'c_death' }
              G.GAME.consumeable_buffer = 0
            end
            return true
          end
        }))
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    AG.effects.activate_type_aura("Dark")
  end,
  remove_from_deck = function(self, card, from_debuff)
    AG.effects.deactivate_type_aura("Dark")
  end,
}

return {
  config_key = "yveltal",
  list = { yveltal }
}
