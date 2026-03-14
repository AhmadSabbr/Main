local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local NovaLib = {}

function NovaLib:CreateWindow(Settings)
	local Title = Settings.Title or "Window"
	local Window = {}
	local dragging = false
	local startPos, lastMouse
	local dragSpeed = 100
	local minimizeKeybind = Settings.MinimizeKeybind
	local minimizeKey = Settings.MinimizeKey
	local minimized = false

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Library"
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local mainFrameHolder = Instance.new("Frame")
	mainFrameHolder.Name = "mainFrameHolder"
	mainFrameHolder.Parent = ScreenGui
	mainFrameHolder.BackgroundColor3 = Color3.fromRGB(68, 12, 121)
	mainFrameHolder.BackgroundTransparency = 0.4
	mainFrameHolder.BorderSizePixel = 0
	mainFrameHolder.Position = UDim2.new(0.317180604,0,0.172029704,0)
	mainFrameHolder.Size = UDim2.new(0,580,0,530)
	
	UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == minimizeKey then
				minimized = not minimized
				mainFrameHolder.Visible = not minimized
			end
		end
	end)
	
	local mainFrameHolderUICorner = Instance.new("UICorner")
	mainFrameHolderUICorner.CornerRadius = UDim.new(0,32)
	mainFrameHolderUICorner.Parent = mainFrameHolder
	
	local mainFrameHolderUIScale = Instance.new("UIScale")
	mainFrameHolderUIScale.Parent = mainFrameHolder
	mainFrameHolderUIScale.Scale = 1

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "mainFrame"
	mainFrame.Parent = mainFrameHolder
	mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
	mainFrame.BackgroundTransparency = 0.6
	mainFrame.BorderSizePixel = 0
	mainFrame.Position = UDim2.new(0.0178160574,0,0.0174956694,0)
	mainFrame.Size = UDim2.new(0,560,0,510)

	local mainFrameUICorner = Instance.new("UICorner")
	mainFrameUICorner.CornerRadius = UDim.new(0,32)
	mainFrameUICorner.Parent = mainFrame

	local topBarHolder = Instance.new("Frame")
	topBarHolder.Name = "topBarHolder"
	topBarHolder.Parent = mainFrame
	topBarHolder.Size = UDim2.new(0,560,0,55)
	topBarHolder.BackgroundTransparency = 1
	topBarHolder.ClipsDescendants = true

	local topBarHolderUICorner = Instance.new("UICorner")
	topBarHolderUICorner.CornerRadius = UDim.new(0,32)
	topBarHolderUICorner.Parent = topBarHolder

	local topBar = Instance.new("Frame")
	topBar.Name = "topBar"
	topBar.Parent = topBarHolder
	topBar.BackgroundColor3 = Color3.fromRGB(69,18,100)
	topBar.BackgroundTransparency = 0.4
	topBar.BorderSizePixel = 0
	topBar.Size = UDim2.new(1,0,1,32)

	local title = Instance.new("TextLabel")
	title.Name = "title"
	title.Parent = topBar
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0.109090909,0,0,0)
	title.Size = UDim2.new(0,500,0,55)
	title.Font = Enum.Font.Arimo
	title.RichText = true
	title.Text = "<b>" .. Title .. "</b>"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	
	local libraryCloseFrameHolder = Instance.new("Frame")
	libraryCloseFrameHolder.Name = "libraryCloseFrameHolder"
	libraryCloseFrameHolder.Parent = mainFrameHolder
	libraryCloseFrameHolder.BackgroundColor3 = Color3.fromRGB(0,0,0)
	libraryCloseFrameHolder.BackgroundTransparency = 1
	libraryCloseFrameHolder.BorderSizePixel = 0
	libraryCloseFrameHolder.Size = UDim2.new(0,580,0,530)
	libraryCloseFrameHolder.Visible = false
	libraryCloseFrameHolder.AutoLocalize = false

	local libraryCloseFrameHolderUICorner = Instance.new("UICorner")
	libraryCloseFrameHolderUICorner.CornerRadius = UDim.new(0,32)
	libraryCloseFrameHolderUICorner.Parent = libraryCloseFrameHolder

	local libraryCloseFrame = Instance.new("Frame")
	libraryCloseFrame.Name = "libraryCloseFrame"
	libraryCloseFrame.Parent = libraryCloseFrameHolder
	libraryCloseFrame.BackgroundColor3 = Color3.fromRGB(70,19,115)
	libraryCloseFrame.BackgroundTransparency = 1
	libraryCloseFrame.BorderSizePixel = 0
	libraryCloseFrame.Position = UDim2.new(0.240386546,0,0.335849047,0)
	libraryCloseFrame.Size = UDim2.new(0,300,0,200)

	local libraryCloseUICorner = Instance.new("UICorner")
	libraryCloseUICorner.Parent = libraryCloseFrame

	local libraryCloseOptionsHolder = Instance.new("Frame")
	libraryCloseOptionsHolder.Name = "libraryCloseOptionsHolder"
	libraryCloseOptionsHolder.Parent = libraryCloseFrame
	libraryCloseOptionsHolder.BackgroundColor3 = Color3.fromRGB(48,19,99)
	libraryCloseOptionsHolder.BackgroundTransparency = 1
	libraryCloseOptionsHolder.BorderSizePixel = 0
	libraryCloseOptionsHolder.Position = UDim2.new(0,0,0.643286765,0)
	libraryCloseOptionsHolder.Size = UDim2.new(0,300,0,71)

	local libraryCloseOptionsUICorner = Instance.new("UICorner")
	libraryCloseOptionsUICorner.CornerRadius = UDim.new(0,4)
	libraryCloseOptionsUICorner.Parent = libraryCloseOptionsHolder

	local libraryCloseTitle = Instance.new("TextLabel")
	libraryCloseTitle.Name = "libraryCloseTitle"
	libraryCloseTitle.Parent = libraryCloseFrame
	libraryCloseTitle.BackgroundTransparency = 1
	libraryCloseTitle.Position = UDim2.new(0.0967,0,0.07,0)
	libraryCloseTitle.Size = UDim2.new(0,200,0,50)
	libraryCloseTitle.Font = Enum.Font.Arimo
	libraryCloseTitle.RichText = true
	libraryCloseTitle.Text = "<b> Close Gui </b>"
	libraryCloseTitle.TextColor3 = Color3.fromRGB(255,255,255)
	libraryCloseTitle.TextSize = 18
	libraryCloseTitle.TextTransparency = 1
	libraryCloseTitle.TextXAlignment = Enum.TextXAlignment.Left
	libraryCloseTitle.AutoLocalize = false

	local libraryCloseDescription = Instance.new("TextLabel")
	libraryCloseDescription.Name = "libraryCloseDescription"
	libraryCloseDescription.Parent = libraryCloseFrame
	libraryCloseDescription.BackgroundTransparency = 1
	libraryCloseDescription.Position = UDim2.new(0.0967,0,0.285,0)
	libraryCloseDescription.Size = UDim2.new(0,200,0,37)
	libraryCloseDescription.Font = Enum.Font.Arimo
	libraryCloseDescription.RichText = true
	libraryCloseDescription.Text = "<b> Would you like to close this gui interface? </b>"
	libraryCloseDescription.TextColor3 = Color3.fromRGB(255,255,255)
	libraryCloseDescription.TextSize = 14
	libraryCloseDescription.TextTransparency = 1
	libraryCloseDescription.TextXAlignment = Enum.TextXAlignment.Left
	libraryCloseDescription.AutoLocalize = false

	local libraryCloseYesButton = Instance.new("TextButton")
	libraryCloseYesButton.Name = "libraryCloseYesButton"
	libraryCloseYesButton.Parent = libraryCloseOptionsHolder
	libraryCloseYesButton.BackgroundTransparency = 1
	libraryCloseYesButton.Position = UDim2.new(0.098,0,0.141,0)
	libraryCloseYesButton.Size = UDim2.new(0,110,0,50)
	libraryCloseYesButton.Font = Enum.Font.Arimo
	libraryCloseYesButton.RichText = true
	libraryCloseYesButton.Text = "<b> Yes </b>"
	libraryCloseYesButton.TextColor3 = Color3.fromRGB(255,255,255)
	libraryCloseYesButton.TextSize = 14
	libraryCloseYesButton.TextTransparency = 1
	libraryCloseYesButton.AutoLocalize = false

	libraryCloseYesButton.MouseButton1Click:Connect(function()
		libraryCloseFrameHolder.Visible = false
		mainFrameHolder.Visible = false
	end)

	local libraryCloseYesButtonUICorner = Instance.new("UICorner")
	libraryCloseYesButtonUICorner.Parent = libraryCloseYesButton
	libraryCloseYesButtonUICorner.CornerRadius = UDim.new(0,4)

	local libraryCloseYesButtonUIStroke = Instance.new("UIStroke")
	libraryCloseYesButtonUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	libraryCloseYesButtonUIStroke.Parent = libraryCloseYesButton
	libraryCloseYesButtonUIStroke.Color = Color3.fromRGB(94,51,153)
	libraryCloseYesButtonUIStroke.Thickness = 1.5
	libraryCloseYesButtonUIStroke.Transparency = 1

	local libraryCloseNoButton = Instance.new("TextButton")
	libraryCloseNoButton.Name = "libraryCloseNoButton"
	libraryCloseNoButton.Parent = libraryCloseOptionsHolder
	libraryCloseNoButton.BackgroundTransparency = 1
	libraryCloseNoButton.Position = UDim2.new(0.525,0,0.141,0)
	libraryCloseNoButton.Size = UDim2.new(0,110,0,50)
	libraryCloseNoButton.Font = Enum.Font.Arimo
	libraryCloseNoButton.RichText = true
	libraryCloseNoButton.Text = "<b> No </b>"
	libraryCloseNoButton.TextColor3 = Color3.fromRGB(255,255,255)
	libraryCloseNoButton.TextSize = 14
	libraryCloseNoButton.TextTransparency = 1
	libraryCloseNoButton.AutoLocalize = false

	local libraryCloseNoButtonUIStroke = Instance.new("UIStroke")
	libraryCloseNoButtonUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	libraryCloseNoButtonUIStroke.Parent = libraryCloseNoButton
	libraryCloseNoButtonUIStroke.Color = Color3.fromRGB(94,51,153)
	libraryCloseNoButtonUIStroke.Thickness = 1.5
	libraryCloseNoButtonUIStroke.Transparency = 1

	libraryCloseNoButton.MouseButton1Click:Connect(function()
		local tweenInfo = TweenInfo.new(0.5)
		TweenService:Create(libraryCloseFrame,tweenInfo,{BackgroundTransparency=1}):Play()
		TweenService:Create(libraryCloseOptionsHolder,tweenInfo,{BackgroundTransparency=1}):Play()
		TweenService:Create(libraryCloseTitle,tweenInfo,{TextTransparency=1}):Play()
		TweenService:Create(libraryCloseDescription,tweenInfo,{TextTransparency=1}):Play()
		TweenService:Create(libraryCloseYesButton,tweenInfo,{TextTransparency=1}):Play()
		TweenService:Create(libraryCloseNoButton,tweenInfo,{TextTransparency=1}):Play()
		TweenService:Create(libraryCloseYesButtonUIStroke,tweenInfo,{Transparency=1}):Play()
		TweenService:Create(libraryCloseNoButtonUIStroke,tweenInfo,{Transparency=1}):Play()
		task.wait(0.5)
		libraryCloseFrameHolder.Visible = false
	end)

	local libraryCloseNoUICorner = Instance.new("UICorner")
	libraryCloseNoUICorner.CornerRadius = UDim.new(0,4)
	libraryCloseNoUICorner.Parent = libraryCloseNoButton

	local moonImage = Instance.new("ImageLabel")
	moonImage.Name = "moonImage"
	moonImage.Parent = topBar
	moonImage.BackgroundTransparency = 1
	moonImage.Position = UDim2.new(0.030,0,0.12,0)
	moonImage.Size = UDim2.new(0,30,0,30)
	moonImage.Image = "rbxassetid://78068350315809"

	local xButton = Instance.new("ImageButton")
	xButton.Name = "xButton"
	xButton.Parent = topBar
	xButton.BackgroundTransparency = 1
	xButton.Position = UDim2.new(0.93,0,0.12,0)
	xButton.Size = UDim2.new(0,30,0,30)
	xButton.Image = "rbxassetid://116840683700746"

	xButton.MouseButton1Click:Connect(function()
		libraryCloseFrameHolder.Visible = true
		libraryCloseFrameHolder.AutoLocalize = true
		local tweenInfo = TweenInfo.new(0.5)
		TweenService:Create(libraryCloseFrameHolder,tweenInfo,{BackgroundTransparency=0.8}):Play()
		TweenService:Create(libraryCloseFrame,tweenInfo,{BackgroundTransparency=0.1}):Play()
		TweenService:Create(libraryCloseOptionsHolder,tweenInfo,{BackgroundTransparency=0.4}):Play()
		TweenService:Create(libraryCloseTitle,tweenInfo,{TextTransparency=0}):Play()
		TweenService:Create(libraryCloseDescription,tweenInfo,{TextTransparency=0}):Play()
		TweenService:Create(libraryCloseYesButton,tweenInfo,{TextTransparency=0}):Play()
		TweenService:Create(libraryCloseNoButton,tweenInfo,{TextTransparency=0}):Play()
		TweenService:Create(libraryCloseYesButtonUIStroke,tweenInfo,{Transparency=0}):Play()
		TweenService:Create(libraryCloseNoButtonUIStroke,tweenInfo,{Transparency=0}):Play()
	end)

	local maximizeButton = Instance.new("ImageButton")
	maximizeButton.Name = "maximizeButton"
	maximizeButton.Parent = topBar
	maximizeButton.BackgroundTransparency = 1
	maximizeButton.Position = UDim2.new(0.88,0,0.16,0)
	maximizeButton.Size = UDim2.new(0,25,0,25)
	maximizeButton.Image = "rbxassetid://112544679223166"

	local minimizeButton = Instance.new("ImageButton")
	minimizeButton.Name = "minimizeButton"
	minimizeButton.Parent = topBar
	minimizeButton.BackgroundTransparency = 1
	minimizeButton.Position = UDim2.new(0.8218,0,0.12,0)
	minimizeButton.Size = UDim2.new(0,30,0,30)
	minimizeButton.Image = "rbxassetid://122469386482081"
	
	minimizeButton.MouseButton1Click:Connect(function()
		mainFrameHolder.Visible = false
	end)

	local topBarUICorner = Instance.new("UICorner")
	topBarUICorner.CornerRadius = UDim.new(0,32)
	topBarUICorner.Parent = topBar

	local Hide = Instance.new("Frame")
	Hide.Name = "Hide"
	Hide.Parent = mainFrame
	Hide.BackgroundColor3 = Color3.fromRGB(69,18,100)
	Hide.BackgroundTransparency = 1
	Hide.BorderSizePixel = 0
	Hide.Position = UDim2.new(0,0,0,39)
	Hide.Size = UDim2.new(1,0,0,16)
	Hide.ZIndex = 2

	local tabsHolder = Instance.new("Frame")
	tabsHolder.Name = "tabsHolder"
	tabsHolder.Parent = mainFrame
	tabsHolder.BackgroundTransparency = 1
	tabsHolder.Position = UDim2.new(3.2697406e-07,0,0.107843138,0)
	tabsHolder.Size = UDim2.new(0,198,0,455)

	local tabsContainer = Instance.new("ScrollingFrame")
	tabsContainer.Name = "tabsContainer"
	tabsContainer.Parent = tabsHolder
	tabsContainer.Active = true
	tabsContainer.BackgroundColor3 = Color3.fromRGB(69,18,100)
	tabsContainer.BackgroundTransparency = 0.6
	tabsContainer.BorderSizePixel = 0
	tabsContainer.Position = UDim2.new(1.2207031e-06,0,-0.00204689102,0)
	tabsContainer.Size = UDim2.new(0,198,0,430)
	tabsContainer.ScrollBarThickness = 0

	local tabsContainerUIListLayout = Instance.new("UIListLayout")
	tabsContainerUIListLayout.Parent = tabsContainer
	tabsContainerUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabsContainerUIListLayout.Padding = UDim.new(0,4)
	
	local featuresHolder = Instance.new("Frame")
	featuresHolder.Name = "featuresHolder"
	featuresHolder.Parent = mainFrame
	featuresHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	featuresHolder.BackgroundTransparency = 1.000
	featuresHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	featuresHolder.BorderSizePixel = 0
	featuresHolder.Position = UDim2.new(0.35357219, 0, 0.107843138, 0)
	featuresHolder.Size = UDim2.new(0, 360, 0, 429)
	
	local featuresContainer = Instance.new("ScrollingFrame")
	featuresContainer.Name = "featuresContainer"
	featuresContainer.Parent = featuresHolder
	featuresContainer.Active = true
	featuresContainer.BackgroundColor3 = Color3.fromRGB(91, 20, 135)
	featuresContainer.BackgroundTransparency = 0.800
	featuresContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	featuresContainer.BorderSizePixel = 0
	featuresContainer.Position = UDim2.new(0, 0, -0.00233100238, 0)
	featuresContainer.Size = UDim2.new(0, 363, 0, 430)
	featuresContainer.ScrollBarThickness = 3
	
	local featuresContainerUIListLayout = Instance.new("UIListLayout")
	featuresContainerUIListLayout.Parent = featuresContainer
	featuresContainerUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	featuresContainerUIListLayout.Padding = UDim.new(0, 6)

	local function lerp(a,b,t)
		return a + (b-a)*t
	end

	local function update(dt)
		if not dragging or not startPos then return end
		local delta = lastMouse - UserInputService:GetMouseLocation()
		local x = startPos.X.Offset - delta.X
		local y = startPos.Y.Offset - delta.Y
		mainFrameHolder.Position = UDim2.new(
			startPos.X.Scale,
			lerp(mainFrameHolder.Position.X.Offset, x, dt * dragSpeed),
			startPos.Y.Scale,
			lerp(mainFrameHolder.Position.Y.Offset, y, dt * dragSpeed)
		)
	end

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = mainFrameHolder.Position
			lastMouse = UserInputService:GetMouseLocation()
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	RunService.Heartbeat:Connect(update)

	Window.Gui = ScreenGui

	return Window
end

return NovaLib
