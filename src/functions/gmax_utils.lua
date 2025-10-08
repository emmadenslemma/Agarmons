-- Add "Can Dynamax" tooltip to existing Pokemon
local type_tooltip_ref = type_tooltip
type_tooltip = function(self, info_queue, center)
  type_tooltip_ref(self, info_queue, center)
  if pokermon_config.detailed_tooltips and GMAX.get_gmax_key(center) then
    info_queue[#info_queue + 1] = { set = 'Other', key = 'gmax_poke' }
  end
end

GMAX = {
  preload = function(item)
    -- Required to block Transformation
    item.aux_poke = true
    -- Add `turns_left` to extra
    item.config = item.config or {}
    item.config.extra = item.config.extra or {}
    item.config.extra.turns_left = 3
    -- Add "x turns left" to loc_txt.text
    if item.loc_txt and item.loc_txt.text then -- we still have to manually define it if we use localization files
      table.insert(item.loc_txt.text, 1, "{C:agar_gmax,s:1.1}#1#{s:1.1} #2#")
      table.insert(item.loc_txt.text, 2, "{br:2.5}ERROR - CONTACT STEAK")
    end
    -- Add `revert` to the end of `calculate`
    if item.calculate then
      local calculate_ref = item.calculate
      item.calculate = function(self, card, context)
        local ret, no_eff = calculate_ref(self, card, context)
        GMAX.revert(self, card, context)
        return ret, no_eff
      end
    else
      item.calculate = GMAX.revert
    end
    -- Add  `loc_vars` to.. loc_vars
    if item.loc_vars then
      local loc_vars_ref = item.loc_vars
      item.loc_vars = function(self, info_queue, center)
        local loc_table = loc_vars_ref(self, info_queue, center)
        return GMAX.loc_vars(self, info_queue, center, loc_table)
      end
    else
      item.loc_vars = GMAX.loc_vars
    end
  end,
  get_gmax_key = function(base_card)
    return base_card
        and base_card.config
        and GMAX.evos[base_card.config.center_key]
        or nil
  end,
  get_base_key = function(gmax_card)
    if gmax_card and gmax_card.config then
      for base, gmax in pairs(GMAX.evos) do
        if gmax == gmax_card.config.center_key then
          return base
        end
      end
    end
    return nil
  end,
  revert = function(self, card, context)
    if context.end_of_round and context.cardarea == G.jokers then
      -- TODO: This needs to happen AFTER clearing the blind so we can still get completion stake stickers
      --   but BEFORE end of round tallies so we can get Pikachu/Gengar progress
      poke_evolve(card, GMAX.get_base_key(card), true)
    end
    if context.after and context.cardarea == G.jokers then
      card.ability.extra.turns_left = card.ability.extra.turns_left - 1
      if card.ability.extra.turns_left > 0 then
        card_eval_status_text(card, "extra", nil, nil, nil, {
          message = localize { type = "variable", key = card.ability.extra.turns_left == 1 and "agar_x_turns_left_singular_ex" or "agar_x_turns_left_plural_ex", vars = { card.ability.extra.turns_left } },
          colour = G.C.agar_gmax,
        })
      else
        -- Event to make it devolve after scoring visuals are over
        G.E_MANAGER:add_event(Event({
          func = function()
            poke_evolve(card, GMAX.get_base_key(card), true)
            return true
          end
        }))
      end
    end
  end,
  loc_vars = function(self, info_queue, center, loc_table)
    loc_table = loc_table or {}
    loc_table.vars = loc_table.vars or {}

    table.insert(loc_table.vars, 1, center.ability.extra.turns_left)
    table.insert(loc_table.vars, 2, localize(center.ability.extra.turns_left == 1 and "agar_turns_left_singular" or "agar_turns_left_plural"))

    return loc_table
  end,
}

-- key is pre-gmax object key, value is post-gmax object key
GMAX.evos = GMAX.evos or {} -- (initializing it here so lower priority mods can just copy paste this whole file without overwriting it)
