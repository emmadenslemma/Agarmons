-- G-Max Copperajah 879
local init = function()
  SMODS.Joker:take_ownership("maelmc_copperajah", { gmax = "gmax_copperajah", megas = false }, true)
  SMODS.Joker:take_ownership("maelmc_gmax_copperajah", {
    rarity = "agar_gmax",
    stage = "Gigantamax",
  }, true)
end

return {
  can_load = not not next(SMODS.find_mod("PokermonMaelmc") and agarmons_config.gmax),
  init = init,
  list = {}
}
