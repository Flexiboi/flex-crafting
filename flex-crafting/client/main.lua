local QBCore = exports['qb-core']:GetCoreObject()
local canplacebench = true
local placedbench, crafting, benchprop = false, false, nil
local benches = {}

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(50)
    end
end

function listContains(items, item)
    for i = 1, #items do
        if items[i] == item then
            return true, i
        end
    end
    return false
end

function listIndex(items, item)
    local i = 0
    for k, v in pairs(items) do
        i += 1
        if k == item then
            return i
        end
        if #items == i then
            return false
        end
    end
end

function playanim(animdic, anim)
    local ped = PlayerPedId()
    loadAnimDict(animdic)
    TaskPlayAnim(ped, animdic, anim, 1.0, -1.0,-1,1,0,0, 0,0)
    Wait(GetAnimDuration(animdic, anim) * 1000)
    ClearPedTasksImmediately(ped)
end

function DeleteBench(prop)
    if DoesEntityExist(prop) then
        playanim('random@domestic', 'pickup_low')
        DeleteEntity(prop)
        TriggerServerEvent('flex-crafting:server:givebench')
        placedbench, crafting, benchprop = false, false, nil
    end
end

function BenchDied()
    if DoesEntityExist(benchprop) then
        DeleteEntity(benchprop)
        TriggerServerEvent('flex-crafting:server:givebench')
        placedbench, crafting, benchprop = false, false, nil
    end
end

function OpenCraft(benchid, id)
    local columns = {
        {
            header = "Craften",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(benches[id].blueprints) do
        if Config.benches[benchid].crafting[k] then
            local i = Config.benches[benchid].crafting[k]
            local uses = Lang:t("info.crafting.infinite")
            if tonumber(v) > 0 then
                uses = v
            end
            local item = {}
            item.header = "<img src=nui://"..Config.inventorylink..QBCore.Shared.Items[i.itemname].image.." width=35px style='margin-right: 10px'> " .. i.label
            local text = ""
            for k, v in pairs(i.materials) do
                if QBCore.Shared.Items[v.item] then
                    text = text .. "- " .. QBCore.Shared.Items[v.item].label .. ": " .. v.amount .. "<br>"
                else
                    print('ERROR 404 '..v.item..' typo')
                end
            end
            text = text..Lang:t("info.crafting.uses")..tostring(uses)..'<br>'
            text = text..Lang:t("info.crafting.youget")..tostring(i.amount)..'<br>'
            item.text = text
            item.params = {
                event = 'flex-crafting:client:craft',
                args = {
                    benchesid = id,
                    id = k,
                    bench = benchid,
                    item = i.itemname,
                    itemtype = i.itemtype,
                    maxuses = tonumber(uses)
                }
            }
            table.insert(columns, item)
        end
    end

    exports['qb-menu']:openMenu(columns)
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    QBCore.Functions.Notify(Lang:t("success.grabbench"), "success", 5000)
    DeleteBench(benchprop)
end)

local function RepairBench(benchtype)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if tonumber(benchhealth) >= 100 then
        QBCore.Functions.Notify(Lang:t("success.alreadymaxhealth"), 'success', 5000)
        return
    end
    QBCore.Functions.TriggerCallback("flex-crafting:server:canRepair", function(hasMaterials)
        if not (hasMaterials) then
            QBCore.Functions.Notify(Lang:t("error.notenoughtorepair"), 'error', 5000)
            for k, v in pairs(Config.benches[benchtype].repaircost) do
                QBCore.Functions.Notify(Lang:t("error.youdonthave")..v.amount..' x '..QBCore.Shared.Items[v.item].name, 'error', 5000)
            end
            return
        end
        SetPedCanPlayAmbientAnims(ped, true) 
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_HAMMERING', 0, false)
        QBCore.Functions.Progressbar('repair_bench', Lang:t("info.repairingworkbench"), Config.benches[benchtype].benchrepairtime * 1000, false, false, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {animDict = nil,anim = nil}, {}, {}, function() -- Success
            QBCore.Functions.Notify(Lang:t("success.repairedbench"), 'success')
            benchhealth = 100
            for _, v in pairs(Config.benches[benchtype].repaircost) do
                TriggerServerEvent('flex-crafting:server:removeItem', v.item, v.amount)
            end
            local hammer = GetClosestObjectOfType(pos.x, pos.y, pos.z, 5.0, GetHashKey('prop_tool_hammer'), false, true ,true)
            if DoesEntityExist(hammer) then
                SetEntityAsMissionEntity(hammer, false, false)
                DeleteObject(hammer)
            end
            ClearPedTasksImmediately(ped)
        end, function() -- Cancel
            local hammer = GetClosestObjectOfType(pos.x, pos.y, pos.z, 5.0, GetHashKey('prop_tool_hammer'), false, true ,true)
            if DoesEntityExist(hammer) then
                SetEntityAsMissionEntity(hammer, false, false)
                DeleteObject(hammer)
            end
            ClearPedTasksImmediately(ped)
            QBCore.Functions.Notify(Lang:t("error.stoppedrepairbench"), 'error', 5000)
        end)
    end, Config.benches[benchtype].repaircost)
end

local sleep = 1000
CreateThread(function()
    while true do
        Wait(sleep)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for k, v in pairs(benches) do
            local distance = #(v.coords - pos)
            local closestVehicle, closestDistance = QBCore.Functions.GetClosestVehicle(pos)
            if closestDistance < 3 then
                QBCore.Functions.TriggerCallback("flex-crafting:server:isOwner", function(isOwner)
                    if isOwner then
                        QBCore.Functions.Notify(Lang:t("error.cartoclose"), "error", 5000)
                        DeleteBench(benchprop)
                    end
                end, k)
            elseif distance >= 6 then
                QBCore.Functions.TriggerCallback("flex-crafting:server:isOwner", function(isOwner)
                    if isOwner then
                        DeleteBench(benchprop)
                    end
                end, k)
            elseif tonumber(v.benchhealth) <= 0 then
                QBCore.Functions.TriggerCallback("flex-crafting:server:isOwner", function(isOwner)
                    if isOwner then
                        QBCore.Functions.Notify(Lang:t("error.benchbroke"), "error", 5000)
                        BenchDied()
                    end
                end, k)
            end
            if not v.coords then return end
            if distance < 6 then
                -- Draw Interaction Text above bench
                QBCore.Functions.DrawText3D(v.coords.x, v.coords.y, v.coords.z+0.6+Config.benches[v.benchtype].text3dYoffset, '~o~'..Lang:t("text.benchhealth")..'~w~: '..v.benchhealth..'%')
                QBCore.Functions.DrawText3D(v.coords.x, v.coords.y, v.coords.z+0.5+Config.benches[v.benchtype].text3dYoffset, '[~o~E~w~] '..Lang:t("text.craft")..' [~o~G~w~] '..Lang:t("text.takebench")..' [~o~H~w~] '..Lang:t("text.repair"))
                
                if IsControlJustReleased(0, 38) then -- E
                    OpenCraft(v.benchtype, k)
                elseif IsControlJustReleased(0, 47) then -- G
                    QBCore.Functions.TriggerCallback("flex-crafting:server:isOwner", function(isOwner)
                        if isOwner then
                            QBCore.Functions.Notify(Lang:t("success.grabbench"), "success", 5000)
                            DeleteBench(benchprop)
                        else
                            QBCore.Functions.Notify(Lang:t("error.notowner"), "error", 5000)
                        end
                    end, k)
                elseif IsControlJustReleased(0, 101) then -- H
                    RepairBench(v.benchtype)
                end
                sleep = 1
            else
                sleep = 1000
            end
        end
    end
end)

RegisterNetEvent('flex-crafting:client:useblueprint', function(item, itemname)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for k, v in pairs(benches) do
        local distance = #(v.coords - pos)
        if distance < 2 then
            LocalPlayer.state:set('inv_busy', true, true)
            playanim("misscarsteal4@aliens", "rehearsal_base_idle_director")
            if Config.benches[v.benchtype].crafting[itemname] ~= nil then
                local inlist, id = listContains(v.blueprints, itemname)
                if not inlist then
                    QBCore.Functions.Progressbar("learnblueprint", Lang:t('info.useblueprint'), 1000 * 8, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "mini@repair",
                        anim = "fixing_a_player",
                        flags = 49,
                    }, {}, {}, function()
                        -- table.insert(blueprints, itemname)
                        -- blueprints[itemname] = Config.benches[benchtype].crafting[itemname].uses
                        TriggerServerEvent('flex-crafting:server:useBluePrint', k, itemname, Config.benches[v.benchtype].crafting[itemname].uses)
                        QBCore.Functions.Notify(Lang:t("success.usedblueprint"), "success", 5000)
                        TriggerServerEvent('flex-crafting:server:removeblueprint', item)
                        LocalPlayer.state:set('inv_busy', false, true)
                    end, function()
                        TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
                        LocalPlayer.state:set('inv_busy', false, true)
                    end)
                    break
                else
                    LocalPlayer.state:set('inv_busy', false, true)
                    QBCore.Functions.Notify(Lang:t("error.alreadyonit"), "error", 5000)
                    break
                end
            else
                LocalPlayer.state:set('inv_busy', false, true)
                QBCore.Functions.Notify(Lang:t("error.error404"), "error", 5000)
            end
        end
        if k == #benches then 
            if distance > 3 and distance ~= nil then
                LocalPlayer.state:set('inv_busy', false, true)
                QBCore.Functions.Notify(Lang:t("error.cantuseblueprint"), "error", 5000)
            else
                QBCore.Functions.Notify(Lang:t("info.needworkbench"), "info", 5000)
            end
            return
        end
    end
end)

RegisterNetEvent('flex-crafting:client:placebench', function(id, itemdata, benchId)
    TriggerServerEvent('flex-crafting:server:removeBench', itemdata)
    if placedbench then 
        TriggerServerEvent('flex-crafting:server:addBench', itemdata, benchId)
        return QBCore.Functions.Notify(Lang:t("error.alreadyplaced"), "error", 5000)
    end
    LocalPlayer.state:set('inv_busy', false, true)
    local ped = PlayerPedId()
    local pos, heading = GetEntityCoords(ped), GetEntityHeading(ped)
    if not canplacebench then
        TriggerServerEvent('flex-crafting:server:addBench', itemdata, benchId)
        return QBCore.Functions.Notify(Lang:t("error.notvalidplace"), "error", 5000)
    end
    -- if pos.z < Config.undergroundZcheck then return QBCore.Functions.Notify(Lang:t("error.notvalidplace"), "error", 5000) end
    if Config.benches[id] ~= nil then
        crafting = true
        local closestVehicle, closestDistance = QBCore.Functions.GetClosestVehicle(pos)
        if closestDistance > 10 then
            canplacebench = false
            PlaceObject(Config.benches[id].model, function(pPlaced, pCoords, pHeading)
                if pPlaced then
                    benchprop = CreateObject(Config.benches[id].model, pCoords.x, pCoords.y, pCoords.z, true, true, true)
                    PlaceObjectOnGroundProperly(benchprop)
                    SetEntityHeading(benchprop, pHeading)
                    FreezeEntityPosition(benchprop, true)
                    TriggerServerEvent('flex-crafting:server:updateBenchCoords', benchId, GetEntityCoords(benchprop))
                    QBCore.Functions.Notify(Lang:t("success.placedbench"), "success", 5000)
                    placedbench = true
                    canplacebench = true
                    TriggerServerEvent('flex-crafting:server:updateBenches')
                else
                    canplacebench = true
                    TriggerServerEvent('flex-crafting:server:addBench', itemdata, benchId)
                end
            end)
        else
            TriggerServerEvent('flex-crafting:server:addBench', itemdata, benchId)
            QBCore.Functions.Notify(Lang:t("error.cartoclose"), "error", 5000)
        end
    end
end)

RegisterNetEvent('flex-crafting:client:updateBenches', function(bnchs)
    benches = bnchs
end)

local function craft(item, matid, bench, itemtype, uses, benchesid)
    local ped = PlayerPedId()
    local propcoords = GetEntityCoords(benchprop)
    QBCore.Functions.FaceToPos(propcoords.x, propcoords.y, propcoords.z)
    QBCore.Functions.Progressbar('crafting_item', Lang:t("info.crafting", {value = Config.benches[bench].crafting[matid].label}), Config.benches[bench].crafting[matid].crafttime * 1000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        QBCore.Functions.Notify(Lang:t("success.crafted", {value = Config.benches[bench].crafting[matid].label}), 'success')
        if math.random(0, 100) <= Config.benches[bench].benchbreakchance then
            TriggerServerEvent('flex-crafting:server:updateBenchHealth', benchesid, Config.benches[bench].benchbreakpercent)
        end
        for k, v in pairs(Config.benches[bench].crafting[matid].materials) do
            TriggerServerEvent('flex-crafting:server:removeItem', v.item, v.amount)
        end
        TriggerServerEvent('flex-crafting:server:updatePrintUses', benchesid, uses, itemname, item)
        TriggerServerEvent('flex-crafting:server:giveItem', item, Config.benches[bench].crafting[matid].amount, itemtype, bench)
        ClearPedTasks(ped)
    end, function() -- Cancel
        ClearPedTasks(ped)
        QBCore.Functions.Notify(Lang:t("error.stoppedcrafting"), 'error', 5000)
    end)
end

RegisterNetEvent('flex-crafting:client:craft', function(data)
    QBCore.Functions.TriggerCallback("flex-crafting:server:canCraft", function(hasMaterials)
        if (hasMaterials) then
            craft(data.item, data.id, data.bench, data.itemtype, data.maxuses, data.benchesid)
        else
            QBCore.Functions.Notify(Lang:t("error.notenoughtmats"), "error", 5000)
            return
        end
    end, Config.benches[data.bench].crafting[data.id].materials)
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
		if DoesEntityExist(benchprop) then
            QBCore.Functions.Notify(Lang:t("success.grabbench"), "success", 5000)
            DeleteEntity(benchprop)
            TriggerServerEvent('flex-crafting:server:givebench')
            placedbench, crafting, benchprop = false, false, nil
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName == GetCurrentResourceName()) then
        LocalPlayer.state:set('inv_busy', false, false)
    end
end)

-- EXPORTS
local function BenchPlaceState(state)
	canplacebench = state
	return canplacebench
end

exports("BenchPlaceState", BenchPlaceState)