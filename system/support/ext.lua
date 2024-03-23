local addon, bxhnz7tp5bge7wvu = ...

function table.size(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function table.contains(t, i)
    for k, v in pairs(t) do
        if v == i then return k end
    end
    return false
end
