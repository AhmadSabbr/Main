local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local NovaLib = {}

function NovaLib:CreateWindow(Settings)
	local Title = Settings.Title or ""
	local Window = {}
	Window._controls = {}
	local CurrentTab = nil
	local dragging = false
	local startPos, lastMouse
	local dragSpeed = 100
	local minimizeKeybind = Settings.MinimizeKeybind
	local minimizeKey = Settings.MinimizeKey
	local minimized = false
	local expanded = false
	
	local writefile = writefile or (function() end)
	local readfile = readfile or (function() return "" end)
	local isfile = isfile or (function() return false end)
	local isfolder = isfolder or (function() return false end)
	local makefolder = makefolder or (function() end)
	local listfiles = listfiles or (function() return {} end)
	local delfile = delfile or (function() end)
	local appendfile = appendfile or (function() end)
	
	local ConfigFolder = "NovaLibraryFolder"
	if not isfolder(ConfigFolder) then
		makefolder(ConfigFolder)
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Library"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local mainFrameHolder = Instance.new("Frame")
	mainFrameHolder.Name = "mainFrameHolder"
	mainFrameHolder.Parent = ScreenGui
	mainFrameHolder.BackgroundColor3 = Color3.fromRGB(68, 12, 121)
	mainFrameHolder.BackgroundTransparency = 0.4
	mainFrameHolder.BorderSizePixel = 0
	mainFrameHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrameHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrameHolder.Size = UDim2.new(0,580,0,530)

	local mainFrameHolderUIScale = Instance.new("UIScale")
	mainFrameHolderUIScale.Scale = 1
	mainFrameHolderUIScale.Parent = mainFrameHolder
	
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
		ScreenGui:Destroy()
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
	
	maximizeButton.MouseButton1Click:Connect(function()
		if expanded then
			TweenService:Create(mainFrameHolderUIScale, TweenInfo.new(0.5), {Scale = 1}):Play()
		else
			TweenService:Create(mainFrameHolderUIScale, TweenInfo.new(0.5), {Scale = 1.4}):Play()
		end
		expanded = not expanded
	end)

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
	
	local notificationFrameHolder = Instance.new("Frame")
	notificationFrameHolder.Name = "notificationFrameHolder"
	notificationFrameHolder.Parent = mainFrameHolder
	notificationFrameHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notificationFrameHolder.BackgroundTransparency = 1
	notificationFrameHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notificationFrameHolder.BorderSizePixel = 0
	notificationFrameHolder.Position = UDim2.new(1.39655173, 0, -0.257395387, 0)
	notificationFrameHolder.Size = UDim2.new(0, 249, 0, 770)

	local notificationFrameHolderUIListLayout = Instance.new("UIListLayout")
	notificationFrameHolderUIListLayout.Parent = notificationFrameHolder
	notificationFrameHolderUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notificationFrameHolderUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notificationFrameHolderUIListLayout.Padding = UDim.new(0, 8)

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
	tabsContainer.ScrollBarImageTransparency = 1
	
	local tabsContainerUIPadding = Instance.new("UIPadding")
	tabsContainerUIPadding.Parent = tabsContainer
	tabsContainerUIPadding.PaddingLeft = UDim.new(0, 15)
	tabsContainerUIPadding.PaddingTop = UDim.new(0, 6)

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
	
	local function CreateNotification(Name, Content, Timer)

		local notificationFrame = Instance.new("Frame")
		notificationFrame.Name = "notificationFrame"
		notificationFrame.Parent = notificationFrameHolder
		notificationFrame.BackgroundColor3 = Color3.fromRGB(60, 13, 100)
		notificationFrame.BackgroundTransparency = 1
		notificationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationFrame.BorderSizePixel = 0
		notificationFrame.Size = UDim2.new(0, 250, 0, 151)
		
		local tweenInfo = TweenInfo.new(0.5)
		TweenService:Create(notificationFrame,tweenInfo,{BackgroundTransparency = 0.4}):Play()

		local notificationFrametitle = Instance.new("TextLabel")
		notificationFrametitle.Name = "title"
		notificationFrametitle.Parent = notificationFrame
		notificationFrametitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationFrametitle.BackgroundTransparency = 1
		notificationFrametitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationFrametitle.BorderSizePixel = 0
		notificationFrametitle.Position = UDim2.new(0.1, 0, 0, 0)
		notificationFrametitle.Size = UDim2.new(0, 200, 0, 44)
		notificationFrametitle.Font = Enum.Font.Arimo
		notificationFrametitle.RichText = true
		notificationFrametitle.Text = "<b>"..Name.."</b>"
		notificationFrametitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationFrametitle.TextSize = 14

		local notificationFrameUICorner = Instance.new("UICorner")
		notificationFrameUICorner.CornerRadius = UDim.new(0, 16)
		notificationFrameUICorner.Parent = notificationFrame

		local notificationFramecontent = Instance.new("TextLabel")
		notificationFramecontent.Name = "content"
		notificationFramecontent.Parent = notificationFrame
		notificationFramecontent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationFramecontent.BackgroundTransparency = 1
		notificationFramecontent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationFramecontent.BorderSizePixel = 0
		notificationFramecontent.Position = UDim2.new(0, 0, 0.291390717, 0)
		notificationFramecontent.Size = UDim2.new(0, 250, 0, 107)
		notificationFramecontent.Font = Enum.Font.Arimo
		notificationFramecontent.RichText = true
		notificationFramecontent.Text = "<b>".. Content .."</b>"
		notificationFramecontent.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationFramecontent.TextSize = 14
		notificationFramecontent.TextXAlignment = Enum.TextXAlignment.Left

		local notificationFramecontentUIPadding_ = Instance.new("UIPadding")
		notificationFramecontentUIPadding_.Parent = notificationFramecontent
		notificationFramecontentUIPadding_.PaddingBottom = UDim.new(0, 100)
		notificationFramecontentUIPadding_.PaddingLeft = UDim.new(0, 4)
		
		wait(Timer)
		notificationFrame:Destroy()
	end

	Window.Gui = ScreenGui
	
	function Window:CreateTab(TabSettings)
		local Tab = {}
		Tab.Window = self
		local Title = TabSettings.Title or ""
		local Icon = TabSettings.Icon or ""
		
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
		featuresContainer.Visible = false
		
		Tab.featuresContainer = featuresContainer

		local featuresContainerUIListLayout = Instance.new("UIListLayout")
		featuresContainerUIListLayout.Parent = featuresContainer
		featuresContainerUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		featuresContainerUIListLayout.Padding = UDim.new(0, 6)
		
		local featuresContainerUIPadding = Instance.new("UIPadding")
		featuresContainerUIPadding.Parent = featuresContainer
		featuresContainerUIPadding.PaddingTop = UDim.new(0, 20)
		featuresContainerUIPadding.PaddingLeft = UDim.new(0, 30)

		local tabHolder = Instance.new("Frame")
		tabHolder.Name = "tabHolder"
		tabHolder.Parent = tabsContainer
		tabHolder.BackgroundTransparency = 1
		tabHolder.BackgroundColor3 = Color3.fromRGB(73, 31, 107)
		tabHolder.BorderSizePixel = 0
		tabHolder.Size = UDim2.new(0, 170, 0, 40)

		local tabHolderUICorner = Instance.new("UICorner")
		tabHolderUICorner.Parent = tabHolder
		tabHolderUICorner.CornerRadius = UDim.new(0, 8)

		local tabButton = Instance.new("TextButton")
		tabButton.Name = "tabButton"
		tabButton.Parent = tabHolder
		tabButton.BackgroundTransparency = 1
		tabButton.BorderSizePixel = 0
		tabButton.Size = UDim2.new(0, 170, 0, 40)
		tabButton.Font = Enum.Font.Arimo
		tabButton.RichText = true
		tabButton.Text = "<b>" .. Title .. "</b>"
		tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabButton.TextSize = 16
		tabButton.TextXAlignment = Enum.TextXAlignment.Left
		
		tabButton.MouseButton1Click:Connect(function()
			for _,v in pairs(featuresHolder:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			for _,v in pairs(tabsContainer:GetChildren()) do
				if v:IsA("Frame") then
					v.BackgroundTransparency = 1
				end
			end
			featuresContainer.Visible = true
			tabHolder.BackgroundTransparency = 0.6
		end)

		local tabButtonUIPadding = Instance.new("UIPadding")
		tabButtonUIPadding.Parent = tabButton
		tabButtonUIPadding.PaddingLeft = UDim.new(0, 50)

		local tabIcon = Instance.new("ImageLabel")
		tabIcon.Name = "tabIcon"
		tabIcon.Parent = tabButton
		tabIcon.BackgroundTransparency = 1
		tabIcon.BorderSizePixel = 0
		tabIcon.Position = UDim2.new(-0.3, 0, 0.175, 0)
		tabIcon.Size = UDim2.new(0, 25, 0, 25)
		tabIcon.Image = Icon

		local tabIconUICorner = Instance.new("UICorner")
		tabIconUICorner.CornerRadius = UDim.new(0, 4)
		tabIconUICorner.Parent = tabIcon
		
		function Tab:CreateConfigNameButton()
			if self._configNameCreated then return end
			self._configNameCreated = true

			local configNameHolder = Instance.new("Frame")
			configNameHolder.Name = "configNameHolder"
			configNameHolder.Parent = self.featuresContainer
			configNameHolder.BackgroundColor3 = Color3.fromRGB(86,8,125)
			configNameHolder.BackgroundTransparency = 0.75
			configNameHolder.BorderSizePixel = 0
			configNameHolder.Size = UDim2.new(0,300,0,50)

			local configNameUICorner = Instance.new("UICorner")
			configNameUICorner.Parent = configNameHolder

			local configNameTitle = Instance.new("TextLabel")
			configNameTitle.Name = "title"
			configNameTitle.Parent = configNameHolder
			configNameTitle.BackgroundTransparency = 1
			configNameTitle.Size = UDim2.new(0,130,0,50)
			configNameTitle.Font = Enum.Font.Arimo
			configNameTitle.RichText = true
			configNameTitle.Text = "<b> Config Name: </b>"
			configNameTitle.TextColor3 = Color3.fromRGB(255,255,255)
			configNameTitle.TextSize = 14
			configNameTitle.TextXAlignment = Enum.TextXAlignment.Left

			local configNameUIPadding = Instance.new("UIPadding")
			configNameUIPadding.Parent = configNameTitle
			configNameUIPadding.PaddingLeft = UDim.new(0,15)

			local configNameline = Instance.new("Frame")
			configNameline.Name = "line"
			configNameline.Parent = configNameHolder
			configNameline.BackgroundColor3 = Color3.fromRGB(79,22,115)
			configNameline.BorderSizePixel = 0
			configNameline.Position = UDim2.new(0.556666672,0,0.9,0)
			configNameline.Size = UDim2.new(0,120,0,2)

			local configNameTextBox = Instance.new("TextBox")
			configNameTextBox.Parent = configNameHolder
			configNameTextBox.BackgroundTransparency = 1
			configNameTextBox.BorderSizePixel = 0
			configNameTextBox.Position = UDim2.new(0.556666672,0,0.14,0)
			configNameTextBox.Size = UDim2.new(0,120,0,35)
			configNameTextBox.Font = Enum.Font.Arimo
			configNameTextBox.RichText = false
			configNameTextBox.Text = ""
			configNameTextBox.TextColor3 = Color3.fromRGB(255,255,255)
			configNameTextBox.TextSize = 12
			configNameTextBox.ClipsDescendants = true

			local configNameTextBoxUIStroke = Instance.new("UIStroke")
			configNameTextBoxUIStroke.Parent = configNameTextBox
			configNameTextBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			configNameTextBoxUIStroke.Thickness = 0.5
			configNameTextBoxUIStroke.Transparency = 0.8
			configNameTextBoxUIStroke.Color = Color3.fromRGB(255,255,255)

			local configNameTextBoxUICorner = Instance.new("UICorner")
			configNameTextBoxUICorner.Parent = configNameTextBox

			configNameTextBox.FocusLost:Connect(function()
				if configNameTextBox.Text == "" then
					configNameTextBox.Text = "<b>...</b>"
				end
			end)

			self.Window._controls = self.Window._controls or {}
			self._configNameBox = configNameTextBox
		end
		
		function Tab:CreateConfigList()
			if self._configListCreated then return end
			self._configListCreated = true
			self._configs = {}

			local configListHolder = Instance.new("Frame")
			configListHolder.Name = "configListHolder"
			configListHolder.Parent = self.featuresContainer
			configListHolder.BackgroundColor3 = Color3.fromRGB(86,8,125)
			configListHolder.BackgroundTransparency = 0.75
			configListHolder.BorderSizePixel = 0
			configListHolder.Size = UDim2.new(0,300,0,50)
			configListHolder.ClipsDescendants = false
			configListHolder.ZIndex = 15

			local configListUICorner = Instance.new("UICorner")
			configListUICorner.Parent = configListHolder

			local configListHoldertitle = Instance.new("TextLabel")
			configListHoldertitle.Name = "title"
			configListHoldertitle.Parent = configListHolder
			configListHoldertitle.BackgroundTransparency = 1
			configListHoldertitle.Size = UDim2.new(0,300,0,50)
			configListHoldertitle.Font = Enum.Font.Arimo
			configListHoldertitle.RichText = true
			configListHoldertitle.Text = "<b>Config List</b>"
			configListHoldertitle.TextColor3 = Color3.fromRGB(255,255,255)
			configListHoldertitle.TextSize = 14
			configListHoldertitle.TextXAlignment = Enum.TextXAlignment.Left

			local configListHoldertitleUIPadding = Instance.new("UIPadding")
			configListHoldertitleUIPadding.Parent = configListHoldertitle
			configListHoldertitleUIPadding.PaddingLeft = UDim.new(0,15)

			local configOptionButton = Instance.new("TextButton")
			configOptionButton.Name = "configOptionButton"
			configOptionButton.Parent = configListHolder
			configOptionButton.BackgroundTransparency = 1
			configOptionButton.BorderSizePixel = 0
			configOptionButton.Position = UDim2.new(0.556666672,0,0.14,0)
			configOptionButton.Size = UDim2.new(0,120,0,35)
			configOptionButton.Font = Enum.Font.Arimo
			configOptionButton.RichText = true
			configOptionButton.Text = "<b>--</b>"
			configOptionButton.TextColor3 = Color3.fromRGB(255,255,255)
			configOptionButton.TextSize = 14
			configOptionButton.TextXAlignment = Enum.TextXAlignment.Left
			configOptionButton.ZIndex = 10

			local configOptionButtonUIStroke = Instance.new("UIStroke")
			configOptionButtonUIStroke.Parent = configOptionButton
			configOptionButtonUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			configOptionButtonUIStroke.Thickness = 0.5
			configOptionButtonUIStroke.Transparency = 0.8
			configOptionButtonUIStroke.Color = Color3.fromRGB(255,255,255)

			local configOptionButtonUICorner = Instance.new("UICorner")
			configOptionButtonUICorner.Parent = configOptionButton

			local configOptionButtonUIPadding = Instance.new("UIPadding")
			configOptionButtonUIPadding.Parent = configOptionButton
			configOptionButtonUIPadding.PaddingLeft = UDim.new(0,8)

			local configOptionButtonImageLabel = Instance.new("ImageLabel")
			configOptionButtonImageLabel.Parent = configOptionButton
			configOptionButtonImageLabel.BackgroundTransparency = 1
			configOptionButtonImageLabel.Position = UDim2.new(0.75,0,0.15,0)
			configOptionButtonImageLabel.Size = UDim2.new(0,25,0,25)
			configOptionButtonImageLabel.Rotation = 90
			configOptionButtonImageLabel.Image = "rbxassetid://88806457765010"

			local configOptionsHolder = Instance.new("Frame")
			configOptionsHolder.Name = "configOptionsHolder"
			configOptionsHolder.Parent = configListHolder
			configOptionsHolder.BackgroundColor3 = Color3.fromRGB(74,13,135)
			configOptionsHolder.BorderSizePixel = 0
			configOptionsHolder.Position = UDim2.new(0.517,0,1,0)
			configOptionsHolder.Size = UDim2.new(0,134,0,0)
			configOptionsHolder.Visible = false
			configOptionsHolder.ZIndex = 20

			local configOptionsHolderUICorner = Instance.new("UICorner")
			configOptionsHolderUICorner.Parent = configOptionsHolder
			configOptionsHolderUICorner.CornerRadius = UDim.new(0,8)

			local configOptionsHolderUIListLayout = Instance.new("UIListLayout")
			configOptionsHolderUIListLayout.Parent = configOptionsHolder

			for _,file in pairs(listfiles(ConfigFolder)) do
				local name = file:match("([^/\\]+)%.json$")
				if name then
					table.insert(self._configs,name)

					local option = Instance.new("TextButton")
					option.Parent = configOptionsHolder
					option.BackgroundTransparency = 1
					option.Size = UDim2.new(1,0,0,30)
					option.Font = Enum.Font.Ubuntu
					option.RichText = true
					option.Text = "<b>"..name.."</b>"
					option.TextColor3 = Color3.fromRGB(255,255,255)
					option.TextSize = 14
					option.ZIndex = 21

					option.MouseButton1Click:Connect(function()
						configOptionButton.Text = name
						configOptionsHolder.Visible = false
					end)
				end
			end

			local visibleCount = math.min(#self._configs,3)
			local height = visibleCount * 30
			configOptionsHolder.Size = UDim2.new(0,134,0,height)

			configOptionButton.MouseButton1Click:Connect(function()
				configOptionsHolder.Visible = not configOptionsHolder.Visible
			end)

			self._configOptionButton = configOptionButton
			self._configOptionsHolder = configOptionsHolder
		end
		
		function Tab:CreateSaveConfigButton()
			if self._saveConfigCreated then return end
			self._saveConfigCreated = true

			local saveConfigButton = Instance.new("Frame")
			saveConfigButton.Name = "saveConfigButton"
			saveConfigButton.Parent = self.featuresContainer
			saveConfigButton.BackgroundColor3 = Color3.fromRGB(86,8,125)
			saveConfigButton.BackgroundTransparency = 0.8
			saveConfigButton.BorderSizePixel = 0
			saveConfigButton.Size = UDim2.new(0,300,0,50)

			local saveConfigButtonUICorner = Instance.new("UICorner")
			saveConfigButtonUICorner.Parent = saveConfigButton

			local saveConfigButtontitle = Instance.new("TextLabel")
			saveConfigButtontitle.Name = "title"
			saveConfigButtontitle.Parent = saveConfigButton
			saveConfigButtontitle.BackgroundTransparency = 1
			saveConfigButtontitle.Position = UDim2.new(0,0,0.1,0)
			saveConfigButtontitle.Size = UDim2.new(0,130,0,40)
			saveConfigButtontitle.Font = Enum.Font.Arimo
			saveConfigButtontitle.RichText = true
			saveConfigButtontitle.Text = "<b>Save Config</b>"
			saveConfigButtontitle.TextColor3 = Color3.fromRGB(255,255,255)
			saveConfigButtontitle.TextSize = 14
			saveConfigButtontitle.TextXAlignment = Enum.TextXAlignment.Left

			local saveConfigButtontitleUIPadding = Instance.new("UIPadding")
			saveConfigButtontitleUIPadding.Parent = saveConfigButtontitle
			saveConfigButtontitleUIPadding.PaddingLeft = UDim.new(0,15)

			local saveConfigButtonButton = Instance.new("ImageButton")
			saveConfigButtonButton.Name = "Button"
			saveConfigButtonButton.Parent = saveConfigButton
			saveConfigButtonButton.BackgroundTransparency = 1
			saveConfigButtonButton.BorderSizePixel = 0
			saveConfigButtonButton.Size = UDim2.new(0,298,0,50)
			saveConfigButtonButton.Position = UDim2.new(0,1,0,0)

			saveConfigButtonButton.MouseButton1Click:Connect(function()
				local name = self._configNameBox.Text
				if not name or name == "" or name == "..." then return end

				local data = {}

				for _,control in pairs(self.Window._controls) do
					if control.Type == "Toggle" then
						data[control.Title] = control.Object:GetValue()
					elseif control.Type == "Slider" then
						data[control.Title] = control.Object:GetValue()
					elseif control.Type == "Textbox" then
						data[control.Title] = control.Object:GetValue()
					elseif control.Type == "Dropdown" then
						data[control.Title] = control.Object:Get()
					end
				end

				local json = HttpService:JSONEncode(data)
				writefile(ConfigFolder.."/"..name..".json",json)

				if not table.find(self._configs,name) then
					table.insert(self._configs,name)

					local option = Instance.new("TextButton")
					option.Parent = self._configOptionsHolder
					option.BackgroundTransparency = 1
					option.Size = UDim2.new(1,0,0,30)
					option.Font = Enum.Font.Ubuntu
					option.RichText = true
					option.Text = "<b>"..name.."</b>"
					option.TextColor3 = Color3.fromRGB(255,255,255)
					option.TextSize = 14
					option.ZIndex = 21

					option.MouseButton1Click:Connect(function()
						self._configOptionButton.Text = name
						self._configOptionsHolder.Visible = false
					end)

					local visibleCount = math.min(#self._configs,3)
					self._configOptionsHolder.Size = UDim2.new(0,134,0,visibleCount*30)
				end
			end)
		end
		
		function Tab:CreateloadConfigButton()
			local loadConfigButton = Instance.new("Frame")
			loadConfigButton.Name = "loadConfigButton"
			loadConfigButton.Parent = self.featuresContainer
			loadConfigButton.BackgroundColor3 = Color3.fromRGB(86,8,125)
			loadConfigButton.BackgroundTransparency = 0.8
			loadConfigButton.BorderSizePixel = 0
			loadConfigButton.Size = UDim2.new(0,300,0,50)

			local loadConfigButtonUICorner = Instance.new("UICorner")
			loadConfigButtonUICorner.Parent = loadConfigButton

			local loadConfigButtontitle = Instance.new("TextLabel")
			loadConfigButtontitle.Name = "title"
			loadConfigButtontitle.Parent = loadConfigButton
			loadConfigButtontitle.BackgroundTransparency = 1
			loadConfigButtontitle.Position = UDim2.new(0,0,0.1,0)
			loadConfigButtontitle.Size = UDim2.new(0,130,0,40)
			loadConfigButtontitle.Font = Enum.Font.Arimo
			loadConfigButtontitle.RichText = true
			loadConfigButtontitle.Text = "<b>Load Config</b>"
			loadConfigButtontitle.TextColor3 = Color3.fromRGB(255,255,255)
			loadConfigButtontitle.TextSize = 14
			loadConfigButtontitle.TextXAlignment = Enum.TextXAlignment.Left

			local loadConfigButtontitleUIPadding = Instance.new("UIPadding")
			loadConfigButtontitleUIPadding.Parent = loadConfigButtontitle
			loadConfigButtontitleUIPadding.PaddingLeft = UDim.new(0,15)

			local loadConfigButtonButton = Instance.new("ImageButton")
			loadConfigButtonButton.Name = "Button"
			loadConfigButtonButton.Parent = loadConfigButton
			loadConfigButtonButton.BackgroundTransparency = 1
			loadConfigButtonButton.BorderSizePixel = 0
			loadConfigButtonButton.Position = UDim2.new(0,1,0,0)
			loadConfigButtonButton.Size = UDim2.new(0,298,0,50)
			loadConfigButtonButton.ImageTransparency = 1

			loadConfigButtonButton.MouseButton1Click:Connect(function()
				local name = self._configOptionButton.Text
				local path = ConfigFolder.."/"..name..".json"
				if not isfile(path) then return end

				local data = HttpService:JSONDecode(readfile(path))

				for _,control in pairs(self.Window._controls) do
					local value = data[control.Title]
					if value ~= nil then
						if control.Type == "Toggle" then
							control.Object:SetValue(value)
						elseif control.Type == "Slider" then
							control.Object:SetValue(value)
						elseif control.Type == "Textbox" then
							control.Object:SetValue(value)
						elseif control.Type == "Dropdown" then
							control.Object:Set(value)
						end
					end
				end
			end)
		end
		
		function Tab:CreateTextSeparator(Text)
			local TextSeparator = {}
			local textSeparatorHolder = Instance.new("Frame")
			textSeparatorHolder.Name = "textSeparatorHolder"
			textSeparatorHolder.Parent = featuresContainer
			textSeparatorHolder.BackgroundColor3 = Color3.fromRGB(86, 8, 125)
			textSeparatorHolder.BackgroundTransparency = 1.000
			textSeparatorHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			textSeparatorHolder.BorderSizePixel = 0
			textSeparatorHolder.Position = UDim2.new(0, 0, 0.349642009, 0)
			textSeparatorHolder.Size = UDim2.new(0, 300, 0, 25)

			local textSeparatorHolderUICorner = Instance.new("UICorner")
			textSeparatorHolderUICorner.Parent = textSeparatorHolder

			local textSeparatorHoldertitle = Instance.new("TextLabel")
			textSeparatorHoldertitle.Name = "title"
			textSeparatorHoldertitle.Parent = textSeparatorHolder
			textSeparatorHoldertitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			textSeparatorHoldertitle.BackgroundTransparency = 1.000
			textSeparatorHoldertitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			textSeparatorHoldertitle.BorderSizePixel = 0
			textSeparatorHoldertitle.Size = UDim2.new(0, 300, 0, 25)
			textSeparatorHoldertitle.Font = Enum.Font.Arimo
			textSeparatorHoldertitle.RichText = true
			textSeparatorHoldertitle.Text = "<b>" .. Text .. "</b>"
			textSeparatorHoldertitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			textSeparatorHoldertitle.TextSize = 16.000
			textSeparatorHoldertitle.TextXAlignment = Enum.TextXAlignment.Left

			local textSeparatorHoldertitleUIPadding = Instance.new("UIPadding")
			textSeparatorHoldertitleUIPadding.Parent = textSeparatorHoldertitle
			textSeparatorHoldertitleUIPadding.PaddingLeft = UDim.new(0, 6)
			
			return TextSeparator
		end
		
		function Tab:CreateLabel(Text)
			local Label = {}
			local labelHolder = Instance.new("Frame")
			labelHolder.Name = "labelHolder"
			labelHolder.Parent = featuresContainer
			labelHolder.BackgroundColor3 = Color3.fromRGB(86, 8, 125)
			labelHolder.BackgroundTransparency = 0.750
			labelHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			labelHolder.BorderSizePixel = 0
			labelHolder.Position = UDim2.new(-0.0210843366, 0, 0.21121718, 0)
			labelHolder.Size = UDim2.new(0, 300, 0, 50)
			
			local labelHolderUICorner = Instance.new("UICorner")
			labelHolderUICorner.Parent = labelHolder
			
			local labelHoldertitle = Instance.new("TextLabel")
			labelHoldertitle.Name = "title"
			labelHoldertitle.Parent = labelHolder
			labelHoldertitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			labelHoldertitle.BackgroundTransparency = 1.000
			labelHoldertitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			labelHoldertitle.BorderSizePixel = 0
			labelHoldertitle.Size = UDim2.new(0, 300, 0, 50)
			labelHoldertitle.Font = Enum.Font.Arimo
			labelHoldertitle.RichText = true
			labelHoldertitle.Text = "<b>" .. Text .. "</b>"
			labelHoldertitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			labelHoldertitle.TextSize = 16.000
			labelHoldertitle.TextXAlignment = Enum.TextXAlignment.Left
			
			local labelHoldertitleUIPadding = Instance.new("UIPadding")
			labelHoldertitleUIPadding.Parent = labelHoldertitle
			labelHoldertitleUIPadding.PaddingLeft = UDim.new(0, 15)
			
			return Label
		end
		
		function Tab:CreateParagraph(Settings)
			local Paragraph = {}
			local Text = Settings.Text or ""
			local Content = Settings.Content or ""
			
			local paragraphHolder = Instance.new("Frame")
			paragraphHolder.Name = "paragraphHolder"
			paragraphHolder.Parent = featuresContainer
			paragraphHolder.BackgroundColor3 = Color3.fromRGB(86, 8, 125)
			paragraphHolder.BackgroundTransparency = 0.750
			paragraphHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			paragraphHolder.BorderSizePixel = 0
			paragraphHolder.Position = UDim2.new(0, 0, 0.352028638, 0)
			paragraphHolder.Size = UDim2.new(0, 300, 0, 80)
			
			local paragraphHolderUICorner = Instance.new("UICorner")
			paragraphHolderUICorner.Parent = paragraphHolder
			
			local paragraphHoldertitle = Instance.new("TextLabel")
			paragraphHoldertitle.Name = "title"
			paragraphHoldertitle.Parent = paragraphHolder
			paragraphHoldertitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			paragraphHoldertitle.BackgroundTransparency = 1.000
			paragraphHoldertitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			paragraphHoldertitle.BorderSizePixel = 0
			paragraphHoldertitle.Size = UDim2.new(0, 300, 0, 40)
			paragraphHoldertitle.Font = Enum.Font.Arimo
			paragraphHoldertitle.RichText = true
			paragraphHoldertitle.Text = "<b>" .. Text .. "</b>"
			paragraphHoldertitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			paragraphHoldertitle.TextSize = 16.000
			paragraphHoldertitle.TextXAlignment = Enum.TextXAlignment.Left
			
			local paragraphHoldertitleUIPadding = Instance.new("UIPadding")
			paragraphHoldertitleUIPadding.Parent = paragraphHoldertitle
			paragraphHoldertitleUIPadding.PaddingLeft = UDim.new(0, 15)
			
			local content = Instance.new("TextLabel")
			content.Name = "content"
			content.Parent = paragraphHolder
			content.BackgroundTransparency = 1
			content.BorderSizePixel = 0
			content.Position = UDim2.new(0,0,0,40)
			content.Size = UDim2.new(1,0,0,0)
			content.Font = Enum.Font.Arimo
			content.RichText = true
			content.Text = "<b>" .. Content .. "</b>"
			content.TextColor3 = Color3.fromRGB(255,255,255)
			content.TextSize = 12
			content.TextTransparency = 0.4
			content.TextXAlignment = Enum.TextXAlignment.Left
			content.TextWrapped = true
			content.AutomaticSize = Enum.AutomaticSize.Y

			local contentUIPadding = Instance.new("UIPadding")
			contentUIPadding.Parent = content
			contentUIPadding.PaddingLeft = UDim.new(0,25)
			contentUIPadding.PaddingBottom = UDim.new(0,10)

			paragraphHolder.AutomaticSize = Enum.AutomaticSize.Y
			
			return Paragraph
		end
		
		function Tab:CreateButton(Settings)
			local Button = {}
			local Title = Settings.Title or "Button"
			local Description = Settings.Description or ""
			local Callback = Settings.Callback or function() end

			local buttonHolder = Instance.new("Frame")
			buttonHolder.Name = "buttonHolder"
			buttonHolder.Parent = featuresContainer
			buttonHolder.BackgroundColor3 = Color3.fromRGB(86, 8, 125)
			buttonHolder.BackgroundTransparency = 0.8
			buttonHolder.BorderSizePixel = 0
			buttonHolder.Size = UDim2.new(0,300,0,65)

			local buttonHolderUICorner = Instance.new("UICorner")
			buttonHolderUICorner.Parent = buttonHolder

			local buttonHoldertitle = Instance.new("TextLabel")
			buttonHoldertitle.Name = "title"
			buttonHoldertitle.Parent = buttonHolder
			buttonHoldertitle.BackgroundTransparency = 1
			buttonHoldertitle.Size = UDim2.new(0,130,0,40)
			buttonHoldertitle.Font = Enum.Font.ArialBold
			buttonHoldertitle.Text = Title
			buttonHoldertitle.TextColor3 = Color3.fromRGB(255,255,255)
			buttonHoldertitle.TextSize = 16
			buttonHoldertitle.TextXAlignment = Enum.TextXAlignment.Left

			local buttonHoldertitleUIPadding = Instance.new("UIPadding")
			buttonHoldertitleUIPadding.Parent = buttonHoldertitle
			buttonHoldertitleUIPadding.PaddingLeft = UDim.new(0,15)

			local ImageButton = Instance.new("ImageButton")
			ImageButton.Name = "Button"
			ImageButton.Parent = buttonHolder
			ImageButton.BackgroundTransparency = 1
			ImageButton.BorderSizePixel = 0
			ImageButton.Position = UDim2.new(0.0066,0,0,0)
			ImageButton.Size = UDim2.new(0,298,0,65)
			ImageButton.ImageTransparency = 1

			local description = Instance.new("TextLabel")
			description.Name = "description"
			description.Parent = buttonHolder
			description.BackgroundTransparency = 1
			description.BorderSizePixel = 0
			description.Position = UDim2.new(0.04,0,0.47,0)
			description.Size = UDim2.new(0,240,0,34)
			description.Font = Enum.Font.ArialBold
			description.Text = Description
			description.TextColor3 = Color3.fromRGB(255,255,255)
			description.TextSize = 12
			description.TextXAlignment = Enum.TextXAlignment.Left

			local buttonImage = Instance.new("ImageLabel")
			buttonImage.Name = "buttonImage"
			buttonImage.Parent = buttonHolder
			buttonImage.BackgroundTransparency = 1
			buttonImage.BorderSizePixel = 0
			buttonImage.Image = "rbxassetid://75547167447899"
			buttonImage.Position = UDim2.new(0.8733,0,0.3076,0)
			buttonImage.Size = UDim2.new(0,25,0,25)

			local buttonImageUICorner = Instance.new("UICorner")
			buttonImageUICorner.Parent = buttonImage

			ImageButton.MouseButton1Click:Connect(function()
				Callback()
			end)

			return Button
		end
		
		function Tab:CreateToggle(Settings)
			local Toggle = {}
			local Title = Settings.Title or ""
			local State = Settings.State or false
			local Callback = Settings.Callback or function() end

			local toggleHolder = Instance.new("Frame")
			toggleHolder.Name = "toggleHolder"
			toggleHolder.Parent = self.featuresContainer
			toggleHolder.BackgroundColor3 = Color3.fromRGB(86,8,125)
			toggleHolder.BackgroundTransparency = 0.75
			toggleHolder.BorderSizePixel = 0
			toggleHolder.Size = UDim2.new(0,300,0,50)

			local toggleHolderUICorner = Instance.new("UICorner")
			toggleHolderUICorner.Parent = toggleHolder

			local toggleHoldertitle = Instance.new("TextLabel")
			toggleHoldertitle.Name = "title"
			toggleHoldertitle.Parent = toggleHolder
			toggleHoldertitle.BackgroundTransparency = 1
			toggleHoldertitle.BorderSizePixel = 0
			toggleHoldertitle.Size = UDim2.new(0,130,0,50)
			toggleHoldertitle.Font = Enum.Font.Arimo
			toggleHoldertitle.RichText = true
			toggleHoldertitle.Text = "<b>" .. Title .. "</b>"
			toggleHoldertitle.TextColor3 = Color3.fromRGB(255,255,255)
			toggleHoldertitle.TextSize = 16
			toggleHoldertitle.TextXAlignment = Enum.TextXAlignment.Left

			local toggleHoldertitleUIPadding = Instance.new("UIPadding")
			toggleHoldertitleUIPadding.Parent = toggleHoldertitle
			toggleHoldertitleUIPadding.PaddingLeft = UDim.new(0,15)

			local stateBox = Instance.new("ImageButton")
			stateBox.Name = "stateBox"
			stateBox.Parent = toggleHolder
			stateBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
			stateBox.BackgroundTransparency = 0.8
			stateBox.BorderSizePixel = 0
			stateBox.Position = UDim2.new(0.816666663,0,0.2,0)
			stateBox.Size = UDim2.new(0,30,0,30)
			stateBox.ImageTransparency = 1

			local stateBoxUICorner = Instance.new("UICorner")
			stateBoxUICorner.Parent = stateBox

			local function Update()
				if State then
					stateBox.BackgroundColor3 = Color3.fromRGB(204,98,193)
					stateBox.BackgroundTransparency = 0
				else
					stateBox.BackgroundColor3 = Color3.fromRGB(230,230,230)
					stateBox.BackgroundTransparency = 0.8
				end
				Callback(State)
			end

			stateBox.MouseButton1Click:Connect(function()
				State = not State
				Update()
			end)

			function Toggle:SetValue(Value)
				State = Value
				Update()
			end

			function Toggle:GetValue()
				return State
			end

			Update()

			self.Window._controls = self.Window._controls or {}

			table.insert(self.Window._controls,{
				Type = "Toggle",
				Title = Title,
				Object = Toggle
			})

			return Toggle
		end
		
		function Tab:CreateTextbox(Settings)
			local Textbox = {}
			local Title = Settings.Title or ""
			local Callback = Settings.Callback or function() end

			local textboxHolder = Instance.new("Frame")
			textboxHolder.Name = "textboxHolder"
			textboxHolder.Parent = self.featuresContainer
			textboxHolder.BackgroundColor3 = Color3.fromRGB(86,8,125)
			textboxHolder.BackgroundTransparency = 0.75
			textboxHolder.BorderSizePixel = 0
			textboxHolder.Size = UDim2.new(0,300,0,50)

			local textboxHolderUICorner = Instance.new("UICorner")
			textboxHolderUICorner.Parent = textboxHolder

			local textboxHoldertitle = Instance.new("TextLabel")
			textboxHoldertitle.Name = "title"
			textboxHoldertitle.Parent = textboxHolder
			textboxHoldertitle.BackgroundTransparency = 1
			textboxHoldertitle.BorderSizePixel = 0
			textboxHoldertitle.Size = UDim2.new(0,130,0,50)
			textboxHoldertitle.Font = Enum.Font.Arimo
			textboxHoldertitle.RichText = true
			textboxHoldertitle.Text = "<b>"..Title.."</b>"
			textboxHoldertitle.TextColor3 = Color3.fromRGB(255,255,255)
			textboxHoldertitle.TextSize = 16
			textboxHoldertitle.TextXAlignment = Enum.TextXAlignment.Left

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Parent = textboxHoldertitle
			UIPadding.PaddingLeft = UDim.new(0,15)

			local TextBox = Instance.new("TextBox")
			TextBox.Parent = textboxHolder
			TextBox.BackgroundTransparency = 1
			TextBox.BorderSizePixel = 0
			TextBox.Position = UDim2.new(0.456666678,0,0.14,0)
			TextBox.Size = UDim2.new(0,150,0,35)
			TextBox.Font = Enum.Font.Arimo
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(255,255,255)
			TextBox.TextSize = 12
			TextBox.ClearTextOnFocus = false

			local TextBoxUIStroke = Instance.new("UIStroke")
			TextBoxUIStroke.Parent = TextBox
			TextBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			TextBoxUIStroke.Thickness = 0.5
			TextBoxUIStroke.Transparency = 0.8
			TextBoxUIStroke.Color = Color3.fromRGB(255,255,255)

			local UICorner = Instance.new("UICorner")
			UICorner.Parent = TextBox

			TextBox.FocusLost:Connect(function()
				Callback(TextBox.Text)
			end)

			function Textbox:GetValue()
				return TextBox.Text
			end

			function Textbox:SetValue(v)
				TextBox.Text = v
				Callback(v)
			end

			self.Window._controls = self.Window._controls or {}

			table.insert(self.Window._controls,{
				Type = "Textbox",
				Title = Title,
				Object = Textbox
			})

			return Textbox
		end
		
		function Tab:CreateSlider(Settings)
			local Slider = {}
			local Title = Settings.Title or ""
			local Min = Settings.Min or 0
			local Max = Settings.Max or 100
			local Value = Settings.Default or Min
			local Callback = Settings.Callback or function() end
			local dragging = false

			local sliderHolder = Instance.new("Frame")
			sliderHolder.Parent = self.featuresContainer
			sliderHolder.BackgroundColor3 = Color3.fromRGB(86,8,125)
			sliderHolder.BackgroundTransparency = 0.75
			sliderHolder.BorderSizePixel = 0
			sliderHolder.Size = UDim2.new(0,300,0,50)

			local corner = Instance.new("UICorner",sliderHolder)

			local title = Instance.new("TextLabel")
			title.Parent = sliderHolder
			title.BackgroundTransparency = 1
			title.Size = UDim2.new(0,130,0,50)
			title.Font = Enum.Font.Arimo
			title.RichText = true
			title.Text = "<b>"..Title.."</b>"
			title.TextColor3 = Color3.fromRGB(255,255,255)
			title.TextSize = 16
			title.TextXAlignment = Enum.TextXAlignment.Left

			local pad = Instance.new("UIPadding",title)
			pad.PaddingLeft = UDim.new(0,15)

			local valueText = Instance.new("TextLabel")
			valueText.Parent = sliderHolder
			valueText.BackgroundTransparency = 1
			valueText.Position = UDim2.new(0.483333319,0,0,0)
			valueText.Size = UDim2.new(0,60,0,50)
			valueText.Font = Enum.Font.Arimo
			valueText.RichText = true
			valueText.Text = "<b>"..Value.."</b>"
			valueText.TextColor3 = Color3.fromRGB(255,255,255)
			valueText.TextSize = 14

			local line = Instance.new("Frame")
			line.Parent = sliderHolder
			line.BackgroundColor3 = Color3.fromRGB(255,255,255)
			line.BackgroundTransparency = 0.8
			line.BorderSizePixel = 0
			line.Position = UDim2.new(0.64,0,0.46,0)
			line.Size = UDim2.new(0,100,0,4)

			local lineCorner = Instance.new("UICorner",line)

			local dragger = Instance.new("Frame")
			dragger.Parent = line
			dragger.BackgroundColor3 = Color3.fromRGB(255,255,255)
			dragger.BorderSizePixel = 0
			dragger.Size = UDim2.new(0,15,0,15)

			local draggerCorner = Instance.new("UICorner",dragger)

			local function Update(v)
				Value = math.clamp(v,Min,Max)
				local percent = (Value-Min)/(Max-Min)
				dragger.Position = UDim2.new(percent,0,-1.5,0)
				valueText.Text = "<b>"..Value.."</b>"
				Callback(Value)
			end

			dragger.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local percent = math.clamp((input.Position.X-line.AbsolutePosition.X)/line.AbsoluteSize.X,0,1)
					local val = math.floor(Min+(Max-Min)*percent+0.5)
					Update(val)
				end
			end)

			function Slider:SetValue(v)
				Update(v)
			end

			function Slider:GetValue()
				return Value
			end

			Update(Value)

			self.Window._controls = self.Window._controls or {}

			table.insert(self.Window._controls,{
				Type = "Slider",
				Title = Title,
				Object = Slider
			})

			return Slider
		end
		
		function Tab:CreateInput(Settings)
			local Input = {}
			local Title = Settings.Title or ""
			local Callback = Settings.Callback or function() end
			local waiting = false
			local currentKey = nil

			local inputHolder = Instance.new("Frame")
			inputHolder.Name = "inputHolder"
			inputHolder.Parent = featuresContainer
			inputHolder.BackgroundColor3 = Color3.fromRGB(86,8,125)
			inputHolder.BackgroundTransparency = 0.75
			inputHolder.BorderSizePixel = 0
			inputHolder.Size = UDim2.new(0,300,0,50)

			local inputHolderUICorner = Instance.new("UICorner")
			inputHolderUICorner.Parent = inputHolder

			local title = Instance.new("TextLabel")
			title.Name = "title"
			title.Parent = inputHolder
			title.BackgroundTransparency = 1
			title.BorderSizePixel = 0
			title.Size = UDim2.new(0,130,0,50)
			title.Font = Enum.Font.Arimo
			title.RichText = true
			title.Text = "<b>"..Title.."</b>"
			title.TextColor3 = Color3.fromRGB(255,255,255)
			title.TextSize = 16
			title.TextXAlignment = Enum.TextXAlignment.Left

			local titleUIPadding = Instance.new("UIPadding")
			titleUIPadding.Parent = title
			titleUIPadding.PaddingLeft = UDim.new(0,15)

			local inputButtonBox = Instance.new("TextButton")
			inputButtonBox.Name = "inputButtonBox"
			inputButtonBox.Parent = inputHolder
			inputButtonBox.BackgroundTransparency = 1
			inputButtonBox.BorderSizePixel = 0
			inputButtonBox.Position = UDim2.new(0.483333319,0,0.14,0)
			inputButtonBox.Size = UDim2.new(0,140,0,35)
			inputButtonBox.Font = Enum.Font.Arimo
			inputButtonBox.Text = "Default"
			inputButtonBox.TextColor3 = Color3.fromRGB(255,255,255)
			inputButtonBox.TextSize = 14
			inputButtonBox.TextXAlignment = Enum.TextXAlignment.Left

			local inputButtonBoxUIStroke = Instance.new("UIStroke")
			inputButtonBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			inputButtonBoxUIStroke.Parent = inputButtonBox
			inputButtonBoxUIStroke.Thickness = 0.5
			inputButtonBoxUIStroke.Transparency = 0.8
			inputButtonBoxUIStroke.Color = Color3.fromRGB(255,255,255)

			local inputButtonBoxUICorner = Instance.new("UICorner")
			inputButtonBoxUICorner.CornerRadius = UDim.new(0,4)
			inputButtonBoxUICorner.Parent = inputButtonBox

			local inputButtonBoxUIPadding = Instance.new("UIPadding")
			inputButtonBoxUIPadding.Parent = inputButtonBox
			inputButtonBoxUIPadding.PaddingLeft = UDim.new(0,12)

			local line = Instance.new("Frame")
			line.Name = "line"
			line.Parent = inputHolder
			line.BackgroundColor3 = Color3.fromRGB(79,22,115)
			line.BorderSizePixel = 0
			line.Position = UDim2.new(0.49,0,0.9,0)
			line.Size = UDim2.new(0,140,0,2)

			inputButtonBox.MouseButton1Click:Connect(function()
				waiting = true
				inputButtonBox.Text = "..."
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed then return end
				if waiting then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode.Name
						inputButtonBox.Text = currentKey
						waiting = false
						Callback(currentKey)
					end
				end
			end)

			function Input:SetKey(key)
				currentKey = key
				inputButtonBox.Text = key
			end

			return Input
		end
		
		function Tab:CreateDropdown(Settings)
			local Dropdown = {}
			local Title = Settings.Title or ""
			local Options = Settings.Options or {}
			local Multi = Settings.Multi or false
			local Callback = Settings.Callback or function() end
			local selected = {}
			local buttons = {}
			local open = false

			local dropdownHolder = Instance.new("Frame")
			dropdownHolder.Name = "dropdownHolder"
			dropdownHolder.Parent = self.featuresContainer
			dropdownHolder.BackgroundColor3 = Color3.fromRGB(86,8,125)
			dropdownHolder.BackgroundTransparency = 0.75
			dropdownHolder.BorderSizePixel = 0
			dropdownHolder.Size = UDim2.new(0,300,0,50)
			dropdownHolder.ClipsDescendants = false
			dropdownHolder.ZIndex = 10

			local corner = Instance.new("UICorner", dropdownHolder)

			local title = Instance.new("TextLabel")
			title.Parent = dropdownHolder
			title.BackgroundTransparency = 1
			title.Size = UDim2.new(0,300,0,50)
			title.Font = Enum.Font.Arimo
			title.RichText = true
			title.Text = "<b>"..Title.."</b>"
			title.TextColor3 = Color3.fromRGB(255,255,255)
			title.TextSize = 16
			title.TextXAlignment = Enum.TextXAlignment.Left

			local pad = Instance.new("UIPadding", title)
			pad.PaddingLeft = UDim.new(0,15)

			local optionButton = Instance.new("TextButton")
			optionButton.Parent = dropdownHolder
			optionButton.BackgroundTransparency = 1
			optionButton.BorderSizePixel = 0
			optionButton.Position = UDim2.new(0.49,0,0.14,0)
			optionButton.Size = UDim2.new(0,140,0,35)
			optionButton.Font = Enum.Font.Arimo
			optionButton.RichText = true
			optionButton.Text = "<b>Options</b>"
			optionButton.TextColor3 = Color3.fromRGB(255,255,255)
			optionButton.TextSize = 14
			optionButton.TextXAlignment = Enum.TextXAlignment.Left
			optionButton.ZIndex = 10

			local optionButtonUIStroke = Instance.new("UIStroke")
			optionButtonUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			optionButtonUIStroke.Parent = optionButton
			optionButtonUIStroke.Thickness = 0.5
			optionButtonUIStroke.Transparency = 0.8
			optionButtonUIStroke.Color = Color3.fromRGB(255,255,255)

			local buttonCorner = Instance.new("UICorner", optionButton)

			local pad2 = Instance.new("UIPadding", optionButton)
			pad2.PaddingLeft = UDim.new(0,8)

			local arrow = Instance.new("ImageLabel")
			arrow.Parent = optionButton
			arrow.BackgroundTransparency = 1
			arrow.Position = UDim2.new(0.8,0,0.15,0)
			arrow.Size = UDim2.new(0,25,0,25)
			arrow.Rotation = 90
			arrow.Image = "rbxassetid://88806457765010"

			local optionsHolder = Instance.new("Frame")
			optionsHolder.Parent = dropdownHolder
			optionsHolder.BackgroundColor3 = Color3.fromRGB(74,13,135)
			optionsHolder.BorderSizePixel = 0
			optionsHolder.Position = UDim2.new(0.517,0,1,0)
			optionsHolder.Size = UDim2.new(0,134,0,0)
			optionsHolder.Visible = false
			optionsHolder.ZIndex = 20

			local optionsCorner = Instance.new("UICorner", optionsHolder)
			local layout = Instance.new("UIListLayout", optionsHolder)

			local function updateText()
				if #selected == 0 then
					optionButton.Text = "<b>Options</b>"
					return
				end
				local text = table.concat(selected,", ")
				optionButton.Text = "<b>"..text.."</b>"
			end

			local function fire()
				if Multi then
					Callback(selected)
				else
					Callback(selected[1])
				end
			end

			local function selectOption(opt)
				if Multi then
					if table.find(selected,opt) then
						table.remove(selected,table.find(selected,opt))
					else
						table.insert(selected,opt)
					end
				else
					selected = {opt}
					open = false
					optionsHolder.Visible = false
				end
				updateText()
				fire()
			end

			local function createOption(opt)
				local button = Instance.new("TextButton")
				button.Parent = optionsHolder
				button.BackgroundTransparency = 1
				button.BorderSizePixel = 0
				button.Size = UDim2.new(1,0,0,30)
				button.Font = Enum.Font.Arimo
				button.RichText = true
				button.Text = "<b>"..opt.."</b>"
				button.TextColor3 = Color3.fromRGB(255,255,255)
				button.TextSize = 14

				button.MouseButton1Click:Connect(function()
					selectOption(opt)
				end)

				buttons[opt] = button
			end

			for _,opt in ipairs(Options) do
				createOption(opt)
			end

			optionsHolder.Size = UDim2.new(0,134,0,#Options*30)

			optionButton.MouseButton1Click:Connect(function()
				open = not open
				optionsHolder.Visible = open
			end)

			function Dropdown:AddOption(opt)
				if buttons[opt] then return end
				table.insert(Options,opt)
				createOption(opt)
				optionsHolder.Size = UDim2.new(0,134,0,#Options*30)
			end

			function Dropdown:RemoveOption(opt)
				if not buttons[opt] then return end
				buttons[opt]:Destroy()
				buttons[opt] = nil

				for i,v in ipairs(Options) do
					if v == opt then
						table.remove(Options,i)
						break
					end
				end

				for i,v in ipairs(selected) do
					if v == opt then
						table.remove(selected,i)
						break
					end
				end

				optionsHolder.Size = UDim2.new(0,134,0,#Options*30)
				updateText()
			end

			function Dropdown:Get()
				return Multi and selected or selected[1]
			end

			function Dropdown:Set(v)
				if Multi then
					selected = v
				else
					selected = {v}
				end
				updateText()
				fire()
			end

			self.Window._controls = self.Window._controls or {}

			table.insert(self.Window._controls,{
				Type = "Dropdown",
				Title = Title,
				Object = Dropdown
			})

			return Dropdown
		end

		return Tab
	end

	return Window
end

return NovaLib
