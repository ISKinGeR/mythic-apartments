
_aptData = {}
_aptDataByRoomId = {}
_availableApartments = {}
_assignedApartments = {} 
_apartmentAssignments = {} 
_reservedApartments = {} -- aptId = true



if _raidedApartments then
	_raidedApartments = {}
end

function Startup()
	if not Logger then
		Logger = exports["skdev-base"]:FetchComponent("Logger")
	end
	
	if not Database then
		Database = exports["skdev-base"]:FetchComponent("Database")
	end
	
	
	local aptConfigs = GetApartmentDataFromConfig()
	
	_aptData = {}
	_aptDataByRoomId = {}
	_availableApartments = {}
	_assignedApartments = {}
	_apartmentAssignments = {}
	local aptIds = {}

	
	for _, aptData in ipairs(aptConfigs) do
		local index = #_aptData + 1
		aptData.id = index
		
		
		if aptData.roomId then
			_aptDataByRoomId[aptData.roomId] = aptData
		end
		
		table.insert(_aptData, aptData)
		GlobalState[string.format("Apartment:%s", index)] = aptData
		table.insert(aptIds, index)
	end

	GlobalState["Apartments"] = aptIds
	
	
	LoadApartmentAssignments()
	
	if Logger then
		Logger:Info("Apartments", string.format("Loaded ^2%d^7 apartment rooms", #aptIds))
	end
end


function LoadApartmentAssignments()
	if not Database then return end
	
	local thirtyDaysAgo = os.time() * 1000 - (30 * 24 * 60 * 60 * 1000) 
	
	Database.Game:find({
		collection = "apartment_assignments",
		query = {}
	}, function(success, assignments)
		if not success then
			Logger:Warn("Apartments", "Failed to load apartment assignments")
			UpdateAvailableApartments()
			return
		end
		
		
		_assignedApartments = {}
		_apartmentAssignments = {}
		
		
		if not assignments or #assignments == 0 then
			UpdateAvailableApartments()
			if Logger then
				local availableCount = #_availableApartments
				Logger:Info("Apartments", string.format("Loaded assignments: ^2%d^7 available, ^3%d^7 assigned", availableCount, 0))
			end
			return
		end
		
		
		for _, assignment in ipairs(assignments) do
			
			local p = promise.new()
			Database.Game:findOne({
				collection = "characters",
				query = {
					SID = assignment.characterSID
				},
				options = {
					projection = {
						LastPlayed = 1,
						SID = 1
					}
				}
			}, function(charSuccess, charResults)
				if charSuccess and charResults then
					
					local lastPlayed = charResults.LastPlayed
					
					
					
					if lastPlayed and lastPlayed ~= -1 and lastPlayed < thirtyDaysAgo then
						
						ReleaseApartmentAssignment(assignment.apartmentId, assignment.characterSID, true)
						p:resolve(false)
					else
						
					_assignedApartments[assignment.apartmentId] = {
						characterSID = assignment.characterSID,
						characterID = assignment.characterID,
						assignedAt = assignment.assignedAt
					}
					
					local charSID = assignment.characterSID
					_apartmentAssignments[charSID] = assignment.apartmentId
					_apartmentAssignments[tostring(charSID)] = assignment.apartmentId
					if tonumber(charSID) then
						_apartmentAssignments[tonumber(charSID)] = assignment.apartmentId
					end
					
					
					if EnsureCharacterDoorAccess then
						EnsureCharacterDoorAccess(assignment.characterSID, assignment.apartmentId)
					end
						
						p:resolve(true)
					end
				else
					
					ReleaseApartmentAssignment(assignment.apartmentId, assignment.characterSID, true)
					p:resolve(false)
				end
			end)
			Citizen.Await(p)
		end
		
		UpdateAvailableApartments()
		
		if Logger then
			local availableCount = #_availableApartments
			local assignedCount = 0
			for _ in pairs(_assignedApartments) do
				assignedCount = assignedCount + 1
			end
			Logger:Info("Apartments", string.format("Loaded assignments: ^2%d^7 available, ^3%d^7 assigned", availableCount, assignedCount))
		end
	end)
end


function UpdateAvailableApartments(showDebug)
	_availableApartments = {}

	if not _aptData then return end
	if not _assignedApartments then _assignedApartments = {} end
	if not _reservedApartments then _reservedApartments = {} end

	for aptId, _ in ipairs(_aptData) do
		if not _assignedApartments[aptId] and not _reservedApartments[aptId] then
			table.insert(_availableApartments, aptId)
		end
	end
end



function AssignApartmentToCharacter(apartmentId, characterID, characterSID)
	if not apartmentId or not characterID or not characterSID then
		return false
	end

	if _assignedApartments[apartmentId] then
		return false
	end

	_assignedApartments[apartmentId] = {
		characterSID = characterSID,
		characterID = characterID,
		assignedAt = os.time() * 1000
	}

	_apartmentAssignments[characterSID] = apartmentId
	_apartmentAssignments[tostring(characterSID)] = apartmentId
	if tonumber(characterSID) then
		_apartmentAssignments[tonumber(characterSID)] = apartmentId
	end

	_reservedApartments[apartmentId] = nil

	if Database then
		Database.Game:insertOne({
			collection = "apartment_assignments",
			document = {
				apartmentId = apartmentId,
				characterID = characterID,
				characterSID = characterSID,
				assignedAt = os.time() * 1000
			}
		}, function(success)
			if not success then
				_assignedApartments[apartmentId] = nil
				_apartmentAssignments[characterSID] = nil
				_apartmentAssignments[tostring(characterSID)] = nil
				if tonumber(characterSID) then
					_apartmentAssignments[tonumber(characterSID)] = nil
				end

				_reservedApartments[apartmentId] = nil
				UpdateAvailableApartments(true)
			end
		end)
	end

	UpdateAvailableApartments()
	return true
end

function GetAvailableApartmentsByFloor()
	local floors = {}

	for _, aptId in ipairs(_availableApartments) do
		if not _assignedApartments[aptId] and not _reservedApartments[aptId] then
			local apt = _aptData[aptId]
			if apt and apt.floor then
				floors[apt.floor] = floors[apt.floor] or {}
				table.insert(floors[apt.floor], aptId)
			end
		end
	end

	return floors
end

function ReleaseApartmentAssignment(apartmentId, characterSID, silent)
	if not _assignedApartments[apartmentId] then
		return false 
	end
	
	if not Database then
		if Logger then
			Logger:Warn("Apartments", "Database component not available for ReleaseApartmentAssignment")
		end
		return false
	end
	
	local assignment = _assignedApartments[apartmentId]
	local characterID = assignment and assignment.characterID
	
	
	if RemoveCharacterDoorAccess then
		RemoveCharacterDoorAccess(characterSID, apartmentId)
	end
	
	
	local invType = 13 
	if _aptData[apartmentId] and _aptData[apartmentId].invEntity then
		invType = _aptData[apartmentId].invEntity
	end
	
	if Inventory then
		local stashName = string.format("%s-%s", characterSID, invType)
		if MySQL then
			MySQL.query.await("DELETE FROM inventory WHERE name = ?", { stashName })
			if Logger then
				Logger:Info("Apartments", "stash cleared for apartment " .. apartmentId .. " (character " .. characterSID .. ")")
			end
		end
	end
	
	Database.Game:delete({
		collection = "apartment_assignments",
		query = {
			apartmentId = apartmentId,
			characterSID = characterSID
		}
	}, function(success)
		if success then
			
			_assignedApartments[apartmentId] = nil
			_apartmentAssignments[characterSID] = nil
			_apartmentAssignments[tostring(characterSID)] = nil
			if tonumber(characterSID) then
				_apartmentAssignments[tonumber(characterSID)] = nil
			end
			
			
			if characterID then
				Database.Game:updateOne({
					collection = "characters",
					query = {
						_id = characterID
					},
					update = {
						["$set"] = {
							Apartment = 0
						}
					}
				}, function(charUpdateSuccess)
					if charUpdateSuccess and Logger then
						Logger:Info("Apartments", string.format("Cleared apartment %s from character %s (ID: %s) database record", apartmentId, characterSID, tostring(characterID)))
					end
				end)
			end
			
			
			UpdateAvailableApartments()
			
			if not silent and Logger then
				Logger:Info("Apartments", string.format("Released apartment %s from character %s - now available for assignment", apartmentId, characterSID))
			end
		end
	end)
	
	return true
end


function GetCharacterApartment(characterSID)
	return _apartmentAssignments[characterSID]
end


function GetApartmentByRoomId(roomId)
	return _aptDataByRoomId[roomId]
end


function GetRandomAvailableApartment()
	if not _availableApartments or #_availableApartments == 0 then
		return nil
	end

	local byFloor = GetAvailableApartmentsByFloor()
	if not byFloor then return nil end

	-- sort floors ASC (1 → 20)
	local floorList = {}
	for floor, _ in pairs(byFloor) do
		table.insert(floorList, floor)
	end
	table.sort(floorList)

	-- pick FIRST available room on LOWEST floor
	for _, floor in ipairs(floorList) do
		local rooms = byFloor[floor]
		if rooms and #rooms > 0 then
			local aptId = rooms[1]

			-- HARD LOCK
			_reservedApartments[aptId] = true
			return aptId
		end
	end

	return nil
end



function IsApartmentAvailable(apartmentId)
	return not _assignedApartments[apartmentId]
end
