local Events = require("utility/events")
--local Constants = require("constants")
local Wires = {}


function Wires.RegisterEvents()
    Events.RegisterHandler(defines.events.on_built_entity, "Wires.HandlePowerPoledPlaced", Wires.HandlePowerPoledPlaced)
    Events.RegisterHandler(defines.events.on_robot_built_entity, "Wires.HandlePowerPoledPlaced", Wires.HandlePowerPoledPlaced)
end


function Wires.OnStartup()
    Wires.OnLoad()
end


function Wires.OnLoad()
    Wires.RegisterEvents()
end


function Wires.HandlePowerPoledPlaced(eventData)
    local createdEntity = eventData.created_entity
    if not createdEntity.valid then return end
    if createdEntity.type ~= "electric-pole" then return end

    local copperWireNeighbours = createdEntity.neighbours["copper"]
    if copperWireNeighbours == nil or #copperWireNeighbours == 0 then return end
    for _, neighbour in pairs(copperWireNeighbours) do
        if neighbour.force ~= createdEntity.force then
            createdEntity.disconnect_neighbour(neighbour)
        end
    end
end


return Wires
