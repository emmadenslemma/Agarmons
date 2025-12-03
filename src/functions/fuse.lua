local function do_fuse(card, with, fuse_into)
  G.E_MANAGER:add_event(Event({
    func = function()
      local form = with.ability.extra.form or card.ability.extra.form
      poke_evolve(with, fuse_into, true)
      card:remove()
      if form then
        with.ability.extra.form = form
        with.config.center:set_ability(with)
      end
      return true
    end
  }))
end

local function get_adjacent_jokers(card, dir)
  local adjacent = {}
  if dir ~= 'right' and card.rank > 1 then
    table.insert(adjacent, G.jokers.cards[card.rank - 1])
  end
  if dir ~= 'left' and card.rank < #G.jokers.cards then
    table.insert(adjacent, G.jokers.cards[card.rank + 1])
  end
  return adjacent
end

local function get_fuses(card)
  local fuses = card.config.center.fuses
  if fuses and fuses.with then return { fuses } end
  return fuses
end

AG.hookafterfunc(Card, 'stop_drag', function(self)
  -- Try fuse
  local fuses = get_fuses(self)
  if fuses then
    for _, fuse in ipairs(fuses) do
      local target
      for _, card in ipairs(get_adjacent_jokers(self, fuse.direction)) do
        if card.config.center.key == fuse.with then target = card end
      end
      if target then
        do_fuse(self, target, fuse.into)
      end
    end
  end
end)
