local QBCore = exports['qb-core']:GetCoreObject()
local HiveStates = {}

for i, hive in pairs(Config.Hives) do
    HiveStates[i] = { onCooldown = false }
end

CreateThread(function()
    local model = GetHashKey(Config.SellerPedModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local coords = Config.SellerLocation
    local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "server",
                event = "qb-beehive:server:SellHoney",
                icon = "fas fa-dollar-sign",
                label = "Sell Honey",
                canInteract = function(entity, distance, data)
                    if QBCore.Functions.HasItem("honey") then
                        return true
                    else
                        return false
                    end
                end
            }
        },
        distance = 2.5
    })
end)

CreateThread(function()
    for i, hive in pairs(Config.Hives) do
        local zoneName = "beehive_" .. i
        exports['qb-target']:AddCircleZone(zoneName, hive.coords, 1.0, {
            name = zoneName, debugPoly = false
        }, {
            options = {
                {
                    type = "server",
                    event = "qb-beehive:server:HarvestHoney",
                    icon = "fas fa-hand",
                    label = "Harvest Honey",
                    canInteract = function(entity, distance, data)
                        return (HiveStates[i] and not HiveStates[i].onCooldown)
                    end
                }
            },
            distance = 1.5
        })
    end
end)

RegisterNetEvent('qb-beehive:client:SetHiveCooldown', function(hiveId, onCooldown)
    if HiveStates[hiveId] then
        HiveStates[hiveId].onCooldown = onCooldown
    end
end)
