local Events = {}

function Events.DoFirst()
    if MOD == nil then MOD = {} end
    if MOD.events == nil then MOD.events = {} end
end

function Events.RegisterHandler(eventName, handlerName, handlerFunction)
    if MOD.events[eventName] == nil then MOD.events[eventName] = {} end
    MOD.events[eventName][handlerName] = handlerFunction
end

function Events.RemoveHandler(eventName, handlerName)
    if MOD.events[eventName] == nil then return end
    MOD.events[eventName][handlerName] = nil
end

function Events.Fire(eventData)
    local eventName = eventData.name
    if MOD.events[eventName] == nil then return end
    for _, handlerFunction in pairs(MOD.events[eventName]) do
        handlerFunction(eventData)
    end
end

return Events
