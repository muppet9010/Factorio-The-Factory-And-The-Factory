local Constants = require("constants")
local Events = require("scripts/events")
local LandClaim = {}


function LandClaim.OnStartup()
    Events.RegisterHandler(defines.events.on_chunk_generated, "LandClaim.OnChunkGenerated", LandClaim.OnChunkGenerated)
    Events.RegisterHandler(defines.events.on_built_entity, "LandClaim.OnBuiltEntity", LandClaim.OnBuiltEntity)
end


function LandClaim.OnChunkGenerated(eventData)
    local groundTiles = eventData.surface.find_tiles_filtered{area = eventData.area, collision_mask = "ground-tile"}
    for k, tile in pairs(groundTiles) do
        eventData.surface.create_entity{name = Constants.LandClaims["none"].landClaimName, position = tile.position, force = "neutral"}
    end
end


function LandClaim.OnBuiltEntity(eventData)
    local created_entity = eventData.created_entity
    if Constants.LandClaimNames[created_entity.name] ~= nil then
        local noneLandClaim = created_entity.surface.find_entity(Constants.LandClaims["none"].landClaimName, created_entity.position)
        if noneLandClaim ~= nil then
            noneLandClaim.destroy()
        end
    end
end


return LandClaim
