local Constants = require("constants")


local function CreateLandClaim(name, tileColor, imageNameEnd, landTileName)
    local landClaim = {
        type = "simple-entity",
        name = landTileName,
        icons = {
            {
                icon = Constants.AssetModName .. "/graphics/entity/land-claim-" .. imageNameEnd .. ".png",
                icon_size = 64,
                tint = tileColor
            }
        },
        order = landTileName,
        picture = {
            filename = Constants.AssetModName .. "/graphics/entity/land-claim-" .. imageNameEnd .. ".png",
            width = 64,
            height = 64,
            tint = tileColor,
            scale = 0.5
        },
        render_layer = "ground-patch-higher2",
        collision_box = {{-0.45, -0.45}, {0.45, 0.45}},
        collision_mask = Constants.CollisionMaskLists[name],
        selection_box = {{-0.45, -0.45}, {0.45, 0.45}},
        flags = {"not-rotatable", "not-on-map", "not-blueprintable", "not-deconstructable", "placeable-neutral"},
        selectable_in_game = false
    }
    data:extend({landClaim})
end


for k, landClaim in pairs(Constants.LandClaims) do
    CreateLandClaim(landClaim.name, landClaim.landClaimColor, landClaim.landClaimImageName, landClaim.landClaimName)
end
