local find_leftmost_or_highlighted = AGAR.TARGET_UTILS.find_leftmost_or_highlighted

local plate = function(ptype, sprite_pos)
  local key = ptype:lower() .. 'plate'
  return {
    name = key,
    key = key,
    set = "Item",
    pos = sprite_pos,
    atlas = "AgarmonsConsumables",
    cost = 3,
    hidden = true,
    can_use = function(self, card)
      return find_leftmost_or_highlighted('j_agar_arceus')
    end,
    use = function(self, card, area, copier)
      local arceus = find_leftmost_or_highlighted('j_agar_arceus')
      arceus.ptype = ptype
      arceus:juice_up()
    end,
    in_pool = function(self)
      return SMODS.find_card('j_agar_arceus')[1]
    end
  }
end

return {
  enabled = agarmons_config.arceus,
  list = {
    plate("Colorless", { x = 0, y = 3 }),
    plate("Grass", { x = 1, y = 3 }),
    plate("Fire", { x = 2, y = 3 }),
    plate("Water", { x = 3, y = 3 }),
    plate("Lightning", { x = 4, y = 3 }),
    plate("Psychic", { x = 5, y = 3 }),
    plate("Fighting", { x = 0, y = 4 }),
    plate("Dark", { x = 1, y = 4 }),
    plate("Metal", { x = 2, y = 4 }),
    plate("Fairy", { x = 3, y = 4 }),
    plate("Dragon", { x = 4, y = 4 }),
    plate("Earth", { x = 5, y = 4 }),
  }
}
