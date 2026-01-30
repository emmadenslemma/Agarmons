AG.effects = {}

function AG.effects.apply_scry_hand_effects()
  return SMODS.find_card('j_agar_uxie')[1]
      or SMODS.find_card('j_agar_mesprit')[1]
      or SMODS.find_card('j_agar_azelf')[1]
      or (SMODS.find_card('j_agar_lunala')[1] or { ability = { extra = {} } }).ability.extra.full_active
end

function AG.effects.apply_force_jumbo_packs()
  return next(SMODS.find_card('j_agar_drampa'))
end

function AG.effects.apply_force_mega_packs()
  return next(SMODS.find_card('j_agar_mega_drampa'))
end

local function try_upgrade_pack(center, from, to)
  local upgraded_key = center.key:gsub(from, to)
  if center.key == upgraded_key then return end
  local pack_num = tonumber(upgraded_key:match("_(%d)$")) or 1
  return G.P_CENTERS[upgraded_key]
      or G.P_CENTERS[upgraded_key:gsub('_%d$', '_' .. math.floor(pack_num / 2))]
      or G.P_CENTERS[upgraded_key:gsub('_%d$', '_1')] -- default to the first variant
end

local function apply_pack_upgrades(center)
  if AG.effects.apply_force_mega_packs() then
    return try_upgrade_pack(center, "normal", "mega")
        or try_upgrade_pack(center, "jumbo", "mega") or center
  elseif AG.effects.apply_force_jumbo_packs() then
    return try_upgrade_pack(center, "normal", "jumbo") or center
  end
  return center
end

local get_pack_ref = get_pack
function get_pack(_key, _type)
  local center = get_pack_ref(_key, _type)
  if _key == 'shop_pack' then
    return apply_pack_upgrades(center)
  end
  return center
end

function AG.effects.upgrade_shop_packs()
  if G.shop_booster and G.shop_booster.cards then
    for _, pack in ipairs(G.shop_booster.cards) do
      local new_center = apply_pack_upgrades(pack.config.center)
      if new_center ~= pack.config.center then
        pack:set_ability(new_center, true)
        -- `set_ability` overrides these with `self.original_T`, which is *sometimes* erroneously the size of a regular playing card:
        pack.T.w = G.CARD_W * 1.27
        pack.T.h = G.CARD_H * 1.27
        pack:set_cost()
        pack:juice_up()
      end
    end
  end
end

function AG.effects.uncap_interest()
  return next(SMODS.find_card('j_poke_mega_raichu_y'))
end

function AG.effects.apply_ortalab_statue()
  return next(SMODS.find_card('j_poke_galarian_mrmime'))
      or next(SMODS.find_card('j_poke_mrrime'))
end

AG.effects.ortalab_statue_card = nil -- for intellisense

-- Ripped from Ortalab with minor adjustments for Galarian Mr. Mime
local statue_wrapper = function(func, context, ...)
  -- cardarea is changed when unscoring cards are played, so we have to check early
  local is_play = context.cardarea == G.play
  func(context, ...)
  if is_play and AG.effects.apply_ortalab_statue() and AG.effects.ortalab_statue_card then
    context.cardarea = { cards = { AG.effects.ortalab_statue_card } }
    func(context, ...)
    context.cardarea = G.play -- for if other mods need to hook this function
  end
end

AG.hookaroundfunc(SMODS, 'calculate_main_scoring', statue_wrapper)
AG.hookaroundfunc(SMODS, 'calculate_destroying_cards', statue_wrapper)

function AG.effects.apply_trick_room()
  return G.GAME.modifiers.trick_room
      or (G.GAME.modifiers.trick_room_setters or 0) > 0
end

-- Trick Room code, for scoring consumables before jokers etc.
AG.hookaroundfunc(SMODS, 'get_card_areas', function(orig, ...)
  local t = orig(...)
  if AG.effects.apply_trick_room() then
    t = AG.list_utils.rev(t)
  end
  return t
end)

function AG.effects.apply_sturdy_glass()
  return next(SMODS.find_card('j_agar_glastrier'))
end

AG.hookaroundfunc(_G, 'poke_remove_card', function(orig, card, ...)
  if not (SMODS.has_enhancement(card, 'm_glass') and AG.effects.apply_sturdy_glass()) then
    return orig(card, ...)
  end
end)

-- The final failsafe. this won't work on its own but it should stop the edge cases.
--    some of the specific fixes are for stopping `context.remove_playing_cards`,
--     but some are there to stop the game from breaking in half. funny stuff.
AG.hookaroundfunc(Card, 'shatter', function(orig, card)
  if SMODS.has_enhancement(card, 'm_glass') and AG.effects.apply_sturdy_glass() then
    card.getting_sliced = false
    card.shattered = false
    return
  end
  return orig(card)
end)
