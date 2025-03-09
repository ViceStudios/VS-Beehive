local QBCore = exports['qb-core']:GetCoreObject()

local HiveCooldown = {}
for i, _ in pairs(Config.Hives) do
    HiveCooldown[i] = false
end

local SoldToday = {}

RegisterNetEvent('qb-beehive:server:HarvestHoney', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local ped = GetPlayerPed(src)
    local pCoords = GetEntityCoords(ped)
    local hiveId = nil
    for i, hive in pairs(Config.Hives) do
        if #(pCoords - hive.coords) < 2.0 then
            hiveId = i
            break
        end
    end
    if not hiveId then
        return
    end

    if HiveCooldown[hiveId] then
        TriggerClientEvent('QBCore:Notify', src, "This hive has no more honey right now. Try again later.", "error")
        return
    end

    HiveCooldown[hiveId] = true
    TriggerClientEvent('qb-beehive:client:SetHiveCooldown', -1, hiveId, true)

    local amount = math.random(Config.HarvestAmount.min, Config.HarvestAmount.max)
    Player.Functions.AddItem("honey", amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["honey"], 'add', amount)
    TriggerClientEvent('QBCore:Notify', src, "You collected " .. amount .. "x Honey", "success")

    SetTimeout(Config.HiveCooldown * 1000, function()
        HiveCooldown[hiveId] = false
        TriggerClientEvent('qb-beehive:client:SetHiveCooldown', -1, hiveId, false)
    end)
end)

RegisterNetEvent('qb-beehive:server:SellHoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local ped = GetPlayerPed(src)
    local pCoords = GetEntityCoords(ped)
    local sellDist = #(pCoords - vector3(Config.SellerLocation.x, Config.SellerLocation.y, Config.SellerLocation.z))
    if sellDist > 5.0 then
        TriggerClientEvent('QBCore:Notify', src, "You must be at the honey vendor to sell honey.", "error")
        return
    end

    local honeyItem = Player.Functions.GetItemByName("honey")
    if not honeyItem or honeyItem.amount < 1 then
        TriggerClientEvent('QBCore:Notify', src, "You have no honey to sell.", "error")
        return
    end

    local totalHoney = honeyItem.amount
    local sellAmount = totalHoney
    local pricePerUnit = Config.HoneyPrice

    if Config.DailySellLimit > 0 then
        local cid = Player.PlayerData.citizenid
        if not SoldToday[cid] then SoldToday[cid] = 0 end

        local limitRemaining = Config.DailySellLimit - SoldToday[cid]
        if limitRemaining <= 0 then
            TriggerClientEvent('QBCore:Notify', src, "You've reached the daily selling limit for honey.", "error")
            return
        end

        if sellAmount > limitRemaining then
            sellAmount = limitRemaining
        end
    end

    if sellAmount > 0 then
        Player.Functions.RemoveItem("honey", sellAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["honey"], 'remove', sellAmount)
        local earnings = sellAmount * pricePerUnit
        Player.Functions.AddMoney("cash", earnings, "sold-honey")
        TriggerClientEvent('QBCore:Notify', src, "Sold " .. sellAmount .. "x Honey for $" .. earnings, "success")

        if Config.DailySellLimit > 0 then
            local cid = Player.PlayerData.citizenid
            SoldToday[cid] = (SoldToday[cid] or 0) + sellAmount
        end
    end
end)
