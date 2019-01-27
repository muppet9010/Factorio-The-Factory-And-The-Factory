local Constants = require("constants")
local Breach = {}


function Breach.OnStartup()
    Breach.CreateTeamStartChests()
end


function Breach.CreateTeamStartChests()
    if global.MOD.initialMapLoad ~= nil then return end
    local surface = game.surfaces[1]
    for _, team in pairs(Constants.Teams) do
        if team.playerConstruction then
            local chestPosition = surface.find_non_colliding_position("wooden-chest", {x=0, y=0}, 0, 1)
            local chest = surface.create_entity{name="wooden-chest", position=chestPosition, force=team.name}
            chest.get_output_inventory().insert({name=team.landClaim.name, count=100})
            surface.create_entity{name=team.landClaim.name, position=chestPosition, force=team.name}
        end
    end
end


return Breach
