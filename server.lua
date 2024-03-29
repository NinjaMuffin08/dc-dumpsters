local QBCore = exports['qb-core']:GetCoreObject()
local DumpsterSearched = {}
local PreviousDumpster = {}
local Cancelled = {}
local ExistingDumpsters = {}
-- seconds
local RestartTimer = 15
-- true , give items inside of an inventory box | false , give item directly
local RewardInventory = true
local Loot = {
    ['tier1'] = {
        'plastic',
        'metalscrap',
        'copper',
        'aluminum',
        'iron',
        'steel',
        'glass',
        'tosti'
    },
    ['tier2'] = {
        'rolex',
        'diamond_ring',
        'goldchain',
        'cryptostick',
        'vodka',
        'bandage'
    },
    ['tier3'] = {
        'snspistol_part_1',
        'snspistol_part_2',
        'snspistol_part_3',
        'painkillers'
    }
}

local function CreateLog(id, source, Player)
    local Log = {
        [1] = 'Tried to search a dumpster too far away. [Log #1]',
        [2] = 'Tried to search a dumpster that is too close to his previous one. [Log #2]',
    }
    if not Log[id] then TriggerEvent('qb-log:server:CreateLog', 'dumpsters', 'Dumpsters', 'green', 'Tried to create a log which doesn\'t exist. #'..id) print('Tried to create a log which doesn\'t exist. #'..id) return end
    TriggerEvent('qb-log:server:CreateLog', 'dumpsters', 'Dumpsters', 'green', string.format("**%s** (CitizenID: %s | ID: %s) - %s", GetPlayerName(source), Player.PlayerData.citizenid, source, Log[id]))
end

local function RestartDumpster(DumpsterCoordsX, DumpsterCoordsY)
    local EndTime = os.time() + RestartTimer

    while os.time() < EndTime do
        Wait(1000)
    end

    for i = 1, #DumpsterSearched do
        if not DumpsterSearched[i] then return end
        if DumpsterSearched[i].x == DumpsterCoordsX and DumpsterSearched[i].y == DumpsterCoordsY then
            table.remove(DumpsterSearched, i)
            break
        end
    end
end

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function HasSearched(DumpsterCoordsX, DumpsterCoordsY)
    for i = 1, #DumpsterSearched do 
        if DumpsterSearched[i].x == DumpsterCoordsX and DumpsterSearched[i].y == DumpsterCoordsY then return true end
    end
    return false
end

local function GetTier(Chance)
    if Chance <= 80 then return 'tier1'
    elseif Chance <= 98 then return 'tier2' end
    return 'tier3'
end

local function GetAmount(Tier)
    if Tier == 'tier1' then return math.random(3, 10)
    elseif Tier == 'tier2' then return math.random(1, 4) end
    return math.random(1, 2)
end

RegisterNetEvent('qb-dumpsters:search:check', function(DumpsterCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local DumpsterCoordsX = round(DumpsterCoords.x, 3)
    local DumpsterCoordsY = round(DumpsterCoords.y, 3)
    local DumpsterCoordsZ = round(DumpsterCoords.z, 3)
    local RandomTimer = math.random(3000, 6000)

    if #(PlayerCoords - vector3(DumpsterCoordsX, DumpsterCoordsY, DumpsterCoordsZ)) > 3 then CreateLog(1, src, Player) return end

    TriggerClientEvent('qb-dumpsters:search:start', src, RandomTimer)
    SetTimeout(RandomTimer - 50, function()
        if HasSearched(DumpsterCoordsX, DumpsterCoordsY) then TriggerClientEvent('QBCore:Notify', src, 'It seems like this one has already been searched', 'error') return end
        if not PreviousDumpster[src] then PreviousDumpster[src] = DumpsterCoords
        elseif (#(PreviousDumpster[src] - DumpsterCoords) < 0.8) and not PreviousDumpster[src] == DumpsterCoords then CreateLog(2, src, Player) return end
        if Cancelled[src] then Cancelled[src] = false return end

        DumpsterSearched[#DumpsterSearched + 1] = {x = DumpsterCoordsX, y = DumpsterCoordsY}
        PreviousDumpster[src] = DumpsterCoords

        if not RewardInventory then
            for i = 1, 3 do
                local Tier = GetTier(math.random(1, 100))
                local Item = Loot[Tier][math.random(1, #Loot[Tier])]
                local Amount = GetAmount(Tier)
                Player.Functions.AddItem(Item, Amount)
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Item], "add")
                TriggerEvent('qb-log:server:CreateLog', 'dumpsters', 'Dumpsters', 'green', string.format("**%s** (CitizenID: %s | ID: %s) - Found %sx %s. Player: %s Dumpster: %s", GetPlayerName(src), Player.PlayerData.citizenid, src, Amount, QBCore.Shared.Items[Item].name, PlayerCoords, DumpsterCoords))
            end
        else
            local RandomName = "Dumpster"..math.random(1, 999)
            local Dumpster = {}
            Dumpster.name = "trunk-"..RandomName
            Dumpster.label = RandomName
            Dumpster.maxweight = 8000
            Dumpster.slots = 5
            Dumpster.inventory = {}
            TriggerEvent('inventory:server:addTrunkItems', RandomName, {})
            for i = 1, 3 do
                local Tier = GetTier(math.random(1, 100))
                local Item = Loot[Tier][math.random(1, #Loot[Tier])]
                local Amount = GetAmount(Tier)
                local itemInfo = QBCore.Shared.Items[Item]
                if itemInfo then
                    Dumpster.inventory[i] = {
                            name = itemInfo["name"],
                            amount = Amount,
                            info = "",
                            label = itemInfo["label"],
                            description = itemInfo["description"] or "",
                            weight = itemInfo["weight"],
                            type = itemInfo["type"],
                            unique = itemInfo["unique"],
                            useable = itemInfo["useable"],
                            image = itemInfo["image"],
                            slot = i,
                    }
                end
                TriggerEvent('qb-log:server:CreateLog', 'dumpsters', 'Dumpsters', 'green', string.format("**%s** (CitizenID: %s | ID: %s) - Created %sx %s inside of %s. Player: %s Dumpster: %s", GetPlayerName(src), Player.PlayerData.citizenid, src, Amount, QBCore.Shared.Items[Item].name, RandomName, PlayerCoords, DumpsterCoords))
            end
            TriggerEvent('inventory:server:addTrunkItems', RandomName, Dumpster.inventory)
            Wait(20)
            TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items, Dumpster)
        end
        RestartDumpster(DumpsterCoordsX, DumpsterCoordsY)
    end)
end)

RegisterNetEvent('qb-dumpsters:search:cancel', function()
    Cancelled[source] = true
    TriggerClientEvent('QBCore:Notify', source, 'Cancelled', 'error')
end)

QBCore.Functions.CreateCallback('dc-dumpsters:callback:checkCoords', function(_, cb, NetID)
    if not DoesEntityExist(NetworkGetEntityFromNetworkId(NetID)) then return end -- add model checking if you want
    if ExistingDumpsters[NetID] then
        cb(ExistingDumpsters[NetID].x, ExistingDumpsters[NetID].y)
    else
        local Coords = GetEntityCoords(NetworkGetEntityFromNetworkId(NetID))
        local DumpsterX, DumpsterY
        if Coords.x < 0 then DumpsterX = -Coords.x else DumpsterX = Coords.x end
        if Coords.y < 0 then DumpsterY = -Coords.y else DumpsterY = Coords.y end
        ExistingDumpsters[NetID] = {
            x = round(DumpsterX, 1),
            y = round(DumpsterY, 1)
        }
        cb(ExistingDumpsters[NetID].x, ExistingDumpsters[NetID].y)
    end
end)
