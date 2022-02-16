--[[
PreloadingService, DarkPixlz 2022, V1.1.0 BETA BUILD. Do not claim as your own!

Info in PreloadingService/DefaultUI/ABOUT

Please place in ReplicatedStorage!

]]

--WARNING: IF YOU DID NOT BUY THIS FROM @DarkPixlz OR THE DEVFORUM, YOU GOT SCAMMED AND THERE IS PROBABLY A VIRUS IN HERE!
--THERE IS NO require() or getfenv 's in here! Press control/command + F, then type require() and getfenv().
--IF THE RESULTS AREN'T COMMENTED, DELETE THIS SCRIPT! GET IT FROM THE DEVFORUM LINK ABOVE. STAY SAFE FROM SCAMS!
local Loader = {}
print("Loaded PreloadService v1.0.1 by DarkPixlz!")
Loader.Completed = Instance.new("BindableEvent")
repeat task.wait() until Loader.Completed
local Settings = require(script.Settings)
function Print(msg)
	if Settings.PrintData == true then
		print("[PreloadService]: "..msg)
	end
end
function Loader.Load(AssetsData, UIType, CustomUI)
	Print("Module fired to load data!")
	local ContentProvider = game:GetService("ContentProvider")
	local text
	local barImg
	--	local NewUI = CustomUI:Clone()
	local Frame
	local Assets = {}
	local Type
	local UIType = ""
	if not AssetsData == nil then
		Print("Data is custom!")
		Assets = AssetsData
	else
		if AssetsData == "Game" then
			Type = "Game"
			Assets = {
				game:GetService("HttpService"),
				game.Players.LocalPlayer.PlayerGui,
				game:GetService("Workspace"),
				game:GetService("Players"),
				game:GetService("NetworkClient"),
				game:GetService("ReplicatedFirst"),
				game:GetService("ReplicatedStorage"),
				game:GetService("ServerStorage"),
				game:GetService("StarterPack"),
				game:GetService("StarterPlayer"),
				game:GetService("Teams"),
				game:GetService("SoundService"),
				game:GetService("Chat"),
				game:GetService("LocalizationService"),
				game:GetService("Lighting")
			} 
		end
	end
	--	NewUI.Parent = script
	--	NewUI.Name = "PreloadServiceCustomUI"
	if CustomUI == nil or "" then
		print(AssetsData)
		if Type == "Game" then
			if not Settings.LightDefaultUI then
			local DefaultUI = script.DefaultUI:Clone()
			DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
			text = DefaultUI.Game.LoadingText
			barImg = DefaultUI.Game.Bar.Progress
			UIType = "DarkGame"
			else
				local DefaultUI = script.DefaultUI:Clone()
				DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
				text = DefaultUI.GameLight.LoadingText
				barImg = DefaultUI.Game.Bar.Progress
				UIType = "DarkGame"
			end
		else
			if not Settings.LightDefaultUI then
			local DefaultUI = script.DefaultUI:Clone()
			DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
			text = DefaultUI.Other.LoadingText
				barImg = DefaultUI.Other.Bar.Progress
			else
				local DefaultUI = script.DefaultUI:Clone()
				DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
				text = DefaultUI.OtherLight.LoadingText
				barImg = DefaultUI.OtherLight.Bar.Progress
			end
		end
	else
		text = CustomUI.LoadingText
		barImg = CustomUI.Bar.Progress
	end
	text.Parent.Visible = true
	task.wait(Settings.StartDelay)
	local succ, err = pcall(function()
		if text.Parent.Name == "Other" or "OtherLight" --[[Other default UI, It has a script in it]] then
			text.Parent.Bar.LocalScript.Disabled = true
		end
		for i = 1, #Assets do
			local Asset = Assets[i]
			if UIType == "LoadingGameScreen" then
			end
			text.Text = "Loading "..Asset.Name.." [".. i .. " / "..#Assets.."]"
			if Asset.Name == "HttpService" then
				text.Text = "Pinging HttpService.."
			end
			ContentProvider:PreloadAsync({Asset})
			Print("Loaded "..Asset.Name)
			task.wait(Settings.InBetweenAssetsDelay)
			local Progress = i / #Assets
			barImg:TweenSize(UDim2.new(Progress, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 1, false)
			task.wait()
		end
	end)
	if not succ then
		warn("[PreloadService]: Could not preload an item! Error: "..err)
	else
		text.Text = "Finished!"
		barImg:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 2, true) 
		Print("Successfully loaded")
		if Settings.AutoCloseUI then
			if not Settings.UseTweens then
				game.Players.LocalPlayer.PlayerGui.DefaultUI:Destroy()
			else
				
			end
		end
		local succ1, err2 = pcall(function() Loader.Completed:Fire() end)
		if not succ1 then Print(err2) return else print(succ1) end
	end
end

function Loader.CheckVersion()
	local marketplace = game:GetService("MarketplaceService")

	local success, result = pcall(function()
		return marketplace:GetProductInfo(8788148542)
	end)

	if success then
		if result then
			if result.Description:match("1.0.2") then
				Print("Up to date! Version: 1.0.3")
			else
				warn("[ProloadService]: Out of date or MarketplaceService error. Please update your module by reinstalling it!")
				if Settings.ShutdownIfOutofDate then script:Destroy() end
			end
		end
	end
end
return Loader
