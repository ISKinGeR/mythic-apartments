AddEventHandler("Apartment:Server:SpawnInside", function()
    
end)

RegisterNetEvent("Apartment:Server:LeavePoly", function()
    local src = source
    if _requestors[src] ~= nil then
        for k, v in ipairs(_requests) do
            if v == src then
                table.remove(_requests, k)
                return
            end
        end
    end
end)


AddEventHandler("Characters:Server:CharacterDeleted", function(characterID)
	if not Database then return end
	
	
	Database.Game:findOne({
		collection = "characters",
		query = {
			_id = characterID
		},
		options = {
			projection = {
				SID = 1,
				Apartment = 1
			}
		}
	}, function(success, results)
		if success and results and results[1] then
			local charData = results[1]
			local characterSID = charData.SID
			local aptId = GetCharacterApartment(characterSID)
			
			if aptId and aptId > 0 then
				if Logger then
					Logger:Info("Apartments", string.format("Releasing apartment %s from deleted character %s", aptId, characterSID))
				end
				ReleaseApartmentAssignment(aptId, characterSID, false)
			end
		end
	end)
end)

RegisterNetEvent("Apartment:Server:ElevatorFloorChanged", function(buildingName, floor)
	local source = source

	if not buildingName or floor == nil then
		return
	end

	local player = Fetch:Source(source)
	if not player then
		return
	end

	local char = player:GetData("Character")
	if not char then
		return
	end

	local characterSID = char:GetData("SID")
	local aptId = GetCharacterApartment(characterSID)

	local elevatorFloors = Config.HotelElevators and Config.HotelElevators[buildingName]
	if not elevatorFloors or not elevatorFloors[floor] then
		return
	end

	local floorConfig = elevatorFloors[floor]
	local bucketReset = floorConfig.bucketReset
	local isApartmentFloor = floorConfig.isApartmentFloor

	local playerRoute = Routing:GetPlayerRoute(source)

	if bucketReset then
		Routing:RoutePlayerToGlobalRoute(source)
		GlobalState[string.format("%s:Apartment", source)] = nil

		if Pwnzor and Pwnzor.Players then
			Pwnzor.Players:TempPosIgnore(source)
		end

		Player(source).state.inApartment = nil
		Player(source).state.tpLocation = nil

		TriggerClientEvent("Apartment:Client:ExitElevator", source)
		return
	end

	if isApartmentFloor and aptId and aptId > 0 then
		-- THIS is the key: shared route name ONLY by building+floor
		local expectedRouteName = string.format("Apartment:Floor:%s:%s", buildingName, floor)
		local expectedRouteId = Routing:RequestRouteId(expectedRouteName, false)

		local currentApartmentState = Player(source).state.inApartment
		local alreadyInApartment = currentApartmentState and currentApartmentState.type == aptId and currentApartmentState.id == characterSID

		if playerRoute.route ~= expectedRouteId then
			Player(source).state.inApartment = {
				type = aptId,
				id = characterSID,
			}

			if Pwnzor and Pwnzor.Players then
				Pwnzor.Players:TempPosIgnore(source)
			end

			Routing:AddPlayerToRoute(source, expectedRouteId)
			GlobalState[string.format("%s:Apartment", source)] = characterSID
		end

		-- keep this if you need it for your flow
		if not alreadyInApartment then
			TriggerClientEvent("Apartment:Client:InnerStuff", source, aptId, characterSID, false)
		end
	end
end)

function GetFloorFurniture(buildingName, floor)
    local result = {}

    if not GlobalState["Apartments"] then
        return result
    end

    for _, aptId in ipairs(GlobalState["Apartments"]) do
        local apt = GlobalState[string.format("Apartment:%s", aptId)]
        if not apt then goto continue end

        -- فلترة المبنى
        if apt.buildingName ~= buildingName then
            goto continue
        end

        -- فلترة الفلور
        if apt.floor ~= floor then
            goto continue
        end

        local furniture = apt.furniture or {}

        table.insert(result, {
            aptId = aptId,
            roomLabel = apt.roomLabel,
            floor = apt.floor,
            furniture = furniture,
        })

        ::continue::
    end

    return result
end

-- Clean up apartment state on logout
RegisterNetEvent("Apartment:Server:LogoutCleanup", function()
	local source = source
	Player(source).state.inApartment = nil
	Player(source).state.tpLocation = nil
	GlobalState[string.format("%s:Apartment", source)] = nil
	if Routing then
		local playerRoute = Routing:GetPlayerRoute(source)
		if playerRoute and playerRoute.route then
			Routing:RoutePlayerToGlobalRoute(source)
		end
	end
end)

-- AddEventHandler("Characters:Created", function(source, charData)
-- 	if not _aptData or #_aptData == 0 then
-- 		if Logger then
-- 			Logger:Warn("Apartments", "Characters:Created called but _aptData is not loaded yet")
-- 		end
-- 		return
-- 	end
-- 	local aptId = GetRandomAvailableApartment()
	
-- 	if aptId then
-- 		local assignResult = AssignApartmentToCharacter(aptId, charData.ID, charData.SID)
		
-- 		if assignResult then
-- 			if Database then
-- 				Database.Game:updateOne({
-- 					collection = "characters",
-- 					query = {
-- 						_id = charData.ID
-- 					},
-- 					update = {
-- 						["$set"] = {
-- 							Apartment = aptId
-- 						}
-- 					}
-- 				}, function(success)
-- 					if success then
-- 						if EnsureCharacterDoorAccess then
-- 							EnsureCharacterDoorAccess(charData.SID, aptId)
-- 						end
-- 						if source and source > 0 then
-- 							if SendApartmentAssignmentEmail then
-- 								SendApartmentAssignmentEmail(source, aptId, charData.SID)
-- 							end
-- 						end
						
-- 						if Logger then
-- 							Logger:Info("Apartments", string.format("Assigned apartment %s to new character %s (%s)", aptId, charData.SID, charData.First .. " " .. charData.Last))
-- 						end
-- 					end
-- 				end)
-- 			end
-- 		end
-- 	else
-- 		if Logger then
-- 			Logger:Warn("Apartments", string.format("No apartments available for new character %s (%s) - character is homeless", charData.SID, charData.First .. " " .. charData.Last))
-- 		end
-- 	end
-- end)
