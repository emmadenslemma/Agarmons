AG.gmax = {
  scale = 1.15,
  -- stops Snorlax from spawning leftovers and machamp from giving extra hands
  evolving = false,
  -- key is pre-gmax object key, value is post-gmax object key
  evos = {}
}

-- Add "Can Dynamax" tooltip to existing Pokemon
local type_tooltip_ref = type_tooltip
type_tooltip = function(self, info_queue, center)
  type_tooltip_ref(self, info_queue, center)
  if agarmons_config.gmax and pokermon_config.detailed_tooltips and AG.gmax.get_gmax_key(center) then
    info_queue[#info_queue + 1] = { set = 'Other', key = 'gmax_poke' }
  end
end

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
  G.E_MANAGER:add_event(Event({
    func = function()
      local center = G.P_CENTERS[key]
      local orig_method = center[method_name]
      center[method_name] = function(...)
        if not AG.gmax.evolving then orig_method(...) end
      end
      return true
    end
  }))
end

AG.gmax.get_gmax_key = function(base_card)
  return base_card
      and base_card.config
      and base_card.config.center
      and AG.gmax.evos[base_card.config.center.key]
      or nil
end

AG.gmax.get_base_key = function(gmax_card)
  if gmax_card and gmax_card.config then
    for base, gmax in pairs(AG.gmax.evos) do
      if gmax == gmax_card.config.center.key then
        return base
      end
    end
  end
  return nil
end

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
  if G.GAME.round_resets.ante == G.GAME.win_ante and G.GAME.blind.boss then
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
  if context.end_of_round and not context.individual and not context.repetition then
    AG.gmax.devolve(card)
  end
  if context.after and context.cardarea == G.jokers then
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
  table.insert(loc_table.vars, 2, localize(center.ability.extra.turns_left == 1 and "agar_turns_left_singular" or "agar_turns_left_plural"))

  return loc_table
end

SMODS.DrawStep {
  key = 'gmax_clouds',
  order = 71,
  func = function(self)
    if poke_is_in_collection(self) then return end
    if not G.shared_gmax_clouds then
      G.shared_gmax_clouds = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["agar_gmax_clouds"])
    end
    if self.ability and self.ability.extra and type(self.ability.extra) == 'table'
        and self.ability.extra.turns_left then
      local y_offset = G.CARD_H / 4
      G.shared_gmax_clouds:draw_shader('dissolve', nil, nil, true, self.children.center, nil, 0, nil, -y_offset)
    end
  end,
  conditions = { vortex = false, facing = 'front' }
}
