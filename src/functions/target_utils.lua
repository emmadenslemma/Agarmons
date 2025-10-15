local target_utils = {}

-- Version of SMODS.find_card that optionally prioritizes highlighted cards
function target_utils.find_card(key_or_func, use_highlighted)
  local results = {}
  local is_target = function(card)
    if type(key_or_func) == "string" then
      return card.config.center.key == key_or_func
    else
      return key_or_func(card)
    end
  end
  for _, cardarea in pairs(SMODS.get_card_areas("jokers")) do
    if use_highlighted and cardarea.highlight and #cardarea.highlighted == 1 then
      highlight = cardarea.highlighted[1]
      if is_target(highlight) then
        results[#results + 1] = highlight
      end
    elseif cardarea.cards then
      for _, card in pairs(cardarea.cards) do
        if is_target(card) then
          results[#results + 1] = card
        end
      end
    end
  end
  return results
end

function target_utils.find_leftmost(key_or_func, use_highlighted)
  return target_utils.find_card(key_or_func, use_highlighted)[1]
end

function target_utils.find_leftmost_or_highlighted(key_or_func)
  return target_utils.find_leftmost(key_or_func, true)
end

return {
  name = "Agarmons Targeting Helper Functions",
  key = "TARGET_UTILS",
  value = target_utils
}
