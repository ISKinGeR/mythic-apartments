function RegisterMiddleware()
	if not Middleware then
		return
	end

	Middleware:Add("Characters:Creating", function(source, cData)
		return {{
			Apartment = 0,
			NeedsApartment = true,
		}}
	end)

	Middleware:Add("Characters:Spawning", function(source)
		local player = Fetch:Source(source)
		if not player then return end

		local char = player:GetData("Character")
		if not char then return end

		local characterSID = char:GetData("SID")
		local characterID = char:GetData("ID")

		local aptId = tonumber(char:GetData("Apartment") or 0) or 0
		local needsApartment = char:GetData("NeedsApartment") == true

		-- If DB says no apartment yet and NeedsApartment=true => assign now
		if (aptId == 0) and needsApartment then
			-- Refresh pool (optional debug)
			if UpdateAvailableApartments then
				UpdateAvailableApartments(true)
			end

			local newAptId = GetRandomAvailableApartment and GetRandomAvailableApartment() or nil
			if newAptId then
				local ok = AssignApartmentToCharacter(newAptId, characterID, characterSID)
				if ok then
					aptId = newAptId

					-- Update runtime character state
					char:SetData("Apartment", newAptId)
					char:SetData("NeedsApartment", false)

					-- PERSIST (THIS IS WHAT STOPS RE-ASSIGN ON RELOG)
					if Database then
						Database.Game:updateOne({
							collection = "characters",
							query = { _id = characterID },
							update = {
								["$set"] = {
									Apartment = newAptId,
									NeedsApartment = false,
								}
							}
						})
					end

					if EnsureCharacterDoorAccess then
						EnsureCharacterDoorAccess(characterSID, newAptId)
					end

					if SendApartmentAssignmentEmail then
						SendApartmentAssignmentEmail(source, newAptId, characterSID)
					end

					if Logger and _aptData and _aptData[newAptId] then
						local a = _aptData[newAptId]
						Logger:Info(
							"Apartments",
							string.format(
								"Auto-assigned apt %s (Room %s, Floor %s) to SID %s",
								newAptId,
								a.roomLabel or "?",
								a.floor or "?",
								characterSID
							)
						)
					end
				end
			end
		end

		-- Ensure runtime mapping exists for existing characters (if assignments table was missing)
		if aptId > 0 then
			local runtimeApt = GetCharacterApartment and GetCharacterApartment(characterSID) or nil
			if not runtimeApt or runtimeApt ~= aptId then
				if AssignApartmentToCharacter then
					AssignApartmentToCharacter(aptId, characterID, characterSID)
				end
			end

			if EnsureCharacterDoorAccess then
				EnsureCharacterDoorAccess(characterSID, aptId)
			end
		end

		-- Sync state used by clients
		GlobalState[string.format("Apartment:Interior:%s", characterSID)] = aptId
	end, 2)

	Middleware:Add("Characters:Logout", function(source)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			TriggerClientEvent("Apartment:Client:Cleanup", source, GlobalState[string.format("%s:Apartment", source)])
			GlobalState[string.format("%s:Apartment", source)] = nil
			GlobalState[string.format("Apartment:Interior:%s", char:GetData("SID"))] = char:GetData("Apartment")

			Player(source).state.inApartment = nil
			Player(source).state.tpLocation = nil

			if Routing then
				Routing:RoutePlayerToGlobalRoute(source)
			end
		end
	end)

	Middleware:Add("Characters:GetSpawnPoints", function(source, charId, cData)
		local spawns = {}

		if cData.New then
			return spawns
		end

		local aptId = GetCharacterApartment(cData.SID)
		if not aptId or aptId == 0 then
			aptId = tonumber(cData.Apartment or 0) or 0
		end

		if aptId > 0 then
			local apt = _aptData[aptId]
			if apt and apt.interior and apt.interior.wakeup then
				local roomLabel = apt.roomLabel or aptId
				local buildingLabel = apt.buildingLabel or apt.buildingName or "Apartment"
				local label = string.format("%s - Room %s", buildingLabel, roomLabel)

				table.insert(spawns, {
					id = string.format("APT:%s:%s", aptId, cData.SID),
					label = label,
					location = {
						x = apt.interior.wakeup.x,
						y = apt.interior.wakeup.y,
						z = apt.interior.wakeup.z,
						h = apt.interior.wakeup.h or 0.0,
					},
					icon = "building",
					event = "Apartment:SpawnInside",
				})
			end
		end

		return spawns
	end, 2)
end
