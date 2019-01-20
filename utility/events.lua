local Events = {}

function Events.PreOnStartup()
    if global.MOD.events == nil then global.MOD.events = {} end
end

function Events.RegisterHandler(eventName, handlerName, handlerFunction)
    if global.MOD.events[eventName] == nil then global.MOD.events[eventName] = {} end
    global.MOD.events[eventName][handlerName] = handlerFunction
end

function Events.RemoveHandler(eventName, handlerName)
    if global.MOD.events[eventName] == nil then return end
    global.MOD.events[eventName][handlerName] = nil
end

function Events.Fire(eventName, eventData)
    if global.MOD.events[eventName] == nil then return end
    for _, handlerFunction in pairs(global.MOD.events[eventName]) do
        handlerFunction(eventData)
    end
end

return Events
