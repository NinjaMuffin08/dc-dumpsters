local QBCore = exports['qb-core']:GetCoreObject()
local DumpsterSearched = {}
local Searching = {}

local function StartedSearching(source)
    local Exists = false
    for i = 1, #Searching do 
        if Searching[i].Id == source then
            Exists = true
            Searching[i].Started = true
            break
        end
    end
    if not Exists then
        Searching[#Searching + 1] = {Id = source, Started = true}
    end
end

local function RestartDumpster(DumpsterCoordsX, DumpsterCoordsY)
    local Done = false
    Timer = Config.replenishtimer
    while Timer >= 1 do
        Timer = Timer - 1
        Wait(1000)
    end
    
    if Timer == 0 then
        for i = 1, #DumpsterSearched do
            if Done then
                break
            end
            if i then
                if DumpsterSearched[i].x == DumpsterCoordsX and DumpsterSearched[i].y == DumpsterCoordsY then
                    DumpsterSearched[i] = nil
                    Done = true
                end
            end
        end
    end
end

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function HasSearched(DumpsterCoordsX, DumpsterCoordsY)
    local Has = false
    for i = 1, #DumpsterSearched do 
        if DumpsterSearched[i].x == DumpsterCoordsX and DumpsterSearched[i].y == DumpsterCoordsY then 
            Has = true
        end
    end
    return Has
end

local function CreateLog(id, source, Player)
    local notifications = {
        [1] = function()
            TriggerEvent('qb-log:server:CreateLog', 'dumpster', 'Dumpster Search', 'red', '**'..GetPlayerName(source)..'** (CitizenID: '..Player.PlayerData.citizenid..' | ID: '..source..')  Tried to search a dumpster too far away. **qb-dumpsters:timer:check**')
        end,
        [2] = function()
            TriggerEvent('qb-log:server:CreateLog', 'dumpster', 'Dumpster Search', 'red', '**'..GetPlayerName(source)..'** (CitizenID: '..Player.PlayerData.citizenid..' | ID: '..source..')  Tried to finish a dumpster he shouldn\'t be finishing. **qb-dumpsters:search:complete**')
        end
    }
    local type = notifications[id]
	if type then
		type()
	else
		print("qb-dumpsters something is wrong with the logs")
	end
end

RegisterNetEvent('qb-dumpsters:timer:check', function(DumpsterCoordsX, DumpsterCoordsY, DumpsterCoordsZ)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local DumpsterCoordsX = round(DumpsterCoordsX, 2)
    local DumpsterCoordsY = round(DumpsterCoordsY, 2)
    local DumpsterCoordsZ = round(DumpsterCoordsZ, 2)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))

    if #(PlayerCoords - vector3(DumpsterCoordsX, DumpsterCoordsY, DumpsterCoordsZ)) > 3 then CreateLog(1, src, Player) return end
    if HasSearched(DumpsterCoordsX, DumpsterCoordsY) then TriggerClientEvent('QBCore:Notify', src, 'It seems like this one has already been searched', 'error', 3000) return end
    
    StartedSearching(src)
    DumpsterSearched[#DumpsterSearched + 1] = {x = DumpsterCoordsX, y = DumpsterCoordsY}
    TriggerClientEvent('qb-dumpsters:search:start', src)
    RestartDumpster(DumpsterCoordsX, DumpsterCoordsY)
end)

local function HasStartedSearching(source)
    local Has = false
    for i = 1, #Searching do 
        if Searching[i].Id == source and Searching[i].Started then
            Has = true
            Searching[i].Started = false
            break
        end
    end
    return Has
end

local function GetTier(Chance)
    local Tier = nil
    if Chance <= 80 then
        Tier = 'tier1'
    elseif Chance <= 95 then 
        Tier = 'tier2'
    else
        Tier = 'tier3'
    end
    return Tier
end

local function GetAmount(Tier)
    local Amount = nil
    if Tier == 'tier1' then
        Amount = math.random(3, 12)
    elseif Tier == 'tier2' then 
        Amount = math.random(1, 4)
    else
        Amount = math.random(1, 2)
    end
    return Amount
end

RegisterNetEvent('qb-dumpsters:search:complete', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Chance = math.random(1, 100)
    local Tier = GetTier(Chance)
    local Item = Config.loot[Tier][math.random(1, #Config.loot[Tier])]
    local Amount = GetAmount(Tier)

    if not HasStartedSearching(src) then CreateLog(2, src, Player) return end

    Player.Functions.AddItem(Item, Amount)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Item], "add")
end)
