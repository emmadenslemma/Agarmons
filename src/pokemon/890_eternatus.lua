local scale = AG.gmax.scale / 0.96

-- Eternatus 890
local eternatus = {
  name = "eternatus",
  display_size = { w = 71 * scale, h = 95 * scale },
  config = { extra = {} },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
  end,
  designer = "Eternalnacho",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dark",
  gen = 8,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced and not context.blueprint then
      for _, other_joker in ipairs(poke_get_adjacent_jokers(card)) do
        if not other_joker.getting_sliced and AG.gmax.get_gmax_key(other_joker) then
          AG.gmax.evolve(other_joker)
        end
      end
    end
  end,
  in_pool = function(self)
    return AG.target_utils.find_leftmost(AG.gmax.get_gmax_key) and pokemon_in_pool(self)
  end
}

-- eternamax_scale = scale * 1.12

-- Eternamax Eternatus 890-1
-- local eternamax_eternatus = {
--   name = "eternamax_eternatus",
--   display_size = { w = 71 * eternamax_scale, h = 95 * eternamax_scale },
--   config = { extra = {} },
--   loc_vars = function(self, info_queue, center)
--     type_tooltip(self, info_queue, center)
--   end,
--   rarity = "agar_eternamax",
--   cost = 30,
--   stage = "Eternamax",
--   ptype = "Dark",
--   gen = 8,
--   calculate = function(self, card, context)
--   end,
-- }

return {
  enabled = agarmons_config.gmax and agarmons_config.eternatus or false,
  list = { eternatus }
}
