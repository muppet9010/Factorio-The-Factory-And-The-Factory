local Constants = require("constants")
local Commands = require("scripts/commands")
local Forces = {}


function Forces.OnStartup()
    Forces.CreateForces()
    Forces.RegisterCommands()
end


function Forces.CreateForces()
    for _, team in pairs(Constants.Teams) do
        if game.forces[team.name] == nil then game.create_force(team.name) end
    end
    local breachForce = game.forces["breach"]

    for _, team in pairs(Constants.PlayerConstructionTeams) do
        local force = game.forces[team.name]
        for otherTeamName in pairs(Constants.PlayerConstructionTeams) do
            if team.name ~= otherTeamName then
                force.set_cease_fire(otherTeamName, true)
            end
        end
        force.set_friend("breach", true)
        breachForce.set_friend(force, true)
    end

    local enemyForce = game.forces["enemy"]
    breachForce.set_friend(enemyForce, true)
    enemyForce.set_friend(breachForce, true)
end


function Forces.RegisterCommands()
    Commands.Register("change-players-team", {"api-description.change-players-team"}, Forces.ChangePlayersForceCommand, true)
    Commands.Register("change-my-team", {"api-description.change-my-team"}, Forces.ChangeMyForceCommand, false)
end


function Forces.ChangePlayersForceCommand(data)
    local callingPlayer = game.players[data.player_index]
    local args = {}
    for text in string.gmatch(data.parameter or "nil", "%S+") do
        table.insert(args, text)
    end
    if #args ~= 2 then
        callingPlayer.print{"api-error.change-player-team-argument-count"}
        return
    end

    local suppliedPlayerString = args[1]
    local targetPlayer = game.players[suppliedPlayerString]
    if targetPlayer == nil then
        callingPlayer.print{"api-error.player-not-valid", suppliedPlayerString}
        return
    end

    local suppliedTeamString = args[2]
    local targetForce = game.forces[suppliedTeamString]
    if targetForce == nil then
        for _, team in pairs(Constants.Teams) do
            if team.displayName == suppliedTeamString then
                targetForce = game.forces[team.name]
                break
            end
        end
    end
    if targetForce == nil then
        callingPlayer.print{"api-error.team-not-valid", suppliedTeamString}
        return
    end
    game.print{"api-message.player-moved-to-team-by-admin", targetPlayer.name, Constants.Teams[targetForce.name].displayName}
    Forces.MovePlayerToForce(targetPlayer, targetForce)
end


function Forces.ChangeMyForceCommand(data)
    local callingPlayer = game.players[data.player_index]

    local suppliedTeamString = data.parameter
    local targetForce = game.forces[suppliedTeamString]
    if targetForce == nil then
        for _, team in pairs(Constants.Teams) do
            if team.displayName == suppliedTeamString then
                targetForce = game.forces[team.name]
                break
            end
        end
    end
    if targetForce == nil then
        callingPlayer.print{"api-error.team-not-valid", suppliedTeamString}
        return
    end
    game.print{"api-message.player-moved-to-team", callingPlayer.name, Constants.Teams[targetForce.name].displayName}
    Forces.MovePlayerToForce(callingPlayer, targetForce)
end


function Forces.MovePlayerToForce(player, force)
    --TODO: empty inventory and change player to new force
end


return Forces
