-- Arceus 382
local arceus = {
  name = "arceus",
  pos = { x = 4, y = 4 },
  soul_pos = { x = 5, y = 4 },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if center.ability.extra.ptype and center.ability.extra.ptype ~= "Colorless" then
      return { key = 'j_agar_arceus_' .. string.lower(center.ability.extra.ptype) }
    end
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Colorless",
  atlas = "AtlasJokersBasicGen04",
  gen = 4,
  aux_poke = true,
  calculate = function(self, card, context)
  end,
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.ptype then
      local ptypes = {
        Colorless = { x = 4, y = 4 },
        Grass = { x = 6, y = 4 },
        Fire = { x = 8, y = 4 },
        Water = { x = 10, y = 4 },
        Lightning = { x = 0, y = 5 },
        Psychic = { x = 2, y = 5 },
        Fighting = { x = 4, y = 5 },
        Dark = { x = 6, y = 5 },
        Metal = { x = 8, y = 5 },
        Fairy = { x = 10, y = 5 },
        Dragon = { x = 0, y = 6 },
        Earth = { x = 2, y = 6 },
      }
      local pos = ptypes[card.ability.extra.ptype]
      local soul_pos = { x = pos.x + 1, y = pos.y }
      card.children.center:set_sprite_pos(pos)
      card.children.floating_sprite:set_sprite_pos(soul_pos)
    end
  end,
}

local init = function()
  local apply_type_sticker_ref = apply_type_sticker
  apply_type_sticker = function(card, sticker_type)
    if card.config.center.key == 'j_agar_arceus' then return end
    apply_type_sticker_ref(card, sticker_type)
  end

  pokermon.add_family {
    { key = "arceus" },
    { key = "arceus", ptype = "Grass" },
    { key = "arceus", ptype = "Fire" },
    { key = "arceus", ptype = "Water" },
    { key = "arceus", ptype = "Lightning" },
    { key = "arceus", ptype = "Psychic" },
    { key = "arceus", ptype = "Fighting" },
    { key = "arceus", ptype = "Dark" },
    { key = "arceus", ptype = "Metal" },
    { key = "arceus", ptype = "Fairy" },
    { key = "arceus", ptype = "Dragon" },
    { key = "arceus", ptype = "Earth" },
  }

  extended_family["arceus"] = {}
end

return {
  enabled = agarmons_config.arceus,
  init = init,
  list = { arceus }
}
