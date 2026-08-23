local Orion = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

function Orion:CreateOrion(orionName)
    orionName = orionName or "Orion"

    local isClosed = false
    local dragging = false
    local dragStart
    local startPosition

    ----------------------------------------------------------------
    -- ScreenGui
    ----------------------------------------------------------------

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Orion_" .. tostring(orionName)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- ใช้ CoreGui ถ้ารันใน executor และ fallback เป็น PlayerGui
    local parentSuccess = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)

    if not parentSuccess or not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    ----------------------------------------------------------------
    -- Main Frame
    ----------------------------------------------------------------

    local MainWhiteFrame = Instance.new("Frame")
    MainWhiteFrame.Name = "MainWhiteFrame"
    MainWhiteFrame.Parent = ScreenGui
    MainWhiteFrame.BackgroundColor3 = Color3.fromRGB(139, 0, 23)
    MainWhiteFrame.BorderSizePixel = 0
    MainWhiteFrame.ClipsDescendants = true
    MainWhiteFrame.Position = UDim2.new(0.237, 0, 0.36, 0)
    MainWhiteFrame.Size = UDim2.new(0, 528, 0, 310)

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 3)
    mainCorner.Parent = MainWhiteFrame

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = MainWhiteFrame
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Position = UDim2.new(0, 3, 0, 0)
    MainFrame.Size = UDim2.new(0, 525, 0, 310)

    local mainCorner2 = Instance.new("UICorner")
    mainCorner2.CornerRadius = UDim.new(0, 3)
    mainCorner2.Parent = MainFrame

    ----------------------------------------------------------------
    -- Tab Frame
    ----------------------------------------------------------------

    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "tabFrame"
    tabFrame.Parent = MainFrame
    tabFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    tabFrame.BorderColor3 = Color3.fromRGB(53, 53, 53)
    tabFrame.ClipsDescendants = true
    tabFrame.Size = UDim2.new(0, 100, 0, 309)

    local tabList = Instance.new("UIListLayout")
    tabList.Name = "tabList"
    tabList.Parent = tabFrame
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 2)

    local tabPadd = Instance.new("UIPadding")
    tabPadd.Name = "tabPadd"
    tabPadd.Parent = tabFrame
    tabPadd.PaddingRight = UDim.new(0, 2)
    tabPadd.PaddingTop = UDim.new(0, 5)

    ----------------------------------------------------------------
    -- Header
    ----------------------------------------------------------------

    local header = Instance.new("Frame")
    header.Name = "header"
    header.Parent = MainFrame
    header.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
    header.Position = UDim2.new(0.2076, 0, 0.0258, 0)
    header.Size = UDim2.new(0, 408, 0, 43)

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 3)
    headerCorner.Parent = header

    local libTitle = Instance.new("TextLabel")
    libTitle.Name = "libTitle"
    libTitle.Parent = header
    libTitle.BackgroundTransparency = 1
    libTitle.Position = UDim2.new(0, 12, 0, 0)
    libTitle.Size = UDim2.new(1, -55, 1, 0)
    libTitle.Font = Enum.Font.GothamSemibold
    libTitle.Text = tostring(orionName)
    libTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    libTitle.TextSize = 18
    libTitle.TextXAlignment = Enum.TextXAlignment.Left

    local closeLib = Instance.new("ImageButton")
    closeLib.Name = "closeLib"
    closeLib.Parent = header
    closeLib.BackgroundTransparency = 1
    closeLib.Position = UDim2.new(1, -34, 0.21, 0)
    closeLib.Size = UDim2.new(0, 25, 0, 25)
    closeLib.Image = "rbxassetid://4988112250"

    ----------------------------------------------------------------
    -- Content
    ----------------------------------------------------------------

    local elementContainer = Instance.new("Frame")
    elementContainer.Name = "elementContainer"
    elementContainer.Parent = MainFrame
    elementContainer.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    elementContainer.Position = UDim2.new(0.2076, 0, 0.1871, 0)
    elementContainer.Size = UDim2.new(0, 408, 0, 243)

    local elementCorner = Instance.new("UICorner")
    elementCorner.CornerRadius = UDim.new(0, 3)
    elementCorner.Parent = elementContainer

    local pagesFolder = Instance.new("Folder")
    pagesFolder.Name = "Pages"
    pagesFolder.Parent = elementContainer

    ----------------------------------------------------------------
    -- Dragging
    ----------------------------------------------------------------

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = MainWhiteFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        MainWhiteFrame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    ----------------------------------------------------------------
    -- Close / Minimize
    ----------------------------------------------------------------

    closeLib.MouseButton1Click:Connect(function()
        isClosed = not isClosed

        if isClosed then
            closeLib.Image = "rbxassetid://5165666242"

            TweenService:Create(
                closeLib,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad),
                {Rotation = 360}
            ):Play()

            MainWhiteFrame:TweenSize(
                UDim2.new(0, 424, 0, 58),
                Enum.EasingDirection.In,
                Enum.EasingStyle.Linear,
                0.12,
                true
            )

            TweenService:Create(
                MainFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 1}
            ):Play()

            TweenService:Create(
                MainWhiteFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 1}
            ):Play()

        else
            closeLib.Image = "rbxassetid://4988112250"

            TweenService:Create(
                closeLib,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad),
                {Rotation = 0}
            ):Play()

            MainWhiteFrame:TweenSize(
                UDim2.new(0, 528, 0, 310),
                Enum.EasingDirection.In,
                Enum.EasingStyle.Linear,
                0.12,
                true
            )

            TweenService:Create(
                MainFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0}
            ):Play()

            TweenService:Create(
                MainWhiteFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0}
            ):Play()
        end
    end)

    ----------------------------------------------------------------
    -- Section Handler
    ----------------------------------------------------------------

    local SectionHandler = {}
    local firstPage = true

    function SectionHandler:CreateSection(secName)
        secName = secName or "Tab"

        ----------------------------------------------------------------
        -- Tab Button
        ----------------------------------------------------------------

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "tabBtn_" .. tostring(secName)
        tabBtn.Parent = tabFrame
        tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabBtn.BorderColor3 = Color3.fromRGB(53, 53, 53)
        tabBtn.Size = UDim2.new(0, 95, 0, 32)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = tostring(secName)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 14
        tabBtn.AutoButtonColor = false

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 3)
        tabCorner.Parent = tabBtn

        ----------------------------------------------------------------
        -- Page
        ----------------------------------------------------------------

        local newPage = Instance.new("ScrollingFrame")
        newPage.Name = "newPage_" .. tostring(secName)
        newPage.Parent = pagesFolder
        newPage.Active = true
        newPage.BackgroundTransparency = 1
        newPage.BorderSizePixel = 0
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ScrollBarThickness = 5
        newPage.ScrollBarImageColor3 = Color3.fromRGB(255, 2, 40)
        newPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        newPage.Visible = false

        local pageItemList = Instance.new("UIListLayout")
        pageItemList.Name = "pageItemList"
        pageItemList.Parent = newPage
        pageItemList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageItemList.SortOrder = Enum.SortOrder.LayoutOrder
        pageItemList.Padding = UDim.new(0, 3)

        local UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = newPage
        UIPadding.PaddingRight = UDim.new(0, 5)
        UIPadding.PaddingTop = UDim.new(0, 5)
        UIPadding.PaddingBottom = UDim.new(0, 5)

        local function UpdateSize()
            task.defer(function()
                local contentSize = pageItemList.AbsoluteContentSize

                newPage.CanvasSize = UDim2.new(
                    0,
                    0,
                    0,
                    contentSize.Y + 10
                )
            end)
        end

        pageItemList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
        newPage.ChildAdded:Connect(UpdateSize)
        newPage.ChildRemoved:Connect(UpdateSize)

        ----------------------------------------------------------------
        -- Tab Switching
        ----------------------------------------------------------------

        tabBtn.MouseButton1Click:Connect(function()
            for _, page in ipairs(pagesFolder:GetChildren()) do
                if page:IsA("ScrollingFrame") then
                    page.Visible = false
                end
            end

            for _, button in ipairs(tabFrame:GetChildren()) do
                if button:IsA("TextButton") then
                    TweenService:Create(
                        button,
                        TweenInfo.new(
                            0.18,
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ),
                        {
                            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                        }
                    ):Play()
                end
            end

            newPage.Visible = true

            TweenService:Create(
                tabBtn,
                TweenInfo.new(
                    0.18,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                {
                    BackgroundColor3 = Color3.fromRGB(139, 0, 23)
                }
            ):Play()

            UpdateSize()
        end)

        -- เปิด Tab แรกอัตโนมัติ
        if firstPage then
            firstPage = false
            newPage.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(139, 0, 23)
        end

        ----------------------------------------------------------------
        -- Element Handler
        ----------------------------------------------------------------

        local ElementHandler = {}

        ----------------------------------------------------------------
        -- TextLabel
        ----------------------------------------------------------------

        function ElementHandler:TextLabel(labelText)
            labelText = labelText or ""

            local labelFrame = Instance.new("Frame")
            labelFrame.Name = "labelFrame"
            labelFrame.Parent = newPage
            labelFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            labelFrame.Size = UDim2.new(1, -10, 0, 42)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = labelFrame

            local txtLabel = Instance.new("TextLabel")
            txtLabel.Name = "txtLabel"
            txtLabel.Parent = labelFrame
            txtLabel.BackgroundTransparency = 1
            txtLabel.Size = UDim2.new(1, 0, 1, 0)
            txtLabel.Font = Enum.Font.GothamSemibold
            txtLabel.Text = tostring(labelText)
            txtLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            txtLabel.TextSize = 14

            UpdateSize()

            return txtLabel
        end

        ----------------------------------------------------------------
        -- TextButton
        ----------------------------------------------------------------

        function ElementHandler:TextButton(buttonText, buttonInfo, callback)
            buttonText = buttonText or ""
            buttonInfo = buttonInfo or ""
            callback = callback or function() end

            local frame = Instance.new("Frame")
            frame.Name = "textButtonFrame"
            frame.Parent = newPage
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            frame.Size = UDim2.new(1, -10, 0, 42)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = frame

            local button = Instance.new("TextButton")
            button.Name = "TextButton"
            button.Parent = frame
            button.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
            button.Position = UDim2.new(0, 7, 0.5, -13)
            button.Size = UDim2.new(0, 141, 0, 27)
            button.Font = Enum.Font.GothamSemibold
            button.Text = tostring(buttonText)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.AutoButtonColor = false

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 3)
            buttonCorner.Parent = button

            local info = Instance.new("TextLabel")
            info.Name = "textButtonInfo"
            info.Parent = frame
            info.BackgroundTransparency = 1
            info.Position = UDim2.new(0, 155, 0, 0)
            info.Size = UDim2.new(1, -165, 1, 0)
            info.Font = Enum.Font.GothamSemibold
            info.Text = tostring(buttonInfo)
            info.TextColor3 = Color3.fromRGB(198, 198, 198)
            info.TextSize = 14
            info.TextXAlignment = Enum.TextXAlignment.Right

            button.MouseButton1Click:Connect(function()
                callback()
            end)

            UpdateSize()

            return button
        end

        ----------------------------------------------------------------
        -- Toggle
        ----------------------------------------------------------------

        function ElementHandler:Toggle(togInfo, callback)
            togInfo = togInfo or ""
            callback = callback or function() end

            local frame = Instance.new("Frame")
            frame.Name = "toggleFrame"
            frame.Parent = newPage
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            frame.Size = UDim2.new(1, -10, 0, 42)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = frame

            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "toggleButton"
            toggleButton.Parent = frame
            toggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            toggleButton.Position = UDim2.new(0, 7, 0.5, -13)
            toggleButton.Size = UDim2.new(0, 27, 0, 27)
            toggleButton.Text = ""
            toggleButton.AutoButtonColor = false

            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 5)
            toggleCorner.Parent = toggleButton

            local info = Instance.new("TextLabel")
            info.Name = "toggleInfo"
            info.Parent = frame
            info.BackgroundTransparency = 1
            info.Position = UDim2.new(0, 45, 0, 0)
            info.Size = UDim2.new(1, -55, 1, 0)
            info.Font = Enum.Font.GothamSemibold
            info.Text = tostring(togInfo)
            info.TextColor3 = Color3.fromRGB(198, 198, 198)
            info.TextSize = 14
            info.TextXAlignment = Enum.TextXAlignment.Right

            local toggled = false

            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled

                TweenService:Create(
                    toggleButton,
                    TweenInfo.new(
                        0.18,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    {
                        BackgroundColor3 = toggled
                            and Color3.fromRGB(181, 1, 31)
                            or Color3.fromRGB(25, 25, 25)
                    }
                ):Play()

                callback(toggled)
            end)

            UpdateSize()

            return {
                Set = function(_, value)
                    toggled = value == true

                    toggleButton.BackgroundColor3 = toggled
                        and Color3.fromRGB(181, 1, 31)
                        or Color3.fromRGB(25, 25, 25)

                    callback(toggled)
                end,

                Get = function()
                    return toggled
                end
            }
        end

        ----------------------------------------------------------------
        -- Slider
        ----------------------------------------------------------------

        function ElementHandler:Slider(sliderin, minvalue, maxvalue, callback)
            sliderin = sliderin or "Slider"
            minvalue = tonumber(minvalue) or 0
            maxvalue = tonumber(maxvalue) or 500
            callback = callback or function() end

            if maxvalue < minvalue then
                minvalue, maxvalue = maxvalue, minvalue
            end

            local frame = Instance.new("Frame")
            frame.Name = "sliderFrame"
            frame.Parent = newPage
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            frame.Size = UDim2.new(1, -10, 0, 42)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = frame

            local sliderButton = Instance.new("TextButton")
            sliderButton.Name = "sliderButton"
            sliderButton.Parent = frame
            sliderButton.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            sliderButton.BorderSizePixel = 0
            sliderButton.Position = UDim2.new(0, 7, 0.5, -5)
            sliderButton.Size = UDim2.new(0, 141, 0, 10)
            sliderButton.Text = ""
            sliderButton.AutoButtonColor = false

            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 5)
            sliderCorner.Parent = sliderButton

            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "sliderFill"
            sliderFill.Parent = sliderButton
            sliderFill.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new(0, 0, 1, 0)

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 5)
            fillCorner.Parent = sliderFill

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Name = "sliderValue"
            valueLabel.Parent = frame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(0, 155, 0, 0)
            valueLabel.Size = UDim2.new(0, 65, 1, 0)
            valueLabel.Font = Enum.Font.GothamSemibold
            valueLabel.Text = tostring(minvalue) .. "/" .. tostring(maxvalue)
            valueLabel.TextColor3 = Color3.fromRGB(199, 0, 33)
            valueLabel.TextSize = 14
            valueLabel.TextXAlignment = Enum.TextXAlignment.Left

            local info = Instance.new("TextLabel")
            info.Name = "sliderInfo"
            info.Parent = frame
            info.BackgroundTransparency = 1
            info.Position = UDim2.new(0, 220, 0, 0)
            info.Size = UDim2.new(1, -230, 1, 0)
            info.Font = Enum.Font.GothamSemibold
            info.Text = tostring(sliderin)
            info.TextColor3 = Color3.fromRGB(198, 198, 198)
            info.TextSize = 14
            info.TextXAlignment = Enum.TextXAlignment.Right

            local currentValue = minvalue
            local draggingSlider = false

            local function setValueFromX(x)
                local absolutePosition = sliderButton.AbsolutePosition.X
                local absoluteSize = sliderButton.AbsoluteSize.X

                if absoluteSize <= 0 then
                    return
                end

                local percent = math.clamp(
                    (x - absolutePosition) / absoluteSize,
                    0,
                    1
                )

                currentValue = math.floor(
                    minvalue + ((maxvalue - minvalue) * percent) + 0.5
                )

                valueLabel.Text =
                    tostring(currentValue) .. "/" .. tostring(maxvalue)

                sliderFill.Size = UDim2.new(percent, 0, 1, 0)

                callback(currentValue)
            end

            sliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    draggingSlider = true
                    setValueFromX(input.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not draggingSlider then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then

                    setValueFromX(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    draggingSlider = false
                end
            end)

            UpdateSize()

            return {
                Set = function(_, value)
                    value = math.clamp(
                        tonumber(value) or minvalue,
                        minvalue,
                        maxvalue
                    )

                    currentValue = value

                    local percent =
                        (value - minvalue) / (maxvalue - minvalue)

                    if maxvalue == minvalue then
                        percent = 0
                    end

                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    valueLabel.Text =
                        tostring(value) .. "/" .. tostring(maxvalue)

                    callback(value)
                end,

                Get = function()
                    return currentValue
                end
            }
        end

        ----------------------------------------------------------------
        -- KeyBind
        ----------------------------------------------------------------

        function ElementHandler:KeyBind(keInfo, firstt, callback)
            keInfo = keInfo or "Keybind"
            callback = callback or function() end

            local oldKey

            -- รองรับ Enum.KeyCode / string / Instance ที่มี Name
            if typeof(firstt) == "EnumItem" then
                oldKey = firstt.Name
            elseif typeof(firstt) == "string" then
                oldKey = firstt
            elseif firstt and firstt.Name then
                oldKey = firstt.Name
            else
                oldKey = "RightShift"
            end

            local frame = Instance.new("Frame")
            frame.Name = "keybindFrame"
            frame.Parent = newPage
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            frame.Size = UDim2.new(1, -10, 0, 42)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = frame

            local button = Instance.new("TextButton")
            button.Name = "KeyButton"
            button.Parent = frame
            button.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
            button.Position = UDim2.new(0, 7, 0.5, -13)
            button.Size = UDim2.new(0, 76, 0, 27)
            button.Font = Enum.Font.GothamSemibold
            button.Text = tostring(oldKey)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.AutoButtonColor = false

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 3)
            buttonCorner.Parent = button

            local info = Instance.new("TextLabel")
            info.Name = "keybindInfo"
            info.Parent = frame
            info.BackgroundTransparency = 1
            info.Position = UDim2.new(0, 95, 0, 0)
            info.Size = UDim2.new(1, -105, 1, 0)
            info.Font = Enum.Font.GothamSemibold
            info.Text = tostring(keInfo)
            info.TextColor3 = Color3.fromRGB(198, 198, 198)
            info.TextSize = 14
            info.TextXAlignment = Enum.TextXAlignment.Right

            local listening = false

            button.MouseButton1Click:Connect(function()
                if listening then
                    return
                end

                listening = true
                button.Text = ". . ."
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        oldKey = input.KeyCode.Name
                        button.Text = oldKey
                        listening = false
                    end

                    return
                end

                if gameProcessed then
                    return
                end

                if input.KeyCode ~= Enum.KeyCode.Unknown
                    and input.KeyCode.Name == oldKey then

                    callback()
                end
            end)

            UpdateSize()

            return {
                Set = function(_, key)
                    if typeof(key) == "EnumItem" then
                        oldKey = key.Name
                    else
                        oldKey = tostring(key)
                    end

                    button.Text = oldKey
                end,

                Get = function()
                    return oldKey
                end
            }
        end

        ----------------------------------------------------------------
        -- TextBox
        ----------------------------------------------------------------

        function ElementHandler:TextBox(textInfo, placeHolderText1, callback)
            textInfo = textInfo or ""
            placeHolderText1 = placeHolderText1 or ""
            callback = callback or function() end

            local frame = Instance.new("Frame")
            frame.Name = "textBoxFrame"
            frame.Parent = newPage
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            frame.Size = UDim2.new(1, -10, 0, 42)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = frame

            local inputBackground = Instance.new("Frame")
            inputBackground.Name = "textboxBackground"
            inputBackground.Parent = frame
            inputBackground.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
            inputBackground.Position = UDim2.new(0, 7, 0.5, -13)
            inputBackground.Size = UDim2.new(0, 141, 0, 27)

            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 3)
            inputCorner.Parent = inputBackground

            local textBox = Instance.new("TextBox")
            textBox.Name = "TextBox"
            textBox.Parent = inputBackground
            textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            textBox.BorderSizePixel = 0
            textBox.Position = UDim2.new(0, 1, 0, 1)
            textBox.Size = UDim2.new(1, -2, 1, -2)
            textBox.Font = Enum.Font.GothamSemibold
            textBox.PlaceholderColor3 = Color3.fromRGB(115, 115, 115)
            textBox.PlaceholderText = tostring(placeHolderText1)
            textBox.Text = ""
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.TextSize = 13
            textBox.ClearTextOnFocus = false

            local textboxCorner = Instance.new("UICorner")
            textboxCorner.CornerRadius = UDim.new(0, 3)
            textboxCorner.Parent = textBox

            local info = Instance.new("TextLabel")
            info.Name = "textboxInfo"
            info.Parent = frame
            info.BackgroundTransparency = 1
            info.Position = UDim2.new(0, 155, 0, 0)
            info.Size = UDim2.new(1, -165, 1, 0)
            info.Font = Enum.Font.GothamSemibold
            info.Text = tostring(textInfo)
            info.TextColor3 = Color3.fromRGB(198, 198, 198)
            info.TextSize = 14
            info.TextXAlignment = Enum.TextXAlignment.Right

            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(textBox.Text)
                    textBox.Text = ""
                end
            end)

            UpdateSize()

            return textBox
        end

        ----------------------------------------------------------------
        -- Dropdown
        ----------------------------------------------------------------

        function ElementHandler:Dropdown(dInfo, list, callback)
            dInfo = dInfo or "Dropdown"
            list = list or {}
            callback = callback or function() end

            local isDropped = false
            local DropYSize = 42

            local frame = Instance.new("Frame")
            frame.Name = "dropDownFrame"
            frame.Parent = newPage
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            frame.ClipsDescendants = true
            frame.Size = UDim2.new(1, -10, 0, 42)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = frame

            local main = Instance.new("Frame")
            main.Name = "dropdownmain"
            main.Parent = frame
            main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            main.Size = UDim2.new(1, 0, 0, 42)
            main.ZIndex = 2

            local mainCorner = Instance.new("UICorner")
            mainCorner.CornerRadius = UDim.new(0, 3)
            mainCorner.Parent = main

            local itemLabel = Instance.new("TextLabel")
            itemLabel.Name = "dropdownItem"
            itemLabel.Parent = main
            itemLabel.BackgroundTransparency = 1
            itemLabel.Position = UDim2.new(0, 10, 0, 0)
            itemLabel.Size = UDim2.new(1, -60, 0, 42)
            itemLabel.Font = Enum.Font.GothamSemibold
            itemLabel.Text = tostring(dInfo)
            itemLabel.TextColor3 = Color3.fromRGB(255, 1, 43)
            itemLabel.TextSize = 14
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.ZIndex = 3

            local arrow = Instance.new("ImageButton")
            arrow.Name = "Arrow"
            arrow.Parent = main
            arrow.BackgroundTransparency = 1
            arrow.Position = UDim2.new(1, -37, 0.5, -10)
            arrow.Size = UDim2.new(0, 27, 0, 21)
            arrow.Image = "rbxassetid://5165666242"
            arrow.ImageColor3 = Color3.fromRGB(181, 1, 31)
            arrow.ZIndex = 3

            local listLayout = Instance.new("UIListLayout")
            listLayout.Parent = frame
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Padding = UDim.new(0, 5)

            for _, value in ipairs(list) do
                local optionBtn = Instance.new("TextButton")
                optionBtn.Name = "optionBtn"
                optionBtn.Parent = frame
                optionBtn.BackgroundColor3 = Color3.fromRGB(118, 0, 20)
                optionBtn.Size = UDim2.new(1, -17, 0, 39)
                optionBtn.Font = Enum.Font.GothamSemibold
                optionBtn.Text = "   " .. tostring(value)
                optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionBtn.TextSize = 14
                optionBtn.TextXAlignment = Enum.TextXAlignment.Left
                optionBtn.ZIndex = 1
                optionBtn.LayoutOrder = 10

                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 3)
                optionCorner.Parent = optionBtn

                DropYSize = DropYSize + 44

                optionBtn.MouseButton1Click:Connect(function()
                    callback(value)

                    itemLabel.Text =
                        tostring(dInfo) .. ": " .. tostring(value)

                    isDropped = false

                    frame:TweenSize(
                        UDim2.new(1, -10, 0, 42),
                        Enum.EasingDirection.In,
                        Enum.EasingStyle.Quint,
                        0.1,
                        true
                    )

                    TweenService:Create(
                        arrow,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad),
                        {Rotation = 0}
                    ):Play()

                    task.wait(0.1)
                    UpdateSize()
                end)
            end

            arrow.MouseButton1Click:Connect(function()
                isDropped = not isDropped

                local targetSize

                if isDropped then
                    targetSize = DropYSize
                else
                    targetSize = 42
                end

                frame:TweenSize(
                    UDim2.new(1, -10, 0, targetSize),
                    Enum.EasingDirection.In,
                    Enum.EasingStyle.Quint,
                    0.1,
                    true
                )

                TweenService:Create(
                    arrow,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad),
                    {
                        Rotation = isDropped and 180 or 0
                    }
                ):Play()

                task.wait(0.1)
                UpdateSize()
            end)

            UpdateSize()

            return {
                Set = function(_, value)
                    itemLabel.Text =
                        tostring(dInfo) .. ": " .. tostring(value)
                end
            }
        end

        return ElementHandler
    end

    return SectionHandler
end

return Orion
