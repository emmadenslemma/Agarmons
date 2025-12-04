local function do_fuse(card, with, fuse_into)
  G.E_MANAGER:add_event(Event({
    func = function()
      if card.getting_sliced or with.getting_sliced then return end

      local form = with.ability.extra.form or card.ability.extra.form

      poke_evolve(with, fuse_into, true)
      card:remove()

      if form then
        with.ability.extra.form = form

        if type(with.config.center.set_ability) == 'function' then
          with.config.center:set_ability(with)
        end
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
  if card.area and card.area ~= G.jokers then return end
  local fuses = card.config.center.fuses
  if fuses and fuses.with then return { fuses } end
  return fuses
end

-- Decide when to draw the 'fuse' shader
AG.hookafterfunc(Card, 'drag', function(self)
  if self.ready_to_fuse then return end
  local fuses = get_fuses(self)
  if fuses then
    for _, fuse in ipairs(fuses) do
      for _, card in ipairs(get_adjacent_jokers(self, fuse.direction)) do
        if card.config.center.key == fuse.with then
          self.ready_to_fuse = true
          card.ready_to_fuse = true

          local cur_rank = self.rank

          G.E_MANAGER:add_event(Event({
            trigger = 'condition',
            blocking = false,
            func = function()
              if not self or not card then return true end

              if self.rank == cur_rank and self.states.drag.is then
                return false
              end

              self.ready_to_fuse = false
              card.ready_to_fuse = false
              return true
            end
          }))
        end
      end
    end
  end
end)

SMODS.DrawStep {
  key = 'ready_to_fuse',
  order = 45,
  func = function(self)
    if self.ready_to_fuse then
      self.children.center:draw_shader('agar_fuse')
    end
  end,
  conditions = { vortex = false, facing = 'front' },
}

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
