local Events = require("factorio-utils/events")
local LandClaim = require("scripts/land-claim")
local Forces = require("scripts/forces")
local Wires = require("scripts/wires")
local Breach = require("scripts/breach")


local function OnStartup()
    if global.MOD == nil then global.MOD = {} end
    if global.MOD.Settings == nil then global.MOD.Settings = {} end
    Events.DoFirst()

    LandClaim.OnStartup()
    Forces.OnStartup()
    Wires.OnStartup()
    Breach.OnStartup()
end

local function OnLoad()
    Events.DoFirst()

    LandClaim.OnLoad()
    Forces.OnLoad()
    Wires.OnLoad()
end


script.on_init(OnStartup)
script.on_load(OnLoad)
script.on_configuration_changed(OnStartup)

script.on_event(defines.events.on_chunk_generated, Events.CallHandler)
script.on_event(defines.events.on_built_entity, Events.CallHandler)
script.on_event(defines.events.on_research_finished, Events.CallHandler)
script.on_event(defines.events.on_runtime_mod_setting_changed, Events.CallHandler)
script.on_event(defines.events.on_player_selected_area, Events.CallHandler)
script.on_event(defines.events.on_player_alt_selected_area, Events.CallHandler)
