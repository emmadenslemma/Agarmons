-- Rayquaza 384
local rayquaza = {
  name = "rayquaza",
  config = { extra = { Xmult_multi = 1.5 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local hanged_man_name_text = localize { type = 'name_text', set = 'Tarot', key = 'c_hanged_man' }
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'holding', vars = { hanged_man_name_text } }
      info_queue[#info_queue+1] = G.P_CENTERS.c_hanged_man
    end
    return { vars = { hanged_man_name_text, card.ability.extra.Xmult_multi } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dragon",
  gen = 3,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round then
      if context.other_card.debuff then
        return {
          message = localize('k_debuffed'),
          colour = G.C.RED
        }
      else
        return {
          Xmult = card.ability.extra.Xmult_multi
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      local hanged_man = SMODS.add_card { key = 'c_hanged_man', edition = 'e_negative' }
      SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot }, hanged_man)
    end
  end,
  -- megas = { "mega_rayquaza" },
}

-- Mega Rayquaza 384-1
local mega_rayquaza = {
  name = "mega_rayquaza",
  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = "poke_mega",
  cost = 30,
  stage = "Mega",
  ptype = "Dragon",
  gen = 3,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

local init = function()
  AG.hookafterfunc(SMODS.current_mod, 'set_debuff', function(card)
    return card.playing_card
        and card.config.center ~= G.P_CENTERS.c_base
        and next(SMODS.find_card('j_agar_rayquaza'))
  end)
end

return {
  config_key = "rayquaza",
  init = init,
  list = { rayquaza, --[[mega_rayquaza]] }
}
