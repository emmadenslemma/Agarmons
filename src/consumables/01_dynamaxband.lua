-- Activate to """mega evolve""" to a Gmax pokemon for 3 ~~turns~~ hands
-- once per round use
-- Issues: Having to use it on the same mon repeatedly - have it auto-use on entering blind?
--   what happens if it's already Gmaxed? can we un-gmax at the end of blind? test if stake stickers still apply
local dynamaxband = {
  name = "dynamaxband",
  key = "dynamaxband",
  set = "Spectral",
  helditem = true,
  pos = { x = 0, y = 0 },
  loc_txt = {
    name = "Dynamax Band",
    text = {
      "{C:attention}Reusable{}",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}Dynamaxes{} a Pokemon",
      "Lasts for {C:attention}3{} Hands",
      "{C:inactive}(Useable once per round)",
    },
  },
  atlas = "AgarmonsConsumables",
  cost = 4,
  hidden = true,
  soul_set = "Item",
  soul_rate = .01,
  unlocked = true,
  discovered = true,
  use = function(self, card)
  end,
  can_use = function(self, card)
    return false
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return false
  end,
}

return {
  name = "Agarmons Dynamax Band",
  enabled = agarmons_config.gmax or false,
  list = { dynamaxband }
}
