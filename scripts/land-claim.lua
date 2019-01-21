local Constants = require("constants")
local Events = require("utility/events")
local LandClaim = {}


function LandClaim.RegisterEvents()
    --Events.RegisterHandler(defines.events.on_chunk_generated, "LandClaim.OnChunkGenerated_AddNoneOwnedTiles", LandClaim.OnChunkGenerated_AddNoneOwnedTiles)
    --Events.RegisterHandler(defines.events.on_built_entity, "LandClaim.OnBuiltEntity_RemoveNoneOwnedTiles", LandClaim.OnBuiltEntity_RemoveNoneOwnedTiles)
    Events.RegisterHandler(defines.events.on_player_selected_area, "LandClaim.OnSelectedAreaWithLandClaimTool", LandClaim.OnSelectedAreaWithLandClaimTool)
end


function LandClaim.OnStartup()
    LandClaim.OnLoad()
end


function LandClaim.OnLoad()
    LandClaim.RegisterEvents()
end


--not used as is for blocking buildings on non-claimed tiles
function LandClaim.OnChunkGenerated_AddNoneOwnedTiles(eventData)
    local groundTiles = eventData.surface.find_tiles_filtered{area = eventData.area, collision_mask = "ground-tile"}
    for k, tile in pairs(groundTiles) do
        eventData.surface.create_entity{name = Constants.LandClaims["none"].landClaimName, position = tile.position, force = "neutral"}
    end
end


--not used as is for blocking buildings on non-claimed tiles
function LandClaim.OnBuiltEntity_RemoveNoneOwnedTiles(eventData)
    local created_entity = eventData.created_entity
    if Constants.LandClaimNames[created_entity.name] ~= nil then
        local noneLandClaim = created_entity.surface.find_entity(Constants.LandClaims["none"].landClaimName, created_entity.position)
        if noneLandClaim ~= nil then
            noneLandClaim.destroy()
        end
    end
end


function LandClaim.OnSelectedAreaWithLandClaimTool(eventData)
    local itemUsedName = eventData.item
    local player = game.players[eventData.player_index]
    local landClaim = Constants.LandClaims[player.force.name]
    local landClaimName = landClaim.landClaimName
    if itemUsedName ~= landClaimName then return end

    local tilesSelected = eventData.tiles
    local landClaimTilesHeld = player.get_item_count(landClaimName)
    local landClaimTilesRequired = {}
    local surface = player.surface
    for _, tile in pairs(tilesSelected) do
        if surface.count_entities_filtered{position = tile.position, name = landClaimName}  == 0 then
            table.insert(landClaimTilesRequired, tile.position)
        end
    end

    if #landClaimTilesRequired > landClaimTilesHeld then
        player.print("not enough Land Claim tiles for this")
        --TODO: do this as floaty text in future
        return
    end

    player.print("doing it " .. #landClaimTilesRequired)
end


return LandClaim
