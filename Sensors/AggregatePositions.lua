local sensorInfo = {
	name = "Aggregate positions",
	desc = "Select always only one position out of bunch of near neighbours.",
	author = "Petrroll",
	date = "2018-05-10",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

local SpringGetGroundHeight = Spring.GetGroundHeight 

-- @description from each close neighborhood return exactly one location
return function(locations, neighborhoodTreshold)
	neighborhoodTreshold = neighborhoodTreshold or 512

	aggrdCoefs = {}
	aggrdLocs = {}
	aggrdLocId = 1 --number of locations seen in specific neighborhoods, needed for average position calculation

	for _, loc in pairs(locations) do

		local isCloseToAlreadySelected = false
		for selectedLocKey, selectedLoc in pairs(aggrdLocs) do
			-- current location is within an already seen neighborhood
			if loc:Distance(selectedLoc) < neighborhoodTreshold then
				-- newNeighborhoodCentre = (oldCentre * numberOfLocationsInNeighbSofar + newLocation) / (numberOfLocationsInNeighbSofar + 1)
				local currCoef = aggrdCoefs[selectedLocKey]
				local newSelectedLoc = (selectedLoc * currCoef + loc) / (currCoef + 1) 

				aggrdLocs[selectedLocKey] = newSelectedLoc
				aggrdCoefs[selectedLocKey] = currCoef + 1

				isCloseToAlreadySelected = true
			end
		end 

		-- location from a completely new neighborhood
		if isCloseToAlreadySelected == false then
			aggrdCoefs[aggrdLocId] = 1
			aggrdLocs[aggrdLocId] = loc
			aggrdLocId = aggrdLocId + 1
		end
		
	end

	return aggrdLocs

end