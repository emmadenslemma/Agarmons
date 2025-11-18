AG.effects = {}

function AG.effects.apply_scry_hand_effects()
  return SMODS.find_card('j_agar_uxie', false)[1]
      or SMODS.find_card('j_agar_mesprit', false)[1]
      or SMODS.find_card('j_agar_azelf', false)[1]
      or (SMODS.find_card('j_agar_lunala', false)[1] or { ability = { extra = {} } }).ability.extra.full_active
end
