local class = Class('task')

function class:initialize(name, initial_boredom)
  self.name = name
  self.boredom = initial_boredom or 0
end

return class
