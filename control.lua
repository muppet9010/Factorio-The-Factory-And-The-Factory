local Events = require("factorio-utils/events")
local LandClaim = require("scripts/land-claim")
local Forces = require("scripts/forces")
local Wires = require("scripts/wires")
local Breach = require("scripts/breach")
local Player = require("scripts/player")


local function OnStartup()
    if global.MOD == nil then global.MOD = {} end
    if global.MOD.Settings == nil then global.MOD.Settings = {} end

    LandClaim.OnStartup()
    Forces.OnStartup()
    Wires.OnStartup()
    Breach.OnStartup()
    Player.OnStartup()
end

local function OnLoad()
    LandClaim.OnLoad()
    Forces.OnLoad()
    Wires.OnLoad()
    Player.OnLoad()
end


script.on_init(OnStartup)
script.on_load(OnLoad)
script.on_configuration_changed(OnStartup)

Events.RegisterEvent(defines.events.on_chunk_generated)
Events.RegisterEvent(defines.events.on_built_entity)
Events.RegisterEvent(defines.events.on_research_finished)
Events.RegisterEvent(defines.events.on_player_selected_area)
Events.RegisterEvent(defines.events.on_player_alt_selected_area)
Events.RegisterEvent(defines.events.on_player_created)
Events.RegisterEvent("SetPlayerPermissionGroup")
