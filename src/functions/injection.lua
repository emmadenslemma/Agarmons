---@deprecated use `poke_add_to_family` instead
function AG.append_to_family(existing_name, new_name, to_end)
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
