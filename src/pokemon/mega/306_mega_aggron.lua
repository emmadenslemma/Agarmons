-- Mega Aggron 306-1
local mega_aggron = {
  name = "mega_aggron",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Metal",
  gen = 3,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "Xmult" },
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult,
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    AG.defer(function()
      for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        for _, joker in ipairs(area.cards) do
          joker:set_debuff()
        end
      end
    end)
  end
}

local function init()
  pokermon.add_family { "aggron", "mega_aggron" }
  SMODS.Joker:take_ownership("poke_aggron", { megas = { "mega_aggron" }, poke_custom_values_to_keep = { "Xmult" } }, true)

  AG.hookbeforefunc(SMODS.current_mod, 'set_debuff', function(card)
    if (card.ability.set == 'Joker'
          or card.ability.set == 'Enhanced'
          or card.ability.set == 'Default')
        and next(SMODS.find_card('j_poke_mega_aggron')) then
      return 'prevent_debuff'
    end
  end)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_aggron }
}
