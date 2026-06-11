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
  return false -- next(SMODS.find_card('j_poke_mega_raichu_y'))
end

function AG.effects.apply_ortalab_statue()
  return next(SMODS.find_card('j_poke_galarian_mrmime'))
      or next(SMODS.find_card('j_poke_mrrime'))
end

function AG.effects.get_ortalab_statue_card_count()
  local joker = SMODS.find_card('j_poke_mrrime')[1] or SMODS.find_card('j_poke_galarian_mrmime')[1]
  if joker then return joker.ability.extra.scored_cards end
  return 0
end

AG.effects.ortalab_statue_cards = nil -- for intellisense

-- Ripped from Ortalab with minor adjustments for Galarian Mr. Mime
local statue_wrapper = function(func, context, ...)
  -- cardarea is changed when unscoring cards are played, so we have to check early
  local is_play = context.cardarea == G.play
  func(context, ...)
  if is_play and AG.effects.apply_ortalab_statue() and AG.effects.ortalab_statue_cards then
    context.cardarea = { cards = AG.effects.ortalab_statue_cards }
    func(context, ...)
    context.cardarea = G.play -- for if other mods need to hook this function
  end
end

AG.hookaroundfunc(SMODS, 'calculate_main_scoring', statue_wrapper)
AG.hookaroundfunc(SMODS, 'calculate_destroying_cards', statue_wrapper)

function AG.effects.apply_trick_room()
  return not not G.GAME.modifiers.trick_room ~= ((G.GAME.modifiers.trick_room_setters or 0) > 0)
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

function AG.effects.prevent_destruction(card)
  return (SMODS.has_enhancement(card, 'm_glass') and AG.effects.apply_sturdy_glass())
end

AG.hookaroundfunc(pokermon, 'remove_card', function(orig, card, ...)
  if not AG.effects.prevent_destruction(card) then
    return orig(card, ...)
  end
end)

AG.hookbeforefunc(SMODS, 'calculate_context', function(context)
  if context.remove_playing_cards then
    for i = #context.removed, 1, -1 do
      if AG.effects.prevent_destruction(context.removed[i]) then
        table.remove(context.removed, i)
      end
    end
    if #context.removed == 0 then
      return {}
    end
  end
end)

AG.hookaroundfunc(Card, 'shatter', function(orig, card)
  if AG.effects.prevent_destruction(card) then
    card.getting_sliced = false
    card.shattered = false
    return
  end
  return orig(card)
end)

function AG.effects.should_replay_hand()
  return not G.GAME.agar_replaying_hand
      and G.GAME.current_round.hands_played == 0
      and next(SMODS.find_card('j_agar_dialga_origin'))
end

function AG.effects.replay_hand()
  G.E_MANAGER:add_event(Event({
    func = function()
      if Talisman and Talisman.scoring_coroutine then return false end
      G.GAME.agar_replaying_hand = true
      G.FUNCS.evaluate_play()
      G.GAME.agar_replaying_hand = false
      G.E_MANAGER:add_event(Event({
        func = function()
          if Talisman and Talisman.scoring_coroutine then return false end
          G.FUNCS.draw_from_play_to_discard()
          G.GAME.hands_played = G.GAME.hands_played + 1
          G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
          G.E_MANAGER:add_event(Event({
            func = function()
              if Talisman and Talisman.scoring_coroutine then return false end
              G.STATE_COMPLETE = false
              return true
            end,
          }))
          return true
        end,
      }))
      return true
    end
  }))
end

function AG.effects.activate_type_aura(ptype, amount)
  amount = amount or 1
  G.GAME.agar_type_auras = G.GAME.agar_type_auras or {}
  G.GAME.agar_type_auras[ptype] = (G.GAME.agar_type_auras[ptype] or 0) + amount
  AG.energy.mod_all_energy_and_limit(ptype, amount)
end

function AG.effects.deactivate_type_aura(ptype, amount)
  amount = amount or 1
  G.GAME.agar_type_auras = G.GAME.agar_type_auras or {}
  G.GAME.agar_type_auras[ptype] = math.max(0, (G.GAME.agar_type_auras[ptype] or 0) - amount)
  AG.energy.mod_all_energy_and_limit(ptype, -amount)
end

function AG.effects.apply_type_auras(card)
  for ptype, amount in pairs(G.GAME.agar_type_auras or {}) do
    AG.energy.mod_energy_and_limit(card, ptype, amount)
  end
end

function AG.effects.remove_type_auras(card)
  for ptype, amount in pairs(G.GAME.agar_type_auras or {}) do
    AG.energy.mod_energy_and_limit(card, ptype, -amount)
  end
end

AG.hookafterfunc(SMODS.current_mod, 'calculate', function(self, context)
  if context.card_added and context.card.ability.set == 'Joker' then
    AG.effects.apply_type_auras(context.card)
  end
end)

AG.hookaroundfunc(pokermon, 'apply_type_sticker', function(orig, card, ...)
  if pokermon.is_in_collection(card) then return orig(card, ...) end
  AG.effects.remove_type_auras(card)
  orig(card, ...)
  AG.defer(function() -- make 'energized' appear after 'tera'
    AG.effects.apply_type_auras(card)
  end)
end)

function AG.effects.add_crab_chip_multiplier(mod)
  G.GAME.agar_crab_chip_multiplier = (G.GAME.agar_crab_chip_multiplier or 1) * mod
end

function AG.effects.remove_crab_chip_multiplier(mod)
  G.GAME.agar_crab_chip_multiplier = (G.GAME.agar_crab_chip_multiplier or mod or 1) / (mod or 1)
end

AG.hookaroundfunc(Card, 'get_chip_bonus', function(orig, self)
  local chips = orig(self)
  if self:get_id() == 13 then
    chips = chips * (G.GAME.agar_crab_chip_multiplier or 1)
  end
  return chips
end)

SMODS.Edition:take_ownership('foil', {
  calculate = function(self, card, context)
    if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
      local chips = card.edition.chips
      if card:get_id() == 13 then
        chips = chips * (G.GAME.agar_crab_chip_multiplier or 1)
      end
      return {
        chips = chips
      }
    end
  end
}, true)
