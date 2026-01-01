AG.gmax = {
  scale = 1.,
  -- stops Snorlax from spawning leftovers and machamp from giving extra hands
  evolving = false,
}

-- Add "Can Dynamax" tooltip to existing Pokemon
AG.hookafterfunc(_G, 'type_tooltip', function(self, info_queue, center)
  if agarmons_config.gmax and pokermon_config.detailed_tooltips and AG.gmax.get_gmax_key(center) then
    info_queue[#info_queue+1] = { set = 'Other', key = 'gmax_poke' }
  end
end, true)

AG.gmax.preload = function(item)
  -- *Make it bigger*
  item.display_size = { w = 71 * AG.gmax.scale, h = 95 * AG.gmax.scale }
  -- Add `turns_left` to extra
  item.config = item.config or {}
  item.config.extra = item.config.extra or {}
  item.config.extra.turns_left = 3
  -- Add "x turns left" to loc_txt.text
  if item.loc_txt and item.loc_txt.text then -- we still have to manually define it if we use localization files
    table.insert(item.loc_txt.text, 1, "{C:agar_gmax,s:1.1}#1#{s:1.1} #2#")
    table.insert(item.loc_txt.text, 2, "{br:2.5}ERROR - CONTACT STEAK")
  end
  -- Add `revert` to the end of `calculate`
  if item.calculate then
    local calculate_ref = item.calculate
    item.calculate = function(self, card, context)
      local ret, no_eff = calculate_ref(self, card, context)
      AG.gmax.revert(self, card, context)
      return ret, no_eff
    end
  else
    item.calculate = AG.gmax.revert
  end
  -- Add  `loc_vars` to.. loc_vars
  if item.loc_vars then
    local loc_vars_ref = item.loc_vars
    item.loc_vars = function(self, info_queue, center)
      local loc_table = loc_vars_ref(self, info_queue, center)
      return AG.gmax.loc_vars(self, info_queue, center, loc_table)
    end
  else
    item.loc_vars = AG.gmax.loc_vars
  end
end

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

AG.hookbeforefunc(_G, 'get_previous_evo', function(card, full_key)
  local name = card.name or card.ability.name
  if string.sub(name, 6) == "gmax_" then
    return AG.gmax.get_previous_from_gmax(card)
  end
end)

AG.gmax.evolve = function(card)
  AG.gmax.evolving = true
  poke_evolve(card, AG.gmax.get_gmax_key(card), false, localize("agar_dynamax_ex"))
  -- Events to reset `evolving` after the evolution animation
  G.E_MANAGER:add_event(Event({
    func = function()
      G.E_MANAGER:add_event(Event({
        func = function()
          AG.gmax.evolving = false
          return true
        end
      }))
      return true
    end
  }))
end

AG.gmax.devolve = function(card)
  -- Events to devolve after stake stickers get applied
  -- Don't think about it.
  -- Evolving with the animation does the same thing, so this will be fixed when I add an animation to Dynamaxing
  ---- Crashing with Zoroark copying a G-Max form, temporarily disabled
  if false and G.GAME.round_resets.ante == G.GAME.win_ante and G.GAME.blind.boss then
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = delay and 2.0 or 0,
      func = function()
        G.E_MANAGER:add_event(Event({
          func = function()
            AG.gmax.evolving = true
            poke_evolve(card, AG.gmax.get_base_key(card), true)
            AG.gmax.evolving = false
            return true
          end
        }))
        return true
      end
    }))
  else
    AG.gmax.evolving = true
    poke_evolve(card, AG.gmax.get_base_key(card), true)
    AG.gmax.evolving = false
  end
end

AG.gmax.revert = function(self, card, context)
  if context.round_eval and not context.blueprint then
    AG.gmax.devolve(card)
  end
  if context.after and context.cardarea == G.jokers and not context.blueprint then
    card.ability.extra.turns_left = card.ability.extra.turns_left - 1
    if card.ability.extra.turns_left > 0 then
      card_eval_status_text(card, "extra", nil, nil, nil, {
        message = localize { type = "variable", key = card.ability.extra.turns_left == 1 and "agar_x_turns_left_singular_ex" or "agar_x_turns_left_plural_ex", vars = { card.ability.extra.turns_left } },
        colour = G.C.agar_gmax,
      })
    else
      -- Event to make it devolve after scoring visuals are over
      G.E_MANAGER:add_event(Event({
        func = function()
          AG.gmax.devolve(card)
          return true
        end
      }))
    end
  end
end

AG.gmax.loc_vars = function(self, info_queue, center, loc_table)
  loc_table = loc_table or {}
  loc_table.vars = loc_table.vars or {}

  table.insert(loc_table.vars, 1, center.ability.extra.turns_left)
  table.insert(loc_table.vars, 2,
    localize(center.ability.extra.turns_left == 1
      and "agar_turns_left_singular"
      or "agar_turns_left_plural"))

  return loc_table
end

-- SMODS.DrawStep {
--   key = 'gmax_clouds',
--   order = 71,
--   func = function(self)
--     if poke_is_in_collection(self) then return end
--     if not G.shared_gmax_clouds then
--       G.shared_gmax_clouds = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["agar_gmax_clouds"])
--     end
--     if self.ability and self.ability.extra and type(self.ability.extra) == 'table'
--         and self.ability.extra.turns_left then
--       local y_offset = G.CARD_H / 4
--       G.shared_gmax_clouds:draw_shader('dissolve', nil, nil, true, self.children.center, nil, 0, nil, -y_offset)
--     end
--   end,
--   conditions = { vortex = false, facing = 'front' }
-- }
