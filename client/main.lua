local QBCore = exports['qb-core']:GetCoreObject()

-- Distance Check On Dumpster Prop
CreateThread(function()
	while true do
        local WaitTime = 900
        if not (NearbyDumpster2 or NearbyDumpster3 or NearbyDumpster4 or NearbyDumpster5 or NearbyDumpster6) then 
            WaitTime = 400
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            Dumpster1 = GetClosestObjectOfType(PlayerCoords, 2.0, 218085040, false, false, false)
            if Dumpster1 ~= 0 then
                Dumpster1Coords = GetEntityCoords(Dumpster1)
                if not DoingSomething then 
                    if #(PlayerCoords - Dumpster1Coords) < 1.8 then
                        NearbyDumpster1 = true
                    else 
                        NearbyDumpster1 = false
                    end 
                else
                    NearbyDumpster1 = false
                end
            end
        end
        Wait(WaitTime)
	end
end)

CreateThread(function()
	while true do
        local WaitTime = 900
        if not (NearbyDumpster1 or NearbyDumpster3 or NearbyDumpster4 or NearbyDumpster5 or NearbyDumpster6) then 
            WaitTime = 400
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            Dumpster2 = GetClosestObjectOfType(PlayerCoords, 2.0, 666561306, false, false, false)
            if Dumpster2 ~= 0 then
                Dumpster2Coords = GetEntityCoords(Dumpster2)
                if not DoingSomething then 
                    if #(PlayerCoords - Dumpster2Coords) < 1.8 then
                        NearbyDumpster2 = true
                    else 
                        NearbyDumpster2 = false
                    end 
                else
                    NearbyDumpster2 = false
                end
            end
        end
        Wait(WaitTime)
	end
end)

CreateThread(function()
	while true do
        local WaitTime = 900
        if not (NearbyDumpster1 or NearbyDumpster2 or NearbyDumpster4 or NearbyDumpster5 or NearbyDumpster6) then 
            WaitTime = 400
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            Dumpster3 = GetClosestObjectOfType(PlayerCoords, 2.0, -58485588, false, false, false)
            if Dumpster3 ~= 0 then
                Dumpster3Coords = GetEntityCoords(Dumpster3)
                if not DoingSomething then 
                    if #(PlayerCoords - Dumpster3Coords) < 1.8 then
                        NearbyDumpster3 = true
                    else 
                        NearbyDumpster3 = false
                    end 
                else
                    NearbyDumpster3 = false
                end
            end
        end
        Wait(WaitTime)
	end
end)

CreateThread(function()
	while true do
        local WaitTime = 900
        if not (NearbyDumpster1 or NearbyDumpster2 or NearbyDumpster3 or NearbyDumpster5 or NearbyDumpster6) then 
            WaitTime = 400
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            Dumpster4 = GetClosestObjectOfType(PlayerCoords, 2.0, -206690185, false, false, false)
            if Dumpster4 ~= 0 then
                Dumpster4Coords = GetEntityCoords(Dumpster4)
                if not DoingSomething then 
                    if #(PlayerCoords - Dumpster4Coords) < 1.8 then
                        NearbyDumpster4 = true
                    else 
                        NearbyDumpster4 = false
                    end 
                else
                    NearbyDumpster4 = false
                end
            end
        end
        Wait(WaitTime)
	end
end)

CreateThread(function()
	while true do
        local WaitTime = 900
        if not (NearbyDumpster1 or NearbyDumpster2 or NearbyDumpster3 or NearbyDumpster4 or NearbyDumpster6) then 
            WaitTime = 400
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            Dumpster5 = GetClosestObjectOfType(PlayerCoords, 2.0, 1511880420, false, false, false)
            if Dumpster5 ~= 0 then
                Dumpster5Coords = GetEntityCoords(Dumpster5)
                if not DoingSomething then 
                    if #(PlayerCoords - Dumpster5Coords) < 1.8 then
                        NearbyDumpster5 = true
                    else 
                        NearbyDumpster5 = false
                    end 
                else
                    NearbyDumpster5 = false
                end
            end
        end
        Wait(WaitTime)
	end
end)

CreateThread(function()
	while true do
        local WaitTime = 900
        if not (NearbyDumpster1 or NearbyDumpster2 or NearbyDumpster3 or NearbyDumpster4 or NearbyDumpster5) then 
            WaitTime = 400
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            Dumpster6 = GetClosestObjectOfType(PlayerCoords, 2.0, 682791951, false, false, false)
            if Dumpster6 ~= 0 then
                Dumpster6Coords = GetEntityCoords(Dumpster6)
                if not DoingSomething then 
                    if #(PlayerCoords - Dumpster6Coords) < 1.8 then
                        NearbyDumpster6 = true
                    else 
                        NearbyDumpster6 = false
                    end 
                else
                    NearbyDumpster6 = false
                end
            end
        end
        Wait(WaitTime)
	end
end)

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

CreateThread(function()
	while true do
        local WaitTime = 400
        if NearbyDumpster1 then
            WaitTime = 3
            DrawText3D(Dumpster1Coords.x, Dumpster1Coords.y, Dumpster1Coords.z + 1, "~o~E~w~ - Search Dumpster")
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('qb-dumpsters:timer:check', Dumpster1Coords.x, Dumpster1Coords.y, Dumpster1Coords.z)
            end
        end
        if NearbyDumpster2 then
            WaitTime = 3
            DrawText3D(Dumpster2Coords.x, Dumpster2Coords.y, Dumpster2Coords.z + 1, "~o~E~w~ - Search Dumpster")
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('qb-dumpsters:timer:check', Dumpster2Coords.x, Dumpster2Coords.y, Dumpster2Coords.z)
            end
        end
        if NearbyDumpster3 then
            WaitTime = 3
            DrawText3D(Dumpster3Coords.x, Dumpster3Coords.y, Dumpster3Coords.z + 1, "~o~E~w~ - Search Dumpster")
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('qb-dumpsters:timer:check', Dumpster3Coords.x, Dumpster3Coords.y, Dumpster3Coords.z)
            end
        end
        if NearbyDumpster4 then
            WaitTime = 3
            DrawText3D(Dumpster4Coords.x, Dumpster4Coords.y, Dumpster4Coords.z + 1, "~o~E~w~ - Search Dumpster")
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('qb-dumpsters:timer:check', Dumpster4Coords.x, Dumpster4Coords.y, Dumpster4Coords.z)
            end
        end
        if NearbyDumpster5 then
            WaitTime = 3
            DrawText3D(Dumpster5Coords.x, Dumpster5Coords.y, Dumpster5Coords.z + 1, "~o~E~w~ - Search Dumpster")
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('qb-dumpsters:timer:check', Dumpster5Coords.x, Dumpster5Coords.y, Dumpster5Coords.z)
            end
        end
        if NearbyDumpster6 then
            WaitTime = 3
            DrawText3D(Dumpster6Coords.x, Dumpster6Coords.y, Dumpster6Coords.z + 1, "~o~E~w~ - Search Dumpster")
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('qb-dumpsters:timer:check', Dumpster6Coords.x, Dumpster6Coords.y, Dumpster6Coords.z)
            end
        end
        Wait(WaitTime)
    end
end)

local function StartSearching()
    QBCore.Functions.Progressbar("searching_dumpster", "Searching Dumpster", math.random(3000, 6000), false, true, {
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
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('qb-dumpsters:search:complete')
    end, function()
        DoingSomething = false
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify("Canceled", "error")
    end)
end

RegisterNetEvent('qb-dumpsters:search:start', function()
    DoingSomething = true
    StartSearching()
end)
