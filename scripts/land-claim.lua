local Constants = require("constants")
local Events = require("utility/events")
local LandClaim = {}


function LandClaim.GetSettings()
    global.MOD.Settings.landclaimMode = settings.startup["landclaim-mode"].value
end


function LandClaim.OnStartup()
    if global.MOD.Settings.landclaimMode == "entity" then
        Events.RegisterHandler(defines.events.on_chunk_generated, "LandClaim.Tile_OnChunkGenerated", LandClaim.Tile_OnChunkGenerated)
        Events.RegisterHandler(defines.events.on_built_entity, "LandClaim.Tile_OnBuiltEntity", LandClaim.Tile_OnBuiltEntity)
    end
end


function LandClaim.Tile_OnChunkGenerated(eventData)
    local groundTiles = eventData.surface.find_tiles_filtered{area = eventData.area, collision_mask = "ground-tile"}
    for k, tile in pairs(groundTiles) do
        eventData.surface.create_entity{name = Constants.LandClaims["none"].landClaimName, position = tile.position, force = "neutral"}
    end
end


function LandClaim.Tile_OnBuiltEntity(eventData)
    local created_entity = eventData.created_entity
    if Constants.LandClaimNames[created_entity.name] ~= nil then
        local noneLandClaim = created_entity.surface.find_entity(Constants.LandClaims["none"].landClaimName, created_entity.position)
        if noneLandClaim ~= nil then
            noneLandClaim.destroy()
        end
    end
end


return LandClaim
