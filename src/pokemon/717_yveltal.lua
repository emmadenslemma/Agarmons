-- Yveltal 717
local yveltal = {
  name = "yveltal",
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'dark_aura' }
    end
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dark",
  gen = 6,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.pre_discard and not context.hook and #context.full_hand == 2 and G.GAME.current_round.discards_used == 0 then
      local left = context.full_hand[1]
      local right = context.full_hand[2]
      juice_flip_table(card, context.full_hand, false, 2)
      AG.defer(function()
        copy_card(right, left)
      end)
      juice_flip_table(card, context.full_hand, true, 2)
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
