local Events = require("scripts/events")
local LandClaim = require("scripts/land-claim")
local Forces = require("scripts/forces")


local function OnStartup()
    if global.MOD == nil then global.MOD = {} end
    Events.OnStartup()
    LandClaim.OnStartup()
    Forces.OnStartup()
end

local function OnLoad()
    Forces.OnLoad()
end


script.on_init(OnStartup)
script.on_load(OnLoad)
script.on_configuration_changed(OnStartup)

script.on_event(defines.events.on_chunk_generated, function(eventData) Events.Fire(defines.events.on_chunk_generated, eventData) end)
script.on_event(defines.events.on_built_entity, function(eventData) Events.Fire(defines.events.on_built_entity, eventData) end)
script.on_event(defines.events.on_research_finished, function(eventData) Events.Fire(defines.events.on_research_finished, eventData) end)
