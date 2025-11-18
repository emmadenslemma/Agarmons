function AG.append_to_family(existing_name, new_name, to_end)
  for _, family in ipairs(pokermon.family) do
    for i, member in ipairs(family) do
      if (type(member) == 'table' and member.key == existing_name) or member == existing_name then
        table.insert(family, to_end and #family + 1 or i + 1, new_name)
        return
      end
    end
  end
end

function AG.add_megas_to_center(center_key, new_mega)
  G.E_MANAGER:add_event(Event({
    func = function()
      local center = G.P_CENTERS[center_key]
      center.megas = center.megas or {}
      table.insert(center.megas, new_mega)
      local loc_vars_ref = center.loc_vars
      center.loc_vars = function(self, info_queue, center)
        local ret
        if loc_vars_ref then
          ret = loc_vars_ref(self, info_queue, center)
        end
        info_queue[#info_queue + 1] = { set = 'Other', key = 'mega_poke' }
        return ret
      end
      return true
    end
  }))
end
