local sensorInfo = {
	name = "GetPath",
	desc = "Return map of locations specifying a path in a given grid graph.",
	author = "Petrroll",
	date = "2018-05-31",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

--
-- queue implementation based on MIT code: https://github.com/catwell/cw-lua/blob/master/deque/deque.lua
--

--- Deque implementation by Pierre 'catwell' Chapuis
--- MIT licensed (see LICENSE.txt)

local push_right = function(self, x)
  assert(x ~= nil)
  self.tail = self.tail + 1
  self[self.tail] = x
end

local push_left = function(self, x)
  assert(x ~= nil)
  self[self.head] = x
  self.head = self.head - 1
end

local peek_right = function(self)
  return self[self.tail]
end

local peek_left = function(self)
  return self[self.head+1]
end

local pop_right = function(self)
  if self:is_empty() then return nil end
  local r = self[self.tail]
  self[self.tail] = nil
  self.tail = self.tail - 1
  return r
end

local pop_left = function(self)
  if self:is_empty() then return nil end
  local r = self[self.head+1]
  self.head = self.head + 1
  local r = self[self.head]
  self[self.head] = nil
  return r
end

local length = function(self)
  return self.tail - self.head
end

local is_empty = function(self)
  return self:length() == 0
end


local iter_right = function(self)
  local i = self.tail+1
  return function()
    if i > self.head+1 then
      i = i-1
      return self[i]
    end
  end
end

local iter_left = function(self)
  local i = self.head
  return function()
    if i < self.tail then
      i = i+1
      return self[i]
    end
  end
end

local methods = {
  push_right = push_right,
  push_left = push_left,
  peek_right = peek_right,
  peek_left = peek_left,
  pop_right = pop_right,
  pop_left = pop_left,
  iter_right = iter_right,
  iter_left = iter_left,
  length = length,
  is_empty = is_empty,
}

local newQueue = function()
  local r = {head = 0, tail = 0}
  return setmetatable(r, {__index = methods})
end

---
--- End of Queue implementation
---

-- @description returns map of locations specifying a path in a given grid graph
return function(startPos, destPos, boolGridObj)

    local startXi = math.floor(startPos.x / boolGridObj.granularity) + 1
    local startYi = math.floor(startPos.z / boolGridObj.granularity) + 1
    local start = {x=startXi, y=startYi}

    local destXi = math.floor(destPos.x / boolGridObj.granularity) + 1
    local destYi = math.floor(destPos.z / boolGridObj.granularity) + 1
    local dest = {x=destXi, y=destYi}

    local bfsQ = newQueue()
    
    local graphGrid = boolGridObj.grid   
    local navGraph = {}
    
    local function neighborExistsSafeNotExplored(nb, navGraph, graphGrid)
        if not (nb.x >= 1 and nb.x <= #graphGrid) then return false end         -- neighbor not on map in x -> false  
        if not (nb.y >= 1 and nb.y <= #(graphGrid[1])) then return false end    -- neighbor not on map in y -> false  

        return graphGrid[nb.x][nb.y].safe and navGraph[nb.x][nb.y] == nil       -- neighbor safe && not-yet visited
    end

    local nbs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {-1, -1}, {1, 1}, {-1, 1}, {1, -1}}

    
    bfsQ:push_right(dest)
    while not bfsQ:is_empty() do
        local currLoc = bfsQ:pop_right()
        for i=1, #nbs do
            local nb = {x = (currLoc.x + nbs[i][1]), y = (currLoc.y + nbs[i][2])}
            if navGraph[nb.x] == nil then navGraph[nb.x] = {} end   

            -- if the neighbor is safe & hasn't been explored yet -> add to navGraph & queue
            if neighborExistsSafeNotExplored(nb, navGraph, graphGrid) then
                navGraph[nb.x][nb.y] = currLoc
                bfsQ:push_left(nb)                                
            end
        end
    end

    local currLoc = start
    local path = {graphGrid[currLoc.x][currLoc.y].loc}
    while currLoc.x ~= dest.x or currLoc.y ~= dest.y do
        currLoc = navGraph[currLoc.x][currLoc.y]
        path[#path+1] = graphGrid[currLoc.x][currLoc.y].loc
    end

    return path
end