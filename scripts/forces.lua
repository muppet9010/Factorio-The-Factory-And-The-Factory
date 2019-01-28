local Constants = require("constants")
local Commands = require("factorio-utils/commands")
local Events = require("factorio-utils/events")
local Forces = {}


function Forces.RegisterEvents()
    Events.RegisterHandler(defines.events.on_research_finished, "Forces.OnResearchCompleted", Forces.OnResearchCompleted)
end


function Forces.OnStartup()
    Forces.CreateForces()
    Forces.FixAllForcesEnabledRecipes()
    Forces.CreatePermissionGroups()

    Forces.OnLoad()
end


function Forces.OnLoad()
    Forces.RegisterCommands()
    Forces.RegisterEvents()
end


function Forces.CreateForces()
    for _, team in pairs(Constants.Teams) do
        if game.forces[team.name] == nil then game.create_force(team.name) end
    end
    local breachForce = game.forces["breach"]

    for _, team in pairs(Constants.Teams) do
        if team.playerConstruction then
            local force = game.forces[team.name]
            for otherTeamName in pairs(Constants.Teams) do
                if team.playerConstruction and team.name ~= otherTeamName then
                    force.set_cease_fire(otherTeamName, true)
                end
            end
            force.set_friend("breach", true)
            breachForce.set_friend(force, true)
            force.chart(game.surfaces[1], {{x = -224, y =-224}, {x = 224, y = 224}})
        end
    end

    local enemyForce = game.forces["enemy"]
    breachForce.set_friend(enemyForce, true)
    enemyForce.set_friend(breachForce, true)
end


function Forces.FixAllForcesEnabledRecipes()
    for _, force in pairs(game.forces) do
        local forceName = force.name
        if Constants.Teams[forceName] ~= nil and Constants.Teams[forceName].playerConstruction then
            local forceNameLength = string.len(forceName)
            for _, recipe in pairs(force.recipes) do
                if recipe.enabled and string.sub(recipe.name, -forceNameLength) ~= forceName then
                    local teamSpecificRecipeName = Constants.MakeTeamSpecificThingName(Constants.Teams[forceName], recipe.name)
                    if force.recipes[teamSpecificRecipeName] ~= nil then
                        recipe.enabled = false
                        force.recipes[teamSpecificRecipeName].enabled = true
                    end
                end
            end
            force.recipes[Constants.Teams[forceName].landClaim.name].enabled = true
        else
            force.disable_all_prototypes()
        end
    end
end


function Forces.OnResearchCompleted(eventData)
    local technology = eventData.research
    local force = technology.force
    if Constants.Teams[force.name] == nil then return end
    for _, effect in pairs(technology.effects) do
        if effect.type == "unlock-recipe" then
            local unlockedRecipeName = effect.recipe
            local teamSpecificRecipeName = Constants.MakeTeamSpecificThingName(Constants.Teams[force.name], unlockedRecipeName)
            if force.recipes[teamSpecificRecipeName] ~= nil then
                force.recipes[unlockedRecipeName].enabled = false
                force.recipes[teamSpecificRecipeName].enabled = true
            end
        end
    end
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
    local teamDisplayName
    if targetForce == nil then
        for _, team in pairs(Constants.Teams) do
            if team.displayName == suppliedTeamString then
                targetForce = game.forces[team.name]
                teamDisplayName = team.displayName
                break
            end
        end
    else
        if Constants.Teams[targetForce.name] ~= nil then
            teamDisplayName = Constants.Teams[targetForce.name].displayName
        else
            teamDisplayName = targetForce.name
        end
    end
    if targetForce == nil then
        callingPlayer.print{"api-error.team-not-valid", suppliedTeamString}
        return
    end

    game.print{"api-message.player-moved-to-team", callingPlayer.name, teamDisplayName}
    Forces.MovePlayerToForce(callingPlayer, targetForce)
end


function Forces.MovePlayerToForce(player, force)
    --TODO: empty inventory and do anything else required before moving the players team
    player.force = force
    Events.Fire({name="SetPlayerPermissionGroup", player_index=player.index})
end


function Forces.CreatePermissionGroups()
    local nonConstructionTeamAllowedActions = {[defines.input_action.write_to_console] = true, [defines.input_action.start_walking] = true, [defines.input_action.delete_permission_group] = true, [defines.input_action.add_permission_group] = true, [defines.input_action.edit_permission_group] = true}
    game.permissions.create_group("ConstructionTeam")
    local breachGroup = game.permissions.create_group("Breach")
    local spectatorGroup = game.permissions.create_group("Spectator")
    for _, action in pairs(defines.input_action) do
        if not nonConstructionTeamAllowedActions[action] then
            breachGroup.set_allows_action(action, false)
            spectatorGroup.set_allows_action(action, false)
        end
    end
    breachGroup.set_allows_action(defines.input_action.use_ability, true)
    breachGroup.set_allows_action(defines.input_action.use_item, true)
    breachGroup.set_allows_action(defines.input_action.change_shooting_state, true)
end


return Forces
