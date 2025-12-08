local fuse_delay = 0.35
local fuse_timer
local fuse_dist = G.CARD_H -- it just lines up what can I say

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
  if dir ~= 'left' and card.rank < #G.jokers.cards then
    table.insert(adjacent, G.jokers.cards[card.rank + 1])
  end
  if dir ~= 'right' and card.rank > 1 then
    table.insert(adjacent, G.jokers.cards[card.rank - 1])
  end
  return adjacent
end

local function get_fuses(card)
  if card.area and card.area ~= G.jokers then return end
  local fuses = card.config.center.fuses
  if fuses and fuses.with then return { fuses } end
  return fuses
end

local function get_valid_fuse_target(card)
  local fuses = get_fuses(card)
  if fuses then
    for _, fuse in ipairs(fuses) do
      for _, other_card in ipairs(get_adjacent_jokers(card, fuse.direction)) do
        if other_card.config.center.key == fuse.with
            and AG.get_distance(card, other_card) < fuse_dist then
          return {
            card = other_card,
            fuse = fuse,
          }
        end
      end
    end
  end
end

local function can_fuse(card)
  return fuse_timer
      and love.timer.getTime() - fuse_timer >= fuse_delay
      and get_valid_fuse_target(card)
end

local function try_fuse(card)
  local target = get_valid_fuse_target(card)
  if target then
    local other_card = target.card
    local fuse = target.fuse

    if fuse.evo_this then
      do_fuse(other_card, card, fuse.into)
    else
      do_fuse(card, other_card, fuse.into)
    end
  end
end

AG.hookbeforefunc(Card, 'drag', function(self)
  if get_fuses(self) and not fuse_timer then
    fuse_timer = love.timer.getTime()
  end
end)

AG.hookafterfunc(Card, 'stop_drag', function(self)
  if fuse_timer then
    if can_fuse(self) then
      try_fuse(self)
    end
    fuse_timer = nil
  end
end)

-- Decide when to draw the 'fuse' shader
AG.hookafterfunc(Card, 'drag', function(self)
  if self.ready_to_fuse or not can_fuse(self) then return end
  local target = get_valid_fuse_target(self)
  if target then
    local card = target.card
    self.ready_to_fuse = true
    card.ready_to_fuse = true

    local stay_juiced = true
    juice_card_until(self, function() return stay_juiced end, true)
    juice_card_until(card, function() return stay_juiced end, true, 0.3)

    G.E_MANAGER:add_event(Event({
      trigger = 'condition',
      blocking = false,
      func = function()
        if not self or not card then return true end

        if self.states.drag.is and (get_valid_fuse_target(self) or {}).card == card and can_fuse(self) then
          return false
        end

        self.ready_to_fuse = false
        card.ready_to_fuse = false
        stay_juiced = false
        return true
      end
    }))

    return
  end
end)

-- SMODS.DrawStep {
--   key = 'ready_to_fuse',
--   order = 45,
--   func = function(self)
--     if self.ready_to_fuse then
--       self.children.center:draw_shader('agar_fuse')
--     end
--   end,
--   conditions = { vortex = false, facing = 'front' },
-- }
