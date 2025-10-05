-- find somewhere else to put this later:
local type_tooltip_ref = type_tooltip
type_tooltip = function(self, info_queue, center)
  type_tooltip_ref(self, info_queue, center)
  if pokermon_config.detailed_tooltips and center.config.center.gmax_key then
    info_queue[#info_queue + 1] = { set = 'Other', key = 'gmax_poke' }
  end
end

-- Repeating functions from Gigantamax Pokemon
GMAX = {
  preload = function(item)
    -- Required to block Transformation
    item.aux_poke = true
    -- Add `turns_left` to extra
    item.config = item.config or {}
    item.config.extra = item.config.extra or {}
    item.config.extra.turns_left = 3
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
  revert = function(self, card, context)
    if context.end_of_round and context.cardarea == G.jokers then
      poke_evolve(card, card.config.center.base_key, true)
    end
    if context.after and context.cardarea == G.jokers then
      card.ability.extra.turns_left = card.ability.extra.turns_left - 1
      if card.ability.extra.turns_left > 0 then
        card_eval_status_text(card, "extra", nil, nil, nil, {
          message = localize { type = "variable", key = (card.ability.extra.turns_left == 1 and "agar_turns_left_singular_ex" or "agar_turns_left_plural_ex"), vars = { card.ability.extra.turns_left } },
          colour = G.C.agar_gmax,
        })
      else
        G.E_MANAGER:add_event(Event({
          func = function()
            poke_evolve(card, card.config.center.base_key, true)
            return true
          end
        }))
      end
    end
  end,
  loc_vars = function(self, info_queue, center, loc_table)
    local loc_turns_left = localize {
      type = "variable",
      key = center.ability.extra.turns_left == 1 and "agar_gmax_turns_left_singular" or "agar_gmax_turns_left_plural",
      vars = { center.ability.extra.turns_left }
    }

    loc_table = loc_table or {}
    loc_table.vars = loc_table.vars or {}

    table.insert(loc_table.vars, 1, loc_turns_left)

    return loc_table
  end,
}
