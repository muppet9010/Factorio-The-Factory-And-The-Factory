local Constants = require("constants")
local Events = require("factorio-utils/events")
local Player = {}


function Player.RegisterEvents()
    Events.RegisterHandler(defines.events.on_player_created, "Player.OnCreatedEvent", Player.OnCreatedEvent)
    Events.RegisterHandler("SetPlayerPermissionGroup", "Player.SetPermissionGroupEvent", Player.SetPermissionGroupEvent)
end


function Player.OnStartup()
    Player.OnLoad()
end


function Player.OnLoad()
    Player.RegisterEvents()
end


function Player.OnCreatedEvent(eventData)
    Player.SetPermissionGroupEvent(eventData)
end


function Player.SetPermissionGroupEvent(eventData)
    local player = game.players[eventData.player_index]
    local team = Constants.Teams[player.force.name]
    if team == nil or team == Constants.Teams["player"] then
        player.permission_group = game.permissions.get_group("Spectator")
    elseif team == Constants.Teams["breach"] then
        player.permission_group = game.permissions.get_group("Breach")
    else
        player.permission_group = game.permissions.get_group("ConstructionTeam")
    end
end


return Player
