local QBCore = exports['qb-core']:GetCoreObject()
local ClosestDumpster
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
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

--- Distance Check On Dumpster Props
CreateThread(function()
    local Dumpster
	while true do
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        for i = 1, #Dumpsters do
            Dumpster = GetClosestObjectOfType(PlayerCoords.x , PlayerCoords.y, PlayerCoords.z, 2.0, Dumpsters[i], false, false, false)
            if Dumpster ~= 0 then
                DumpsterCoords = GetEntityCoords(Dumpster)
                if not DoingSomething then
                    if #(PlayerCoords - DumpsterCoords) < 1.8 then
                        NearbyDumpster = true
                        ClosestDumpster = Dumpster
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
                local NetID = NetworkGetEntityIsNetworked(ClosestDumpster) and NetworkGetNetworkIdFromEntity(ClosestDumpster)
                if not NetID then
                    NetworkRegisterEntityAsNetworked(ClosestDumpster)
                    NetID = NetworkGetNetworkIdFromEntity(ClosestDumpster)
                    NetworkUseHighPrecisionBlending(NetID, false)
                    SetNetworkIdExistsOnAllMachines(NetID, true)
                    SetNetworkIdCanMigrate(NetID, true)
                    print(NetworkGetEntityIsNetworked(ClosestDumpster), NetworkGetNetworkIdFromEntity(ClosestDumpster))
                end
                QBCore.Functions.TriggerCallback('dc-dumpsters:callback:checkCoords', function(CoordX, CoordY)
                    TriggerEvent("inventory:client:SetCurrentStash", "Dumpster | "..CoordX.." | "..CoordY)
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", "Dumpster | "..CoordX.." | "..CoordY, {
                        maxweight = Weight,
                        slots = Slots,
                    })
                end, NetID)
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
