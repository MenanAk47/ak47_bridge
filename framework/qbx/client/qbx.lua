if Config.Framework == 'auto' and GetResourceState('qbx_core') == 'missing' then return end
if Config.Framework ~= 'auto' and Config.Framework ~= 'qbx' then return end
Config.Framework = 'qbx'

print(string.format("^2['FRAMEWORK']: %s^0", Config.Framework))

Bridge = {}
Integration = {}

PlayerData = {}
PlayerLoaded = false

-- ====================================================================================
--                                     EVENTS
-- ====================================================================================

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = exports.qbx_core:GetPlayerData()
    PlayerLoaded = true
    TriggerEvent('ak47_bridge:OnPlayerLoaded', PlayerData)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    TriggerEvent('ak47_bridge:OnJobUpdate', job)
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    Functions.HasAnyItemRemoved(PlayerData.items, val.items)
    PlayerData = val
    TriggerEvent('ak47_bridge:OnPlayerDataUpdate', PlayerData)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local data = exports.qbx_core:GetPlayerData()
        if data and data.job then
            PlayerData = data
            PlayerLoaded = true
        end
    end
    if PlayerLoaded then
        TriggerEvent('ak47_bridge:OnPlayerLoaded', PlayerData)
    end
end)

-- ====================================================================================
--                                     FUNCTIONS
-- ====================================================================================

Bridge.GetJob = function()
    if not PlayerData or not PlayerData.job then return nil end
    return PlayerData.job
end

exports('GetBridge', function()
    return Bridge
end)