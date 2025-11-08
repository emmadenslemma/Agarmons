AGAR = {}

agarmons_config = SMODS.current_mod.config

SMODS.current_mod.optional_features = {
  retrigger_joker = true,
  quantum_enhancements = true,
}

assert(SMODS.load_file("src/functions.lua"))()
assert(SMODS.load_file("src/artists.lua"))()
assert(SMODS.load_file("src/sprites.lua"))()
assert(SMODS.load_file("src/rarities.lua"))()
assert(SMODS.load_file("src/pokemon.lua"))()
assert(SMODS.load_file("src/consumables.lua"))()
assert(SMODS.load_file("src/challenges.lua"))()
assert(SMODS.load_file("src/settings.lua"))()

if (SMODS.Mods["JokerDisplay"] or {}).can_load then
  assert(SMODS.load_file("src/jokerdisplay.lua"))()
end
