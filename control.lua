local Events = require("utility/events")
local LandClaim = require("scripts/land-claim")
local Forces = require("scripts/forces")


local function OnStartup()
    if global.MOD == nil then global.MOD = {} end
    if global.MOD.Settings == nil then global.MOD.Settings = {} end
    Events.DoFirst()

    LandClaim.OnStartup()
    Forces.OnStartup()
end

local function OnLoad()
    Events.DoFirst()

    LandClaim.OnLoad()
    Forces.OnLoad()
end


script.on_init(OnStartup)
script.on_load(OnLoad)
script.on_configuration_changed(OnStartup)

script.on_event(defines.events.on_chunk_generated, Events.Fire)
script.on_event(defines.events.on_built_entity, Events.Fire)
script.on_event(defines.events.on_research_finished, Events.Fire)
script.on_event(defines.events.on_runtime_mod_setting_changed, Events.Fire)
script.on_event(defines.events.on_player_selected_area, Events.Fire)
