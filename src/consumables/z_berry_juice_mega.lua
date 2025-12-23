local berry_juice_mega = {
  name = "berry_juice_mega",
  key = "poke_berry_juice_mega",
  prefix_config = { key = { mod = false } },
  set = "Item",
  pos = { x = 4, y = 0 },
  loc_txt = {
    name = "Mega Berry Juice",
    text = {
      "{C:attention}Mega Evolves{} leftmost",
      "or selected Joker",
    },
  },
  berry_juice = true,
  poke_multi_item = true,
  atlas = "AgarmonsConsumables",
  cost = 12,
  discovered = true,
  no_collection = true,
  use = function(self, card)
    local target = poke_find_leftmost_or_highlighted(function(joker)
      return get_mega(joker) and not joker.debuff
    end)
    local prefix = target.config.center.poke_custom_prefix or "poke"
    local forced_key = "j_" .. prefix .. "_" .. get_mega(target)
    poke_evolve(target, forced_key)
  end,
  can_use = function(self, card)
    return G.jokers -- Are these null checks necessary?
        and G.jokers.cards
        and #G.jokers.cards > 0
        and poke_find_leftmost_or_highlighted(function(joker)
          return get_mega(joker) and not joker.debuff
        end)
  end,
  in_pool = function(self)
    return false
  end
}

local init = function()
  AG.append_to_family('berry_juice_energy', 'berry_juice_mega')
  table.insert(extended_family['shuckle'], -2, { item = true, name = 'berry_juice_mega' })
end

return {
  init = init,
  list = { berry_juice_mega }
}
