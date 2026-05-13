function AG.hookbeforefunc(table, funcname, hook)
  if not table[funcname] then
    table[funcname] = hook
  else
    local orig = table[funcname]
    table[funcname] = function(...)
      return hook(...)
          or orig(...)
    end
  end
end

function AG.hookafterfunc(table, funcname, hook, always_run)
  if not table[funcname] then
    table[funcname] = hook
  else
    local orig = table[funcname]
    if always_run then
      table[funcname] = function(...)
        local ret = orig(...)
        local hook_ret = hook(...)
        return ret or hook_ret
      end
    else
      table[funcname] = function(...)
        return orig(...)
            or hook(...)
      end
    end
  end
end

function AG.hookaroundfunc(table, funcname, hook)
  if not table[funcname] then
    table[funcname] = function(...)
      return hook(function() end, ...)
    end
  else
    local orig = table[funcname]
    table[funcname] = function(...) return hook(orig, ...) end
  end
end

function AG.get_distance(card, other_card)
  local x1, x2 = card.T.x, other_card.T.x
  local y1, y2 = card.T.y, other_card.T.y
  return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function AG.active_tooltip(card, is_active, scale)
  scale = scale or 0.8
  if card.area and card.area == G.jokers then
    local colour = is_active
        and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
        or G.C.UI.TEXT_INACTIVE
    local text = is_active
        and ('  ' .. localize('k_active') .. '  ')
        or (' ' .. localize('agar_recharging') .. ' ')
    ---@format disable-next
    return {
      { n = G.UIT.C, config = { align = "bm", minh = 0.4 }, nodes = {
        { n = G.UIT.C, config = { ref_table = card, align = "m", colour = colour, r = 0.05, padding = 0.06 }, nodes = {
          { n = G.UIT.T, config = { text = text, colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * scale } },
        }}
      }}
    }
  end
end

-- Fallback for until base mod does something like this:
poke_total_mult = poke_total_mult or function(card)
  local total_mult = (card.ability.perma_mult or 0)
  if card.config.center ~= G.P_CENTERS.m_lucky then
    total_mult = total_mult + card.ability.mult
  end
  if card.edition then
    total_mult = total_mult + (card.edition.mult or 0)
  end
  return total_mult
end

function AG.defer(func)
  G.E_MANAGER:add_event(Event({
    func = function()
      func()
      return true
    end
  }))
end

-- Fallback for Lua 5.2 support
table.unpack = table.unpack or unpack

function AG.delay(time, func)
  G.E_MANAGER:add_event(Event({
    trigger = 'after',
    delay = time,
    func = function()
      func()
      return true
    end
  }))
end

function AG.legendary_orb(args)
  local defaults = {
    set = "Spectral",
    helditem = true,
    saveable = true,
    config = {},
    loc_vars = function(self, info_queue, card)
      if self:get_used_on(card) then
        return { key = self.key .. "_active" }
      end
    end,
    cost = 4,
    hidden = true,
    soul_set = "Item",
    soul_rate = .005,
    get_used_on = function(self, card)
      local used_on = poke_find_card(function(joker)
        return joker.unique_val == card.ability.extra.used_on
      end)
      if not used_on then card.ability.extra.used_on = nil end
      return used_on
    end,
    use = function(self, card)
      local used_on = self:get_used_on(card)

      if used_on then
        poke_evolve(used_on, self.agar_base_key)

        card.ability.extra.used_on = nil
        card.ability.extra.used_on__ID = nil
      else
        local target = poke_find_leftmost_or_highlighted(self.agar_base_key)

        poke_evolve(target, self.agar_form_key)

        card.ability.extra.used_on = target.unique_val
        card.ability.extra.used_on__ID = target.unique_val__saved_ID or target.ID
      end

      card.ability.extra.usable = false
    end,
    can_use = function(self, card)
      if not card.ability.extra.usable then return false end

      local used_on = self:get_used_on(card)
      if used_on then return #G.jokers.highlighted == 0 or G.jokers.highlighted[1] == used_on end

      return poke_find_leftmost_or_highlighted(self.agar_base_key)
    end,
    calculate = function(self, card, context)
      if context.end_of_round and context.game_over == false and context.main_eval and not card.ability.extra.usable then
        card.ability.extra.usable = true
        return {
          message = localize("k_reset")
        }
      end
    end,
    keep_on_use = function(self, card)
      return true
    end,
    in_pool = function(self)
      return next(SMODS.find_card(self.agar_base_key))
    end,
    remove_from_deck = function(self, card, from_debuff)
      local used_on = self:get_used_on(card)
      if used_on then
        poke_evolve(used_on, self.agar_base_key)
      end
    end,
    load = function(self, card, card_table, other_card)
      local ID = card_table.ability.extra.used_on__ID
      if ID and G.ID <= ID then
        G.ID = ID + 1
      end
    end
  }

  local template = SMODS.merge_defaults(args, defaults)

  local extra_defaults = {
    usable = true,
    used_on = nil,
    used_on__ID = nil,
  }

  template.config.extra = SMODS.merge_defaults(template.config.extra, extra_defaults)

  return template
end
