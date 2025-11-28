AG = {}

agarmons_config = SMODS.current_mod.config

SMODS.current_mod.optional_features = {
  retrigger_joker = true,
  quantum_enhancements = true,
}

assert(SMODS.load_file("src/sprites.lua"))()
assert(SMODS.load_file("src/rarities.lua"))()

local load_directory, L = assert(SMODS.load_file("src/loader.lua"))()

load_directory("src/functions")
load_directory("src/pokemon", L.load_pokemon, { post_load = L.load_pokemon_family })
load_directory("src/consumables", function(a) SMODS.Consumable(a) end)
load_directory("src/boosters", function(a) SMODS.Booster(a) end)
load_directory("src/backs", function(a) SMODS.Back(a) end, { post_load = L.load_sleeves })
load_directory("src/challenges", function(a)
  a.button_colour = HEX("F792BC")
  SMODS.Challenge(a)
end)

assert(SMODS.load_file("src/settings.lua"))()

if (SMODS.Mods["JokerDisplay"] or {}).can_load then
  assert(SMODS.load_file("src/jokerdisplay.lua"))()
end
