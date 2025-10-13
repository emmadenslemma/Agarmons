local effects = {}

function effects.apply_scry_hand_effects()
  return SMODS.find_card('j_agar_uxie', false)[1]
      or SMODS.find_card('j_agar_mesprit', false)[1]
      or SMODS.find_card('j_agar_azelf', false)[1]
      or SMODS.find_card('j_agar_lunala', false)[1].ability.extra.full_active
end

return {
  key = "EFFECTS",
  value = effects
}
