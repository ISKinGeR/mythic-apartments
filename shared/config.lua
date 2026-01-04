Config = {}

-- Reception Ped Configuration
-- This ped allows players to request apartments if they don't have one
Config.ReceptionPed = {
    model = "s_m_y_cop_01", -- Receptionist ped model
    coords = vector4(-823.447632, -702.206238, 27.060059, 2.300794), -- Location near apartment entrance (x, y, z, heading) 
    scenario = "WORLD_HUMAN_CLIPBOARD", -- Ped scenario/animation
}
Config.ox_doorlock = {
    first = 1898,
    last = 2277,
}

Config.RoomsReady = {}

-- =======================
-- DOORS FLOOR 1
-- =======================
local DOORS_F1 = {
	[101]={x=-825.866150,y=-724.610962,z=41.674801,h=0},
	[102]={x=-831.466309,y=-724.610962,z=41.674801,h=0},
	[103]={x=-837.066101,y=-724.610962,z=41.674801,h=0},
	[104]={x=-842.666260,y=-724.610962,z=41.674801,h=0},
	[105]={x=-838.819702,y=-721.389587,z=41.674801,h=180},
	[106]={x=-833.219543,y=-721.389587,z=41.674801,h=180},
	[107]={x=-827.619507,y=-721.389587,z=41.674801,h=180},
	[108]={x=-819.983154,y=-704.988525,z=41.674801,h=270},
	[109]={x=-819.983154,y=-699.388672,z=41.674801,h=270},
	[110]={x=-819.983154,y=-693.788818,z=41.674801,h=270},
	[111]={x=-819.983154,y=-688.188843,z=41.674801,h=270},
	[112]={x=-819.983154,y=-682.588867,z=41.674801,h=270},
	[113]={x=-816.609619,y=-686.526245,z=41.674801,h=90},
	[114]={x=-816.609619,y=-692.126282,z=41.674801,h=90},
	[115]={x=-816.609619,y=-697.726257,z=41.674801,h=90},
	[116]={x=-816.609619,y=-703.326294,z=41.674801,h=90},
	[117]={x=-816.609619,y=-708.926270,z=41.674801,h=90},
	[118]={x=-816.609619,y=-714.526245,z=41.674801,h=90},
	[119]={x=-816.569580,y=-720.126282,z=41.674801,h=90},
}

-- =======================
-- POLYS FLOOR 1 (as-is)
-- =======================
local POLYS_F1 = {
	[101]={{-821.16333,-730.47888},{-826.58466,-730.4779},{-826.61719,-724.75116},{-821.17853,-724.74792}},
	[102]={{-826.84900,-730.51257},{-832.22913,-730.44830},{-832.20844,-724.74634},{-826.76721,-724.78467}},
	[103]={{-832.50195,-730.43225},{-837.79608,-730.45044},{-837.77380,-724.75739},{-832.38007,-724.79395}},
	[104]={{-837.73468,-730.88306},{-843.42883,-730.44769},{-843.42810,-724.74280},{-837.96533,-724.76526}},
	[105]={{-843.48535,-715.46960},{-838.05652,-715.55457},{-838.08423,-721.27130},{-843.51086,-721.27130}},
	[106]={{-837.90863,-715.41534},{-832.46924,-715.54218},{-832.48596,-721.26367},{-837.91998,-721.24011}},
	[107]={{-832.22339,-715.42596},{-826.91278,-715.56433},{-826.88275,-721.23572},{-832.31989,-721.25244}},
	[108]={{-825.97290,-709.70361},{-825.79272,-704.22601},{-820.11328,-704.25092},{-820.10663,-709.68481}},
	[109]={{-825.95892,-704.05902},{-825.83472,-698.62628},{-820.10883,-698.64490},{-820.11731,-704.08942}},
	[110]={{-826.11322,-698.66821},{-825.82373,-693.05109},{-820.13153,-693.08374},{-820.10516,-698.48431}},
	[111]={{-825.94598,-692.88989},{-825.82666,-687.42621},{-820.10516,-687.46167},{-820.11407,-692.88934}},
	[112]={{-825.98035,-687.31818},{-825.79181,-681.82574},{-820.10516,-681.83398},{-820.10516,-687.28442}},
	[113]={{-810.60693,-681.82538},{-810.77130,-687.27692},{-816.48419,-687.25787},{-816.43134,-681.82574}},
	[114]={{-810.58954,-687.42877},{-810.73505,-692.85919},{-816.42175,-692.77618},{-816.41089,-687.44324}},
	[115]={{-810.59204,-693.06964},{-810.74359,-698.47137},{-816.44446,-698.42432},{-816.47229,-693.02588}},
	[116]={{-810.56604,-698.51428},{-810.75482,-704.08942},{-816.45807,-704.06549},{-816.48248,-698.64191}},
	[117]={{-810.61407,-704.26654},{-810.75580,-709.68341},{-816.39783,-709.60449},{-816.35803,-704.32147}},
	[118]={{-810.70361,-709.87885},{-810.77130,-715.26355},{-816.48163,-715.28882},{-816.48419,-709.83459}},
	[119]={{-810.63672,-715.38031},{-810.79596,-720.88849},{-816.48419,-720.83710},{-816.47290,-715.42786}},
}

Config.WiwangHotel = {
	key = "map_wiwang_hotel",
	label = "Wiwang Hotel",

	totalFloors = 20,
	roomsPerFloor = 19,

	floorZDelta = 3.800017,

	-- From your generated table: 41.674801 -> 37.174801 / 44.774801
	polyMinZOffset = -4.5,
	polyMaxZOffset =  3.1,

	-- floor 1 only
	doorsF1 = DOORS_F1, -- your 101..119 table (as you already have)
	polysF1 = POLYS_F1, -- your 101..119 table (as you already have)

	-- room 101 template zones (absolute world coords from room 101)
	templateZones101 = {
		stash = vector3(-822.21552, -727.82898, 41.60931),
		wardrobe = vector3(-823.19684, -725.73248, 41.60931),
		spawn = vector4(-825.35181, -726.86676, 41.10820, 270.46735),
	},
}

-- ONLY ONE ROOM furniture template (room 101)
Config.furniture101 = {
	{ model="apa_mp_h_bed_double_08", x=-826.54333, y=-727.75256, z=40.44465, h=90 },
	{ model="apa_mp_h_acc_artwalll_03", x=-826.57959, y=-727.75348, z=41.04229, h=90.256598 },
	{ model="v_res_fh_sidebrdlngb", x=-821.56641, y=-727.81500, z=40.44465, h=270 },
	{ model="bkr_prop_fakeid_desklamp_01a", x=-821.65228, y=-726.55292, z=41.41795, h=261.101226 },
	{ model="v_res_mplanttongue", x=-826.16156, y=-730.14709, z=40.56965, h=261.101135 },
	{ model="apa_mp_h_acc_rugwoolm_03", x=-822.97424, y=-727.75323, z=40.56965, h=360 },
	{ model="prop_ld_suitcase_02", x=-821.61499, y=-724.99438, z=40.56965, h=364.371017 },
	{ model="prop_ld_suitcase_02", x=-821.60004, y=-725.28082, z=40.56965, h=2.246082 },
	{ model="hei_p_attache_case_shut", x=-821.79553, y=-725.70380, z=40.60929, h=275 },
	{ model="v_res_tre_wardrobe", x=-823.20563, y=-725.11786, z=40.56965, h=360 },
}

Config.HotelElevatorsDesc = {
    ["map_wiwang_hotel"] = {
        [-1] = "Garage",
        [0]  = "Lobby",
        [1]  = "Rooms: 100 - 119",
        [2]  = "Rooms: 200 - 219",
        [3]  = "Rooms: 300 - 319",
        [4]  = "Rooms: 400 - 419",
        [5]  = "Rooms: 500 - 519",
        [6]  = "Rooms: 600 - 619",
        [7]  = "Rooms: 700 - 719",
        [8]  = "Rooms: 800 - 819",
        [9]  = "Rooms: 900 - 919",
        [10] = "Rooms: 1000 - 1019",
        [11] = "Rooms: 1100 - 1119",
        [12] = "Rooms: 1200 - 1219",
        [13] = "Rooms: 1300 - 1319",
        [14] = "Rooms: 1400 - 1419",
        [15] = "Rooms: 1500 - 1519",
        [16] = "Rooms: 1600 - 1619",
        [17] = "Rooms: 1700 - 1719",
        [18] = "Rooms: 1800 - 1819",
        [19] = "Rooms: 1900 - 1919",
        [20] = "Rooms: 2000 - 2019",
    }
}

Config.HotelElevators = {
    ["map_wiwang_hotel"] = {

        -- ======================
        -- GARAGE
        -- ======================
        [-1] = {
            bucketReset = true,
            [1] = {
                pos = vec4(-828.502563, -731.570923, 27.055592, 181.596115),
                poly = {
                    center = vector3(-828.502563, -731.570923, 27.055592),
                    length = 2.0,
                    width = 2.0,
                    options = { heading = 181, minZ = 26, maxZ = 31 }
                }
            },
        },

        -- ======================
        -- LOBBY
        -- ======================
        [0] = {
            bucketReset = true,
            [1] = {
                pos = vec4(-819.82, -699.8, 28.07, 90.216),
                poly = {
                    center = vector3(-819.82, -699.8, 28.07),
                    length = 2.0,
                    width = 2.0,
                    options = { heading = 90, minZ = 27, maxZ = 31 }
                }
            },
        },

        -- ======================
        -- FLOORS 1 → 20
        -- ======================
        [1] = { isApartmentFloor = true, [1] = { pos = vec4(-824.11, -717.47, 41.57, 223.66), poly = { center = vector3(-824.11, -717.47, 41.57), length = 2.0, width = 2.0, options = { heading = 223, minZ = 40, maxZ = 44 }}} },
        [2] = { isApartmentFloor = true, [1] = { pos = vec4(-824.11, -717.47, 45.36, 221.24), poly = { center = vector3(-824.11, -717.47, 45.36), length = 2.0, width = 2.0, options = { heading = 221, minZ = 44, maxZ = 48 }}} },
        [3] = { isApartmentFloor = true, [1] = { pos = vec4(-824.10, -717.47, 49.16, 221.29), poly = { center = vector3(-824.10, -717.47, 49.16), length = 2.0, width = 2.0, options = { heading = 221, minZ = 48, maxZ = 52 }}} },
        [4] = { isApartmentFloor = true, [1] = { pos = vec4(-824.09, -717.47, 52.96, 221.34), poly = { center = vector3(-824.09, -717.47, 52.96), length = 2.0, width = 2.0, options = { heading = 221, minZ = 51, maxZ = 55 }}} },
        [5] = { isApartmentFloor = true, [1] = { pos = vec4(-824.08, -717.47, 56.76, 221.75), poly = { center = vector3(-824.08, -717.47, 56.76), length = 2.0, width = 2.0, options = { heading = 221, minZ = 55, maxZ = 59 }}} },
        [6] = { isApartmentFloor = true, [1] = { pos = vec4(-824.07, -717.48, 60.56, 220.95), poly = { center = vector3(-824.07, -717.48, 60.56), length = 2.0, width = 2.0, options = { heading = 220, minZ = 59, maxZ = 63 }}} },
        [7] = { isApartmentFloor = true, [1] = { pos = vec4(-824.06, -717.48, 64.36, 221.71), poly = { center = vector3(-824.06, -717.48, 64.36), length = 2.0, width = 2.0, options = { heading = 221, minZ = 63, maxZ = 67 }}} },
        [8] = { isApartmentFloor = true, [1] = { pos = vec4(-824.06, -717.48, 68.16, 221.38), poly = { center = vector3(-824.06, -717.48, 68.16), length = 2.0, width = 2.0, options = { heading = 221, minZ = 67, maxZ = 71 }}} },
        [9] = { isApartmentFloor = true, [1] = { pos = vec4(-824.32, -717.23, 71.97, 223.36), poly = { center = vector3(-824.32, -717.23, 71.97), length = 2.0, width = 2.0, options = { heading = 223, minZ = 70, maxZ = 74 }}} },
        [10] = { isApartmentFloor = true, [1] = { pos = vec4(-824.27, -717.32, 75.77, 221.08), poly = { center = vector3(-824.27, -717.32, 75.77), length = 2.0, width = 2.0, options = { heading = 221, minZ = 74, maxZ = 78 }}} },
        [11] = { isApartmentFloor = true, [1] = { pos = vec4(-824.20, -717.39, 79.57, 220.42), poly = { center = vector3(-824.20, -717.39, 79.57), length = 2.0, width = 2.0, options = { heading = 220, minZ = 78, maxZ = 82 }}} },
        [12] = { isApartmentFloor = true, [1] = { pos = vec4(-824.12, -717.46, 83.37, 223.31), poly = { center = vector3(-824.12, -717.46, 83.37), length = 2.0, width = 2.0, options = { heading = 223, minZ = 82, maxZ = 86 }}} },
        [13] = { isApartmentFloor = true, [1] = { pos = vec4(-824.05, -717.53, 87.17, 219.96), poly = { center = vector3(-824.05, -717.53, 87.17), length = 2.0, width = 2.0, options = { heading = 219, minZ = 86, maxZ = 90 }}} },
        [14] = { isApartmentFloor = true, [1] = { pos = vec4(-824.05, -717.54, 90.96, 219.93), poly = { center = vector3(-824.05, -717.54, 90.96), length = 2.0, width = 2.0, options = { heading = 219, minZ = 89, maxZ = 93 }}} },
        [15] = { isApartmentFloor = true, [1] = { pos = vec4(-824.04, -717.54, 94.76, 220.04), poly = { center = vector3(-824.04, -717.54, 94.76), length = 2.0, width = 2.0, options = { heading = 220, minZ = 93, maxZ = 97 }}} },
        [16] = { isApartmentFloor = true, [1] = { pos = vec4(-823.97, -717.61, 98.57, 219.73), poly = { center = vector3(-823.97, -717.61, 98.57), length = 2.0, width = 2.0, options = { heading = 219, minZ = 97, maxZ = 101 }}} },
        [17] = { isApartmentFloor = true, [1] = { pos = vec4(-823.96, -717.62, 102.36, 219.90), poly = { center = vector3(-823.96, -717.62, 102.36), length = 2.0, width = 2.0, options = { heading = 219, minZ = 101, maxZ = 105 }}} },
        [18] = { isApartmentFloor = true, [1] = { pos = vec4(-823.95, -717.62, 106.16, 220.07), poly = { center = vector3(-823.95, -717.62, 106.16), length = 2.0, width = 2.0, options = { heading = 220, minZ = 105, maxZ = 109 }}} },
        [19] = { isApartmentFloor = true, [1] = { pos = vec4(-823.88, -717.69, 109.97, 219.83), poly = { center = vector3(-823.88, -717.69, 109.97), length = 2.0, width = 2.0, options = { heading = 219, minZ = 108, maxZ = 112 }}} },
        [20] = { isApartmentFloor = true, [1] = { pos = vec4(-823.81, -717.77, 113.77, 218.50), poly = { center = vector3(-823.81, -717.77, 113.77), length = 2.0, width = 2.0, options = { heading = 218, minZ = 112, maxZ = 116 }}} },
    },
}


-- ====================================
-- Functions and Helpers (NOT CONFIG!)
-- ====================================

local function _getPtXY(pt)
	local x = pt.x or pt[1]
	local y = pt.y or pt[2]
	return x, y
end

local function GetRoomBoxFromPoly(roomData)
	if not roomData.poly or not roomData.poly[1] or not roomData.poly[1][1] then
		return nil
	end

	local pts = roomData.poly[1]
	local minX, maxX = 1e9, -1e9
	local minY, maxY = 1e9, -1e9

	for i = 1, #pts do
		local x, y = _getPtXY(pts[i])
		minX = math.min(minX, x); maxX = math.max(maxX, x)
		minY = math.min(minY, y); maxY = math.max(maxY, y)
	end

	local centerX = (minX + maxX) / 2.0
	local centerY = (minY + maxY) / 2.0
	local length  = math.abs(maxX - minX)
	local width   = math.abs(maxY - minY)

	local centerZ
	if roomData.poly[2] and roomData.poly[2].minZ and roomData.poly[2].maxZ then
		centerZ = (roomData.poly[2].minZ + roomData.poly[2].maxZ) / 2.0
	else
		local de = roomData.zones and roomData.zones.doorEntry
		centerZ = de and de.z or 0.0
	end

	return {
		center = vector3(centerX, centerY, centerZ),
		length = length,
		width  = width,
		heading = 0.0,
		corners = {
			vector2(minX, maxY),
			vector2(maxX, maxY),
			vector2(maxX, minY),
			vector2(minX, minY),
		}
	}
end


local function wrapAngle(a)
	a = a % 360.0
	if a < 0 then a = a + 360.0 end
	return a
end

local function snapCardinal(h)
	h = wrapAngle(h)
	local card = {0, 90, 180, 270}
	local best, diff = 0, 999
	for _, c in ipairs(card) do
		local d = math.abs(h - c)
		d = math.min(d, 360 - d)
		if d < diff then best, diff = c, d end
	end
	return best
end

local function rotate2D(dx, dy, deg)
	local r = math.rad(deg)
	return dx * math.cos(r) - dy * math.sin(r),
		   dx * math.sin(r) + dy * math.cos(r)
end

local function getExtents2D(rawPoly)
	local minX, maxX = 1e9, -1e9
	local minY, maxY = 1e9, -1e9
	for i = 1, 4 do
		local x, y = rawPoly[i][1], rawPoly[i][2]
		minX = math.min(minX, x); maxX = math.max(maxX, x)
		minY = math.min(minY, y); maxY = math.max(maxY, y)
	end
	return minX, maxX, minY, maxY
end

local function approxEq(a, b, eps)
	eps = eps or 0.0005
	return math.abs(a - b) <= eps
end

local function cornerTypeFromPoint(x, y, minX, maxX, minY, maxY)
	local isMinX = approxEq(x, minX) or (math.abs(x - minX) < math.abs(x - maxX))
	local isMaxX = approxEq(x, maxX) or (math.abs(x - maxX) < math.abs(x - minX))
	local isMinY = approxEq(y, minY) or (math.abs(y - minY) < math.abs(y - maxY))
	local isMaxY = approxEq(y, maxY) or (math.abs(y - maxY) < math.abs(y - minY))

	if isMinX and isMaxY then return "NW" end
	if isMaxX and isMaxY then return "NE" end
	if isMaxX and isMinY then return "SE" end
	if isMinX and isMinY then return "SW" end
	return "NW"
end

local function rotateCornerType(t, rot)
	rot = snapCardinal(rot)
	if rot == 0 then
		return t
	elseif rot == 90 then
		if t == "NW" then return "SW" end
		if t == "NE" then return "NW" end
		if t == "SE" then return "NE" end
		if t == "SW" then return "SE" end
	elseif rot == 180 then
		if t == "NW" then return "SE" end
		if t == "NE" then return "SW" end
		if t == "SE" then return "NW" end
		if t == "SW" then return "NE" end
	elseif rot == 270 then
		if t == "NW" then return "NE" end
		if t == "NE" then return "SE" end
		if t == "SE" then return "SW" end
		if t == "SW" then return "NW" end
	end
	return t
end

local function cornerByType(minX, maxX, minY, maxY, t)
	if t == "NW" then return minX, maxY end
	if t == "NE" then return maxX, maxY end
	if t == "SE" then return maxX, minY end
	if t == "SW" then return minX, minY end
	return minX, maxY
end

local function polyFromExtents(minX, maxX, minY, maxY)
	-- UL, UR, DR, DL
	return {
		vector2(minX, maxY),
		vector2(maxX, maxY),
		vector2(maxX, minY),
		vector2(minX, minY),
	}
end

-- Convert hotel rooms to apartment format
function GetApartmentDataFromConfig()
	local apartments = {}

	local H = Config.WiwangHotel
	if not H or not H.doorsF1 or not H.polysF1 or not Config.furniture101 then
		print("[Wiwang] Missing Config.WiwangHotel or Config.furniture101")
		return apartments
	end

	local doorStart = Config.ox_doorlock and Config.ox_doorlock.first or 0
	local doorEnd   = Config.ox_doorlock and Config.ox_doorlock.last or 0
	local totalDoors = (doorEnd - doorStart + 1)
	local totalRooms = (H.totalFloors * H.roomsPerFloor)

	if doorStart > 0 and totalDoors ~= totalRooms then
		print(("[Wiwang] ⚠️ Door range mismatch: doors=%d rooms=%d (first=%d last=%d)"):format(totalDoors, totalRooms, doorStart, doorEnd))
	end

	-- Base room reference (101)
	local BASE_ROOM = 101
	local baseDoor = H.doorsF1[BASE_ROOM]
	local baseDoorCard = snapCardinal(baseDoor.h)

	local basePolyRaw = H.polysF1[BASE_ROOM]
	local bMinX, bMaxX, bMinY, bMaxY = getExtents2D(basePolyRaw)
	local baseThird = basePolyRaw[3]
	local baseCornerType = cornerTypeFromPoint(baseThird[1], baseThird[2], bMinX, bMaxX, bMinY, bMaxY)
	local pivotBaseX, pivotBaseY = cornerByType(bMinX, bMaxX, bMinY, bMaxY, baseCornerType)

	-- Template zones (room 101)
	local tz = H.templateZones101
	local tStash = tz.stash
	local tWardrobe = tz.wardrobe
	local tSpawn = tz.spawn

	local buildingName = H.key
	local buildingLabel = H.label or H.key

	local globalIndex = 0

	for floor = 1, H.totalFloors do
		local zOff = (floor - 1) * H.floorZDelta

		for i = 1, H.roomsPerFloor do
			local room = 100 + i
			local door = H.doorsF1[room]
			local polyRaw = H.polysF1[room]
			if not door or not polyRaw then
				print(("[Wiwang] Missing door/poly for room %d"):format(room))
				goto continue
			end

			globalIndex = globalIndex + 1

			local roomLabel = (floor * 100) + i

			-- doorId mapping: 101 -> first, 2019 -> last
			local doorId = doorStart > 0 and (doorStart + (globalIndex - 1)) or globalIndex

			-- Rotation relative to room 101
			local doorCard = snapCardinal(door.h)
			local rot = wrapAngle(baseDoorCard - doorCard)

			-- Pivot fix (your 3rd-vector2 logic, but correct for 90/270 blocks)
			local minX, maxX, minY, maxY = getExtents2D(polyRaw)
			local needCornerType = rotateCornerType(baseCornerType, rot)
			local pivotX, pivotY = cornerByType(minX, maxX, minY, maxY, needCornerType)

			local function xf(x, y)
				local dx, dy = x - pivotBaseX, y - pivotBaseY
				local rx, ry = rotate2D(dx, dy, rot)
				return pivotX + rx, pivotY + ry
			end

			-- Dynamic poly (same XY as F1, dynamic Z bounds)
			local p = polyFromExtents(minX, maxX, minY, maxY)
			local minZ = (door.z + H.polyMinZOffset) + zOff
			local maxZ = (door.z + H.polyMaxZOffset) + zOff

			-- Dynamic zones from template
			local sx, sy = xf(tStash.x, tStash.y)
			local wx, wy = xf(tWardrobe.x, tWardrobe.y)
			local px, py = xf(tSpawn.x, tSpawn.y)
			local spH = wrapAngle((tSpawn.w or 0.0) + rot)

			local roomData = {
				roomLabel = roomLabel,
				floor = floor,
				type = "regular",
				poly = {
					{ p[1], p[2], p[3], p[4] },
					{ name = tostring(roomLabel), minZ = minZ, maxZ = maxZ }
				},
				zones = {
					doorEntry = vector3(door.x, door.y, door.z + zOff),
					stash = vector3(sx, sy, tStash.z + zOff),
					wardrobe = vector3(wx, wy, tWardrobe.z + zOff),
					spwan = vector4(px, py, tSpawn.z + zOff, spH),
				},
				furniture = {}
			}

			-- Dynamic furniture from Config.furniture101
			for _, f in ipairs(Config.furniture101) do
				local fx, fy = xf(f.x, f.y)
				local fh = wrapAngle((f.h or 0.0) + rot)
				roomData.furniture[#roomData.furniture + 1] = {
					model = f.model,
					x = fx, y = fy, z = (f.z + zOff),
					h = fh
				}
			end

			-- Convert to apartment format (your existing logic)
			local doorEntry = roomData.zones.doorEntry
			local box = GetRoomBoxFromPoly(roomData)
			if not box then goto continue end

			local spawn = roomData.zones.spwan or roomData.zones.spawn
			if not spawn then
				spawn = vector4(doorEntry.x, doorEntry.y, doorEntry.z, 0.0)
			end

			local interiorMinZ = box.center.z - 1.87
			local interiorMaxZ = box.center.z + 1.87

			apartments[#apartments + 1] = {
				name = string.format("%s - Room %s", buildingLabel, roomData.roomLabel),
				buildingName = buildingName,
				buildingLabel = buildingLabel,
				roomLabel = roomData.roomLabel,
				roomId = string.format("%s_%s", buildingName, roomData.roomLabel),

				roomIndex = globalIndex,
				doorId = doorId,

				type = roomData.type,
				floor = roomData.floor,
				invEntity = 13,

				coords = box.center,
				heading = box.heading,
				length = box.length,
				width = box.width,
				options = {
					heading = box.heading,
					minZ = interiorMinZ,
					maxZ = interiorMaxZ,
				},

				furniture = roomData.furniture,

				interior = {
					zone = {
						center = box.center,
						length = box.length,
						width = box.width,
						options = {
							heading = box.heading,
							minZ = interiorMinZ,
							maxZ = interiorMaxZ,
						}
					},

					wakeup = { x = spawn.x, y = spawn.y, z = spawn.z, h = spawn.w or 0.0 },
					spawn  = { x = spawn.x, y = spawn.y, z = spawn.z, h = spawn.w or 0.0 },

					locations = {
						exit = {
							coords = doorEntry,
							length = 0.6,
							width = 1.2,
							options = {
								heading = 0,
								minZ = doorEntry.z - 0.5,
								maxZ = doorEntry.z + 2.0
							}
						},

						wardrobe = roomData.zones.wardrobe and {
							coords = roomData.zones.wardrobe,
							length = 0.6,
							width = 1.2,
							options = {
								heading = 0,
								minZ = roomData.zones.wardrobe.z - 0.5,
								maxZ = roomData.zones.wardrobe.z + 2.0
							}
						} or nil,

						stash = roomData.zones.stash and {
							coords = roomData.zones.stash,
							length = 1.0,
							width = 1.0,
							options = {
								heading = 0,
								minZ = roomData.zones.stash.z - 0.5,
								maxZ = roomData.zones.stash.z + 2.0
							}
						} or nil,

						logout = {
							coords = vector3(spawn.x, spawn.y, spawn.z),
							length = 2.0,
							width = 2.8,
							options = {
								heading = 0,
								minZ = spawn.z - 0.5,
								maxZ = spawn.z + 2.0
							}
						},
					}
				}
			}

			::continue::
		end
	end

	-- Small sanity print only once
	if doorStart > 0 then
		print(("[Wiwang] Built %d apartments. doorId first=%d last=%d (expected last=%d)"):format(
			#apartments, apartments[1].doorId, apartments[#apartments].doorId, doorEnd
		))
	end
	Config.RoomsReady = apartments
	return apartments
end