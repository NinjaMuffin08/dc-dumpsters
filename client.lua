local QBCore = exports['qb-core']:GetCoreObject()
local Dumpster
local DumpsterCoords
local NearbyDumpster
local Dumpsters = {
    218085040,
    666561306,
    -58485588,
    -206690185,
    1511880420,
    682791951
}
local Slots = 20
local Weight = 100000

--- Standard function to show 3DText on the client.
local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

--- Standard function to round a number.
local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

--- Distance Check On Dumpster Props
CreateThread(function()
	while true do
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        for i = 1, #Dumpsters do
            Dumpster = GetClosestObjectOfType(PlayerCoords, 2.0, Dumpsters[i], true)
            if Dumpster ~= 0 then
                DumpsterCoords = GetEntityCoords(Dumpster)
                if not DoingSomething then
                    if #(PlayerCoords - DumpsterCoords) < 1.8 then
                        NearbyDumpster = true
                    else 
                        NearbyDumpster = false
                    end 
                else
                    NearbyDumpster = false
                end
            end
        end
        Wait(600)
	end
end)

--- Check for keypresses when nearby a dumpster.
CreateThread(function()
	while true do
        local WaitTime = 350
        if NearbyDumpster then
            WaitTime = 0
            DrawText3D(DumpsterCoords.x, DumpsterCoords.y, DumpsterCoords.z + 1, "~o~E~w~ - Search Dumpster")
            DrawText3D(DumpsterCoords.x, DumpsterCoords.y, DumpsterCoords.z + 0.80, "~o~G~w~ - Open Dumpster")
            if IsControlJustReleased(0, 38) and not DoingSomething then
                DoingSomething = true
                TriggerServerEvent('qb-dumpsters:search:check', DumpsterCoords)
            elseif IsControlJustReleased(0, 47) and not DoingSomething then
                if DumpsterCoords.x < 0 then DumpsterX = -DumpsterCoords.x else DumpsterX = DumpsterCoords.x end
                if DumpsterCoords.y < 0 then DumpsterY = -DumpsterCoords.y else DumpsterY = DumpsterCoords.y end
                DumpsterX = round(DumpsterX, 1)
                DumpsterY = round(DumpsterY, 1)
                TriggerEvent("inventory:client:SetCurrentStash", "Dumpster | "..DumpsterX.." | "..DumpsterY)
                TriggerServerEvent("inventory:server:OpenInventory", "stash", "Dumpster | "..DumpsterX.." | "..DumpsterY, {
                    maxweight = Weight,
                    slots = Slots,
                })
            end
        end
        Wait(WaitTime)
    end
end)

RegisterNetEvent('qb-dumpsters:search:start', function(RandomTimer)
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar("searching_dumpster", "Searching Dumpster", RandomTimer, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@',
        anim = 'weed_crouch_checkingleaves_idle_01_inspector',
        flags = 16,
    }, {}, {}, function() -- Done
        DoingSomething = false
        ClearPedTasks(ped)
    end, function()
        DoingSomething = false
        ClearPedTasks(ped)
        TriggerServerEvent('qb-dumpsters:search:cancel')
    end)
end)
