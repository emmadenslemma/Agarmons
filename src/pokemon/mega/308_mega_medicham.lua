local function count_empty_slots()
  if not G.consumeables then return 2 end
  return G.consumeables.config.card_limits.total_slots - G.consumeables.config.card_count
end

-- Mega Medicham 308-1
local mega_medicham = {
  name = "mega_medicham",
  agar_inject_prefix = "poke",
  config = { extra = { consumable_slots = 1, Xmult_mod = 2.5 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local current_Xmult = self:get_current_Xmult(card)
    return { vars = { card.ability.extra.consumable_slots, card.ability.extra.Xmult_mod, current_Xmult } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fighting",
  gen = 3,
  blueprint_compat = true,
  get_current_Xmult = function(self, card)
    return count_empty_slots() * card.ability.extra.Xmult_mod
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      local current_Xmult = self:get_current_Xmult(card)
      if current_Xmult > 1 then
        return {
          xmult = current_Xmult
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.consumeables:change_size(card.ability.extra.consumable_slots)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.consumeables:change_size(-card.ability.extra.consumable_slots)
  end,
}

local function init()
  pokermon.add_family { "medicham", "mega_medicham" }
  SMODS.Joker:take_ownership("poke_medicham", { megas = { "mega_medicham" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_medicham }
}
