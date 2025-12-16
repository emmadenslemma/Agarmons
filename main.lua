AG = {}

agarmons_config = SMODS.current_mod.config

-- -- uncomment for hats on your pikachus:
-- agarmons_config.pikachus_with_hats = true
-- agarmons_config.pikachu_hat_rate = 100 -- how often pikachu gets a hat, in percentages

SMODS.current_mod.optional_features = {
  retrigger_joker = true,
  quantum_enhancements = true,
}

assert(SMODS.load_file("src/sprites.lua"))()
assert(SMODS.load_file("src/rarities.lua"))()

local load_directory, l = assert(SMODS.load_file("src/loader.lua"))()

load_directory("src/functions")
load_directory("src/pokemon", l.load_pokemon, { post_load = l.load_pokemon_family })
load_directory("src/consumables", function(a) SMODS.Consumable(a) end)
load_directory("src/boosters", function(a) SMODS.Booster(a) end)
load_directory("src/backs", function(a) SMODS.Back(a) end, { post_load = l.load_sleeves })
load_directory("src/challenges", function(a)
  a.button_colour = HEX("F792BC")
  SMODS.Challenge(a)
end)

assert(SMODS.load_file("src/settings.lua"))()

if (SMODS.Mods["JokerDisplay"] or {}).can_load then
  assert(SMODS.load_file("src/jokerdisplay.lua"))()
end

AG.hookbeforefunc(SMODS.current_mod, 'reset_game_globals', function(run_start)
  if run_start then
    for _, center in pairs(G.P_CENTERS) do
      if center.agar_config_key and not agarmons_config[center.agar_config_key] then
        G.GAME.banned_keys[center.key] = true
      end
    end
  end
end)
