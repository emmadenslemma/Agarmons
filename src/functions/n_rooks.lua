-- an N-rooks solver that solves for:
--   - restricted placement (each rook has only a set amount of columns it can be placed in)
--   - order of rooks (if an early rook can be placed at its step, it must)
--   - amount of rooks (returns the first solution that satisfies the above with the highest amount of placed rooks)
AG.n_rooks = {}

---@alias Column number
---@alias Rook Column[]

---@param rooks Rook[]
function AG.n_rooks.solve(rooks)
  ---@alias Step { next_rook: number, solution: table }
  ---@type Step[]
  local steps = {
    { next_rook = 1, solution = {} }
  }

  ---@alias Solution { rook: number, col: Column }
  ---@type Solution[]
  local solutions = {}

  while #steps > 0 do
    local step = table.remove(steps)
    local next_rook = step.next_rook
    local cols = rooks[next_rook]
    local solution = step.solution

    if cols then
      local inserted = false

      for _, col in ipairs(cols) do
        for _, pos in ipairs(solution) do
          if col == pos.col then goto continue end
        end

        local new_solution = copy_table(solution)
        table.insert(new_solution, { rook = next_rook, col = col })
        table.insert(steps, {
          next_rook = step.next_rook + 1,
          solution = new_solution
        })
        inserted = true
        ::continue::
      end

      if not inserted then
        step.next_rook = next_rook + 1
        table.insert(steps, step)
      end
    else
      table.insert(solutions, solution)
    end
  end

  table.sort(solutions, function(a, b) return #a < #b end)

  return solutions[1] or {}
end

--- Given a list of cards, returns the indexes of cards that contain the first unique suit
---@param cards Card[]
---@return number[]
function AG.n_rooks.solve_suits(cards)
  ---@type Rook[]
  local rooks = {}
  local suits = {}

  -- Convert suits to numbers
  for suit, _ in pairs(SMODS.Suits) do
    table.insert(suits, suit)
  end

  for _, card in ipairs(cards) do
    local rook = {}
    for col, suit in ipairs(suits) do
      if card:is_suit(suit) then table.insert(rook, col) end
    end
    table.insert(rooks, rook)
  end

  local solution = AG.n_rooks.solve(rooks)

  return AG.list_utils.map(solution, function(pos)
    return pos.rook
  end)
end
