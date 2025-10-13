local DisplayCard = Moveable:extend()

DisplayCard.set_card_area = Card.set_card_area
DisplayCard.set_sprites = Card.set_sprites
DisplayCard.hard_set_T = Card.hard_set_T
DisplayCard.move = Card.move
DisplayCard.release = Card.release
DisplayCard.align = Card.align
DisplayCard.align_h_popup = Card.align_h_popup
DisplayCard.update = Card.update
DisplayCard.juice_up = Card.juice_up

-- Necessary for drawing
DisplayCard.draw = Card.draw
DisplayCard.should_draw_shadow = Card.should_draw_shadow
DisplayCard.should_draw_base_shader = Card.should_draw_base_shader

-- Necessary for displaying the tooltip
DisplayCard.hover = Card.hover
DisplayCard.stop_hover = Card.stop_hover
function DisplayCard:generate_UIBox_ability_table()
  local template = self.config.center
  local loc_vars = nil
  if type(template.loc_vars) == 'function' then
    -- This really should be `self` in the third variable, but that requires me to open up `:set_ability`
    loc_vars = (template.loc_vars(template, {}, template) or {}).vars
  end
  return generate_card_ui(template, nil, loc_vars, nil, {}, false, nil, nil, self)
end

-- Necessary for not crashing
function DisplayCard:update_alert() end
function DisplayCard:highlight() end

function DisplayCard:init(X, Y, W, H, card, center, params)
  -- These really should go in a loading function for the shells
  center.set = 'Joker'
  center.key = 'j_agar_' .. center.name
  center.ability = center.config

  self.params = (type(params) == 'table') and params or {}

  Moveable.init(self, X, Y, W, H)

  self.CT = self.VT
  self.config = {
    card = card or {},
    center = center
  }
  self.tilt_var = { mx = 0, my = 0, dx = 0, dy = 0, amt = 0 }
  self.ambient_tilt = 0.2

  self.states.collide.can = true
  self.states.hover.can = true
  self.states.drag.can = true
  self.states.click.can = true

  if self.params.viewed_back then
    self.back = 'viewed_back'
  else
    self.back = 'selected_back'
  end
  self.bypass_discovery_center = self.params.bypass_discovery_center
  self.bypass_discovery_ui = self.params.bypass_discovery_ui
  self.bypass_lock = self.params.bypass_lock
  self.no_ui = self.config.card and self.config.card.no_ui
  self.children = {}
  self.base_cost = 0
  self.extra_cost = 0
  self.cost = 0
  self.sell_cost = 0
  self.sell_cost_label = 0
  self.children.shadow = Moveable(0, 0, 0, 0)
  self.unique_val = 1 - self.ID / 1603301
  self.edition = nil
  self.zoom = true
  self.ability = {}
  self:set_sprites(center)
  -- self:set_ability(center, true)
  -- self:set_base(card, true)

  self.discard_pos = {
    r = 3.6 * (math.random() - 0.5),
    x = math.random(),
    y = math.random()
  }

  self.facing = 'front'
  self.sprite_facing = 'front'
  self.flipping = nil
  self.area = nil
  self.highlighted = false
  self.click_timeout = 0.3
  self.T.scale = 0.95
  self.debuff = false

  self.rank = nil
  self.added_to_deck = nil

  if self.children.front then self.children.front.VT.w = 0 end
  self.children.back.VT.w = 0
  self.children.center.VT.w = 0

  if self.children.front then
    self.children.front.parent = self; self.children.front.layered_parallax = nil
  end
  self.children.back.parent = self; self.children.back.layered_parallax = nil
  self.children.center.parent = self; self.children.center.layered_parallax = nil

  if getmetatable(self) == Card then
    table.insert(G.I.CARD, self)
  end
end

return DisplayCard
