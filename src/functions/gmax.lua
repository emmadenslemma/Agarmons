AG.gmax = {
  scale = 1.2,
  default_duration = 3,
  -- stops Snorlax from spawning leftovers and machamp from giving extra hands
  evolving = false,
}

-- Add "Can Dynamax" tooltip to existing Pokemon
AG.hookafterfunc(pokermon, 'type_tooltip', function(self, info_queue, center)
  if agarmons_config.gmax and pokermon_config.detailed_tooltips and AG.gmax.get_gmax_key(center) then
    info_queue[#info_queue+1] = { set = 'Other', key = 'gmax_poke' }
  end
end, true)

AG.hookbeforefunc(SMODS.Center, 'inject', function(self)
  if self.rarity == 'agar_gmax' then
    self.display_size = { w = 71 * AG.gmax.scale, h = 95 * AG.gmax.scale }
  end
end)

function AG.gmax.localize_turns_left_desc(card)
  local turns_left = card.ability.gmax_turns_left
  local loc_turns = localize('gmax_turns' .. (turns_left == 1 and '' or '_plural'))
  local nodes = {}
  localize({
    type = 'descriptions',
    set = 'Other',
    key = 'gmax_turns_left_desc',
    vars = { turns_left, loc_turns },
    nodes = nodes
  })
  return nodes
end

function AG.gmax.evolve(card)
  AG.gmax.evolving = true
  pokermon.evolve(card, AG.gmax.get_gmax_key(card), false, localize("agar_dynamax_ex"))
  -- Events to reset `evolving` after the evolution animation
  AG.defer(function()
    AG.defer(function()
      AG.gmax.evolving = false
    end)
  end)
end

function AG.gmax.devolve(card)
  AG.gmax.evolving = true
  pokermon.evolve(card, AG.gmax.get_base_key(card), true)
  AG.gmax.evolving = false
end

function AG.gmax.end_turn(card)
  local new_turns_left = card.ability.gmax_turns_left - 1

  card.ability.gmax_turns_left = new_turns_left

  if new_turns_left > 0 then
    SMODS.calculate_effect({
      message = localize { type = "variable", key = 'gmax_a_turns_left' .. (new_turns_left == 1 and '' or '_plural') .. '_ex', vars = { new_turns_left } },
      colour = G.C.agar_gmax,
    }, card)
  else
    -- Event to make it devolve after scoring visuals are over
    AG.defer(function()
      AG.gmax.devolve(card)
    end)
  end
end

AG.hookafterfunc(SMODS.current_mod, 'calculate', function(self, context)
  if context.round_eval then
    for _, joker in ipairs(G.jokers.cards) do
      if joker:is_rarity('agar_gmax') then AG.gmax.devolve(joker) end
    end
  end
  if context.after then
    for _, joker in ipairs(G.jokers.cards) do
      if joker:is_rarity('agar_gmax') then AG.gmax.end_turn(joker) end
    end
  end
end)

AG.gmax.disable_method_during_evolve = function(key, method_name)
  local center = SMODS.Joker.obj_table[key]
  AG.hookbeforefunc(center, method_name, function()
    return AG.gmax.evolving
  end)
end

AG.gmax.get_gmax_key = function(base_card)
  if base_card and base_card.config and base_card.config.center and base_card.config.center.gmax then
    local gmax_name = base_card.config.center.gmax
    local prefix = base_card.config.center.poke_custom_prefix or "poke"
    return "j_" .. prefix .. "_" .. gmax_name
  end
end

AG.gmax.get_base_key = function(gmax_card)
  if gmax_card and gmax_card.config and gmax_card.config.center then
    local base_name = AG.gmax.get_previous_from_gmax(gmax_card)
    local prefix = gmax_card.config.center.poke_custom_prefix or "poke"
    return "j_" .. prefix .. "_" .. base_name
  end
  return nil
end

function AG.gmax.get_previous_from_gmax(card)
  local name = card.ability.name
  local prev = string.sub(name, 6)
  local prefix = card.config.center.poke_custom_prefix or "poke"
  return G.P_CENTERS["j_" .. prefix .. "_" .. prev] and prev or nil
end

AG.hookbeforefunc(pokermon, 'get_previous_evo_from_center', function(center, full_key)
  if center.stage == 'Gigantamax' then
    local prev = center.name:gsub('^gmax_', '')
    local prefix = center.poke_custom_prefix or "poke"
    return full_key and ('j_' .. prefix .. '_' .. prev) or prev
  end
end)

-- SMODS.DrawStep {
--   key = 'gmax_clouds',
--   order = 71,
--   func = function(self)
--     if pokermon.is_in_collection(self) then return end
--     if not G.shared_gmax_clouds then
--       G.shared_gmax_clouds = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["agar_gmax_clouds"])
--     end
--     if self.ability.gmax_turns_left then
--       local y_offset = G.CARD_H / 4
--       G.shared_gmax_clouds:draw_shader('dissolve', nil, nil, true, self.children.center, nil, 0, nil, -y_offset)
--     end
--   end,
--   conditions = { vortex = false, facing = 'front' }
-- }
