AG.list_utils = {}

function AG.list_utils.id(a)
  return a
end

function AG.list_utils.map(list, func)
  new_list = {}
  for _, v in pairs(list) do
    new_list[#new_list+1] = func(v)
  end
  return new_list
end

function AG.list_utils.for_each(list, func)
  for _, v in pairs(list) do
    func(v)
  end
end

---@deprecated
function AG.list_utils.copy(list)
  return AG.list_utils.map(list, AG.list_utils.id)
end

function AG.list_utils.filter(list, func)
  new_list = {}
  for _, v in pairs(list) do
    if func(v) then
      new_list[#new_list+1] = v
    end
  end
  return new_list
end

function AG.list_utils.elem(list, item)
  for _, v in pairs(list) do
    if v == item then return true end
  end
  return false
end
