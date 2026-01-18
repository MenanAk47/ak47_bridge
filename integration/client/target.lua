local function convert(options)
    local distance = options.distance
    options = options.options

    for k, v in pairs(options) do
        if type(k) ~= 'number' then
            table.insert(options, v)
        end
    end

    for id, v in pairs(options) do
        if type(id) ~= 'number' then
            options[id] = nil
            goto continue
        end

        v.onSelect = v.action
        v.distance = v.distance or distance
        v.name = v.name or v.label
        v.items = v.item
        v.icon = v.icon
        v.groups = v.job

        local groupType = type(v.groups)
        if groupType == 'nil' then
            v.groups = {}
            groupType = 'table'
        end
        if groupType == 'string' then
            local val = v.gang
            if type(v.gang) == 'table' then
                if table.type(v.gang) ~= 'array' then
                    val = {}
                    for k in pairs(v.gang) do
                        val[#val + 1] = k
                    end
                end
            end

            if val then
                v.groups = {v.groups, type(val) == 'table' and table.unpack(val) or val}
            end

            val = v.citizenid
            if type(v.citizenid) == 'table' then
                if table.type(v.citizenid) ~= 'array' then
                    val = {}
                    for k in pairs(v.citizenid) do
                        val[#val+1] = k
                    end
                end
            end

            if val then
                v.groups = {v.groups, type(val) == 'table' and table.unpack(val) or val}
            end
        elseif groupType == 'table' then
            local val = {}
            if table.type(v.groups) ~= 'array' then
                for k in pairs(v.groups) do
                    val[#val + 1] = k
                end
                v.groups = val
                val = nil
            end

            val = v.gang
            if type(v.gang) == 'table' then
                if table.type(v.gang) ~= 'array' then
                    val = {}
                    for k in pairs(v.gang) do
                        val[#val + 1] = k
                    end
                end
            end

            if val then
                v.groups = {table.unpack(v.groups), type(val) == 'table' and table.unpack(val) or val}
            end

            val = v.citizenid
            if type(v.citizenid) == 'table' then
                if table.type(v.citizenid) ~= 'array' then
                    val = {}
                    for k in pairs(v.citizenid) do
                        val[#val+1] = k
                    end
                end
            end

            if val then
                v.groups = {table.unpack(v.groups), type(val) == 'table' and table.unpack(val) or val}
            end
        end

        if type(v.groups) == 'table' and table.type(v.groups) == 'empty' then
            v.groups = nil
        end

        if v.event and v.type and v.type ~= 'client' then
            if v.type == 'server' then
                v.serverEvent = v.event
            elseif v.type == 'command' then
                v.command = v.event
            end

            v.event = nil
            v.type = nil
        end

        v.action = nil
        v.job = nil
        v.gang = nil
        v.citizenid = nil
        v.item = nil
        v.qtarget = true

        ::continue::
    end

    return options
end

Bridge.AddBoxZone = function(name, center, length, width, options, targetoptions)
    if GetResourceState('ox_target') == 'started' then
        local z = center.z
        if not options.minZ then options.minZ = -100 end
        if not options.maxZ then options.maxZ = 800 end
        if not options.useZ then
            z = z + math.abs(options.maxZ - options.minZ) / 2
            center = vec3(center.x, center.y, z)
        end
        return exports.ox_target:addBoxZone({
            name = name,
            coords = center,
            size = vec3(width, length, (options.useZ or not options.maxZ) and center.z or math.abs(options.maxZ - options.minZ)),
            debug = options.debugPoly,
            rotation = options.heading,
            options = convert(targetoptions),
        })
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddBoxZone(name, center, length, width, options, targetoptions)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddBoxZone(name, center, length, width, options, targetoptions)
    end
end

Bridge.AddPolyZone = function(name, points, options, targetoptions)
    if GetResourceState('ox_target') == 'started' then
        local newPoints = table.create(#points, 0)
        local thickness = math.abs(options.maxZ - options.minZ)
        for i = 1, #points do
            local point = points[i]
            newPoints[i] = vec3(point.x, point.y, options.maxZ - (thickness / 2))
        end
        return exports.ox_target:addPolyZone({
            name = name,
            points = newPoints,
            thickness = thickness,
            debug = options.debugPoly,
            options = convert(targetoptions),
        })
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddPolyZone(name, points, options, targetoptions)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddPolyZone(name, points, options, targetoptions)
    end
end

Bridge.AddCircleZone = function(name, center, radius, options, targetoptions)
    if GetResourceState('ox_target') == 'started' then
        return exports.ox_target:addSphereZone({
            name = name,
            coords = center,
            radius = radius,
            debug = options.debugPoly,
            options = convert(targetoptions),
        })
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddCircleZone(name, center, radius, options, targetoptions)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddCircleZone(name, center, radius, options, targetoptions)
    end
end

Bridge.RemoveZone = function(id)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeZone(id, true)
    elseif GetResourceState('qb-target') == 'started' then
        exports['qb-target']:RemoveZone(id)
    elseif GetResourceState('qtarget') == 'started' then
        exports['qtarget']:RemoveZone(id)
    end
end

Bridge.AddTargetBone = function(bones, options)
    if GetResourceState('ox_target') == 'started' then
        if type(bones) ~= 'table' then bones = { bones } end
        options = convert(options)
        for _, v in pairs(options) do
            v.bones = bones
        end
        exports.ox_target:addGlobalVehicle(options)
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddTargetBone(bones, options)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddTargetBone(bones, options)
    end
end

Bridge.AddTargetEntity = function(entities, options)
    if GetResourceState('ox_target') == 'started' then
        if type(entities) ~= 'table' then entities = { entities } end
        options = convert(options)
        for i = 1, #entities do
            local entity = entities[i]
            if NetworkGetEntityIsNetworked(entity) then
                exports.ox_target:addEntity(NetworkGetNetworkIdFromEntity(entity), options)
            else
                exports.ox_target:addLocalEntity(entity, options)
            end
        end
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddTargetEntity(entities, options)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddTargetEntity(entities, options)
    end
end

Bridge.RemoveTargetEntity = function(entities, labels)
    if GetResourceState('ox_target') == 'started' then
        if type(entities) ~= 'table' then entities = { entities } end
        for i = 1, #entities do
            local entity = entities[i]
            if NetworkGetEntityIsNetworked(entity) then
                exports.ox_target:removeEntity(NetworkGetNetworkIdFromEntity(entity), labels)
            else
                exports.ox_target:removeLocalEntity(entity, labels)
            end
        end
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:RemoveTargetEntity(entities, labels)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:RemoveTargetEntity(entities, labels)
    end
end

Bridge.AddTargetModel = function(models, options)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addModel(models, convert(options))
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddTargetModel(models, options)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddTargetModel(models, options)
    end
end

Bridge.RemoveTargetModel = function(models, labels)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeModel(models, labels)
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:RemoveTargetModel(models, labels)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:RemoveTargetModel(models, labels)
    end
end

Bridge.AddGlobalPed = function(options)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addGlobalPed(convert(options))
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddGlobalPed(options)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddGlobalPed(options)
    end
end

Bridge.RemoveGlobalPed = function(labels)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeGlobalPed(labels)
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:RemoveGlobalPed(labels)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:RemoveGlobalPed(labels)
    end
end

Bridge.AddGlobalVehicle = function(options)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addGlobalVehicle(convert(options))
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddGlobalVehicle(options)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddGlobalVehicle(options)
    end
end

Bridge.RemoveGlobalVehicle = function(labels)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeGlobalVehicle(labels)
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:RemoveGlobalVehicle(labels)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:RemoveGlobalVehicle(labels)
    end
end

Bridge.AddGlobalObject = function(options)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addGlobalObject(convert(options))
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddGlobalObject(options)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddGlobalObject(options)
    end
end

Bridge.RemoveGlobalObject = function(labels)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeGlobalObject(labels)
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:RemoveGlobalObject(labels)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:RemoveGlobalObject(labels)
    end
end

Bridge.AddGlobalPlayer = function(options)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addGlobalPlayer(convert(options))
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddGlobalPlayer(options)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:AddGlobalPlayer(options)
    end
end

Bridge.RemoveGlobalPlayer = function(labels)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeGlobalPlayer(labels)
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:RemoveGlobalPlayer(labels)
    elseif GetResourceState('qtarget') == 'started' then
        return exports['qtarget']:RemoveGlobalPlayer(labels)
    end
end