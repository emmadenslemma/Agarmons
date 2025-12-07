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
