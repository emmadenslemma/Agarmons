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
