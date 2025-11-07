local my_custom_prefix = 'agar'
local poke_custom_prefix = 'poke'
local family_injection_keys = {}
local invalid_family_keys = {}

local function key_str(prefix, name) return 'j_' .. prefix .. '_' .. (name or '') end

local function append_to_family(existing_name, new_name, target_prefix)
  for _, family in ipairs(pokermon.family) do
    local found_pos
    for i, member in ipairs(family) do
      if (type(member) == 'table' and member.key == existing_name) or member == existing_name then
        found_pos = i
      end
    end
    if found_pos then
      table.insert(family, found_pos + 1, new_name)
    end
  end
  local new_key = key_str(my_custom_prefix, new_name)
  local existing_key = key_str(target_prefix, existing_name)
  family_injection_keys[existing_key] = new_key
  invalid_family_keys[#invalid_family_keys+1] = key_str(target_prefix, new_name)
end

local function add_megas_to_center(center_key, new_mega)
  G.E_MANAGER:add_event(Event({
    func = function()
      local center = G.P_CENTERS[center_key]
      if not center.megas then center.megas = {} end
      table.insert(center.megas, new_mega)
      return true
    end
  }))
end

local family_utils = {
  get_injection_target = function(payload_key)
    for target, payload in pairs(family_injection_keys) do
      if payload == payload_key then return target end
    end
  end,
  get_injection_payload = function(existing_key)
    return family_injection_keys[existing_key]
  end,
  init_mega = function(name_or_template, target_prefix)
    if not target_prefix then target_prefix = poke_custom_prefix end
    local name = type(name_or_template) == 'table' and name_or_template.name or name_or_template
    local pre_evo_name = string.sub(name, 6)
    local pre_evo_key = key_str(target_prefix, pre_evo_name)

    append_to_family(pre_evo_name, name, target_prefix)
    add_megas_to_center(pre_evo_key, name)
  end,
  init_gmax = function(name_or_template, target_prefix)
    if not target_prefix then target_prefix = poke_custom_prefix end
    local name = type(name_or_template) == 'table' and name_or_template.name or name_or_template
    local pre_evo_name = string.sub(name, 6)

    append_to_family(pre_evo_name, name, target_prefix)
  end,
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
      local _, prefix_end = string.find(injection_target, "j_[a-z]+_")
      custom_prefix = string.sub(injection_target, 3, prefix_end - 1)
      cardname = string.sub(injection_target, prefix_end + 1)
    end
  end
  local keys = get_family_keys_ref(cardname, custom_prefix, card)
  local valid_keys = {}
  for i, key in ipairs(keys) do
    if not AGAR.LIST_UTILS.elem(invalid_family_keys, key) then
      valid_keys[#valid_keys + 1] = key
      local injection_key = family_utils.get_injection_payload(key)
      if injection_key then
        table.insert(keys, i + 1, injection_key)
      end
    end
  end
  return valid_keys
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
