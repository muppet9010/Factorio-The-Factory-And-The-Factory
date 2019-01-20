local Constants = require("constants")


local function CreateLandClaimForTile(landClaim, tile)
    local landClaimTile = table.deepcopy(tile)
    landClaimTile.name = landClaim.landClaimName
    landClaimTile.icons = {
        {
            icon = Constants.AssetModName .. "/graphics/entity/land-claim-" .. landClaim.landClaimImageName .. ".png",
            icon_size = 64,
            tint = landClaim.landClaimColor
        }
    }
    landClaimTile.order = landClaim.landClaimName
    landClaimTile.minable.result = landClaim.landClaimName
    for _, variant in pairs(landClaimTile.variants.main) do
        variant.tint = landClaim.landClaimColor
        variant.apply_runtime_tint = true
        if variant.hr_version ~= nil then
            variant.hr_version.tint = landClaim.landClaimColor
            variant.hr_version.apply_runtime_tint = true
        end
    end
    if landClaimTile.variants.material_background ~= nil then
        local variant = landClaimTile.variants.material_background
        variant.tint = landClaim.landClaimColor
        variant.apply_runtime_tint = true
        if variant.hr_version ~= nil then
            variant.hr_version.tint = landClaim.landClaimColor
            variant.hr_version.apply_runtime_tint = true
        end
    end
    for _, mask in pairs(Constants.BuildingCollisionMaskLists[landClaim.name]) do
        table.insert(landClaimTile.collision_mask, mask)
    end
    data:extend({landClaimTile})
end


for _, landClaim in pairs(Constants.LandClaims) do
    if landClaim.team ~= nil then
        for _, tile in pairs(data.raw["tile"]) do
            if tile.minable ~= nil then
                CreateLandClaimForTile(landClaim, tile)
            end
        end
        log(serpent.block(data.raw["tile"][landClaim.landClaimName]))
    end
end
