AG.effects = {}

function AG.effects.apply_scry_hand_effects()
  return SMODS.find_card('j_agar_uxie', false)[1]
      or SMODS.find_card('j_agar_mesprit', false)[1]
      or SMODS.find_card('j_agar_azelf', false)[1]
      or (SMODS.find_card('j_agar_lunala', false)[1] or { ability = { extra = {} } }).ability.extra.full_active
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
  return G.P_CENTERS[upgraded_key]
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
end

AG.effects.ortalab_statue_card = nil -- for intellisense

-- Ripped from Ortalab with minor adjustments for Galarian Mr. Mime
local calculate_main_scoring_ref = SMODS.calculate_main_scoring
SMODS.calculate_main_scoring = function(context, scoring_hand)
  calculate_main_scoring_ref(context, scoring_hand)
  if context.cardarea == G.play and AG.effects.apply_ortalab_statue() and AG.effects.ortalab_statue_card then
    context.cardarea = { cards = { AG.effects.ortalab_statue_card } }
    calculate_main_scoring_ref(context, scoring_hand)
    context.cardarea = G.play
  end
end

local calculate_destroying_cards_ref = SMODS.calculate_destroying_cards
SMODS.calculate_destroying_cards = function(context, cards_destroyed, scoring_hand)
  calculate_destroying_cards_ref(context, cards_destroyed, scoring_hand)
  if context.cardarea == G.play and AG.effects.apply_ortalab_statue() and AG.effects.ortalab_statue_card then
    context.cardarea = { cards = { AG.effects.ortalab_statue_card } }
    calculate_destroying_cards_ref(context, cards_destroyed, scoring_hand)
    context.cardarea = G.play
  end
end

AG.hookafterfunc(SMODS.current_mod, 'calculate', function(context)
  if context.after and AG.effects.ortalab_statue_card then
    AG.effects.ortalab_statue_card:highlight(false)
    AG.effects.ortalab_statue_card = nil
  end
end, true)
