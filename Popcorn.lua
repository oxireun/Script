local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxireun/User/refs/heads/main/Oxireunuilibrary.lua"))()
local Window = Library:NewWindow("Script")
local MainSection = Window:NewSection("Main")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RUNNING = false
local DELETE_MESH_IDS = {
	"rbxassetid://134067155266123",
	"rbxassetid://116001267806355",
	"rbxassetid://109693410898975",
	"rbxassetid://124139603604978",
	"rbxassetid://126762356405534",
	"rbxassetid://102180322252585"
}
local TARGET_MESH_ID = "rbxassetid://111012388367251"
local FLY_HEIGHT = 6
local FLY_SPEED = 500

-- Silinen objeleri yedekle
local deletedObjects = {}

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

-- Silme ve fly işlemi
local function FlyAndDelete()
	local character = getCharacter()
	local hrp = character:WaitForChild("HumanoidRootPart")

	while RUNNING do
		-- 1️⃣ Silme
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("MeshPart") or (obj:IsA("SpecialMesh") and obj.Parent:IsA("BasePart")) then
				local meshId = obj:IsA("MeshPart") and tostring(obj.MeshId) or tostring(obj.MeshId)
				for _, deleteId in ipairs(DELETE_MESH_IDS) do
					if meshId == deleteId then
						pcall(function()
							-- Objeyi yedekle
							if obj:IsA("MeshPart") then
								table.insert(deletedObjects, {obj:Clone(), obj.Parent})
							else
								table.insert(deletedObjects, {obj.Parent:Clone(), obj.Parent.Parent})
							end
							obj:Destroy()
						end)
					end
				end
			end
		end

		-- 2️⃣ En yakın TARGET_MESH_ID objesini bul
		local closestObj = nil
		local closestDist = math.huge
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("MeshPart") and tostring(obj.MeshId) == TARGET_MESH_ID then
				local dist = (hrp.Position - obj.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestObj = obj
				end
			elseif obj:IsA("SpecialMesh") and tostring(obj.MeshId) == TARGET_MESH_ID and obj.Parent:IsA("BasePart") then
				local dist = (hrp.Position - obj.Parent.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestObj = obj.Parent
				end
			end
		end

		-- 3️⃣ Fly hareketi
		if closestObj then
			local targetPos = closestObj.Position + Vector3.new(0, FLY_HEIGHT, 0)
			while RUNNING and (hrp.Position - targetPos).Magnitude > 1 do
				local direction = (targetPos - hrp.Position).Unit
				hrp.CFrame = hrp.CFrame + direction * FLY_SPEED * task.wait()
			end
		end

		task.wait(0.05)
	end
end

-- Toggle
MainSection:CreateToggle("Auto collect", false, function(value)
	RUNNING = value
	if value then
		spawn(FlyAndDelete)
	end
end)

-- UGC 1 butonu: silinen objeleri geri koy
MainSection:CreateButton("Finish", function()
	for _, data in ipairs(deletedObjects) do
		local objClone, parent = data[1], data[2]
		if parent and objClone then
			objClone.Parent = parent
		end
	end
	-- Yedek tabloyu temizle
	deletedObjects = {}
end)

local MainSection = Window:NewSection("Credits")

MainSection:CreateButton("Copy YouTube", function()
  
    setclipboard("https://youtube.com/@oxireun?si=dnaRt4zcDvmnrUu_")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Copied!";
        Text = "YouTube link copied to clipboard!";
        Duration = 2;
    })
end)

MainSection:CreateButton("Copy Discord", function()

    setclipboard("https://discord.gg/M2Xq55wC8Z")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Copied!";
        Text = "Discord invite copied to clipboard!";
        Duration = 2;
    })
end)
