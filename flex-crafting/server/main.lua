local QBCore = exports['qb-core']:GetCoreObject()
local benches = {}

function is_array(table)
    if type(table) ~= 'table' then
      return false
    end
  
    -- objects always return empty size
    if #table > 0 then
      return true
    end
  
    -- only object can have empty length with elements inside
    for k, v in pairs(table) do
      return false
    end
  
    -- if no elements it can be array and not at same time
    return true
end

function listContains(items, item)
    for i = 1, #items do
        if items[i] == item then
            return true, i
        end
    end
    return false
end

for k, v in pairs(Config.benches) do
    QBCore.Functions.CreateUseableItem(v.benchitem, function(source,item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local benchId = #benches + 1
        if item.info ~= nil then
            if item.info.blueprints ~= nil and item.info.benchhealth ~= nil then
                benches[benchId] = {}
                benches[benchId].benchtype = v.benchitem
                local array = item.info.blueprints or {}
                if (not tonumber(item.info.blueprints) or tonumber(item.info.blueprints) == nil) and not is_array(item.info.blueprints) then
                    array = json.decode(item.info.blueprints)
                end
                
                benches[benchId].blueprints = array
                benches[benchId].benchhealth = item.info.benchhealth
                benches[benchId].item = item
                benches[benchId].owner = Player.PlayerData.citizenid
                benches[benchId].coords = GetEntityCoords(GetPlayerPed(src))
                TriggerClientEvent('flex-crafting:client:placebench', source, v.benchitem, item, benchId)
            end
        else
            benches[benchId] = {}
            local bluepr = {}
            benches[benchId].benchtype = v.benchitem
            benches[benchId].blueprints = bluepr
            benches[benchId].benchhealth = 100
            benches[benchId].item = item
            benches[benchId].owner = Player.PlayerData.citizenid
            benches[benchId].coords = GetEntityCoords(GetPlayerPed(src))
            TriggerClientEvent('flex-crafting:client:placebench', source, v.benchitem, item, benchId)
        end
        -- TriggerClientEvent('flex-crafting:client:updateBenches', -1, benches)
    end)
end

QBCore.Functions.CreateUseableItem(Config.blueprintitem, function(source,item)
    TriggerClientEvent('flex-crafting:client:useblueprint', source, item, item.info.item)
end)

QBCore.Functions.CreateCallback('flex-crafting:server:isOwner', function(source, cb, id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    if benches[id].owner == citizenid then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('flex-crafting:server:canCraft', function(source, cb, materials)
    local src = source
    local hasItems = false
    local idk = 0
    local player = QBCore.Functions.GetPlayer(source)
    for k, v in pairs(materials) do
        if player.Functions.GetItemByName(v.item) and player.Functions.GetItemByName(v.item).amount >= v.amount then
            idk = idk + 1
            if idk == #materials then
                cb(true)
            end
        else
            cb(false)
            return
        end
    end
end)

QBCore.Functions.CreateCallback('flex-crafting:server:canRepair', function(source, cb, materials)
    local src = source
    local hasItems = false
    local idk = 0
    local player = QBCore.Functions.GetPlayer(source)
    for k, v in pairs(materials) do
        if player.Functions.GetItemByName(v.item) and player.Functions.GetItemByName(v.item).amount >= v.amount then
            idk = idk + 1
            if idk == #materials then
                cb(true)
            end
        else
            cb(false)
            return
        end
    end
end)

RegisterNetEvent('flex-crafting:server:updateBenches', function()
    TriggerClientEvent('flex-crafting:client:updateBenches', -1, benches)
end)

RegisterNetEvent('flex-crafting:server:updateBenchCoords', function(benchId, coords)
    benches[benchId].coords = coords
    TriggerClientEvent('flex-crafting:client:updateBenches', -1, benches)
end)

RegisterNetEvent('flex-crafting:server:updateBenchHealth', function(benchId, loss)
    benches[benchId].benchhealth = benches[benchId].benchhealth - loss
    TriggerClientEvent('flex-crafting:client:updateBenches', -1, benches)
end)

RegisterNetEvent('flex-crafting:server:useBluePrint', function(benchId, itemname, uses)
    benches[benchId].blueprints[itemname] = uses
    TriggerClientEvent('flex-crafting:client:updateBenches', -1, benches)
end)

RegisterNetEvent('flex-crafting:server:updatePrintUses', function(benchesid, uses, itemname, item)
    if uses ~= nil then
        if uses - 1 <= 0 then
            local inlist, id = listContains(benches[benchesid].blueprints, itemname)
            if inlist then
                table.remove(benches[benchesid].blueprints, id)
                benches[benchesid].blueprints[item] = nil
            end
        else
            benches[benchesid].blueprints[item] = uses - 1
        end
    end
    TriggerClientEvent('flex-crafting:client:updateBenches', -1, benches)
end)

RegisterNetEvent('flex-crafting:server:removeBench', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item.name, 1, item.slot)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item.name], "remove")
end)

RegisterNetEvent('flex-crafting:server:addBench', function(item, id)
    benches[id] = nil
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item.name, 1, item.slot)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item.name], "add")
end)

RegisterNetEvent('flex-crafting:server:removeblueprint', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item.name, 1, item.slot)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item.name], "remove")
end)

RegisterNetEvent('flex-crafting:server:removeItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player == nil then return end
    if Player.Functions.RemoveItem(item, amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount)
    end
end)

RegisterNetEvent('flex-crafting:server:giveItem', function(item, amount, itemtype, bench)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = nil
    if Config.benches[bench].crafting[item].info then
        info = Config.benches[bench].crafting[item].info
    end
    Player.Functions.AddItem(item, amount, false, info)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add", amount)
end)

RegisterNetEvent('flex-crafting:server:givebench', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    for k, v in pairs(benches) do
        if v.owner == citizenid then
            local info = {
                blueprints = json.encode(v.blueprints),
                benchhealth = v.benchhealth
            }
            Player.Functions.AddItem(v.benchtype, 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.benchtype], "add")
            table.remove(benches, k)
            TriggerClientEvent('flex-crafting:client:updateBenches', -1, benches)
            break
        end
    end
end)

function GiveBluePrint(id, i, chance)
    local src = id
    local player = QBCore.Functions.GetPlayer(src)
    if math.random(1, 100) <= chance then
        local info = {item = i, itemname = QBCore.Shared.Items[i].label}
        if player.Functions.AddItem(Config.blueprintitem, 1, false, info) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.blueprintitem], 'add')
        end
    end
end
exports('GiveBluePrint', GiveBluePrint)

QBCore.Commands.Add('giveprint', Lang:t("command.testcommamd"), {{name = 'PlayerID', help = 'ID'}, {name = 'itemname', help = 'Name of the craftitem'}}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local info = {
        item = args[2],
        itemname = QBCore.Shared.Items[args[2]].label
    }
    Player.Functions.AddItem(Config.blueprintitem, 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox',Player.PlayerData.source, QBCore.Shared.Items[Config.blueprintitem], "add")
end, 'admin')