local Constants = require("constants")
local Events = require("scripts/events")
local LandClaim = {}


function LandClaim.OnStartup()
    Events.RegisterHandler(defines.events.on_chunk_generated, "OnChunkGenerated", LandClaim.OnChunkGenerated)
    Events.RegisterHandler(defines.events.on_built_entity, "OnBuiltEntity", LandClaim.OnBuiltEntity)
end


function LandClaim.OnChunkGenerated(event)
    local groundTiles = event.surface.find_tiles_filtered{area = event.area, collision_mask = "ground-tile"}
    for k, tile in pairs(groundTiles) do
        event.surface.create_entity{name = Constants.LandClaims["none"].landClaimName, position = tile.position, force = "neutral"}
    end
end


function LandClaim.OnBuiltEntity(event)
    local created_entity = event.created_entity
    if Constants.LandClaimNames[created_entity.name] ~= nil then
        local noneLandClaim = created_entity.surface.find_entity(Constants.LandClaims["none"].landClaimName, created_entity.position)
        if noneLandClaim ~= nil then
            noneLandClaim.destroy()
        end
    end
end


return LandClaim
