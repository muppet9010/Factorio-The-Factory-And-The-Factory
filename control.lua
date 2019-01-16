local Constants = require("constants")


local function OnChunkGenerated(event)
    local groundTiles = event.surface.find_tiles_filtered{area = event.area, collision_mask = "ground-tile"}
    for k, tile in pairs(groundTiles) do
        event.surface.create_entity{name = Constants.LandClaims["none"].landClaimName, position = tile.position, force = "neutral"}
    end
end

local function OnBuiltEntity(event)
    local created_entity = event.created_entity
    if Constants.LandClaimNames[created_entity.name] ~= nil then
        local noneLandClaim = created_entity.surface.find_entity(Constants.LandClaims["none"].landClaimName, created_entity.position)
        noneLandClaim.destroy()
    end
end


script.on_event(defines.events.on_chunk_generated, OnChunkGenerated)
script.on_event(defines.events.on_built_entity, OnBuiltEntity)


--As testing
script.on_event(defines.events.on_player_joined_game, function(event)
    game.players[event.player_index].force.enable_all_recipes()
end)
