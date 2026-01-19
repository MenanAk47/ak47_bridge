Bridge.Notify = function(source, msg, type, duration)
    TriggerClientEvent('ak47_bridge:client:Notify', source, msg, type, duration)
end

lib.callback.register('ak47_bridge:callback:server:GetTargetMetaValue', function( source, target, type )
    return Bridge.GetPlayerMetaValue(target, type)
end)