AG.effects = {}

function AG.effects.apply_scry_hand_effects()
  return SMODS.find_card('j_agar_uxie', false)[1]
      or SMODS.find_card('j_agar_mesprit', false)[1]
      or SMODS.find_card('j_agar_azelf', false)[1]
      or (SMODS.find_card('j_agar_lunala', false)[1] or { ability = { extra = {} } }).ability.extra.full_active
end

function AG.effects.apply_force_jumbo_packs()
  return next(SMODS.find_card('j_agar_drampa'))
end

function AG.effects.apply_force_mega_packs()
  return next(SMODS.find_card('j_agar_mega_drampa'))
end

local function try_upgrade_pack(center, from, to)
  local upgraded_key = center.key:gsub(from, to)
  return G.P_CENTERS[upgraded_key]
      or G.P_CENTERS[upgraded_key:gsub('_%d$', '_1')] -- default to the first variant
end

local get_pack_ref = get_pack
function get_pack(_key, _type)
  local center = get_pack_ref(_key, _type)
  if _key == 'shop_pack' then
    if AG.effects.apply_force_jumbo_packs() then
      center = try_upgrade_pack(center, "normal", "jumbo") or center
    end
    if AG.effects.apply_force_mega_packs() then
      center = try_upgrade_pack(center, "normal", "mega") or center
      center = try_upgrade_pack(center, "jumbo", "mega") or center
    end
  end
  return center
end
