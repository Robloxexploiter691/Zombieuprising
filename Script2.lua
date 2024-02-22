local uis = game:GetService("UserInputService")
local cam = game:GetService("Workspace").CurrentCamera
local ts = game:GetService("TweenService")
local plr = game:GetService("Players").LocalPlayer
local zombies = game:GetService("Workspace").Zombies
 
local function getClosestSilent()
    local closestDist = math.huge
    local closestPlr = nil
    for _, v in next, zombies.GetChildren(zombies) do
        if game.FindFirstChild(v, "Humanoid") and v.Humanoid.Health > 0 then
            local vector, onScreen = cam.worldToScreenPoint(cam, game.WaitForChild(v, "Head", math.huge).Position)
            local dist = (Vector2.new(uis.GetMouseLocation(uis).X, uis.GetMouseLocation(uis).Y) - Vector2.new(vector.X, vector.Y)).Magnitude
            if dist < closestDist and onScreen then
                closestDist = dist
                closestPlr = v
            end
        end
    end
    return closestPlr
end
 
local namecall;
namecall = hookmetamethod(game, "__namecall", function(Self, ...)
    if not checkcaller() and tostring(getcallingscript()) == "Framework" and string.lower(getnamecallmethod()) == "findpartonraywithignorelist" then
        local args = {...}
        local closest = getClosestSilent()
        if closest then
            local origin = args[1].Origin
            args[1] = Ray.new(origin, closest.Head.Position - origin)
        end
        return namecall(Self, unpack(args))
    end
    return namecall(Self, ...)
end)
