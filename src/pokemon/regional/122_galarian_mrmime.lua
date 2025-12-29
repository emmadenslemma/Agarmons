-- Galarian Mr. Mime 122-1
local galarian_mrmime = {
  name = "galarian_mrmime",
  agar_inject_prefix = "poke",
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Water",
  gen = 8,
}

local init = function()
  AG.append_to_family("mrmime", "galarian_mrmime")
end

return {
  init = init,
  list = { galarian_mrmime }
}
