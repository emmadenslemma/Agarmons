-- Yveltal 717
local yveltal = {
  name = "yveltal",
  config = { extra = { energy_limit_mod = 1, energy_mod = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = 'Other', key = 'energize' }
      info_queue[#info_queue + 1] = G.P_CENTERS.c_death
    end
    return { vars = { center.ability.extra.energy_limit_mod, center.ability.extra.energy_mod } }
  end,
  designer = "Eternalnacho",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dark",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if not context.blueprint then
      -- Stolen from Vanilla Remade Ceremonial Dagger
      if context.setting_blind and not card.getting_sliced then
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
                SMODS.add_card { key = 'c_death' }
                G.GAME.consumeable_buffer = 0
              end
              return true
            end
          }))
        end
      end
      -- Energize new Dark type Jokers
      if context.card_added and context.cardarea == G.jokers
          and not context.card.ability.consumeable
          and energy_matches(context.card, "Dark") then
        AG.energy.increase(context.card, card.ability.extra.energy_mod)
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    AG.energy.increase_limit(card.ability.extra.energy_limit_mod)
    AG.energy.increase_all("Dark", card.ability.extra.energy_mod)
    AG.energy.increase(card, "Dark", card.ability.extra.energy_mod, true)
  end,
  remove_from_deck = function(self, card, from_debuff)
    AG.energy.decrease_limit(card.ability.extra.energy_limit_mod)
    AG.energy.decrease_all("Dark", card.ability.extra.energy_mod)
  end,
}

local init = function()
  -- Energize/De-Energize when using Tera Orb in and out of Dark Aura
  local apply_type_sticker_orig = apply_type_sticker
  apply_type_sticker = function(card, ...)
    local yveltal_present = SMODS.find_card('j_agar_yveltal', true)
    if yveltal_present and energy_matches(card, "Dark") then
      AG.energy.decrease(card, "Dark")
    end
    apply_type_sticker_orig(card, ...)
    if yveltal_present and energy_matches(card, "Dark") then
      AG.energy.increase(card, "Dark")
    end
  end
  -- Fix to `remove` not calling the correct context
  remove = function(self, card, context, check_shiny, skip_joker_type_destroyed)
    if not skip_joker_type_destroyed then
      card.getting_sliced = true
      local flags = SMODS.calculate_context({ joker_type_destroyed = true, card = card })
      if flags.no_destroy then
        card.getting_sliced = nil
        return
      end
    end
    if check_shiny and card.edition and card.edition.poke_shiny then
      SMODS.change_booster_limit(-1)
    end
    play_sound('tarot1')
    card.T.r = -0.2
    card:juice_up(0.3, 0.4)
    card.states.drag.is = true
    card.children.center.pinch.x = true
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.3,
      blockable = false,
      func = function()
        G.jokers:remove_card(card)
        card:remove()
        card = nil
        return true
      end
    }))
    card.gone = true
    return true
  end
end

return {
  enabled = agarmons_config.yveltal or false,
  init = init,
  list = { yveltal }
}
