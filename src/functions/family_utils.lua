local my_custom_prefix = 'agar'
local poke_custom_prefix = 'poke'
local family_injection_keys = {}

local function key_str(prefix, name) return 'j_' .. prefix .. '_' .. (name or '') end

local family_utils = {
  append_key_to_family = function(new_key, existing_key)
    family_injection_keys[existing_key] = new_key
  end,
  get_injection_target = function(payload_key)
    for target, payload in pairs(family_injection_keys) do
      if payload == payload_key then return target end
    end
  end,
  get_injection_payload = function(existing_key)
    return family_injection_keys[existing_key]
  end,
  add_megas_to_center = function(center_key, new_mega)
    G.E_MANAGER:add_event(Event({
      func = function()
        local center = G.P_CENTERS[center_key]
        if not center.megas then center.megas = {} end
        table.insert(center.megas, new_mega)
        return true
      end
    }))
  end
}

local type_tooltip_ref = type_tooltip
type_tooltip = function(self, info_queue, center)
  type_tooltip_ref(self, info_queue, center)
  if agarmons_config.new_megas and pokermon_config.detailed_tooltips
      and center.config and center.config.center and family_utils.get_injection_payload(center.config.center.key) then
    info_queue[#info_queue + 1] = { set = 'Other', key = 'mega_poke' }
  end
end

local get_family_keys_ref = get_family_keys
get_family_keys = function(cardname, custom_prefix, card)
  if custom_prefix == my_custom_prefix then
    local custom_key = key_str(custom_prefix, cardname)
    local injection_target = family_utils.get_injection_target(custom_key)
    if injection_target then
      custom_prefix = poke_custom_prefix
      local _, prefix_end = string.find(injection_target, key_str(poke_custom_prefix))
      cardname = string.sub(injection_target, prefix_end + 1)
    end
  end
  local keys = get_family_keys_ref(cardname, custom_prefix, card)
  for i, key in ipairs(keys) do
    local injection_key = family_utils.get_injection_payload(key)
    if injection_key then
      table.insert(keys, i + 1, injection_key)
    end
  end
  return keys
end

local get_previous_from_mega_ref = get_previous_from_mega
get_previous_from_mega = function(name, prefix, full_key)
  if AGAR.FAMILY_UTILS.get_injection_target(key_str(my_custom_prefix, name)) then prefix = "poke" end
  return get_previous_from_mega_ref(name, prefix, full_key)
end

return {
  key = "FAMILY_UTILS",
  value = family_utils
}
