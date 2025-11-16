function AG.append_to_family(existing_name, new_name)
  for _, family in ipairs(pokermon.family) do
    for i, member in ipairs(family) do
      if (type(member) == 'table' and member.key == existing_name) or member == existing_name then
        table.insert(family, i + 1, new_name)
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
      return true
    end
  }))
end

-- local type_tooltip_ref = type_tooltip
-- type_tooltip = function(self, info_queue, center)
--   type_tooltip_ref(self, info_queue, center)
--   if agarmons_config.new_megas and pokermon_config.detailed_tooltips
--       and center.config and center.config.center and family_utils.get_injection_payload(center.config.center.key) then
--     info_queue[#info_queue + 1] = { set = 'Other', key = 'mega_poke' }
--   end
-- end
