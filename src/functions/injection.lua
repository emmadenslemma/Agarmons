function AG.append_to_family(existing_name, new_name, to_end)
  for _, family in ipairs(pokermon.family) do
    for i, member in ipairs(family) do
      if (type(member) == 'table' and member.key == existing_name) or member == existing_name then
        table.insert(family, to_end and #family + 1 or i + 1, new_name)
        return
      end
    end
  end
  -- if no family is found:
  pokermon.add_family({ existing_name, new_name })
end

---@deprecated
function AG.add_megas_to_center(center_key, new_mega)
  local center = SMODS.Joker.obj_table[center_key]
  center.megas = center.megas or {}
  table.insert(center.megas, new_mega)
  AG.hookafterfunc(center, 'loc_vars', function(self, info_queue, _center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'mega_poke' }
    end
  end, true)
end
