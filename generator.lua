-- =========================================================
-- ONE-TIME WIWANG HOTEL ROOMS GENERATOR (SERVER)
-- FIXED ROTATION + CORRECT PIVOT FOR 90/270 ROOMS
-- OUTPUT INDENTATION: TABS (\t)
-- =========================================================

local HOTEL_KEY		= "map_wiwang_hotel"
local HOTEL_LABEL	= "Wiwang Hotel"
local OUTPUT_FILE	= "generated_hotel_room1s.lua"

local TOTAL_FLOORS		= 20
local ROOMS_PER_FLOOR	= 19

-- Your floors look ~3.80 apart (2->5 are basically perfect)
local FLOOR_Z_DELTA		= 3.800017

-- These match your printed poly minZ/maxZ ranges much better than the old hardcoded 40.58/44.28
-- door.z (41.6748) + (-4.5) ~ 37.17
-- door.z (41.6748) + ( 3.1) ~ 44.77
local POLY_MINZ_OFFSET	= -4.5
local POLY_MAXZ_OFFSET	=  3.1

local DEBUG_PIVOT		= true

-- =======================
-- HELPERS
-- =======================
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

local function getExtents2D(p)
	local minX, maxX = 1e9, -1e9
	local minY, maxY = 1e9, -1e9
	for i = 1, 4 do
		minX = math.min(minX, p[i][1])
		maxX = math.max(maxX, p[i][1])
		minY = math.min(minY, p[i][2])
		maxY = math.max(maxY, p[i][2])
	end
	return minX, maxX, minY, maxY
end

-- Snap points to perfect rectangle corners, keep original order (you already had this)
local function perfectPolySnapKeepOrder(p)
	local minX, maxX, minY, maxY = getExtents2D(p)

	local out = {}
	for i = 1, 4 do
		local x, y = p[i][1], p[i][2]
		out[i] = {
			(math.abs(x - minX) < math.abs(x - maxX)) and minX or maxX,
			(math.abs(y - minY) < math.abs(y - maxY)) and minY or maxY
		}
	end
	return out
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

	-- Prefer exact-ish logic first
	if isMinX and isMaxY then return "NW" end
	if isMaxX and isMaxY then return "NE" end
	if isMaxX and isMinY then return "SE" end
	if isMinX and isMinY then return "SW" end

	-- Fallback (shouldn’t happen with snapped rects)
	return "NW"
end

local function rotateCornerType(t, rot)
	rot = snapCardinal(rot)
	if rot == 0 then
		return t
	elseif rot == 90 then
		-- CCW 90: NW->SW, NE->NW, SE->NE, SW->SE
		if t == "NW" then return "SW" end
		if t == "NE" then return "NW" end
		if t == "SE" then return "NE" end
		if t == "SW" then return "SE" end
	elseif rot == 180 then
		-- 180: NW->SE, NE->SW, SE->NW, SW->NE
		if t == "NW" then return "SE" end
		if t == "NE" then return "SW" end
		if t == "SE" then return "NW" end
		if t == "SW" then return "NE" end
	elseif rot == 270 then
		-- CCW 270: NW->NE, NE->SE, SE->SW, SW->NW
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

local function fmt(n) return string.format("%.6f", n) end
local function v2(x,y) return ("vector2(%s,%s)"):format(fmt(x),fmt(y)) end
local function v3(x,y,z) return ("vector3(%s,%s,%s)"):format(fmt(x),fmt(y),fmt(z)) end
local function v4(x,y,z,w) return ("vector4(%s,%s,%s,%s)"):format(fmt(x),fmt(y),fmt(z),fmt(w)) end

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

-- =======================
-- TEMPLATE ROOM 101
-- =======================
local TEMPLATE = {
	zones = {
		doorEntry = {x=-825.86615,y=-724.61096,z=41.67480},
		stash     = {x=-822.21552,y=-727.82898,z=41.60931},
		wardrobe  = {x=-823.19684,y=-725.73248,z=41.60931},
		spwan     = {x=-825.480591,y=-726.738281,z=41.10820,w=2.03113}, -- vec4(-825.480591, -726.738281, 42.103451, 2.031133)
	},
	furniture = {
		{model="apa_mp_h_bed_double_08",x=-826.54333,y=-727.75256,z=40.44465,h=90},
		{model="apa_mp_h_acc_artwalll_03",x=-826.57959,y=-727.75348,z=41.04229,h=90},
		{model="v_res_fh_sidebrdlngb",x=-821.56641,y=-727.81500,z=40.44465,h=270},
		{model="bkr_prop_fakeid_desklamp_01a",x=-821.65228,y=-726.55292,z=41.41795,h=261},
		{model="v_res_mplanttongue",x=-826.16156,y=-730.14709,z=40.56965,h=261},
		{model="apa_mp_h_acc_rugwoolm_03",x=-822.97424,y=-727.75323,z=40.56965,h=0},
		{model="prop_ld_suitcase_02",x=-821.61499,y=-724.99438,z=40.56965,h=0},
		{model="prop_ld_suitcase_02",x=-821.60004,y=-725.28082,z=40.56965,h=0},
		{model="hei_p_attache_case_shut",x=-821.79553,y=-725.70380,z=40.60929,h=275},
		{model="v_res_tre_wardrobe",x=-823.20563,y=-725.11786,z=40.56965,h=0},
	}
}

-- =======================
-- GENERATOR COMMAND
-- =======================
RegisterCommand("gen_wiwang_hotelrooms", function()
	local out = {}
	local function push(line) out[#out+1] = line end

	-- Base (Room 101) reference
	local BASE_ROOM = 101
	local baseDoor = DOORS_F1[BASE_ROOM]
	local baseDoorCard = snapCardinal(baseDoor.h)

	-- IMPORTANT: use the 3rd vector2 of room 101 poly to define the "base pivot corner type"
	local basePolyRaw = POLYS_F1[BASE_ROOM]
	local bMinX, bMaxX, bMinY, bMaxY = getExtents2D(basePolyRaw)
	local baseThird = basePolyRaw[3]
	local baseCornerType = cornerTypeFromPoint(baseThird[1], baseThird[2], bMinX, bMaxX, bMinY, bMaxY)

	-- And the actual base pivot coordinate (from extents + that corner type)
	local pivotBaseX, pivotBaseY = cornerByType(bMinX, bMaxX, bMinY, bMaxY, baseCornerType)

	if DEBUG_PIVOT then
		print(("[WIWANG GEN] BaseRoom=%d baseDoorCard=%d basePoly[3]=%.3f,%.3f baseCornerType=%s pivotBase=%.3f,%.3f"):format(
			BASE_ROOM, baseDoorCard, baseThird[1], baseThird[2], baseCornerType, pivotBaseX, pivotBaseY
		))
	end

	push("Config.HotelRooms = Config.HotelRooms or {}")
	push(("Config.HotelRooms[%q] = {"):format(HOTEL_KEY))
	push(("\tlabel = %q,"):format(HOTEL_LABEL))

	local idx = 1

	for floor = 1, TOTAL_FLOORS do
		local zOff = (floor - 1) * FLOOR_Z_DELTA

		for i = 1, ROOMS_PER_FLOOR do
			local room = 100 + i
			local door = DOORS_F1[room]
			local polyRaw = POLYS_F1[room]
			if door and polyRaw then
				local doorCard = snapCardinal(door.h)

				-- Your original rotation style, but generalized (baseDoorCard could be non-zero)
				local rot = wrapAngle(baseDoorCard - doorCard)

				-- Snap poly for output (same as before)
				local poly = perfectPolySnapKeepOrder(polyRaw)

				-- Compute rect extents from raw (or snapped, both work)
				local minX, maxX, minY, maxY = getExtents2D(polyRaw)

				-- This is the FIX:
				-- Determine which corner SHOULD be the pivot in this room (rotated from baseCornerType)
				local needCornerType = rotateCornerType(baseCornerType, rot)
				local pivotX, pivotY = cornerByType(minX, maxX, minY, maxY, needCornerType)

				-- For proof/debug: what corner is this room's polyRaw[3] actually?
				if DEBUG_PIVOT and floor == 1 and room >= 108 then
					local t3 = polyRaw[3]
					local t3type = cornerTypeFromPoint(t3[1], t3[2], minX, maxX, minY, maxY)
					print(("[WIWANG GEN] Room=%d doorCard=%d rot=%d baseCorner=%s needCorner=%s | thisPoly[3]=%s -> usingPivot=%s"):format(
						room, doorCard, snapCardinal(rot), baseCornerType, needCornerType, t3type, needCornerType
					))
				end

				-- Transform template XY using pivotBase -> pivot
				local function xf(x,y)
					local dx, dy = x - pivotBaseX, y - pivotBaseY
					local rx, ry = rotate2D(dx, dy, rot)
					return pivotX + rx, pivotY + ry
				end

				local roomLabel = floor * 100 + i

				-- Z bounds derived from door.z (better match to your logs)
				local minZ = (door.z + POLY_MINZ_OFFSET) + zOff
				local maxZ = (door.z + POLY_MAXZ_OFFSET) + zOff

				-- precompute zones
				local sx, sy = xf(TEMPLATE.zones.stash.x, TEMPLATE.zones.stash.y)
				local wx, wy = xf(TEMPLATE.zones.wardrobe.x, TEMPLATE.zones.wardrobe.y)
				local px, py = xf(TEMPLATE.zones.spwan.x, TEMPLATE.zones.spwan.y)
				local spH = wrapAngle(TEMPLATE.zones.spwan.w + rot)

				push(("\t[%d] = {"):format(idx))
				push(("\t\troomLabel = %d,"):format(roomLabel))
				push(("\t\tfloor = %d,"):format(floor))
				push(("\t\ttype = 'regular',"))
				push(("\t\tpoly = {"))
				push(("\t\t\t{"))
				push(("\t\t\t\t%s,"):format(v2(poly[1][1], poly[1][2])))
				push(("\t\t\t\t%s,"):format(v2(poly[2][1], poly[2][2])))
				push(("\t\t\t\t%s,"):format(v2(poly[3][1], poly[3][2])))
				push(("\t\t\t\t%s,"):format(v2(poly[4][1], poly[4][2])))
				push(("\t\t\t},"))
				push(("\t\t\t{ name = %q, minZ = %.6f, maxZ = %.6f }"):format(tostring(roomLabel), minZ, maxZ))
				push(("\t\t},"))

				push(("\t\tzones = {"))
				push(("\t\t\tdoorEntry = %s,"):format(v3(door.x, door.y, door.z + zOff)))
				push(("\t\t\tstash = %s,"):format(v3(sx, sy, TEMPLATE.zones.stash.z + zOff)))
				push(("\t\t\twardrobe = %s,"):format(v3(wx, wy, TEMPLATE.zones.wardrobe.z + zOff)))
				push(("\t\t\tspwan = %s,"):format(v4(px, py, TEMPLATE.zones.spwan.z + zOff, spH)))
				push(("\t\t},"))

				push(("\t\tfurniture = {"))
				for _, f in ipairs(TEMPLATE.furniture) do
					local fx, fy = xf(f.x, f.y)
					local fh = wrapAngle(f.h + rot)
					push(("\t\t\t{ model = %q, x = %.6f, y = %.6f, z = %.6f, h = %.6f },"):format(
						f.model, fx, fy, f.z + zOff, fh
					))
				end
				push(("\t\t},"))

				push(("\t},"))
				idx = idx + 1
			else
				print(("[WIWANG GEN] Missing door or poly for room %d"):format(room))
			end
		end
	end

	push("}")
	SaveResourceFile(GetCurrentResourceName(), OUTPUT_FILE, table.concat(out, "\n"), -1)
	print(("Wiwang Hotel rooms generated successfully. (%d rooms)"):format(idx - 1))
end, true)



-- =========================================================
-- ONE-TIME WIWANG HOTEL OX_DOORLOCK SQL GENERATOR (SERVER)
-- Generates floors 2..20 based on floor 1 door coords (Z + 3.800017 per floor)
-- Output file: server/generated_ox_doorlocks_wiwang_hotel.sql
-- INDENTATION: TABS
-- =========================================================

-- local OUTPUT_SQL		= "server/generated_ox_doorlocks_wiwang_hotel.sql"

-- local TOTAL_FLOORS		= 20
-- local ROOMS_PER_FLOOR	= 19

-- local FLOOR_Z_DELTA		= 3.800017

-- -- You already inserted floor 1 (101..119), so generate "other 19 floors" by default:
-- local START_FLOOR		= 1	-- change to 1 if you want to regenerate everything

-- local DOOR_MODEL			= -138454175
-- local DEFAULT_STATE			= 1
-- local DEFAULT_MAX_DISTANCE	= 2
-- local DEFAULT_DOORS			= false

-- -- =======================
-- -- DOORS FLOOR 1 (BASE)
-- -- =======================
-- local DOORS_F1 = {
-- 	[101]={x=-825.866150,y=-724.610962,z=41.674801,h=0},
-- 	[102]={x=-831.466309,y=-724.610962,z=41.674801,h=0},
-- 	[103]={x=-837.066101,y=-724.610962,z=41.674801,h=0},
-- 	[104]={x=-842.666260,y=-724.610962,z=41.674801,h=0},
-- 	[105]={x=-838.819702,y=-721.389587,z=41.674801,h=180},
-- 	[106]={x=-833.219543,y=-721.389587,z=41.674801,h=180},
-- 	[107]={x=-827.619507,y=-721.389587,z=41.674801,h=180},
-- 	[108]={x=-819.983154,y=-704.988525,z=41.674801,h=270},
-- 	[109]={x=-819.983154,y=-699.388672,z=41.674801,h=270},
-- 	[110]={x=-819.983154,y=-693.788818,z=41.674801,h=270},
-- 	[111]={x=-819.983154,y=-688.188843,z=41.674801,h=270},
-- 	[112]={x=-819.983154,y=-682.588867,z=41.674801,h=270},
-- 	[113]={x=-816.609619,y=-686.526245,z=41.674801,h=90},
-- 	[114]={x=-816.609619,y=-692.126282,z=41.674801,h=90},
-- 	[115]={x=-816.609619,y=-697.726257,z=41.674801,h=90},
-- 	[116]={x=-816.609619,y=-703.326294,z=41.674801,h=90},
-- 	[117]={x=-816.609619,y=-708.926270,z=41.674801,h=90},
-- 	[118]={x=-816.609619,y=-714.526245,z=41.674801,h=90},
-- 	[119]={x=-816.569580,y=-720.126282,z=41.674801,h=90},
-- }

-- -- =======================
-- -- HELPERS
-- -- =======================
-- local function wrapAngle(a)
-- 	a = a % 360.0
-- 	if a < 0 then a = a + 360.0 end
-- 	return a
-- end

-- local function snapCardinal(h)
-- 	h = wrapAngle(h)
-- 	local card = {0, 90, 180, 270}
-- 	local best, diff = 0, 999
-- 	for _, c in ipairs(card) do
-- 		local d = math.abs(h - c)
-- 		d = math.min(d, 360 - d)
-- 		if d < diff then best, diff = c, d end
-- 	end
-- 	return best
-- end

-- -- keep enough precision to match your DB style
-- local function f15(n) return string.format("%.15f", n) end
-- local function f8(n)  return string.format("%.8f", n) end

-- local function buildJson(heading, x, y, z)
-- 	-- JSON string exactly like your samples (keys order doesn’t matter, but we’ll keep it consistent)
-- 	return string.format(
-- 		'{"heading":%d,"coords":{"x":%s,"y":%s,"z":%s},"state":%d,"maxDistance":%d,"doors":%s,"model":%d}',
-- 		heading,
-- 		f15(x),
-- 		f15(y),
-- 		f15(z),
-- 		DEFAULT_STATE,
-- 		DEFAULT_MAX_DISTANCE,
-- 		DEFAULT_DOORS and "true" or "false",
-- 		DOOR_MODEL
-- 	)
-- end

-- -- =======================
-- -- COMMAND
-- -- =======================
-- RegisterCommand("gen_wiwang_doorlocks_sql", function()
-- 	local out = {}
-- 	local function push(line) out[#out+1] = line end

-- 	push("-- =========================================================")
-- 	push("-- WIWANG HOTEL: OX_DOORLOCK GENERATED INSERTS")
-- 	push(("-- Floors: %d -> %d (base is floor 1)"):format(START_FLOOR, TOTAL_FLOORS))
-- 	push(("-- Rooms per floor: %d | Z delta per floor: %.6f"):format(ROOMS_PER_FLOOR, FLOOR_Z_DELTA))
-- 	push("-- =========================================================")
-- 	push("")
-- 	push("START TRANSACTION;")
-- 	push("")

-- 	local total = 0

-- 	for floor = START_FLOOR, TOTAL_FLOORS do
-- 		local zOff = (floor - 1) * FLOOR_Z_DELTA

-- 		for i = 1, ROOMS_PER_FLOOR do
-- 			local baseRoom = 100 + i		-- 101..119
-- 			local door = DOORS_F1[baseRoom]
-- 			if door then
-- 				local roomLabel = floor * 100 + i	-- 201..219, 301..319, ... 2001..2019
-- 				local name = ("hotel@room_%d"):format(roomLabel)

-- 				local heading = snapCardinal(door.h)
-- 				local x, y, z = door.x, door.y, (door.z + zOff)

-- 				local data = buildJson(heading, x, y, z)

-- 				-- IMPORTANT: omit `id` so AUTO_INCREMENT handles it
-- 				-- Tabs for indentation:
-- 				push(("\tINSERT INTO `ox_doorlock` (`name`, `data`) VALUES ('%s', '%s');"):format(name, data))

-- 				total = total + 1
-- 			else
-- 				print(("[WIWANG DOORLOCK GEN] Missing DOORS_F1[%d]"):format(baseRoom))
-- 			end
-- 		end

-- 		push("")
-- 	end

-- 	push("COMMIT;")
-- 	push("")

-- 	SaveResourceFile(GetCurrentResourceName(), OUTPUT_SQL, table.concat(out, "\n"), -1)
-- 	print(("[WIWANG DOORLOCK GEN] Done: wrote %d inserts to %s"):format(total, OUTPUT_SQL))
-- end, true)
