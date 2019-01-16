local Constants = require("constants")


local entityTypesAffectedByLandOwnership = {accumulator = true, ["artillery-turret"] = true, beacon = true , boiler = true}


local function RestrictedPrototypesFromUnclaimLand()
    for type, prototypes in pairs(data.raw) do
        if entityTypesAffectedByLandOwnership[type] then
            for k, prototype in pairs(prototypes) do
                if prototype.collision_mask ~= nil then
                    table.insert(prototype.collision_mask, Constants.CollisionMasks["none"])
                else
                    prototype.collision_mask = Constants.CollisionMaskLists["none"]
                end
            end
        end
    end
end





RestrictedPrototypesFromUnclaimLand()
