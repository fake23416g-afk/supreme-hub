local Library = (function()

if getgenv().Library then
    getgenv().Library:Unload()
end

local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = nil
    pcall(function()
        Mouse = LocalPlayer:GetMouse()
    end)
    if not Mouse then
        Mouse = { X = 0, Y = 0 }
    end

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.F2),
        MenuKeybinds = {
            [tostring(Enum.KeyCode.V)] = true,
            [tostring(Enum.KeyCode.Insert)] = true,
        },

        Flags = { },

        Tween = {
            Time = 0.28,
            Style = Enum.EasingStyle.Quint,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "homxiide",
            Configs = "homxiide/Configs",
            Assets = "homxiide/Assets",
        },

        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,

        Font = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(9, 9, 12),
            ["Outline"] = FromRGB(34, 34, 43),
            ["Inline"] = FromRGB(20, 20, 26),
            ["Accent"] = FromRGB(139, 149, 246),
            ["Text"] = FromRGB(235, 235, 242),
            ["Element"] = FromRGB(29, 29, 37)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    pcall(function()
        for Index, Value in Library.Folders do
            if not isfolder(Value) then
                makefolder(Value)
            end
        end
    end)

    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then
                return
            end

            Library:AddToTheme(self, Properties)
            return self
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then
                return
            end

            if not self.Instance[Event] then
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then
                return
            end

            local Gui = self.Instance
            local Dragging = false
            local DragStart
            local StartPosition

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                local NewX = StartPosition.X.Offset + DragDelta.X
                local NewY = StartPosition.Y.Offset + DragDelta.Y

                local ScreenSize = Gui.Parent.AbsoluteSize
                local GuiSize = Gui.AbsoluteSize

                NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
                NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)

                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
            end

            local InputChanged

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then
                return
            end

            local Gui = self.Instance

            local Resizing = false
            local CurrentSide = nil

            local StartMouse = nil
            local StartPosition = nil
            local StartSize = nil

            local EdgeThickness = 2

            local MakeEdge = function(Name, Position, Size)
                local Button = Instances:Create("TextButton", {
                    Name = "\0",
                    Size = Size,
                    Position = Position,
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Gui,
                    ZIndex = 99999,
                })  Button:AddToTheme({BackgroundColor3 = "Accent"})

                return Button
            end

            local Edges = {
                {Button = MakeEdge(
                    "Left",
                    UDim2New(0, 0, 0, 0),
                    UDim2New(0, EdgeThickness, 1, 0)),
                    Side = "L"
                },

                {Button = MakeEdge(
                    "Right",
                    UDim2New(1, -EdgeThickness, 0, 0),
                    UDim2New(0, EdgeThickness, 1, 0)),
                    Side = "R"
                },

                {Button = MakeEdge(
                    "Top", UDim2New(0, 0, 0, 0),
                    UDim2New(1, 0, 0, EdgeThickness)),
                    Side = "T"
                },

                {Button = MakeEdge(
                    "Bottom",
                    UDim2New(0, 0, 1, -EdgeThickness),
                    UDim2New(1, 0, 0, EdgeThickness)),
                    Side = "B"
                },
            }

            local BeginResizing = function(Side)
                Resizing = true
                CurrentSide = Side

                StartMouse = UserInputService:GetMouseLocation()

                StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)

                for Index, Value in Edges do
                    Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
                end
            end

            local EndResizing = function()
                Resizing = false
                CurrentSide = nil

                for Index, Value in Edges do
                    Value.Button.Instance.BackgroundTransparency = 1
                end
            end

            for Index, Value in Edges do
                Value.Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        BeginResizing(Value.Side)
                    end
                end)
            end

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        EndResizing()
                    end
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then
                    return
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y

                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y

                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end

                if w < Minimum.X then
                    if CurrentSide == "L" then
                        x = x - (Minimum.X - w)
                    end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then
                        y = y - (Minimum.Y - h)
                    end
                    h = Minimum.Y
                end

                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
            end)
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then
                return
            end

            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then
                return
            end

            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Folders.Assets}/{Name}.font`))
        end

        do
            local loaded = pcall(function()
                Library.Font = CustomFont:New("SFProText", 400, "Regular", {
                    Id = "AltHack_SFProText",
                    Url = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts/raw/master/SF-Pro-Text-Regular.otf"
                })
            end)
            if not loaded then
                pcall(function() delfile("AltHack_SFProText") end)
                loaded = pcall(function()
                    Library.Font = CustomFont:New("Inter", 400, "Regular", {
                        Id = "AltHack_Inter",
                        Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Inter.ttf"
                    })
                end)
            end
            if not loaded then
                pcall(function() delfile("AltHack_Inter") end)
                Library.Font = CustomFont:New("OutfitMedium", 400, "Regular", {
                    Id = "OutfitMedium",
                    Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Outfit-Medium.ttf"
                })
            end
        end
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do
            coroutine.close(Value)
        end

        if self.Holder then
            self.Holder:Clean()
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Round = function(self, Number, Float)
        Float = tonumber(Float) or 1
        if Float <= 0 then
            Float = 1
        end
        local Multiplier = 1 / Float
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)

        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end

    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)

        if type(Item) == "table" then
            Item = Item.Instance or Item
        end

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not self.Theme[Value] then
                    Item[Property] = Value
                end

                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.GetConfig = function(self)
        local Config = { }

        for Index, Value in Library.Flags do
            pcall(function()
                if type(Value) == "table" and Value.Key ~= nil then
                    Config[Index] = {Key = tostring(Value.Key), Mode = tostring(Value.Mode or "Toggle")}
                elseif type(Value) == "table" and Value.Color ~= nil then
                    local hex = "#FFFFFF"
                    if type(Value.HexValue) == "string" then
                        hex = "#" .. Value.HexValue
                    elseif typeof(Value.Color) == "Color3" then
                        hex = "#" .. Value.Color:ToHex()
                    end
                    Config[Index] = {Color = hex}
                else
                    Config[Index] = Value
                end
            end)
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local OkDecoded, Decoded = pcall(function()
            return HttpService:JSONDecode(Config)
        end)

        if not OkDecoded or type(Decoded) ~= "table" then
            warn("[alt.gg] LoadConfig: файл конфига битый")
            return false
        end

        for Index, Value in Decoded do
            local SetFunction = Library.SetFlags[Index]

            if SetFunction then
                pcall(function()
                    if type(Value) == "table" and Value.Key ~= nil then
                        SetFunction(Value)
                    elseif type(Value) == "table" and Value.Color ~= nil then
                        SetFunction(Value.Color)
                    else
                        SetFunction(Value)
                    end
                end)
            end
        end

        return true
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Folders.Configs)

        for Index = 1, #List do
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        if type(Item) == "table" then
            Item = Item.Instance or Item
        end

        if not self.ThemeMap[Item] then
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    Library.CompareVectors = function(self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(self, Object, Column)
        local Parent = Column

        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Flag = Data.Flag,

            Hue = 0,
            Saturation = 0,
            Value = 0,

            Color = Color3.fromRGB(0, 0, 0),
            Hex = "#000000",

            IsOpen = false
        }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(0, 16, 0, 16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })

            Instances:Create("UICorner", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = Library.Theme["Outline"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = 'Outline'})

            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(148, 255, 237),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.800000011920929,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "http://www.roblox.com/asset/?id=18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })

            Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 94, 0, 60),
                Size = UDim2New(0, 160, 0, 160),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})

            Instances:Create("UICorner", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })

            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -40, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })

            Instances:Create("UICorner", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })

            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 1, 1, 0),
                BorderSizePixel = 0
            })

            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })

            Instances:Create("UICorner", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })

            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 1, 1, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })

            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })

            Instances:Create("UICorner", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })

            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 5, 0, 5),
                BorderSizePixel = 0
            })

            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0"
            })

            Instances:Create("UICorner", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -8, 0, 8),
                Size = UDim2New(0, 15, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14
            })

            Instances:Create("UIGradient", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })

            Instances:Create("UICorner", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })

            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 15, 0, 15),
                BorderSizePixel = 0
            })

            Instances:Create("UICorner", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0"
            })
        end

        function Colorpicker:Get()
            return Colorpicker.Color
        end

        function Colorpicker:Update()
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()

            Library.Flags[Colorpicker.Flag] = {
                Color = Colorpicker.Color,
                HexValue = Colorpicker.HexValue
            }

            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Glow"]:Tween(nil, {ImageColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

            if Data.Callback then
                Library:SafeCall(Data.Callback, Colorpicker.Color)
            end
        end

        local SlidingPalette = false
        local PaletteChanged

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Saturation = ValueX
            Colorpicker.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.955)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.955)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        local SlidingHue = false
        local HueChanged

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then
                return
            end

            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Hue = ValueY

            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.91)

            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        local Debounce = false
        local RenderStepped

        function Colorpicker:SetOpen(Bool)
            if Debounce then
                return
            end

            Colorpicker.IsOpen = Bool

            Debounce = true

            if Colorpicker.IsOpen then
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance

                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(
                        0,
                        Items["ColorpickerButton"].Instance.AbsolutePosition.X,
                        0,
                        Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)

                for Index, Value in Library.OpenFrames do
                        if Value ~= Colorpicker then
                            Value:SetOpen(false)
                        end
                    end

                Library.OpenFrames[Colorpicker] = Colorpicker
            else
                if Library.OpenFrames[Colorpicker] then
                    Library.OpenFrames[Colorpicker] = nil
                end

                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue
                end

                if not Value.ClassName:find("UI") then
                    Value.ZIndex = (Colorpicker.IsOpen and Data.Section.IsSettings and 9) or (Colorpicker.IsOpen and not Data.Section.IsSettings and 3) or 1
                end

                if type(TransparencyProperty) == "table" then
                    for _, Property in TransparencyProperty do
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end

            NewTween.Tween.Completed:Connect(function()
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                task.wait(0.2)
                Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Colorpicker:Set(Color)
            if type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then
                Color = FromHex(Color)
            end

            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()

            local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.955)
            local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.955)

            local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.955)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
            Colorpicker:Update()
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingPalette = true

                Colorpicker:SlidePalette(Input)

                if PaletteChanged then
                    return
                end

                PaletteChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false

                        PaletteChanged:Disconnect()
                        PaletteChanged = nil
                    end
                end)
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingHue = true

                Colorpicker:SlideHue(Input)

                if HueChanged then
                    return
                end

                HueChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false

                        HueChanged:Disconnect()
                        HueChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not Colorpicker.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return
                end

                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then
            Colorpicker:Set(Data.Default)
        end

        Library.SetFlags[Colorpicker.Flag] = function(Value)
            Colorpicker:Set(Value)
        end

        return Colorpicker, Items
    end

    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Flag = Data.Flag,

            Value = "",
            Key = "",
            Mode = Data.Mode or Data.mode or "Toggle",

            Toggled = false,
            Picking = false,
            IsOpen = false
        }

        local Items = { } do
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                Text = "[NONE]",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = Library.Theme["Element"],
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12
            }):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})

            Instances:Create("UICorner", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })

            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                PaddingLeft = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 7)
            })

            Items["KeybindWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})

            Instances:Create("UICorner", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })

            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})

            Instances:Create("UIListLayout", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Instances:Create("UIPadding", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 10),
                PaddingBottom = UDimNew(0, 10),
                PaddingRight = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 10)
            })

            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Hold",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})

            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Always",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
        end

        local Modes = {
            Toggle = Items["Toggle"],
            Hold = Items["Hold"],
            Always = Items["Always"]
        }

        local Debounce = false
        local RenderStepped

        local PickConnection

        function Keybind:SetOpen(Bool)
            if Debounce then
                return
            end

            Keybind.IsOpen = Bool

            Debounce = true

            if Keybind.IsOpen then
                Items["KeybindWindow"].Instance.Visible = true
                Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance

                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["KeybindWindow"].Instance.Position = UDim2New(
                        0,
                        Items["KeyButton"].Instance.AbsolutePosition.X,
                        0,
                        Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)

                for Index, Value in Library.OpenFrames do
                    if Value ~= Keybind then
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Keybind] = Keybind
            else
                if Library.OpenFrames[Keybind] then
                    Library.OpenFrames[Keybind] = nil
                end

                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["KeybindWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue
                end

                if not Value.ClassName:find("UI") then
                    Value.ZIndex = Keybind.IsOpen and 4 or 1
                end

                if type(TransparencyProperty) == "table" then
                    for _, Property in TransparencyProperty do
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end

            NewTween.Tween.Completed:Connect(function()
                Debounce = false
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                task.wait(0.2)
                Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do
                if Index == Mode then
                    Value:Tween(nil, {TextTransparency = 0})
                else
                    Value:Tween(nil, {TextTransparency = 0.5})
                end
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then
                Keybind.Toggled = true
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end
        end

        function Keybind:Get()
            return Keybind.Key, Keybind.Mode, Keybind.Toggled
        end

        function Keybind:Reset()
            if PickConnection then
                PickConnection:Disconnect()
                PickConnection = nil
            end
            if RenderStepped then
                RenderStepped:Disconnect()
                RenderStepped = nil
            end
            Keybind.Key, Keybind.Value, Keybind.Mode = "None", "None", "Toggle"
            Keybind.Toggled, Keybind.Picking, Keybind.IsOpen = false, false, false
            Library.OpenFrames[Keybind] = nil
            Items["KeyButton"].Instance.Text = "[NONE]"
            Items["KeybindWindow"].Instance.Visible = false
            Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
            for Index, Value in Modes do
                Value:Tween(nil, {TextTransparency = Index == "Toggle" and 0 or 0.5})
            end
            Library.Flags[Keybind.Flag] = {Mode = "Toggle", Key = "None", Toggled = false}
        end

        function Keybind:Set(Key)
            if PickConnection then
                PickConnection:Disconnect()
                PickConnection = nil
            end
            if StringFind(tostring(Key), "Enum") then
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif type(Key) == "table" then
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                Keybind.Mode = Key
                Keybind:SetMode(Key)

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            Keybind.Picking = false
        end

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            if PickConnection then PickConnection:Disconnect() end
            Keybind.Picking = true

            Items["KeyButton"].Instance.Text = "..."

            PickConnection = UserInputService.InputBegan:Connect(function(Input)
                if not Keybind.Picking then return end
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    if Input.KeyCode == Enum.KeyCode.Escape then

                        Keybind:Set(Enum.KeyCode.Backspace)
                    else
                        Keybind:Set(Input.KeyCode)
                    end
                else
                    Keybind:Set(Input.UserInputType)
                end
            end)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Keybind.Value == "None" then
                return
            end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Toggle" then
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Keybind.Value == "None" then
                return
            end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Hold" then
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            end
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always")
        end)

        if Data.Default then
            Keybind:Set({
                Mode = Data.Mode or "Toggle",
                Key = Data.Default,
            })
        end

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind, Items
    end

    do
        Library.Watermark = function(self, Name, Logo)
            local Watermark = { }

            local Items = { } do
                Items["Watermark"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0),
                    Position = UDim2New(0.5, 0, 0, 20),
                    Size = UDim2New(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["Watermark"]:MakeDraggable()

                Instances:Create("UICorner", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 10)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    Size = UDim2New(0, 25, 0, 25),
                    BorderSizePixel = 0
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Perccss in my sodaa",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 34, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18
                }):AddToTheme({TextColor3 = 'Text'})
            end

            function Watermark:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetCenter()
                local CenterPosition = Items["Watermark"].Instance.AbsolutePosition
                task.wait()
                Items["Watermark"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["Watermark"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            Watermark:SetText(Name)
            Watermark:SetCenter()

            return Watermark
        end

        Library.Window = function(self, Data)
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "Window",
                SubName = Data.SubName or Data.subname or "",
                Logo = Data.Logo or Data.logo or "rbxassetid://81441172534384",

                Pages = { },
                Items = { },
                IsOpen = false
            }

            local Items = { } do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5220375657081604, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 900, 0, 600),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(900, 600), Vector2New(9999, 9999))

                Instances:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 16)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    Transparency = 0.2,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Sidebar"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 200, 1, 0),
                    BorderSizePixel = 0
                })

local BottomSeparator = Instance.new("Frame")
BottomSeparator.Parent = Items["Sidebar"].Instance
BottomSeparator.AnchorPoint = Vector2.new(0, 1)
BottomSeparator.Position = UDim2.new(0, 0, 1, -85)
BottomSeparator.Size = UDim2.new(1, 0, 0, 1)
BottomSeparator.BackgroundColor3 = Library.Theme.Outline
BottomSeparator.BorderSizePixel = 0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local BottomTab = Instance.new("Frame")
BottomTab.Parent = Items["Sidebar"].Instance
BottomTab.AnchorPoint = Vector2.new(0, 1)
BottomTab.Position = UDim2.new(0, 0, 1, -8)

BottomTab.Size = UDim2.new(1, 0, 0, 72)
BottomTab.BackgroundTransparency = 1

local Avatar = Instance.new("ImageLabel")
Avatar.Parent = BottomTab
Avatar.BackgroundTransparency = 1
Avatar.Size = UDim2.new(0, 44, 0, 44)
Avatar.Position = UDim2.new(0, 14, 0, 14)
pcall(function()
    Avatar.Image = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
end)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = Avatar

local AvatarRing = Instance.new("UIStroke")
AvatarRing.Color = Library.Theme.Accent
AvatarRing.Transparency = 0.35
AvatarRing.Thickness = 1.5
AvatarRing.Parent = Avatar
Library:AddToTheme(AvatarRing, {Color = 'Accent'})

local Username = Instance.new("TextLabel")
Username.Parent = BottomTab
Username.BackgroundTransparency = 1
Username.Position = UDim2.new(0, 70, 0, 15)
Username.Size = UDim2.new(1, -80, 0, 17)
Username.TextXAlignment = Enum.TextXAlignment.Left
Username.TextTruncate = Enum.TextTruncate.AtEnd
Username.Text = LocalPlayer.DisplayName
Username.FontFace = Library.Font
Username.TextSize = 15
Username.TextColor3 = Library.Theme.Text

local UserSubtitle = Instance.new("TextLabel")
UserSubtitle.Parent = BottomTab
UserSubtitle.BackgroundTransparency = 1
UserSubtitle.Position = UDim2.new(0, 70, 0, 37)
UserSubtitle.Size = UDim2.new(1, -80, 0, 14)
UserSubtitle.TextXAlignment = Enum.TextXAlignment.Left
UserSubtitle.TextTruncate = Enum.TextTruncate.AtEnd
UserSubtitle.Text = Window.Name .. " · " .. (Window.SubName ~= "" and Window.SubName or "client")
UserSubtitle.FontFace = Library.Font
UserSubtitle.TextSize = 12
UserSubtitle.TextTransparency = 0.45
UserSubtitle.TextColor3 = Library.Theme.Text

                Instances:Create("Frame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 70),
                    BorderSizePixel = 0
                })

                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 20, 0, 20),
                    Size = UDim2New(0, 30, 0, 30),
                    BorderSizePixel = 0
                })

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 60, 0, 15),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Subtitle"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.4000000059604645,
                    Text = Window.SubName,
                    Size = UDim2New(0, 0, 0, 14),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 60, 0, 36),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["Pages"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://128693616966482",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 3,
                    Size = UDim2New(1, -16, 1, -185),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 78),
                    BottomImage = "rbxassetid://128693616966482",
                    TopImage = "rbxassetid://128693616966482"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 200, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -200, 1, 0),
                    BorderSizePixel = 0
                })

                Items["TopBar"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 46)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 14),
                    PaddingRight = UDimNew(0, 12)
                })

                Items["TopLeft"] = Instances:Create("Frame", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 0, 30),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    LayoutOrder = 1
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["TopLeft"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 16),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["PageTitle"] = Instances:Create("TextLabel", {
                    Parent = Items["TopLeft"].Instance,
                    FontFace = Library.Font,
                    Text = "",
                    TextColor3 = Library.Theme["Text"],
                    TextSize = 16,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Size = UDim2New(0, 0, 0, 20),
                    LayoutOrder = 1
                }):AddToTheme({TextColor3 = 'Text'})

                Items["SearchBar"] = Instances:Create("Frame", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    BackgroundColor3 = Library.Theme["Element"],
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 0, 28),
                    LayoutOrder = 2
                }):AddToTheme({BackgroundColor3 = 'Element'})

                local SearchFlex = Instance.new("UIFlexItem")
                SearchFlex.FlexMode = Enum.UIFlexMode.Fill
                SearchFlex.Parent = Items["SearchBar"].Instance

                Instances:Create("UICorner", {
                    Parent = Items["SearchBar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["SearchBar"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    Transparency = 0.2,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Instances:Create("ImageLabel", {
                    Parent = Items["SearchBar"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://121018724060431",
                    ImageColor3 = Library.Theme["Text"],
                    ImageTransparency = 0.3,
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 10, 0.5, 0),
                    Size = UDim2New(0, 13, 0, 13),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})

                Items["SearchBox"] = Instances:Create("TextBox", {
                    Parent = Items["SearchBar"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Text = "",
                    PlaceholderText = "Поиск...",
                    PlaceholderColor3 = Library.Theme["Text"],
                    TextColor3 = Library.Theme["Text"],
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.fromScale(1, 1),
                    ClearTextOnFocus = false
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Text'})

                Instances:Create("UIPadding", {
                    Parent = Items["SearchBox"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 30),
                    PaddingRight = UDimNew(0, 10)
                })

                Items["OptsBtn"] = Instances:Create("TextButton", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 30, 0, 30),
                    BackgroundColor3 = Library.Theme["Element"],
                    BorderSizePixel = 0,
                    LayoutOrder = 3
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["OptsBtn"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["OptsBtn"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    Transparency = 0.25,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Instances:Create("ImageLabel", {
                    Parent = Items["OptsBtn"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://85538382643347",
                    ImageColor3 = Library.Theme["Text"],
                    ImageTransparency = 0.25,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 15, 0, 15),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})

                Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 0, 0, 46),
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 1),
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Library.SearchRows = { }

                local function ApplySearchFilter(Query)
                    Window.CurrentQuery = Query or ""
                    Query = StringLower(tostring(Query or ""):gsub("%s", ""))

                    for _, Row in ipairs(Library.SearchRows) do
                        Row.Frame.Visible = (Query == "") or (StringFind(Row.Text, Query, 1, true) ~= nil)
                    end
                end

                Window.ApplySearch = ApplySearchFilter

                Items["SearchBox"]:Connect("Changed", function(Property)
                    if Property == "Text" then
                        ApplySearchFilter(Items["SearchBox"].Instance.Text)
                    end
                end)

                Items["OptsBtn"]:Connect("MouseButton1Down", function()
                    for _, P in Window.Pages do
                        if P.Name == "Settings" and not P.Active then
                            for _, Other in Window.Pages do
                                Other:Turn(Other == P)
                            end
                        end
                    end
                end)

                Window.Items = Items
            end

            local Debounce = false

            function Window:SetCenter()
                local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end

                Window.IsOpen = Bool

                Debounce = true

                if Window.IsOpen then
                    Items["MainFrame"].Instance.Visible = true
                end

                task.delay(0.2, function()
                    Debounce = false
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                local key = tostring(Input.KeyCode)
                local isMenuKey = key == Library.MenuKeybind
                    or (Library.MenuKeybinds and Library.MenuKeybinds[key] == true)
                -- Games may consume F2/V; typing in a textbox must still be ignored.
                if isMenuKey and not UserInputService:GetFocusedTextBox() then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "Page",
                Icon = Data.Icon or Data.icon or "rbxassetid://72196061405823",

                Items = { },
                Active = false,

                Tabs = { },
                TabOrder = { },
                CurrentTab = nil
            }

            Page.Window._NavCounter = (Page.Window._NavCounter or 0) + 1

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextSize = 14,
                    LayoutOrder = Page.Window._NavCounter,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0.4000000059604645,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    Size = UDim2New(0, 18, 0, 18),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.4000000059604645,
                    Text = Page.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 38, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2New(0, 0, 0, 46),
                    Size = UDim2New(1, 0, 1, -46),
                    BorderSizePixel = 0
                })

                Page.Items = Items
            end

            function Page:GetTab(TabName)
                TabName = TabName or "Основное"

                if Page.Tabs[TabName] then
                    return Page.Tabs[TabName]
                end

                local TabFrame = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 1, 0)
                })

                Instances:Create("UIListLayout", {
                    Parent = TabFrame.Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                local Columns = { }

                for ColumnIndex = 1, 2 do
                    local Column = Instances:Create("ScrollingFrame", {
                        Parent = TabFrame.Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = Library.Theme["Outline"],
                        ScrollBarThickness = 2,
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    }):AddToTheme({ScrollBarImageColor3 = 'Outline'})

                    Instances:Create("UIPadding", {
                        Parent = Column.Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 4),
                        PaddingBottom = UDimNew(0, 10),
                        PaddingRight = UDimNew(0, 2),
                        PaddingLeft = UDimNew(0, 2)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = Column.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Columns[ColumnIndex] = Column
                end

                local Button = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["TopLeft"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Text = TabName,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.45,
                    TextSize = 13,
                    BackgroundColor3 = Library.Theme["Accent"],
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Size = UDim2New(0, 0, 0, 24),
                    Visible = false,
                    LayoutOrder = 1 + #Page.TabOrder
                }):AddToTheme({TextColor3 = 'Text', BackgroundColor3 = 'Accent'})

                Instances:Create("UICorner", {
                    Parent = Button.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })

                Instances:Create("UIPadding", {
                    Parent = Button.Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 10)
                })

                local Tab = {Name = TabName, Frame = TabFrame, Columns = Columns, Button = Button}
                Page.Tabs[TabName] = Tab
                table.insert(Page.TabOrder, TabName)

                Button:Connect("MouseButton1Down", function()
                    Page:SelectTab(TabName)
                end)

                Button:Connect("MouseEnter", function()
                    if Page.CurrentTab ~= TabName then
                        Button:Tween(nil, {TextTransparency = 0.15})
                    end
                end)
                Button:Connect("MouseLeave", function()
                    if Page.CurrentTab ~= TabName then
                        Button:Tween(nil, {TextTransparency = 0.45})
                    end
                end)

                if Page.Active and Page.CurrentTab == nil then
                    Page:SelectTab(TabName, true)
                end

                return Tab
            end

            function Page:SelectTab(TabName, SkipFade)
                if not Page.Tabs[TabName] then
                    return
                end

                local OldTab = Page.CurrentTab and Page.Tabs[Page.CurrentTab] or nil
                Page.CurrentTab = TabName

                for _, Name in Page.TabOrder do
                    local Tab = Page.Tabs[Name]
                    local IsCurrent = (Name == TabName)

                    Tab.Frame.Instance.Visible = IsCurrent

                    if #Page.TabOrder > 1 then
                        Tab.Button.Instance.Visible = Page.Active
                        Tab.Button:Tween(nil, {
                            TextColor3 = IsCurrent and Library.Theme.Accent or Library.Theme.Text,
                            TextTransparency = IsCurrent and 0 or 0.45,
                            BackgroundTransparency = IsCurrent and 0.84 or 1
                        })
                    else
                        Tab.Button.Instance.Visible = false
                    end

                    if IsCurrent then
                        Tab.Frame.Instance.Position = UDim2New(0, 0, 0, 14)
                        Tab.Frame:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, 0, 0)})
                    end
                end

                if OldTab and OldTab ~= Page.Tabs[TabName] and OldTab.OnHide then
                    OldTab.OnHide()
                end
                if Page.Tabs[TabName].OnSelect then
                    Page.Tabs[TabName].OnSelect()
                end

                if Page.Window.ApplySearch then
                    Page.Window.ApplySearch(Page.Window.CurrentQuery or "")
                end
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then
                    return
                end

                Page.Active = Bool

                Debounce = true
                Items["Page"].Instance.Visible = Bool
                Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance

                if Bool then
                    Items["Page"].Instance.Position = UDim2New(0, 0, 0, 46 + 30)
                    Items["Page"]:Tween(TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, 0, 46)})
                end

                if Page.Active then

                    Items["Background"]:Tween(nil, {BackgroundTransparency = 0.84, Size = UDim2New(1, 0, 0, 35)})

                    Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})

                    Page.Window.Items["PageTitle"].Instance.Text = Page.Name

                    Page:SelectTab(Page.CurrentTab or Page.TabOrder[1] or "Основное", true)
                else
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 35)})

                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.4})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.4})

                    for _, Name in Page.TabOrder do
                        Page.Tabs[Name].Button.Instance.Visible = false
                    end

                    local HiddenTab = Page.CurrentTab and Page.Tabs[Page.CurrentTab] or nil
                    if HiddenTab and HiddenTab.OnHide then
                        HiddenTab.OnHide()
                    end
                end

                task.delay(0.25, function()
                    Debounce = false
                end)
            end

            Items["Inactive"]:Connect("MouseEnter", function()
                if not Page.Active then
                    Items["Text"]:Tween(nil, {TextTransparency = 0.12})
                    Items["Icon"]:Tween(nil, {ImageTransparency = 0.12})
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 0.93, Size = UDim2New(1, 0, 0, 35)})
                end
            end)

            Items["Inactive"]:Connect("MouseLeave", function()
                if not Page.Active then
                    Items["Text"]:Tween(nil, {TextTransparency = 0.4})
                    Items["Icon"]:Tween(nil, {ImageTransparency = 0.4})
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 35)})
                end
            end)

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Group = function(self, Name)
            self._NavCounter = (self._NavCounter or 0) + 1

            Instances:Create("TextLabel", {
                Parent = self.Items["Pages"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                Text = Name,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.55,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 16),
                LayoutOrder = self._NavCounter
            }):AddToTheme({TextColor3 = 'Text'})
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Side = math.clamp(Data.Side or Data.side or 1, 1, 2),
                Icon = Data.Icon or Data.icon or "rbxassetid://127136375066593",

                Items = { }
            }

            local Tab = Section.Page:GetTab(Data.Tab)
            local TargetColumn = Tab.Columns[Section.Side].Instance

            local Items = { } do
                Items["SectionOutline"] = Instances:Create("Frame", {
                    Parent = TargetColumn,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 44),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Instances:Create("UICorner", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 16)
                })

                Items["Section"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 15)
                })

                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 38),
                    BorderSizePixel = 0
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 14, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 15
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 38),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 4),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 12),
                    PaddingLeft = UDimNew(0, 12)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false
            }

            local Items = { } do
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Toggle.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 32, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Circle"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 0.5,
                    Position = UDim2New(0, 4, 0.5, 0),
                    Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})

                Instances:Create("UICorner", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
            end

            table.insert(Library.SearchRows, {Frame = Items["Toggle"].Instance, Text = StringLower(Toggle.Name), Page = Toggle.Page})

            function Toggle:Get()
                return Toggle.Value
            end

            function Toggle:Set(Value)
                Toggle.Value = Value
                Library.Flags[Toggle.Flag] = Value

                if Toggle.Value then
                    Items["Glow"]:Tween(nil, {ImageTransparency = 0.7})

                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                    Items["Circle"]:Tween(TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        AnchorPoint = Vector2New(1, 0.5),
                        Position = UDim2New(1, -3, 0.5, 0),
                        BackgroundTransparency = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Items["Text"]:Tween(nil, {TextTransparency = 0})
                else
                    Items["Glow"]:Tween(nil, {ImageTransparency = 1})

                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})

                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                    Items["Circle"]:Tween(TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 3, 0.5, 0),
                        BackgroundTransparency = 0.45,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Items["Text"]:Tween(nil, {TextTransparency = 0.45})
                end

                if Toggle.Callback then
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 30),
                    Selectable = false,
                    Active = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://117716971575946",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:Press()
                if not Library or not Items["Stroke"] then
                    return
                end
                Items["Stroke"]:ChangeItemTheme({Color = "Accent"})
                Items["Stroke"]:Tween(nil, {Color = Library.Theme.Accent})
                task.wait(0.1)
                Library:SafeCall(Button.Callback)
                if not Library or not Items["Stroke"] then
                    return
                end
                Items["Stroke"]:ChangeItemTheme({Color = "Outline"})
                Items["Stroke"]:Tween(nil, {Color = Library.Theme.Outline})
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Min = Data.Min or Data.min or 0,
                Default = Data.Default or Data.default or 0,
                Max = Data.Max or Data.max or 100,
                Suffix = Data.Suffix or Data.suffix or "",
                Decimals = Data.Decimals or Data.decimals or 1,
                Callback = Data.Callback or Data.callback or function() end,

                Value = 0,
                Sliding = false
            }

            local Items = { } do
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})

                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    Active = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 0, 5),
                    Selectable = false,
                    BorderSizePixel = 0,
                    LayoutOrder = 2,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                local SliderFlex = Instance.new("UIFlexItem")
                SliderFlex.FlexMode = Enum.UIFlexMode.Fill
                SliderFlex.Parent = Items["RealSlider"].Instance

                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.6000000238418579, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})

                Items["Dragger"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(1, -4, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 13, 0, 13),
                    BorderSizePixel = 0
                })

                Instances:Create("UICorner", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Glow2"] = Instances:Create("ImageLabel", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    Text = "50%",
                    Size = UDim2New(0, 48, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"],
                    LayoutOrder = 3,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextSize = 12
                }):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})

                Instances:Create("UICorner", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
            end

            table.insert(Library.SearchRows, {Frame = Items["Slider"].Instance, Text = StringLower(Slider.Name), Page = Slider.Page})

            function Slider:Get()
                return Slider.Value
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value

                Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

                if Slider.Callback then
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            local InputChanged

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            if Slider.Default then
                Slider:Set(Slider.Default)
            end

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or { "One", "Two", "Three" },
                Default = Data.Default or Data.default or nil,
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,

                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 26),
                    BorderSizePixel = 0
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})

                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 0, 26),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    LayoutOrder = 2,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                local DropdownFlex = Instance.new("UIFlexItem")
                DropdownFlex.FlexMode = Enum.UIFlexMode.Fill
                DropdownFlex.Parent = Items["RealDropdown"].Instance

                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.15,
                    Text = "--",
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://72690112230014",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -8, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})

                Instances:Create("Frame", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -32, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["OptionHolder"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 200, 0, 0),
                    Position = UDim2New(0, 54, 0, 236),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextSize = 14,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Instances:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0"
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 10),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 10),
                    PaddingLeft = UDimNew(0, 10)
                })
            end

            table.insert(Library.SearchRows, {Frame = Items["Dropdown"].Instance, Text = StringLower(Dropdown.Name), Page = Dropdown.Page})

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false
            local RenderStepped

            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true

                if Dropdown.IsOpen then
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y - 25)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 0)
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= Dropdown and not Dropdown.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown
                else
                    if Library.OpenFrames[Dropdown] then
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue
                    end

                    if not Value.ClassName:find("UI") then
                        Value.ZIndex = Dropdown.IsOpen and 3 or 1
                    end

                    if type(TransparencyProperty) == "table" then
                        for _, Property in TransparencyProperty do
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end

                NewTween.Tween.Completed:Connect(function()
                    Debounce = false
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then
                    if type(Option) ~= "table" then
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14
                })

                local OptionLiner = Instances:Create("Frame", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 3, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                local OptionGlow = Instances:Create("ImageLabel", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})

                Instances:Create("UICorner", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                local OptionText = Instances:Create("TextLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Option,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Liner = OptionLiner,
                    Glow = OptionGlow,
                    Text = OptionText,
                    Selected = false
                }

                function OptionData:Toggle(Value)
                    if Value == "Active" then
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 3, 1, 0)})
                        OptionData.Glow:Tween(nil, {ImageTransparency = 0.7})
                        OptionData.Text:Tween(nil, {Position = UDim2New(0, 12, 0.5 ,0), TextTransparency = 0})
                    else
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 3, 0, 0)})
                        OptionData.Glow:Tween(nil, {ImageTransparency = 1})
                        OptionData.Text:Tween(nil, {Position = UDim2New(0, 0, 0.5 ,0), TextTransparency = 0.5})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.Selected = false
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do
                    Dropdown:Add(Value)
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    Dropdown.IsOpen = not Library:IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            for Index, Value in Dropdown.Items do
                Dropdown:Add(Value)
            end

            if Dropdown.Default then
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Name)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Name or "Label"
            }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Label:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            return Label
        end

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Textbox",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,

                Value = ""
            }

            local Items = { } do
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 30),
                    BorderSizePixel = 0
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Textbox.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    Active = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 1),
                    Size = UDim2New(0, 0, 0, 30),
                    Position = UDim2New(1, 0, 1, 0),
                    Selectable = true,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Instances:Create("UIPadding", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Active = false,
                    TextTransparency = 0,
                    AnchorPoint = Vector2New(0, 0.5),
                    PlaceholderColor3 = FromRGB(133, 139, 143),
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 16,
                    Size = UDim2New(0, 0, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Selectable = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    CursorPosition = -1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end

            if Textbox.Finished then
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox
        end
    end

    Library.CreateSettingsPage = function(self, Window, Watermark)
            local SettingsPage = Window:Page({Name = "Settings", Icon = "rbxassetid://80758916183665"})

        do
            local ThemingSection = SettingsPage:Section({Name = "Theming", Tab = "Оформление", Icon = "rbxassetid://73803440257131"})

            do
                for Index, Value in Library.Theme do
                    ThemingSection:Label(Index):Colorpicker({
                        Flag = Index.."_ThemingThing",
                        Default = Value,
                        Alpha = 0,
                        Callback = function(Value)
                            Library.Theme[Index] = Value
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                end
            end

            local ConfigsSection = SettingsPage:Section({Name = "Configs", Tab = "Конфиги", Icon = "rbxassetid://74885853379841"}) do
                local ConfigName
                local ConfigSelected

                local ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs",
                    Flag = "Configs",
                    Items = { },
                    Multi = false,
                    MaxSize = 120,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsSection:Textbox({
                    Name = "Config name",
                    Placeholder = "Config name",
                    Flag = "ConfigName",
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if ConfigName and ConfigName ~= "" then
                            if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                                writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                                Library:RefreshConfigsList(ConfigsDropdown)
                            end
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json"))
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Save",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            writefile(Library.Folders.Configs .. "/" .. ConfigSelected..".json", Library:GetConfig())
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            delfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json")
                            Library:RefreshConfigsList(ConfigsDropdown)
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Refresh",
                    Callback = function()
                        Library:RefreshConfigsList(ConfigsDropdown)
                    end
                })

                Library:RefreshConfigsList(ConfigsDropdown)
            end
        end

        return SettingsPage
    end
end

Library.LucideIconsUrl = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"
Library.IconPacks = Library.IconPacks or {}
Library.ActiveIconPack = "lucide"

function Library:LoadIconPack(Url, PackName)
    PackName = PackName or "lucide"

    if self.IconPacks[PackName] then
        return self.IconPacks[PackName]
    end

    local Success, Result = pcall(function()
        local Source = game:HttpGet(Url)
        local Chunk = loadstring(Source)
        if not Chunk then
            return {}
        end

        local Icons = Chunk()
        if type(Icons) ~= "table" then
            return {}
        end

        return Icons
    end)

    self.IconPacks[PackName] = Success and Result or {}
    return self.IconPacks[PackName]
end

function Library:SetIconPack(PackName)
    self.ActiveIconPack = PackName or "lucide"
end

function Library:GetIconPack(PackName)
    PackName = PackName or self.ActiveIconPack or "lucide"

    if not self.IconPacks[PackName] then
        if PackName == "lucide" then
            self:LoadIconPack(self.LucideIconsUrl, "lucide")
        else
            self.IconPacks[PackName] = {}
        end
    end

    return self.IconPacks[PackName] or {}
end

function Library:ResolveIcon(Icon, PackName)
    if not Icon or Icon == "" then
        return Icon
    end

    if typeof(Icon) ~= "string" then
        return Icon
    end

    if Icon:match("^rbxassetid://") or Icon:match("^https?://") then
        return Icon
    end

    local Icons = self:GetIconPack(PackName)
    return Icons[string.lower(Icon)] or Icon
end

local OriginalWindowFunction = Library.Window
Library.Window = function(self, Data)
    Data = Data or {}

    Data.Logo = self:ResolveIcon(Data.Logo)
    Data.logo = self:ResolveIcon(Data.logo)

    if Data.WatermarkLogo then
        Data.WatermarkLogo = self:ResolveIcon(Data.WatermarkLogo)
    end

    return OriginalWindowFunction(self, Data)
end

local OriginalSectionFunction = Library.Pages.Section
Library.Pages.Section = function(self, Data)
    Data = Data or {}
    Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon
    return OriginalSectionFunction(self, Data)
end

Library.CreateWindow = function(self, Data)
    Data = Data or {}

    local Window = self:Window(Data)
    local Watermark

    if Data.WatermarkEnabled then
        Watermark = self:Watermark(
            Data.WatermarkText or Data.Name or "Window",
            self:ResolveIcon(Data.WatermarkLogo or Data.Logo)
        )
        Window.Watermark = Watermark
    end

    Window._AutoSettingsEnabled = Data.SettingsTabEnabled and true or false
    Window._AutoSettingsWatermark = Watermark

    local OriginalPage = Window.Page
    local CreatingSettings = false

    local function ReorderTabs()
        local Order = 1

        for _, Value in Window.Pages do
            if Value ~= Window.SettingsPage and Value.Items and Value.Items["Inactive"] then
                Value.Items["Inactive"].Instance.LayoutOrder = Order
                Order += 1
            end
        end

        if Window.SettingsPage and Window.SettingsPage.Items and Window.SettingsPage.Items["Inactive"] then
            Window.SettingsPage.Items["Inactive"].Instance.LayoutOrder = 999999
        end
    end

    local function EnsureSettings()
        if not Window._AutoSettingsEnabled or Window.SettingsPage or CreatingSettings then
            ReorderTabs()
            return
        end

        CreatingSettings = true
        Window.SettingsPage = Library:CreateSettingsPage(Window, Window._AutoSettingsWatermark)
        CreatingSettings = false

        ReorderTabs()
    end

    local function WrappedPage(_, TabData)
        TabData = TabData or {}
        TabData.Icon = Library:ResolveIcon(TabData.Icon or TabData.icon)
        TabData.icon = TabData.Icon

        local Page = OriginalPage(Window, TabData)

        EnsureSettings()
        ReorderTabs()

        return Page
    end

    Window.Page = WrappedPage
    Window.CreateTab = WrappedPage
    Window.CreatePage = WrappedPage

    return Window
end

Library.CreateTab = Library.Page
Library.Pages.CreateSection = Library.Pages.Section

Library.Sections.CreateButton = Library.Sections.Button
Library.Sections.CreateToggle = Library.Sections.Toggle
Library.Sections.CreateSlider = Library.Sections.Slider
Library.Sections.CreateDropdown = Library.Sections.Dropdown
Library.Sections.CreateTextbox = Library.Sections.Textbox
Library.Sections.CreateLabel = Library.Sections.Label

local function NormalizeNamedData(NameOrData, Icon)
    if type(NameOrData) == "table" then
        local Data = table.clone(NameOrData)

        if Data.Title and not (Data.Name or Data.name) then
            Data.Name = Data.Title
        end

        if Data.title and not (Data.Name or Data.name) then
            Data.Name = Data.title
        end

        if Icon and not (Data.Icon or Data.icon) then
            Data.Icon = Icon
        end

        return Data
    end

    local Data = {
        Name = NameOrData
    }

    if Icon ~= nil then
        Data.Icon = Icon
    end

    return Data
end

function Library:AddTab(NameOrData, Icon)
    local Data = NormalizeNamedData(NameOrData, Icon)
    Data.Icon = self:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    if self.CreateTab then
        return self:CreateTab(Data)
    end

    return self:Page(Data)
end

function Library.Pages:AddSection(NameOrData, Icon)
    local Data = NormalizeNamedData(NameOrData, Icon)
    Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    if self.CreateSection then
        return self:CreateSection(Data)
    end

    return self:Section(Data)
end

function Library.Sections:AddButton(NameOrData, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateButton(Data)
    end

    return self:CreateButton({
        Name = NameOrData,
        Callback = Callback
    })
end

function Library.Sections:AddToggle(NameOrData, FlagOrCallback, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateToggle(Data)
    end

    local RealCallback = type(FlagOrCallback) == "function" and FlagOrCallback or Callback

    return self:CreateToggle({
        Name = NameOrData,
        Flag = type(FlagOrCallback) == "string" and FlagOrCallback or nil,
        Default = Default,
        Callback = RealCallback
    })
end

function Library.Sections:AddSlider(NameOrData, Min, Max, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateSlider(Data)
    end

    return self:CreateSlider({
        Name = NameOrData,
        Min = Min,
        Max = Max,
        Default = Default,
        Callback = Callback
    })
end

function Library.Sections:AddDropdown(NameOrData, Items, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateDropdown(Data)
    end

    return self:CreateDropdown({
        Name = NameOrData,
        Items = Items,
        Default = Default,
        Callback = Callback
    })
end

function Library.Sections:AddTextbox(NameOrData, Placeholder, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateTextbox(Data)
    end

    return self:CreateTextbox({
        Name = NameOrData,
        Placeholder = Placeholder,
        Callback = Callback
    })
end

function Library.Sections:AddLabel(TextOrData)
    if type(TextOrData) == "table" then
        local Data = NormalizeNamedData(TextOrData)
        return self:CreateLabel(Data.Name or Data.Text or Data.text or "Label")
    end

    return self:CreateLabel(TextOrData)
end

getgenv().Library = Library
return Library
end)()

-- ============================================================
-- DEV TESTING HUB | SUPREME (Boom Hood build)
-- UI: homxiide-style library (gui.lua, embedded)
-- Functions: Aimbot / ESP / Spinbot / AutoShot / Infinite Ammo / No Reload /
--            Instakill controller / TP Bullet (raycast hook) / Auto Stomp /
--            Hitbox / Anti-Stomp / Speed / Jump / Fly / Infinite Jump /
--            Noclip / Anti-Fling / Teleport / Fullbright / Anti-AFK /
--            Menu customization (dim background + snow)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local StatsService = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local OriginalAmbient = Lighting.Ambient
local OriginalBrightness = Lighting.Brightness

local GEN = (tonumber(getgenv().__SupremeHubGen) or 0) + 1
getgenv().__SupremeHubGen = GEN

if getgenv().__SupremeHubCleanup then
    pcall(getgenv().__SupremeHubCleanup)
end

local Running = true
local MenuOpen = false
local MenuFrame = nil
local internalRay = false

local function alive()
    return Running and getgenv().__SupremeHubGen == GEN
end

-- ============================================================
-- STATE
-- ============================================================

local S = {
    -- Aimbot
    Aimbot_Enabled = false,
    Aimbot_WallCheck = true,
    Aimbot_TargetNPCs = false,
    Aimbot_Prediction = false,
    Aimbot_TeamCheck = true,
    Aim_Part = "Head",
    Aim_Smoothing = 0.25,
    Aim_FOV = 150,
    Aim_ShowFOV = false,
    Aim_BulletSpeed = 1500,
    Aimbot_Mode = "Normal",
    FOV_Color = Color3.fromRGB(255, 255, 255),

    -- Silent aim
    Silent_FOV = 300,
    Silent_Range = 500,
    Silent_WallCheck = false,
    Silent_AimPart = "Head",
    Silent_ShowFOV = false,
    Silent_FOV_Color = Color3.fromRGB(255, 90, 90),

    -- ESP
    ESP_Enabled = false,
    Tracers_Enabled = false,
    ESP_MaxDistance = 5000,
    NPC_ESP_Enabled = false,
    NPC_Tracers_Enabled = false,
    NPC_ESP_MaxDistance = 1500,
    ESP_Health = false,
    ESP_VisibleColor = Color3.fromRGB(0, 255, 0),
    ESP_EnemyColor = Color3.fromRGB(255, 0, 0),
    ESP_TeamColor = Color3.fromRGB(0, 128, 255),
    ESP_NPCColor = Color3.fromRGB(0, 200, 255),
    ESP_Thickness = 1.5,
    ESP_TextSize = 14,
    ESP_BoxFilled = false,
    ESP_BoxStyle = "Full",
    ESP_TracerFrom = "Bottom",
    ESP_ShowName = true,
    ESP_ShowDistance = true,
    ESP_TextOutline = true,
    ESP_Arrows = false,
    ESP_ArrowRadius = 140,
    Fullbright_Enabled = false,

    -- Movement
    Spinbot_Enabled = false,
    Spinbot_Speed = 720,
    Spinbot_Tilt = false,
    Speed_Enabled = false,
    Speed_Value = 60,
    Jump_Enabled = false,
    Jump_Value = 90,
    Fly_Enabled = false,
    Fly_Speed = 300,
    InfiniteJump_Enabled = false,
    Noclip_Enabled = false,
    AntiFling_Enabled = false,
    AntiStomp_Enabled = false,
    AntiStomp_Radius = 7,
    AntiStomp_NoRagdoll = true,
    AntiRagdoll_Enabled = false,

    -- Shooting
    AutoShot_Enabled = false,
    AutoShot_Rate = 12,
    AutoShot_RequireTarget = true,
    AutoShot_Mode = "Tool",
    AutoStomp_Enabled = false,
    AutoStomp_Key = "",
    Hitbox_Enabled = false,
    Hitbox_Size = 6,

    -- Exploits
    Ammo_Enabled = false,
    Ammo_ReloadSpam = true,
    Reload_SpamInterval = 0.7,
    NoReload_Enabled = false,
    Instakill_Enabled = false,
    Instakill_Multiplier = 50,
    Instakill_Rate = 45,
    Instakill_Range = 3000,
    TP_Bullet_Enabled = false,
    TP_Bullet_Range = 12,
    AntiAFK_Enabled = false,

    -- Rage
    Rage_Enabled = false,
    Rage_Mode = "Nearest",
    Rage_TargetName = "None",
    Rage_TeamCheck = false,
    Rage_AutoStomp = true,
    Rage_AutoReload = true,
    Rage_StompKey = "E",
    Rage_ReloadKey = "R",
    Rage_Rate = 15,
    Rage_Spin = false,
    Rage_OrbitSpeed = 12,
    Rage_OrbitRadius = 8,
    Rage_OrbitHeight = 5,

    -- Player
    Spectate_Target = nil,
    Spectate_Enabled = false,
    Spectate_Name = "",

    -- Menu
    Menu_DimEnabled = true,
    Menu_DimStrength = 45,
    Menu_SnowEnabled = true,
    Menu_SnowAmount = 60,
    Menu_SnowSpeed = 90,
    Menu_FxType = "Snow",
    Menu_FxBrightness = 80,
    World_SnowEnabled = false,
    World_SnowAmount = 50,
    World_SnowSpeed = 90,
    World_FxType = "Snow",
    World_FxBrightness = 80,
    Watermark_Enabled = true,
    KeybindList_Enabled = true,
    Overlay_BGColor = nil,
    Overlay_TextColor = nil,
    Menu_BGPattern = "None",
    Menu_BGGradientA = Color3.fromRGB(4, 5, 10),
    Menu_BGGradientB = Color3.fromRGB(20, 22, 35),
    Menu_BGGradientRot = 0,
    Menu_DimColor = Color3.fromRGB(4, 5, 10),
    Menu_PatternOpacity = 8,

    -- Music
    Music_Volume = 1,
}

local ESP_CONFIG = {
    TOP_OFFSET = Vector3.new(0, 3, 0),
    BOTTOM_OFFSET = Vector3.new(0, 3.5, 0),
    DISTANCE_DIVISOR = 3.5,
    MIN_HEIGHT = 6,
    MIN_WIDTH = 4,
}

-- Tabs marked IN WORK in the UI: their runtime logic stays disabled.
local EXPLOITS_LOCKED = true
local AMMO_LOCKED = true

local function createWorkCover(parent, options)
    options = options or {}

    local cover = Instance.new("Frame")
    cover.Name = options.Name or "InWorkCover"
    cover.Size = UDim2.new(1, 0, 1, 0)
    cover.BackgroundColor3 = Color3.fromRGB(4, 5, 9)
    cover.BackgroundTransparency = options.Transparency or 0.42
    cover.BorderSizePixel = 0
    cover.ZIndex = options.ZIndex or 50
    cover.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, options.Corner or 12)
    corner.Parent = cover

    local label = Instance.new("TextLabel")
    label.Name = "InWorkText"
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Position = UDim2.new(0.5, 0, 0.5, 0)
    label.Size = UDim2.new(1.6, 0, 0, options.TextSize or 34)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = options.Text or "IN WORK"
    label.TextSize = options.TextSize or 34
    label.TextColor3 = (Library.Theme and Library.Theme.Accent) or Color3.fromRGB(210, 40, 50)
    label.TextTransparency = 0.08
    label.Rotation = options.Rotation or -24
    label.ZIndex = cover.ZIndex + 1
    label.Parent = cover

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Transparency = 0.45
    stroke.Parent = label

    local blocker = Instance.new("TextButton")
    blocker.Name = "InWorkBlocker"
    blocker.Size = UDim2.new(1, 0, 1, 0)
    blocker.BackgroundTransparency = 1
    blocker.Text = ""
    blocker.AutoButtonColor = false
    blocker.Active = true
    blocker.ZIndex = cover.ZIndex + 2
    blocker.Parent = cover

    return { cover = cover, label = label, blocker = blocker }
end

local HasDrawing = type(Drawing) == "table" and type(Drawing.new) == "function"
local ESP_Cache = {}
local ESP_ArrowCache = {}
local arrowsActive = false
local Visibility_Cache = {}
local Tracked_NPCs = {}
local INSTA
local CurrentTargetPart = nil
local CurrentTargetPlayer = nil
local currentTargetPos = nil

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

-- ============================================================
-- UTILITIES
-- ============================================================

local function getCharacter()
    return LocalPlayer.Character
end

local function getHRP(character)
    character = character or LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart") or nil
end

local function getHumanoid(character)
    character = character or LocalPlayer.Character
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

-- UserIds protect the selected account through respawns/rejoins in this session.
-- Usernames are also kept so the normal config system can restore the selection.
local WHITELIST = { Selected = {}, Ids = {}, Bindings = {}, KnownIds = {}, KnownNames = {} }
function WHITELIST.Refresh()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            WHITELIST.KnownIds[string.lower(player.Name)] = player.UserId
            WHITELIST.KnownNames[player.UserId] = player.Name
        end
    end
    local normalized, bindings = {}, {}
    for key, label in pairs(WHITELIST.Selected) do
        local id = WHITELIST.Bindings[key] or WHITELIST.KnownIds[key]
        if id and id ~= LocalPlayer.UserId then WHITELIST.Ids[id] = true end
        local name = id and WHITELIST.KnownNames[id] or label
        normalized[string.lower(name)] = name
        if id then bindings[string.lower(name)] = id end
    end
    WHITELIST.Selected, WHITELIST.Bindings = normalized, bindings
end
function WHITELIST.Selection()
    local names = {}
    for _, name in pairs(WHITELIST.Selected) do table.insert(names, name) end
    table.sort(names)
    return names
end
function WHITELIST.Names()
    local unique = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then unique[string.lower(player.Name)] = player.Name end
    end
    for key, name in pairs(WHITELIST.Selected) do unique[key] = name end
    local names = {}
    for _, name in pairs(unique) do table.insert(names, name) end
    table.sort(names)
    return names
end
function WHITELIST.Apply(names)
    local previousBindings = WHITELIST.Bindings
    WHITELIST.Refresh()
    local selected, ids, bindings = {}, {}, {}
    if type(names) == "table" then
        for _, name in ipairs(names) do
            if type(name) == "string" and name ~= "" and string.lower(name) ~= string.lower(LocalPlayer.Name) then
                local key = string.lower(name)
                local id = previousBindings[key] or WHITELIST.Bindings[key] or WHITELIST.KnownIds[key]
                local canonical = id and WHITELIST.KnownNames[id] or name
                selected[string.lower(canonical)] = canonical
                if id then ids[id] = true; bindings[string.lower(canonical)] = id end
            end
        end
    end
    WHITELIST.Selected, WHITELIST.Ids, WHITELIST.Bindings = selected, ids, bindings
    if WHITELIST.OnChanged then WHITELIST.OnChanged() end
end
function WHITELIST.IsPlayer(player)
    if not player or player == LocalPlayer then return false end
    if WHITELIST.Ids[player.UserId] then return true end
    local key = string.lower(player.Name)
    if WHITELIST.Selected[key] then
        local known = WHITELIST.Bindings[key] or WHITELIST.KnownIds[key]
        if known and known ~= player.UserId then return false end
        WHITELIST.KnownIds[key], WHITELIST.KnownNames[player.UserId] = player.UserId, player.Name
        WHITELIST.Bindings[key] = player.UserId
        WHITELIST.Ids[player.UserId] = true
        return true
    end
    return false
end
function WHITELIST.IsCharacter(character)
    -- A dot call preserves the active method when checked inside a namecall hook.
    return character ~= nil and WHITELIST.IsPlayer(Players.GetPlayerFromCharacter(Players, character))
end
function WHITELIST.IsTarget(part, player)
    return WHITELIST.IsPlayer(player) or (part ~= nil and WHITELIST.IsCharacter(part.Parent))
end
function WHITELIST.BlocksAutoShot(part, player)
    if WHITELIST.IsTarget(part, player) then return true end
    if next(WHITELIST.Selected) == nil and next(WHITELIST.Ids) == nil then return false end
    -- With protected players, do not free-fire without an allowed target.
    if not part then return true end
    local ok, mouse = pcall(function() return LocalPlayer:GetMouse() end)
    local object = ok and mouse and mouse.Target or nil
    for _ = 1, 8 do
        if not object then break end
        local found, owner = pcall(Players.GetPlayerFromCharacter, Players, object)
        if found and WHITELIST.IsPlayer(owner) then return true end
        object = object.Parent
    end
    return false
end

local function isAlive(character)
    local hum = getHumanoid(character)
    return hum ~= nil and hum.Health > 0
end

local function refreshRayFilter()
    local list = {}
    local character = LocalPlayer.Character
    local camera = workspace.CurrentCamera
    if character then
        table.insert(list, character)
    end
    if camera then
        table.insert(list, camera)
    end
    rayParams.FilterDescendantsInstances = list
end

local function getPing(player)
    if player == LocalPlayer then
        local ok, value = pcall(function()
            return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and type(value) == "number" and value > 0 then
            return math.floor(value)
        end
    end

    local ok, value = pcall(function()
        return player:GetNetworkPing()
    end)
    if ok and type(value) == "number" and value > 0 then
        return math.floor(value < 1 and value * 1000 or value)
    end

    return nil
end

-- ============================================================
-- MUSIC SCANNER
-- ============================================================

local musicBaseVolumes = setmetatable({}, { __mode = "k" })
local musicPausedByHub = setmetatable({}, { __mode = "k" })

local function getSoundService()
    local ok, service = pcall(function()
        return game:GetService("SoundService")
    end)
    if ok and service then
        return service
    end
    return nil
end

local function isMusicLike(sound)
    if sound.Name == "SupremeAdminJoinAlert" then return false end
    if sound.IsPlaying then
        return true
    end
    if sound.SoundId == "" then
        return false
    end
    if sound.TimeLength and sound.TimeLength > 5 then
        return true
    end
    local name = string.lower(sound.Name)
    return name:find("music", 1, true) ~= nil
        or name:find("song", 1, true) ~= nil
        or name:find("radio", 1, true) ~= nil
        or name:find("bgm", 1, true) ~= nil
        or name:find("track", 1, true) ~= nil
end

local function scanMusicSounds(includeInactive)
    local found = {}
    local function scan(parent)
        local ok, children = pcall(parent.GetDescendants, parent)
        if not ok or not children then
            return
        end
        for _, sound in ipairs(children) do
            if typeof(sound) == "Instance" and sound:IsA("Sound")
                and sound.Name ~= "SupremeAdminJoinAlert"
                and (includeInactive and isMusicLike(sound) or sound.IsPlaying)
            then
                table.insert(found, sound)
            end
        end
    end

    pcall(scan, workspace)
    local soundService = getSoundService()
    if soundService then
        pcall(scan, soundService)
    end

    return found
end

local function getMusicListText()
    local sounds = scanMusicSounds()
    if #sounds == 0 then
        return "No playing music"
    end
    local names = {}
    for index = 1, math.min(#sounds, 3) do
        table.insert(names, sounds[index].Name)
    end
    if #sounds > 3 then
        table.insert(names, "+" .. tostring(#sounds - 3) .. " more")
    end
    return table.concat(names, " · ")
end

local function applyMusicVolume()
    local sounds = scanMusicSounds()
    local volume = math.clamp(S.Music_Volume or 1, 0, 10)
    for _, sound in ipairs(sounds) do
        local base = musicBaseVolumes[sound]
        if base == nil then
            base = sound.Volume
            musicBaseVolumes[sound] = base
        end
        local target = base * volume
        if math.abs((sound.Volume or 0) - target) > 0.001 then
            sound.Volume = target
        end
    end
end

local function pauseMusic()
    local sounds = scanMusicSounds()
    for _, sound in ipairs(sounds) do
        if sound.IsPlaying then
            musicPausedByHub[sound] = true
            sound:Pause()
        end
    end
end

local function resumeMusic()
    for sound, paused in pairs(musicPausedByHub) do
        if paused and sound.Parent then
            sound:Play()
        end
    end
    musicPausedByHub = setmetatable({}, { __mode = "k" })
end

local musicSwitchIndex = 0

local function switchMusic()
    local sounds = scanMusicSounds(true)
    if #sounds == 0 then
        return nil
    end
    musicSwitchIndex = (musicSwitchIndex % #sounds) + 1
    local target = sounds[musicSwitchIndex]
    for _, sound in ipairs(sounds) do
        if sound == target then
            musicPausedByHub[sound] = nil
            if not sound.IsPlaying then
                sound:Play()
            end
        elseif sound.IsPlaying then
            musicPausedByHub[sound] = true
            sound:Pause()
        end
    end
    return target
end

local function stopMusic()
    local sounds = scanMusicSounds()
    for _, sound in ipairs(sounds) do
        musicPausedByHub[sound] = nil
        sound:Stop()
    end
end

local function notify(text)
    if not (Library and Library.Holder) then
        return
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(280, 42)
    frame.Position = UDim2.new(0.5, -140, 0, 18)
    frame.BackgroundColor3 = Color3.fromRGB(22, 23, 28)
    frame.BorderSizePixel = 0
    frame.ZIndex = 50
    frame.Parent = Library.Holder.Instance

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(64, 68, 82)
    stroke.Transparency = 0.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 1, 0)
    label.Position = UDim2.fromOffset(12, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(232, 233, 238)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Text = tostring(text)
    label.Parent = frame

    task.delay(3, function()
        if frame.Parent then
            frame:Destroy()
        end
    end)
end

-- ============================================================
-- VISIBILITY / ESP
-- ============================================================

local function getVisibility(id, character)
    local now = tick()
    local cached = Visibility_Cache[id]
    if cached and now - cached.lastUpdate < 0.1 then
        return cached.isVisible
    end

    local camera = workspace.CurrentCamera
    if not camera then
        return false
    end

    local parts = {
        character:FindFirstChild("Head"),
        character:FindFirstChild("HumanoidRootPart"),
        character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm"),
        character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm"),
        character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg"),
        character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg"),
    }

    local origin = camera.CFrame.Position
    local isVisible = false

    for _, part in ipairs(parts) do
        if part and part:IsA("BasePart") then
            internalRay = true
            local ok, result = pcall(function()
                return workspace:Raycast(origin, part.Position - origin, rayParams)
            end)
            internalRay = false
            if ok and result and result.Instance:IsDescendantOf(character) then
                isVisible = true
                break
            end
        end
    end

    Visibility_Cache[id] = { isVisible = isVisible, lastUpdate = now }
    return isVisible
end

local function clearEntityESP(id)
    local entry = ESP_Cache[id]
    if entry then
        for _, drawing in pairs(entry) do
            pcall(function()
                drawing:Remove()
            end)
        end
        ESP_Cache[id] = nil
    end
    Visibility_Cache[id] = nil
end

local function hideESP(id)
    local entry = ESP_Cache[id]
    if not entry then
        return
    end
    for _, drawing in pairs(entry) do
        drawing.Visible = false
    end
end

local function drawESP(id, character, hrp, name, team, isNPC)
    if not HasDrawing then
        return
    end

    local showBox = isNPC and S.NPC_ESP_Enabled or (not isNPC and S.ESP_Enabled)
    local showTracer = isNPC and S.NPC_Tracers_Enabled or (not isNPC and S.Tracers_Enabled)
    local maxDistance = isNPC and S.NPC_ESP_MaxDistance or S.ESP_MaxDistance

    if not showBox and not showTracer then
        return
    end

    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local distance = (camera.CFrame.Position - hrp.Position).Magnitude
    if distance > maxDistance or distance == 0 then
        return
    end

    local rootScreen, onScreen = camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then
        return
    end

    if not ESP_Cache[id] then
        local entry = {
            Box = Drawing.new("Square"),
            Text = Drawing.new("Text"),
            Tracer = Drawing.new("Line"),
        }
        for index = 1, 8 do
            entry["Corner" .. index] = Drawing.new("Line")
        end
        ESP_Cache[id] = entry
        ESP_Cache[id].Box.Thickness = S.ESP_Thickness
        ESP_Cache[id].Box.Filled = S.ESP_BoxFilled
        ESP_Cache[id].Text.Size = S.ESP_TextSize
        ESP_Cache[id].Text.Center = true
        ESP_Cache[id].Text.Outline = S.ESP_TextOutline
        ESP_Cache[id].Tracer.Thickness = S.ESP_Thickness
    end

    local box = ESP_Cache[id].Box
    local text = ESP_Cache[id].Text
    local tracer = ESP_Cache[id].Tracer

    box.Thickness = S.ESP_Thickness
    box.Filled = S.ESP_BoxFilled
    text.Size = S.ESP_TextSize
    tracer.Thickness = S.ESP_Thickness

    if not showBox then
        box.Visible = false
        text.Visible = false
        for index = 1, 8 do
            local line = ESP_Cache[id]["Corner" .. index]
            if line then
                line.Visible = false
            end
        end
    end
    if not showTracer then
        tracer.Visible = false
    end

    local topScreen = camera:WorldToViewportPoint(hrp.Position + ESP_CONFIG.TOP_OFFSET)
    local bottomScreen = camera:WorldToViewportPoint(hrp.Position - ESP_CONFIG.BOTTOM_OFFSET)

    local height = math.abs(bottomScreen.Y - topScreen.Y)
    local width = height / 2
    if height < ESP_CONFIG.MIN_HEIGHT then
        height = ESP_CONFIG.MIN_HEIGHT
        width = ESP_CONFIG.MIN_WIDTH
    end

    local visible = getVisibility(id, character)
    local color

    if isNPC then
        color = S.ESP_NPCColor
    else
        color = S.ESP_EnemyColor
        if team ~= nil and team == LocalPlayer.Team then
            color = S.ESP_TeamColor
        elseif visible then
            color = S.ESP_VisibleColor
        end
    end

    local left = rootScreen.X - width / 2
    local top = topScreen.Y
    local right = left + width
    local bottom = top + height

    if showBox then
        local filled = S.ESP_BoxFilled and true or false
        local cornerStyle = S.ESP_BoxStyle == "Corners" and not filled
        box.Visible = not cornerStyle
        box.Filled = filled
        box.Transparency = filled and 0.45 or 0
        box.Size = Vector2.new(width, height)
        box.Position = Vector2.new(left, top)
        box.Color = color

        local cornerLength = math.max(4, math.min(width, height) * 0.25)
        local segments = {
            { left, top, left + cornerLength, top },
            { left, top, left, top + cornerLength },
            { right - cornerLength, top, right, top },
            { right, top, right, top + cornerLength },
            { left, bottom, left + cornerLength, bottom },
            { left, bottom - cornerLength, left, bottom },
            { right - cornerLength, bottom, right, bottom },
            { right, bottom - cornerLength, right, bottom },
        }

        for index = 1, 8 do
            local line = ESP_Cache[id]["Corner" .. index]
            if line then
                local segment = segments[index]
                line.Thickness = S.ESP_Thickness
                line.Color = color
                line.From = Vector2.new(segment[1], segment[2])
                line.To = Vector2.new(segment[3], segment[4])
                line.Visible = cornerStyle
            end
        end

        local parts = {}
        if isNPC then
            table.insert(parts, "[NPC]")
        end
        if S.ESP_ShowName then
            table.insert(parts, name)
        end
        if S.ESP_ShowDistance then
            table.insert(parts, string.format("[%dm]", math.floor(distance / ESP_CONFIG.DISTANCE_DIVISOR)))
        end
        local label = table.concat(parts, " ")
        if S.ESP_Health then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                label = label .. string.format(" %dHP", math.floor(humanoid.Health))
            end
        end
        if label == "" then
            label = name
        end

        text.Text = label
        text.Position = Vector2.new(rootScreen.X, top - 18)
        text.Color = color
        text.Outline = S.ESP_TextOutline
        text.Visible = true
    end

    if showTracer then
        local originY = camera.ViewportSize.Y
        if S.ESP_TracerFrom == "Center" then
            originY = camera.ViewportSize.Y / 2
        end
        tracer.From = Vector2.new(camera.ViewportSize.X / 2, originY)
        tracer.To = Vector2.new(rootScreen.X, bottomScreen.Y)
        tracer.Color = color
        tracer.Visible = true
    end
end

local function clearArrowEntry(id)
    local entry = ESP_ArrowCache[id]
    if not entry then
        return
    end
    for _, drawing in pairs(entry) do
        pcall(function()
            drawing:Remove()
        end)
    end
    ESP_ArrowCache[id] = nil
end

local function updateEntityArrow(id, position, color)
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local screen, onScreen = camera:WorldToViewportPoint(position)
    local viewport = camera.ViewportSize
    local centerX, centerY = viewport.X / 2, viewport.Y / 2
    local radius = math.max(60, S.ESP_ArrowRadius or 140)
    local dx, dy = screen.X - centerX, screen.Y - centerY
    local distance = math.sqrt(dx * dx + dy * dy)

    local entry = ESP_ArrowCache[id]
    if (onScreen and distance < radius) or distance == 0 then
        if entry then
            entry.A.Visible = false
            entry.B.Visible = false
            entry.C.Visible = false
        end
        return
    end

    if not entry then
        entry = {
            A = Drawing.new("Line"),
            B = Drawing.new("Line"),
            C = Drawing.new("Line"),
        }
        ESP_ArrowCache[id] = entry
    end

    local angle = math.atan2(dy, dx)
    local tipX = centerX + math.cos(angle) * radius
    local tipY = centerY + math.sin(angle) * radius
    local size = 16
    local spread = 0.55

    local leftX = tipX - math.cos(angle - spread) * size
    local leftY = tipY - math.sin(angle - spread) * size
    local rightX = tipX - math.cos(angle + spread) * size
    local rightY = tipY - math.sin(angle + spread) * size
    local stemX = tipX - math.cos(angle) * (size * 0.85)
    local stemY = tipY - math.sin(angle) * (size * 0.85)

    local thickness = math.max(1, S.ESP_Thickness or 1)

    for _, line in ipairs({ entry.A, entry.B, entry.C }) do
        line.Thickness = thickness
        line.Color = color
        line.Visible = true
    end

    entry.A.From = Vector2.new(tipX, tipY)
    entry.A.To = Vector2.new(leftX, leftY)
    entry.B.From = Vector2.new(tipX, tipY)
    entry.B.To = Vector2.new(rightX, rightY)
    entry.C.From = Vector2.new(tipX, tipY)
    entry.C.To = Vector2.new(stemX, stemY)
end

local function updateArrows()
    if not HasDrawing then
        return
    end

    if not S.ESP_Arrows then
        if arrowsActive then
            for id in pairs(ESP_ArrowCache) do
                clearArrowEntry(id)
            end
            arrowsActive = false
        end
        return
    end

    arrowsActive = true
    local seen = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if hrp and humanoid and humanoid.Health > 0 then
                local enemy = player.Team == nil or player.Team ~= LocalPlayer.Team
                if enemy then
                    local id = tostring(player.UserId)
                    seen[id] = true
                    updateEntityArrow(id, hrp.Position, S.ESP_EnemyColor)
                end
            end
        end
    end

    for id in pairs(ESP_ArrowCache) do
        if not seen[id] then
            clearArrowEntry(id)
        end
    end
end

local function scanNPC(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return
    end
    if not model:FindFirstChild("HumanoidRootPart") then
        return
    end
    if Players:GetPlayerFromCharacter(model) then
        return
    end
    Tracked_NPCs[model] = true
end

task.spawn(function()
    local count = 0
    for _, object in ipairs(workspace:GetDescendants()) do
        if not alive() then
            return
        end
        if object:IsA("Model") then
            scanNPC(object)
        end
        count += 1
        if count % 500 == 0 then
            task.wait()
        end
    end
end)

workspace.DescendantAdded:Connect(function(object)
    if not alive() then
        return
    end
    if object:IsA("Model") then
        task.delay(0.5, function()
            if alive() then
                scanNPC(object)
            end
        end)
    end
end)

workspace.DescendantRemoving:Connect(function(object)
    if Tracked_NPCs[object] then
        Tracked_NPCs[object] = nil
        clearEntityESP(object)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    clearEntityESP(tostring(player.UserId))
end)

-- ============================================================
-- TARGETING / AIMBOT
-- ============================================================

local function getAimPart(character, partMode)
    local mode = partMode or S.Aim_Part
    if mode == "Head" then
        return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    end

    if mode == "Torso" then
        return character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("HumanoidRootPart")
    end

    local camera = workspace.CurrentCamera
    if not camera then
        return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    end

    local mouse = UserInputService:GetMouseLocation()
    local bestPart = nil
    local bestDistance = nil

    for _, partName in ipairs({ "Head", "UpperTorso", "Torso", "HumanoidRootPart" }) do
        local part = character:FindFirstChild(partName)
        if part then
            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
                if not bestDistance or distance < bestDistance then
                    bestDistance = distance
                    bestPart = part
                end
            end
        end
    end

    return bestPart or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
end

local function findTarget()
    local camera = workspace.CurrentCamera
    if not camera then
        return nil
    end

    local bestPart = nil
    local bestPlayer = nil
    local shortest = S.Aim_FOV
    local mouse = UserInputService:GetMouseLocation()

    local function consider(entityId, character, player)
        if WHITELIST.IsPlayer(player) or not isAlive(character) then
            return
        end
        local part = getAimPart(character)
        if not part then
            return
        end

        local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
        if not onScreen then
            return
        end

        local distanceToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
        if distanceToMouse >= shortest then
            return
        end

        if S.Aimbot_WallCheck and not getVisibility(entityId, character) then
            return
        end

        bestPart = part
        bestPlayer = player
        shortest = distanceToMouse
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local team = player.Team
            if not (S.Aimbot_TeamCheck and team ~= nil and team == LocalPlayer.Team) then
                consider(tostring(player.UserId), player.Character, player)
            end
        end
    end

    if S.Aimbot_TargetNPCs then
        for npc in pairs(Tracked_NPCs) do
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hrp then
                consider(npc, npc, nil)
            end
        end
    end

    return bestPart, bestPlayer
end

local function findSilentTarget()
    local camera = workspace.CurrentCamera
    if not camera then
        return nil
    end

    local bestPart = nil
    local bestPlayer = nil
    local shortest = S.Silent_FOV
    local mouse = UserInputService:GetMouseLocation()
    local origin = camera.CFrame.Position

    local function consider(entityId, character, player)
        if WHITELIST.IsPlayer(player) or not isAlive(character) then
            return
        end

        local part = getAimPart(character, S.Silent_AimPart)
        if not part then
            return
        end

        if (part.Position - origin).Magnitude > S.Silent_Range then
            return
        end

        local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
        if not onScreen then
            return
        end

        local distanceToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
        if distanceToMouse >= shortest then
            return
        end

        if S.Silent_WallCheck and not getVisibility(entityId, character) then
            return
        end

        bestPart = part
        bestPlayer = player
        shortest = distanceToMouse
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local team = player.Team
            if not (S.Aimbot_TeamCheck and team ~= nil and team == LocalPlayer.Team) then
                consider(tostring(player.UserId), player.Character, player)
            end
        end
    end

    if S.Aimbot_TargetNPCs then
        for npc in pairs(Tracked_NPCs) do
            if npc:FindFirstChild("HumanoidRootPart") then
                consider(npc, npc, nil)
            end
        end
    end

    return bestPart, bestPlayer
end

local function entityTeam(entity, character)
    local value = character and character:GetAttribute("Team")
    if value == nil and entity and entity ~= character then
        value = entity:GetAttribute("Team")
    end
    if value ~= nil then
        return tostring(value)
    end
    local team = entity and entity.Team
    if team then
        return team.Name
    end
    return nil
end

local function characterFlag(character, name)
    if not character then return false end
    if character:GetAttribute(name) == true then return true end
    local effects = character:FindFirstChild("BodyEffects")
    local value = character:FindFirstChild(name) or (effects and effects:FindFirstChild(name))
    return value ~= nil and value:IsA("BoolValue") and value.Value == true
end

local function isDeadEntity(entity, character)
    if characterFlag(character, "Dead") then
        return true
    end
    if entity and entity ~= character and entity:GetAttribute("Dead") == true then
        return true
    end
    return false
end


local function isKnocked(character)
    if not character or isDeadEntity(character, character) then return false end
    local names = { "Knocked", "K.O", "KO" }
    for _, name in ipairs(names) do
        if characterFlag(character, name) then return true end
    end
    -- PlatformStand is a fallback only when no explicit KO state is available.
    local effects = character:FindFirstChild("BodyEffects")
    for _, name in ipairs(names) do
        if type(character:GetAttribute(name)) == "boolean" then return false end
        local value = character:FindFirstChild(name) or (effects and effects:FindFirstChild(name))
        if value and value:IsA("BoolValue") then return false end
    end
    local humanoid = getHumanoid(character)
    return humanoid ~= nil and humanoid.PlatformStand == true
end

local function sameTeamAsLocal(entity, character)
    local mine = entityTeam(LocalPlayer, LocalPlayer.Character)
    local theirs = entityTeam(entity, character)
    return mine ~= nil and theirs ~= nil and mine == theirs
end

-- Closest player to the cursor (or screen center) regardless of FOV.
local function findCursorTarget(mode, maxRange)
    local camera = workspace.CurrentCamera
    if not camera then
        return nil
    end

    local mouse = UserInputService:GetMouseLocation()
    local viewport = camera.ViewportSize
    local anchor = mode == "Center" and Vector2.new(viewport.X / 2, viewport.Y / 2) or mouse
    local localHRP = getHRP()
    local bestPart = nil
    local bestPlayer = nil
    local shortest = nil

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if player ~= LocalPlayer and character and isAlive(character)
            and not WHITELIST.IsPlayer(player)
            and not isDeadEntity(player, character)
            and not (S.Aimbot_TeamCheck and sameTeamAsLocal(player, character)) then
            local part = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
            if part then
                local inRange = true
                if maxRange and localHRP then
                    inRange = (part.Position - localHRP.Position).Magnitude <= maxRange
                end
                if inRange then
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - anchor).Magnitude
                        if not shortest or distance < shortest then
                            shortest = distance
                            bestPart = part
                            bestPlayer = player
                        end
                    end
                end
            end
        end
    end

    return bestPart, bestPlayer
end

local function updateAimbot(dt, mouse)
    -- Rage owns the shared target until it stops; other aim modes must not overwrite it.
    if S.Rage_Enabled or (INSTA and INSTA.Owns()) then return end
    if not (S.Aimbot_Enabled or S.AutoShot_Enabled or S.TP_Bullet_Enabled or S.Aimbot_Mode == "Silent" or S.Rage_Enabled) then
        CurrentTargetPart = nil
        CurrentTargetPlayer = nil
        currentTargetPos = nil
        return
    end

    local targetPart, targetPlayer
    if S.Aimbot_Mode == "Silent" then
        targetPart, targetPlayer = findSilentTarget()
    else
        targetPart, targetPlayer = findTarget()
    end
    CurrentTargetPart = targetPart
    CurrentTargetPlayer = targetPlayer
    currentTargetPos = targetPart and targetPart.Position or nil

    if not targetPart then
        return
    end

    if S.Aimbot_Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        if not mousemoverel then
            return
        end

        local aimPosition = targetPart.Position
        local camera = workspace.CurrentCamera

        if S.Aimbot_Prediction and targetPart.AssemblyLinearVelocity then
            local distance = (aimPosition - camera.CFrame.Position).Magnitude
            local speed = math.max(S.Aim_BulletSpeed, 1)
            aimPosition = aimPosition + targetPart.AssemblyLinearVelocity * (distance / speed)
        end

        local screenPos, onScreen = camera:WorldToViewportPoint(aimPosition)
        if onScreen then
            local moveX = (screenPos.X - mouse.X) * S.Aim_Smoothing
            local moveY = (screenPos.Y - mouse.Y) * S.Aim_Smoothing
            mousemoverel(moveX, moveY)
        end
    end
end

-- ============================================================
-- SPINBOT
-- ============================================================

local spinAngle = 0

local function updateSpinbot(dt)
    if not S.Spinbot_Enabled then
        return
    end

    local character = LocalPlayer.Character
    local hrp = getHRP(character)
    if not hrp or not isAlive(character) then
        return
    end

    spinAngle = (spinAngle + math.rad(S.Spinbot_Speed) * dt) % (math.pi * 2)
    local tilt = 0
    if S.Spinbot_Tilt then
        tilt = math.rad(22) * math.sin(tick() * 9)
    end

    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(tilt, spinAngle, 0)
end

-- ============================================================
-- ANTI-STOMP
-- ============================================================

local stompCooldown = 0

local ragdollStatesDisabled = false

local function setRagdollStates(enabled)
    local humanoid = getHumanoid()
    if not humanoid then
        return
    end
    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, enabled)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, enabled)
    end)
end

local function updateAntiRagdoll()
    if not (S.AntiStomp_NoRagdoll or S.AntiRagdoll_Enabled) then
        if ragdollStatesDisabled then
            setRagdollStates(true)
            ragdollStatesDisabled = false
        end
        return
    end
    if S.Fly_Enabled then
        return
    end

    local humanoid = getHumanoid()
    if not humanoid or humanoid.Health <= 0 then
        return
    end

    if not ragdollStatesDisabled then
        setRagdollStates(false)
        ragdollStatesDisabled = true
    end

    pcall(function()
        if humanoid.PlatformStand then
            humanoid.PlatformStand = false
        end

        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.PlatformStanding
        then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function updateAntiStomp(dt)
    stompCooldown -= dt

    local character = LocalPlayer.Character
    local hrp = getHRP(character)
    local humanoid = getHumanoid(character)
    if not hrp or not humanoid or humanoid.Health <= 0 then
        return
    end

    if stompCooldown > 0 then
        return
    end

    local radius = S.AntiStomp_Radius
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local otherHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if otherHRP then
                local delta = otherHRP.Position - hrp.Position
                local horizontal = Vector3.new(delta.X, 0, delta.Z)
                local above = delta.Y > 1.2 and delta.Y < 8

                if above and horizontal.Magnitude <= radius then
                    local velocity = otherHRP.AssemblyLinearVelocity
                    if velocity.Y < -5 then
                        local away = horizontal
                        if away.Magnitude < 0.5 then
                            away = Vector3.new(1, 0, 0)
                        else
                            away = away.Unit
                        end

                        local newPosition = hrp.Position + away * 4 + Vector3.new(0, 1, 0)
                        hrp.CFrame = CFrame.new(newPosition) * (hrp.CFrame - hrp.Position)
                        stompCooldown = 0.6
                        break
                    end
                end
            end
        end
    end
end

-- ============================================================
-- MOVEMENT: SPEED / JUMP / FLY / NOCLIP / ANTI-FLING
-- ============================================================

local movementSaved = setmetatable({}, { __mode = "k" })
local noclipSaved = setmetatable({}, { __mode = "k" })
local FLY = { active = false, humanoid = nil }
local setSpeedEnabled = function(value) S.Speed_Enabled = value end

local function stopFly()
    if not FLY.active then
        return
    end
    FLY.active = false
    local humanoid = FLY.humanoid or getHumanoid()
    FLY.humanoid = nil
    if humanoid then
        humanoid.PlatformStand = false
    end
end

local function updateSpeedAndJump()
    local humanoid = getHumanoid()
    if not humanoid or humanoid.Health <= 0 then
        return
    end

    local saved = movementSaved[humanoid]
    if not saved then
        saved = {
            WalkSpeed = humanoid.WalkSpeed,
            JumpPower = humanoid.JumpPower,
            JumpHeight = humanoid.JumpHeight,
            UseJumpPower = humanoid.UseJumpPower,
        }
        movementSaved[humanoid] = saved
    end

    if S.Speed_Enabled and not S.Fly_Enabled and not S.Rage_Enabled then
        local requested = tonumber(S.Speed_Value) or 60
        if requested ~= requested then requested = 60 end
        local target = math.clamp(requested, 16, 120)
        local now = os.clock()
        -- Apply on enable/value change only. Never fight a game reset each frame.
        if not saved.SpeedApplied or saved.SpeedTarget ~= target then
            if not saved.SpeedApplyAt or now - saved.SpeedApplyAt >= 0.5 then
                if not saved.SpeedApplied then saved.WalkSpeed = humanoid.WalkSpeed end
                saved.SpeedApplied = true
                saved.SpeedTarget = target
                saved.SpeedApplyAt = now
                if humanoid.WalkSpeed ~= target then humanoid.WalkSpeed = target end
            end
        elseif humanoid.WalkSpeed ~= target and now - saved.SpeedApplyAt >= 0.5 then
            saved.SpeedApplied = false
            saved.SpeedTarget = nil
            setSpeedEnabled(false)
            notify("Speed disabled: the game reset WalkSpeed")
        end
    elseif saved.SpeedApplied then
        -- Preserve a newer game value when it has already replaced our speed.
        if humanoid.WalkSpeed == saved.SpeedTarget then
            humanoid.WalkSpeed = saved.WalkSpeed
        end
        saved.SpeedApplied = false
        saved.SpeedTarget = nil
        saved.SpeedApplyAt = nil
    end

    if S.Jump_Enabled then
        if not saved.JumpApplied then
            saved.UseJumpPower = humanoid.UseJumpPower
            saved.JumpPower = humanoid.JumpPower
            saved.JumpHeight = humanoid.JumpHeight
            saved.JumpApplied = true
        end
        if not humanoid.UseJumpPower then humanoid.UseJumpPower = true end
        if humanoid.JumpPower ~= S.Jump_Value then humanoid.JumpPower = S.Jump_Value end
    elseif saved.JumpApplied then
        humanoid.UseJumpPower = saved.UseJumpPower
        humanoid.JumpPower = saved.JumpPower
        humanoid.JumpHeight = saved.JumpHeight
        saved.JumpApplied = false
    end
end

local function updateFly(dt)
    local character = LocalPlayer.Character
    local hrp = getHRP(character)
    local humanoid = getHumanoid(character)

    if not S.Fly_Enabled or not hrp or not humanoid or humanoid.Health <= 0 then
        stopFly()
        return
    end

    if not FLY.active or FLY.humanoid ~= humanoid then
        FLY.active = true
        FLY.humanoid = humanoid
        humanoid.PlatformStand = true
    end

    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local direction = Vector3.new(0, 0, 0)
    local look = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction += look
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction -= look
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction += right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction -= right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction += Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        direction -= Vector3.new(0, 1, 0)
    end

    if direction.Magnitude > 0 then
        direction = direction.Unit
    end

    local offset = hrp.CFrame - hrp.Position
    hrp.CFrame = CFrame.new(hrp.Position + direction * S.Fly_Speed * dt) * offset
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end

local function updateNoclip()
    if not S.Noclip_Enabled and next(noclipSaved) == nil then
        return
    end

    local character = LocalPlayer.Character
    if not character then
        return
    end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if S.Noclip_Enabled then
                if noclipSaved[part] == nil then
                    noclipSaved[part] = part.CanCollide
                end
                if part.CanCollide then
                    part.CanCollide = false
                end
            elseif noclipSaved[part] ~= nil then
                part.CanCollide = noclipSaved[part]
                noclipSaved[part] = nil
            end
        end
    end
end

local function updateAntiFling()
    if not S.AntiFling_Enabled then
        return
    end

    local character = LocalPlayer.Character
    local hrp = getHRP(character)
    if not hrp then
        return
    end

    local velocity = hrp.AssemblyLinearVelocity
    if velocity and velocity.Magnitude > 180 then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

pcall(function()
    UserInputService.JumpRequest:Connect(function()
        if not alive() or not S.InfiniteJump_Enabled then
            return
        end
        local humanoid = getHumanoid()
        local hrp = getHRP()
        if humanoid and humanoid.Health > 0 and hrp then
            local ok, state = pcall(function()
                return humanoid:GetState()
            end)
            if ok and state == Enum.HumanoidStateType.Jumping then
                return
            end

            local jumpPower = humanoid.JumpPower or 50
            if not humanoid.UseJumpPower then
                local gravity = workspace.Gravity or 196.2
                local height = humanoid.JumpHeight or 7.2
                jumpPower = math.sqrt(2 * gravity * math.max(height, 0))
            end
            if S.Jump_Enabled then
                jumpPower = S.Jump_Value
            end

            local velocity = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(velocity.X, math.max(jumpPower, velocity.Y), velocity.Z)
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

pcall(function()
    LocalPlayer.Idled:Connect(function()
        if not alive() or not S.AntiAFK_Enabled then
            return
        end
        local virtualUser = game:GetService("VirtualUser")
        virtualUser:CaptureController()
        virtualUser:ClickButton2(Vector2.new())
    end)
end)

local TP_STEP_DISTANCE = 120

-- Long instant jumps are what triggers the game's teleport checks, so move in
-- short increments instead and cap the total distance
local function safeTeleport(targetPosition)
    local hrp = getHRP()
    if not hrp or not targetPosition then
        return false
    end

    local startPosition = hrp.Position
    local delta = targetPosition - startPosition
    local distance = delta.Magnitude
    if distance < 0.5 then
        return true
    end

    if distance > TP_STEP_DISTANCE then
        delta = delta.Unit * TP_STEP_DISTANCE
        distance = TP_STEP_DISTANCE
    end

    local steps = math.clamp(math.ceil(distance / 8), 1, 20)
    for step = 1, steps do
        if not alive() then
            return false
        end
        local position = startPosition + delta * (step / steps)
        pcall(function()
            local rotation = hrp.CFrame - hrp.CFrame.Position
            hrp.CFrame = CFrame.new(position) * rotation
            if typeof(hrp.AssemblyLinearVelocity) == "Vector3" then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
        if step < steps then
            task.wait(0.03)
        end
    end
    return true
end

local function teleportToNearestPlayer()
    local hrp = getHRP()
    if not hrp then
        return false
    end

    local best = nil
    local shortest = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local otherHRP = getHRP(player.Character)
            if otherHRP then
                local distance = (otherHRP.Position - hrp.Position).Magnitude
                if distance < shortest then
                    shortest = distance
                    best = otherHRP
                end
            end
        end
    end

    if not best then
        return false
    end

    return safeTeleport(best.Position + Vector3.new(0, 2.5, 0))
end

local function getEquippedTool()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end
    local humanoid = getHumanoid(character)
    local tool = humanoid and humanoid:FindFirstChildOfClass("Tool")
    return tool or character:FindFirstChildOfClass("Tool")
end

-- ============================================================
-- SPECTATOR / TARGET PLAYER ACTIONS
-- ============================================================

local savedCameraSubject = nil

local function getPlayerByName(name)
    local targetName = string.lower(string.gsub(name or "", "%s+", ""))
    if targetName == "" then
        return nil
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local display = string.lower(player.DisplayName)
            local user = string.lower(player.Name)
            if display == targetName or user == targetName
                or string.find(display, targetName, 1, true)
                or string.find(user, targetName, 1, true) then
                return player
            end
        end
    end
    return nil
end

local function teleportToPlayerByName(name)
    local target = getPlayerByName(name)
    if not target or not target.Character then
        return false
    end
    local targetHRP = getHRP(target.Character)
    if not targetHRP then
        return false
    end
    local hrp = getHRP()
    if not hrp then
        return false
    end
    hrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0))
    return true
end

local function setSpectateTarget(player)
    local camera = workspace.CurrentCamera
    if not camera then
        return false
    end

    if not player or not player.Character then
        return false
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end

    if savedCameraSubject == nil then
        savedCameraSubject = camera.CameraSubject
    end

    camera.CameraSubject = humanoid
    S.Spectate_Target = player
    S.Spectate_Enabled = true
    return true
end

local function stopSpectating()
    local camera = workspace.CurrentCamera
    if camera and savedCameraSubject then
        camera.CameraSubject = savedCameraSubject
    end
    savedCameraSubject = nil
    S.Spectate_Target = nil
    S.Spectate_Enabled = false
end

local function startSpectateByName(name)
    local target = getPlayerByName(name)
    if not target then
        notify("Player not found")
        stopSpectating()
        return false
    end

    if setSpectateTarget(target) then
        notify("Spectating " .. target.Name)
        return true
    end

    notify("Cannot spectate target")
    stopSpectating()
    return false
end

pcall(function()
    Players.PlayerRemoving:Connect(function(player)
        if S.Spectate_Target == player then
            stopSpectating()
            notify("Spectate target left")
        end
    end)
end)

local ADMIN = (function()
    local ADMIN = {
        Enabled = true, ShowPanel = true, SoundEnabled = true, NotifyEnabled = true,
        SoundId = "6753645454", Volume = 1, UseSymbols = false,
        Groups = {
            {Id = 605595634, MinRank = 20, Label = "BH STAFF TEAM"},
            {Id = 925309458, MinRank = 50, Label = "MOD"},
        },
        KnownNames = {
            boomffa_mod = true, boomffaadmin = true, boomffa_admin = true,
            boomffa_staff = true, boom_moderator = true, boomgamemod = true,
        },
        Symbols = {"✅", "☑️", "👑", "⭐", "🛡️", "✨", "🌟", "⚡", "🔱", "💎", "🏆", "🎖️"},
        Entries = {}, Cache = {}, Pending = {}, Queue = {}, Unchecked = {},
        Notified = setmetatable({}, {__mode = "k"}), Joined = setmetatable({}, {__mode = "k"}), Connections = {},
        Workers = 0, MaxWorkers = 2, Epoch = 0, Started = false, Destroyed = false,
    }

    function ADMIN.Active()
        return not ADMIN.Destroyed and alive() and ADMIN.Enabled
    end
    function ADMIN.Connect(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(ADMIN.Connections, connection)
        return connection
    end
    function ADMIN.Render() end -- Replaced by the panel implementation below.
    function ADMIN.Current(job)
        return ADMIN.Active() and job.Epoch == ADMIN.Epoch and job.Player.Parent == Players
            and ADMIN.Pending[job.Player] == job
    end
    function ADMIN.Detect(player, job)
        if not player or player == LocalPlayer or player.Parent ~= Players then return nil end
        if ADMIN.KnownNames[string.lower(player.Name)] then
            return {Detected = true, Label = "Known username", Rank = 0, Confidence = "name", Incomplete = false}
        end
        local labels, highest, incomplete = {}, 0, false
        for _, group in ipairs(ADMIN.Groups) do
            if job and not ADMIN.Current(job) then return nil end
            local ok, rank = pcall(function()
                local method = player.GetRankInGroupAsync or player.GetRankInGroup
                return method(player, group.Id)
            end)
            if job and not ADMIN.Current(job) then return nil end
            if ok and type(rank) == "number" then
                if rank >= group.MinRank then
                    highest = math.max(highest, rank)
                    local label = group.Label .. " | rank " .. tostring(rank)
                    local roleOk, role = pcall(function()
                        local method = player.GetRoleInGroupAsync or player.GetRoleInGroup
                        return method(player, group.Id)
                    end)
                    if job and not ADMIN.Current(job) then return nil end
                    if roleOk and type(role) == "string" and role ~= "" then label = role .. " [" .. group.Label .. "]" end
                    table.insert(labels, label)
                end
            else
                incomplete = true
            end
        end
        if #labels > 0 then
            return {Detected = true, Label = table.concat(labels, " / "), Rank = highest, Confidence = "group", Incomplete = incomplete}
        end
        if ADMIN.UseSymbols then
            for _, symbol in ipairs(ADMIN.Symbols) do
                if string.find(player.Name, symbol, 1, true) or string.find(player.DisplayName or "", symbol, 1, true) then
                    return {Detected = true, Label = "Display-name symbol; unverified", Rank = 0, Confidence = "possible", Incomplete = incomplete}
                end
            end
        end
        return {Detected = false, Incomplete = incomplete}
    end

    function ADMIN.NormalizeSoundId(value)
        local text = tostring(value or ""):gsub("%s+", "")
        return text:match("^(%d+)$") or text:match("rbxassetid://(%d+)")
            or text:match("[?&]id=(%d+)") or text:match("/asset/(%d+)")
    end
    function ADMIN.StopSound()
        if ADMIN.ActiveSound then
            pcall(function() ADMIN.ActiveSound:Stop(); ADMIN.ActiveSound:Destroy() end)
            ADMIN.ActiveSound = nil
        end
    end
    function ADMIN.PlayAlert(force)
        if ADMIN.Destroyed or not alive() or (not force and (not ADMIN.Enabled or not ADMIN.SoundEnabled)) then return false end
        local id = ADMIN.NormalizeSoundId(ADMIN.SoundId)
        if not id then return false end
        ADMIN.StopSound()
        local ok = pcall(function()
            local sound = Instance.new("Sound")
            sound.Name = "SupremeAdminJoinAlert"
            sound.SoundId = "rbxassetid://" .. id
            sound.Volume = math.clamp(tonumber(ADMIN.Volume) or 1, 0, 3)
            sound.Looped = false
            sound.Parent = game:GetService("SoundService")
            ADMIN.ActiveSound = sound
            sound.Ended:Connect(function()
                if ADMIN.ActiveSound == sound then ADMIN.ActiveSound = nil end
                sound:Destroy()
            end)
            game:GetService("Debris"):AddItem(sound, 10)
            sound:Play()
        end)
        if not ok then ADMIN.StopSound() end
        return ok
    end
    function ADMIN.Commit(player, result, alertJoin)
        if not ADMIN.Active() or player.Parent ~= Players or not result then return end
        ADMIN.Unchecked[player] = result.Incomplete and true or nil
        if result.Detected then
            ADMIN.Entries[player.UserId] = {Player = player, Label = result.Label, Rank = result.Rank, Confidence = result.Confidence}
            if alertJoin and result.Confidence ~= "possible" and not ADMIN.Notified[player] then
                ADMIN.Notified[player] = true
                if ADMIN.NotifyEnabled then notify("Администратор онлайн: " .. player.Name .. " [" .. result.Label .. "]") end
                ADMIN.PlayAlert(false)
            end
        else
            ADMIN.Entries[player.UserId] = nil
        end
        ADMIN.Render()
    end
    function ADMIN.Pump()
        while ADMIN.Active() and ADMIN.Workers < ADMIN.MaxWorkers and #ADMIN.Queue > 0 do
            local job = table.remove(ADMIN.Queue, 1)
            if ADMIN.Current(job) then
                ADMIN.Workers += 1
                task.spawn(function()
                    local completed, failure = pcall(function()
                        local ok, result = pcall(ADMIN.Detect, job.Player, job)
                        if ADMIN.Current(job) then
                            if not ok then result = {Detected = false, Incomplete = true} end
                            if result then
                                ADMIN.Cache[job.Player.UserId] = {Result = result, Until = os.clock() + (result.Incomplete and 10 or 120)}
                                ADMIN.Commit(job.Player, result, job.AlertJoin)
                            end
                        end
                    end)
                    if ADMIN.Pending[job.Player] == job then ADMIN.Pending[job.Player] = nil end
                    ADMIN.Workers = math.max(0, ADMIN.Workers - 1)
                    if not ADMIN.Destroyed then task.defer(ADMIN.Pump) end
                    if not completed then warn("[SUPREME Admins] " .. tostring(failure)) end
                end)
            end
        end
    end
    function ADMIN.Request(player, alertJoin, force)
        if not ADMIN.Active() or not player or player == LocalPlayer or player.Parent ~= Players then return end
        alertJoin = alertJoin or (ADMIN.Joined[player] and not ADMIN.Notified[player])
        local existing = ADMIN.Pending[player]
        if existing then existing.AlertJoin = existing.AlertJoin or alertJoin; return end
        local cached = ADMIN.Cache[player.UserId]
        if not force and cached and cached.Until > os.clock() then ADMIN.Commit(player, cached.Result, alertJoin); return end
        local job = {Player = player, AlertJoin = alertJoin == true, Epoch = ADMIN.Epoch}
        ADMIN.Pending[player] = job
        ADMIN.Unchecked[player] = true
        if alertJoin then table.insert(ADMIN.Queue, 1, job) else table.insert(ADMIN.Queue, job) end
        ADMIN.Pump()
    end
    function ADMIN.Scan(force)
        if not ADMIN.Active() then return end
        for _, player in ipairs(Players:GetPlayers()) do ADMIN.Request(player, false, force) end
        ADMIN.Render()
    end
    function ADMIN.StatusText()
        local found, possible, unchecked = 0, 0, 0
        for _, entry in pairs(ADMIN.Entries) do
            if entry.Player.Parent == Players then
                if entry.Confidence == "possible" then possible += 1 else found += 1 end
            end
        end
        for player in pairs(ADMIN.Unchecked) do if player.Parent == Players then unchecked += 1 end end
        return string.format("Detected: %d | Possible: %d | Unchecked: %d", found, possible, unchecked)
    end
    function ADMIN.SetEnabled(value)
        value = value == true
        if ADMIN.Enabled == value then return end
        ADMIN.Enabled = value
        ADMIN.Epoch += 1
        ADMIN.Queue, ADMIN.Pending = {}, {}
        ADMIN.Joined = setmetatable({}, {__mode = "k"})
        if not value then
            ADMIN.Entries, ADMIN.Unchecked = {}, {}
            ADMIN.StopSound()
        elseif ADMIN.Started then ADMIN.Scan(false) end
        ADMIN.Render()
    end
    function ADMIN.Start()
        if ADMIN.Started or ADMIN.Destroyed then return end
        ADMIN.Started = true
        ADMIN.Connect(Players.PlayerAdded, function(player)
            local epoch = ADMIN.Epoch
            if ADMIN.Active() then ADMIN.Joined[player] = true end
            ADMIN.Cache[player.UserId] = nil
            task.delay(1.5, function()
                if epoch == ADMIN.Epoch and ADMIN.Active() and player.Parent == Players then ADMIN.Request(player, true, true) end
            end)
        end)
        ADMIN.Connect(Players.PlayerRemoving, function(player)
            local entry = ADMIN.Entries[player.UserId]
            if entry and entry.Player == player then ADMIN.Entries[player.UserId] = nil end
            ADMIN.Pending[player], ADMIN.Unchecked[player], ADMIN.Notified[player], ADMIN.Joined[player] = nil, nil, nil, nil
            for index = #ADMIN.Queue, 1, -1 do
                if ADMIN.Queue[index].Player == player then table.remove(ADMIN.Queue, index) end
            end
            ADMIN.Cache[player.UserId] = nil
            ADMIN.Render()
        end)
        local elapsed = 0
        ADMIN.Connect(RunService.Heartbeat, function(dt)
            if not ADMIN.Active() then return end
            elapsed += dt
            if elapsed >= 30 then elapsed = 0; ADMIN.Scan(false) end
        end)
        ADMIN.Scan(false)
    end
    function ADMIN.Destroy()
        if ADMIN.Destroyed then return end
        ADMIN.Destroyed, ADMIN.Enabled = true, false
        ADMIN.Epoch += 1
        ADMIN.Queue, ADMIN.Pending, ADMIN.Entries, ADMIN.Unchecked = {}, {}, {}, {}
        for _, connection in ipairs(ADMIN.Connections) do connection:Disconnect() end
        ADMIN.Connections = {}
        ADMIN.StopSound()
        ADMIN.DestroyPanel()
    end

-- Admin-list view. Detection, polling, sound and lifecycle belong to ADMIN's core.
-- Expected entries: ADMIN.Entries[userId] = {Player, Label, Confidence, Rank}.
function ADMIN.DestroyPanel()
    local panel = ADMIN.Panel
    ADMIN.Panel = nil
    if panel then
        panel.Drag = nil
        panel.Gui:Destroy()
    end
end

function ADMIN.BuildPanel()
    if not alive() then return nil end
    if ADMIN.Panel and ADMIN.Panel.Gui.Parent then return ADMIN.Panel end
    local parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not parent then return nil end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SupremeAdminsPanel"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 35
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Position = UDim2.new(1, -20, 0, 70)
    frame.Size = UDim2.fromOffset(320, 260)
    frame.BackgroundColor3 = Color3.fromRGB(16, 18, 25)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(195, 70, 80)
    border.Thickness = 1
    border.Parent = frame

    local header = Instance.new("TextLabel")
    header.Name = "DragHeader"
    header.Size = UDim2.new(1, -20, 0, 24)
    header.Position = UDim2.fromOffset(10, 7)
    header.BackgroundTransparency = 1
    header.Font = Enum.Font.GothamBold
    header.TextSize = 14
    header.TextColor3 = Color3.fromRGB(255, 115, 125)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Text = "ADMINS ONLINE"
    header.Active = true
    header.Parent = frame

    local stateLabel = Instance.new("TextLabel")
    stateLabel.Name = "AdminCount"
    stateLabel.Position = UDim2.fromOffset(10, 33)
    stateLabel.Size = UDim2.new(1, -20, 0, 18)
    stateLabel.BackgroundTransparency = 1
    stateLabel.Font = Enum.Font.Gotham
    stateLabel.TextSize = 11
    stateLabel.TextColor3 = Color3.fromRGB(190, 195, 210)
    stateLabel.TextXAlignment = Enum.TextXAlignment.Left
    stateLabel.Parent = frame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "AdminRows"
    scroll.Position = UDim2.fromOffset(8, 56)
    scroll.Size = UDim2.new(1, -16, 1, -100)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(195, 70, 80)
    scroll.Parent = frame
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll

    local empty = Instance.new("TextLabel")
    empty.Name = "EmptyAdmins"
    empty.Size = UDim2.new(1, -4, 0, 42)
    empty.BackgroundTransparency = 1
    empty.Font = Enum.Font.Gotham
    empty.TextSize = 12
    empty.TextColor3 = Color3.fromRGB(150, 155, 175)
    empty.Text = "No admins detected"
    empty.Parent = scroll

    local stop = Instance.new("TextButton")
    stop.Name = "StopAdminSpectate"
    stop.Position = UDim2.new(0, 10, 1, -36)
    stop.Size = UDim2.new(1, -20, 0, 26)
    stop.BackgroundColor3 = Color3.fromRGB(45, 48, 62)
    stop.BorderSizePixel = 0
    stop.Font = Enum.Font.Gotham
    stop.TextSize = 12
    stop.TextColor3 = Color3.fromRGB(230, 232, 240)
    stop.Text = "Stop spectating"
    stop.Parent = frame
    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 5)
    stopCorner.Parent = stop

    local panel = {
        Gui = gui, Frame = frame, Header = header, StateLabel = stateLabel,
        Scroll = scroll, Empty = empty, Stop = stop, Rows = {}, Signature = nil,
    }
    ADMIN.Panel = panel
    header.InputBegan:Connect(function(input)
        if not alive() or not ADMIN.Enabled or not gui.Enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            panel.Drag = { Input = input, Start = input.Position, Origin = frame.Position }
        end
    end)
    stop.MouseButton1Click:Connect(function()
        if not alive() or not ADMIN.Enabled or not ADMIN.ShowPanel then return end
        stopSpectating()
        ADMIN.Render()
    end)

    -- One pair of global input listeners for this detector's lifetime.
    if not ADMIN.PanelInputBound then
        ADMIN.PanelInputBound = true
        ADMIN.Connect(UserInputService.InputChanged, function(input)
            local current = ADMIN.Panel
            local drag = current and current.Drag
            if not drag or not alive() or not ADMIN.Enabled or not current.Gui.Enabled then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or (input.UserInputType == Enum.UserInputType.Touch and input == drag.Input) then
                local delta = input.Position - drag.Start
                current.Frame.Position = UDim2.new(
                    drag.Origin.X.Scale, drag.Origin.X.Offset + delta.X,
                    drag.Origin.Y.Scale, drag.Origin.Y.Offset + delta.Y
                )
            end
        end)
        ADMIN.Connect(UserInputService.InputEnded, function(input)
            local current = ADMIN.Panel
            if current and current.Drag and (input == current.Drag.Input
                or input.UserInputType == Enum.UserInputType.MouseButton1) then current.Drag = nil end
        end)
    end
    return panel
end

function ADMIN.Render()
    if not alive() then return end
    if not ADMIN.Enabled or not ADMIN.ShowPanel then
        if ADMIN.Panel then ADMIN.Panel.Gui.Enabled = false; ADMIN.Panel.Drag = nil end
        return
    end
    local panel = ADMIN.BuildPanel()
    if not panel then return end
    panel.Gui.Enabled = true
    local entries, signature = {}, {}
    local confirmed, possible = 0, 0
    for _, entry in pairs(ADMIN.Entries) do
        local player = entry.Player
        if player and player ~= LocalPlayer and player.Parent == Players then table.insert(entries, entry) end
    end
    table.sort(entries, function(a, b) return string.lower(a.Player.Name) < string.lower(b.Player.Name) end)
    for _, entry in ipairs(entries) do
        local player = entry.Player
        if entry.Confidence == "possible" then possible += 1 else confirmed += 1 end
        table.insert(signature, table.concat({tostring(player.UserId), player.Name, player.DisplayName or player.Name,
            tostring(entry.Label or "Staff"), tostring(entry.Confidence or "group"), tostring(entry.Rank or 0)}, "\0"))
    end
    local newSignature = table.concat(signature, "\1")
    local rosterChanged = #panel.Rows ~= #entries
    if not rosterChanged then
        for index, entry in ipairs(entries) do
            if panel.Rows[index].Player ~= entry.Player then rosterChanged = true; break end
        end
    end
    if panel.Signature ~= newSignature or rosterChanged then
        for _, row in ipairs(panel.Rows) do row.Button:Destroy() end
        panel.Rows, panel.Signature = {}, newSignature
        for index, entry in ipairs(entries) do
            local player = entry.Player
            local row = Instance.new("TextButton")
            row.Name = "Admin_" .. tostring(player.UserId)
            row.LayoutOrder = index
            row.Size = UDim2.new(1, -4, 0, 44)
            row.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
            row.BorderSizePixel = 0
            row.Text = ""
            row.AutoButtonColor = true
            row.Parent = panel.Scroll
            local round = Instance.new("UICorner")
            round.CornerRadius = UDim.new(0, 6)
            round.Parent = row
            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(1, -14, 0, 19)
            name.Position = UDim2.fromOffset(7, 3)
            name.BackgroundTransparency = 1
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.TextTruncate = Enum.TextTruncate.AtEnd
            name.Font = Enum.Font.GothamSemibold
            name.TextSize = 12
            name.TextColor3 = Color3.fromRGB(235, 237, 245)
            name.Text = (player.DisplayName or player.Name) .. " (@" .. player.Name .. ")"
            name.Parent = row
            local role = Instance.new("TextLabel")
            role.Size = UDim2.new(1, -14, 0, 17)
            role.Position = UDim2.fromOffset(7, 23)
            role.BackgroundTransparency = 1
            role.TextXAlignment = Enum.TextXAlignment.Left
            role.TextTruncate = Enum.TextTruncate.AtEnd
            role.Font = Enum.Font.Gotham
            role.TextSize = 10
            role.TextColor3 = entry.Confidence == "possible" and Color3.fromRGB(255, 195, 100) or Color3.fromRGB(255, 145, 155)
            role.Text = (entry.Confidence == "possible" and "Possible: " or "") .. tostring(entry.Label or "Staff")
            role.Parent = row
            row.MouseButton1Click:Connect(function()
                local current = ADMIN.Entries[player.UserId]
                if not alive() or not ADMIN.Enabled or not ADMIN.ShowPanel or player.Parent ~= Players
                    or not current or current.Player ~= player then return end
                if setSpectateTarget(player) then
                    S.Spectate_Name = player.Name
                    notify("Spectating admin: " .. player.Name)
                    ADMIN.Render()
                else
                    notify("Admin character is not ready for spectating")
                end
            end)
            table.insert(panel.Rows, {Button = row, Player = player})
        end
    end
    for _, row in ipairs(panel.Rows) do
        row.Button.BackgroundColor3 = S.Spectate_Enabled and S.Spectate_Target == row.Player
            and Color3.fromRGB(65, 38, 48) or Color3.fromRGB(28, 31, 42)
    end
    panel.Empty.Visible = #entries == 0
    panel.StateLabel.Text = ADMIN.StatusText and ADMIN.StatusText()
        or ("Admins online: " .. tostring(confirmed) .. (possible > 0 and (" | possible: " .. tostring(possible)) or ""))
    panel.Stop.Text = S.Spectate_Enabled and "Stop spectating" or "Click an admin to spectate"
end

    return ADMIN
end)() -- ADMIN_DETECTOR_END


-- ============================================================
-- AUTO SHOT
-- ============================================================

local shotClock = 0

local function updateAutoShot(dt)
    shotClock -= dt
    if S.Rage_Enabled or (INSTA and INSTA.Owns()) or not S.AutoShot_Enabled then
        return
    end

    if UserInputService:GetFocusedTextBox() then
        return
    end

    if WHITELIST.BlocksAutoShot(CurrentTargetPart, CurrentTargetPlayer) then return end
    if S.AutoShot_RequireTarget and not CurrentTargetPart then
        return
    end

    if shotClock > 0 then
        return
    end

    shotClock = 1 / math.max(1, S.AutoShot_Rate)

    if S.AutoShot_Mode == "Mouse" and type(getgenv().mouse1click) == "function" then
        pcall(getgenv().mouse1click)
        return
    end

    local tool = getEquippedTool()
    if tool then
        pcall(function()
            tool:Activate()
        end)
    elseif type(getgenv().mouse1click) == "function" then
        pcall(getgenv().mouse1click)
    end
end

-- ============================================================
-- INSTAKILL: MAG DUMP
-- ============================================================

-- Replaced by the scoped reference controller below.

-- ============================================================
-- RAGE
-- ============================================================

local rageClock = 0
local rageSpinAngle = 0
local rageOrbitAngle = 0
local lastRageTarget = nil
local rageStompAction = nil
local rageReloadAction = nil
local rageStompChar = nil
local rageStompStart = 0
local rageStompIgnore = setmetatable({}, { __mode = "k" })

local rageLockedPlayer = nil
local RAGE = {
    reloadAt = setmetatable({}, { __mode = "k" }), pendingKO = setmetatable({}, { __mode = "k" }),
    aimRemote = nil, scanAt = 0,
}
local STOMP = { Target = nil, Owner = nil, ReadyAt = 0, ShotsLeft = 0, StartedAt = 0, Remote = nil, Kind = nil, ScanAt = 0 }
function STOMP.Reset()
    STOMP.Target, STOMP.Owner = nil, nil
    STOMP.ReadyAt, STOMP.ShotsLeft, STOMP.StartedAt = 0, 0, 0
end

local function ragePlayerEligible(player, allowFinish)
    if player == LocalPlayer or player.Parent ~= Players or WHITELIST.IsPlayer(player) then
        return false
    end
    if S.Rage_Mode == "Selected" and player.Name ~= S.Rage_TargetName then
        return false
    end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 or humanoid.Health ~= humanoid.Health
        or isDeadEntity(player, character) or not getHRP(character) then
        return false
    end
    local knocked = isKnocked(character)
    if knocked and (rageStompIgnore[character] or 0) > os.clock() then return false end
    if humanoid.Health < 1 then
        if not allowFinish or not S.Rage_AutoStomp then return false end
        if not knocked then
            -- Health and KO may replicate on separate frames. Retain only the current victim briefly.
            local deadline = RAGE.pendingKO[character]
            if not deadline then deadline = os.clock() + 0.25; RAGE.pendingKO[character] = deadline end
            if os.clock() >= deadline then return false end
        end
    else
        RAGE.pendingKO[character] = nil
    end
    if knocked and not S.Rage_AutoStomp then return false end
    return not (S.Rage_TeamCheck and sameTeamAsLocal(player, character))
end

local function findRagePlayerTarget()
    if rageLockedPlayer and ragePlayerEligible(rageLockedPlayer, true) then
        local part = getAimPart(rageLockedPlayer.Character)
        if part then
            return part
        end
    end
    rageLockedPlayer = nil
    local root = getHRP()
    local bestPart, distance = nil, math.huge
    if not root then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if ragePlayerEligible(player, false) then
            local part = getAimPart(player.Character)
            if part then
                local d = (getHRP(player.Character).Position - root.Position).Magnitude
                if d < distance then
                    bestPart, distance = part, d
                    rageLockedPlayer = player
                end
            end
        end
    end
    return bestPart
end

local function findRageTarget()
    local hrp = getHRP()
    if not hrp then
        return nil
    end

    local bestPart = nil
    local shortest = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and ragePlayerEligible(player, false)
            and not isKnocked(character)
            then
            local part = getAimPart(character)
            if part then
                local distance = (getHRP(character).Position - hrp.Position).Magnitude
                if distance < shortest then
                    shortest = distance
                    bestPart = part
                end
            end
        end
    end

    if S.Aimbot_TargetNPCs then
        for npc in pairs(Tracked_NPCs) do
            local root = getHRP(npc)
            if root and isAlive(npc) and getHumanoid(npc).Health >= 1 and not isDeadEntity(npc, npc) and not isKnocked(npc) then
                local part = getAimPart(npc)
                if part then
                    local distance = (root.Position - hrp.Position).Magnitude
                    if distance < shortest then
                        shortest = distance
                        bestPart = part
                    end
                end
            end
        end
    end

    return bestPart
end

-- Downed enemies that are still stompable; makes Rage finish a kill and
-- then move straight to the next player
local function findRageStompTarget()
    if not S.Rage_AutoStomp then return nil end
    local hrp = getHRP()
    if not hrp then
        return nil
    end

    local bestPart = nil
    local bestCharacter = nil
    local shortest = math.huge
    local now = os.clock()

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and ragePlayerEligible(player, false)
            and isKnocked(character)
            and (rageStompIgnore[character] == nil or rageStompIgnore[character] < now)
            then
            local part = getAimPart(character)
            if part then
                local distance = (getHRP(character).Position - hrp.Position).Magnitude
                if distance < shortest then
                    shortest = distance
                    bestPart = part
                    bestCharacter = character
                end
            end
        end
    end

    return bestPart, bestCharacter
end


-- Orbit always runs; only the camera/mouse/firing are paused while the menu
-- is open or a textbox is focused, otherwise its controls cannot be clicked
local function rageInputBlocked()
    local menuOpen = MenuOpen
    if MenuFrame then
        local ok, visible = pcall(function()
            return MenuFrame.Visible
        end)
        if ok then
            menuOpen = visible == true
        end
    end
    if menuOpen then
        return true
    end
    local focused = false
    pcall(function()
        focused = UserInputService:GetFocusedTextBox() ~= nil
    end)
    return focused
end


local function clearRageTarget(force)
    if STOMP.Owner == "Rage" then STOMP.Reset() end
    if force or (lastRageTarget and CurrentTargetPart == lastRageTarget) then
        CurrentTargetPart, CurrentTargetPlayer, currentTargetPos = nil, nil, nil
    end
    lastRageTarget, rageLockedPlayer, rageStompChar = nil, nil, nil
end

local function updateRage(dt)
    rageClock = math.max(0, rageClock - dt)
    if not S.Rage_Enabled then
        clearRageTarget()
        rageClock = 0
        return
    end

    local hrp, localHumanoid = getHRP(), getHumanoid()
    if not hrp or not localHumanoid or localHumanoid.Health <= 0 then clearRageTarget(true); return end
    local stompPart, stompCharacter, targetPart
    if S.Rage_Mode == "Selected" or S.Rage_Mode == "All" then
        targetPart = findRagePlayerTarget()
        local character = targetPart and rageLockedPlayer and rageLockedPlayer.Character
        if S.Rage_AutoStomp and character and isKnocked(character) then
            stompPart, stompCharacter = targetPart, character
        end
    else
        -- Finish the current downed victim before searching again.
        if rageLockedPlayer and ragePlayerEligible(rageLockedPlayer, true)
            and (isKnocked(rageLockedPlayer.Character) or getHumanoid(rageLockedPlayer.Character).Health < 1) then
            local lockedCharacter = rageLockedPlayer.Character
            targetPart = getAimPart(lockedCharacter)
            if isKnocked(lockedCharacter) then stompCharacter, stompPart = lockedCharacter, targetPart end
        else
            rageLockedPlayer = nil
            stompPart, stompCharacter = findRageStompTarget()
        end
        targetPart = targetPart or stompPart or findRageTarget()
        if targetPart then rageLockedPlayer = Players:GetPlayerFromCharacter(targetPart.Parent) end
    end
    if not targetPart then clearRageTarget(true); return end

    local stomping = stompPart ~= nil and stompCharacter ~= nil
    local targetCharacter = targetPart.Parent
    local targetRoot = targetCharacter and getHRP(targetCharacter)
    if not targetRoot then clearRageTarget(true); return end
    CurrentTargetPart = targetPart
    CurrentTargetPlayer = Players:GetPlayerFromCharacter(targetPart.Parent)
    currentTargetPos = targetPart.Position
    lastRageTarget = targetPart
    local targetHumanoid = getHumanoid(targetPart.Parent)
    if S.Rage_AutoStomp and not stomping and targetHumanoid and targetHumanoid.Health < 1 then
        -- Waiting for KO confirmation: do not continue shooting or switch victims in this grace period.
        return
    end
    if not stomping then
        rageStompChar = nil
        if STOMP.Owner == "Rage" then STOMP.Reset() end
    end

    local center = targetPart.Position
    if not stomping then
        local radius = math.max(2, S.Rage_OrbitRadius or 8)
        local height = S.Rage_OrbitHeight or 5
        local speed = math.clamp(S.Rage_OrbitSpeed or 12, 0, 60) * 4
        rageOrbitAngle = (rageOrbitAngle + speed * dt) % (math.pi * 2)
        local desired = targetRoot.Position + Vector3.new(math.cos(rageOrbitAngle) * radius, height, math.sin(rageOrbitAngle) * radius)
        hrp.CFrame = CFrame.new(desired, center)
    end
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    local inputBlocked = rageInputBlocked()
    local camera = workspace.CurrentCamera
    if camera and not inputBlocked and not S.Spectate_Enabled then
        camera.CFrame = CFrame.new(camera.CFrame.Position, center)
        local screenPos, onScreen = camera:WorldToViewportPoint(center)
        local moveMouse = getgenv().mousemoverel
        if onScreen and type(moveMouse) == "function" then
            local mouse = UserInputService:GetMouseLocation()
            pcall(moveMouse, screenPos.X - mouse.X, screenPos.Y - mouse.Y)
        end
    end
    if S.Rage_Spin and not stomping then
        rageSpinAngle = (rageSpinAngle + dt * 20) % (math.pi * 2)
        hrp.CFrame = CFrame.new(hrp.Position, center) * CFrame.Angles(0, rageSpinAngle, 0)
    end
    if inputBlocked then
        if stomping then rageStompStart = os.clock() end
        if STOMP.Owner == "Rage" then STOMP.Reset() end
        return
    end

    local now = os.clock()
    if stomping then
        if rageStompChar ~= stompCharacter then
            rageStompChar, rageStompStart = stompCharacter, now
        elseif now - rageStompStart >= 3 then
            rageStompIgnore[stompCharacter] = now + 4
            clearRageTarget(true)
            return
        end
        if rageStompAction then pcall(rageStompAction, stompCharacter, S.Rage_StompKey) end
        return
    end

    local tool = getEquippedTool()
    if not tool then return end
    local ammo = tool:FindFirstChild("Ammo")
    if ammo and (ammo:IsA("IntValue") or ammo:IsA("NumberValue")) and ammo.Value <= 0 then
        if S.Rage_AutoReload and now >= (RAGE.reloadAt[tool] or 0) then
            RAGE.reloadAt[tool] = now + 1.25
            if rageReloadAction then pcall(rageReloadAction) end
        end
        return
    end
    if rageClock > 0 then return end
    rageClock = 1 / math.max(1, S.Rage_Rate)
    local cooldown = tool:FindFirstChild("ShootingCooldown")
    if cooldown and (cooldown:IsA("NumberValue") or cooldown:IsA("IntValue")) then
        local value = cooldown.Value
        if value == value and value > 0 and value < math.huge then rageClock = math.max(rageClock, value) end
    end

    -- Use only the observed one-Vector3 aiming message, never guessed damage/admin remotes.
    if RAGE.aimRemote and not RAGE.aimRemote.Parent then RAGE.aimRemote = nil end
    if not RAGE.aimRemote then
        if now >= RAGE.scanAt then
            RAGE.scanAt = now + 3
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("MouseZovEvent")
            if remote and (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) then RAGE.aimRemote = remote end
        end
    end
    if RAGE.aimRemote then pcall(function() RAGE.aimRemote:FireServer(center) end) end
    pcall(function() tool:Activate() end)
end

-- ============================================================
-- AUTO STOMP / HITBOX EXPANDER
-- ============================================================

local hitboxSaved = setmetatable({}, { __mode = "k" })


local stompButtonCache = { Button = nil, ScanAt = 0 }

local function findStompButton()
    local cached = stompButtonCache.Button
    if cached and cached.Parent and cached.Visible then return cached end
    local now = os.clock()
    if now < stompButtonCache.ScanAt then return nil end
    stompButtonCache.Button, stompButtonCache.ScanAt = nil, now + 1
    local root = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    if not root then return nil end
    local ok, descendants = pcall(function() return root:GetDescendants() end)
    if not ok then return nil end
    for _, object in ipairs(descendants) do
        local typeOk, isButton = pcall(function() return object:IsA("TextButton") or object:IsA("ImageButton") end)
        if typeOk and isButton then
            local visibleOk, visible = pcall(function() return object.Visible end)
            if visibleOk and visible then
                local name = string.lower(object.Name or "")
                local text = ""
                pcall(function() text = string.lower(object.Text or "") end)
                if name:find("stomp", 1, true) or text:find("stomp", 1, true)
                    or name:find("shoe", 1, true) or text:find("shoe", 1, true) then
                    stompButtonCache.Button = object
                    return object
                end
            end
        end
    end
    return nil
end

local ActionKeys = { Resolved = {} }
function ActionKeys.Resolve(value)
    local key = string.upper(tostring(value or "")):gsub("%s+", "")
    if key == "" then return nil end
    local code = ActionKeys.Resolved[key]
    if not code then
        for _, candidate in ipairs(Enum.KeyCode:GetEnumItems()) do
            if string.upper(candidate.Name) == key then code = candidate; ActionKeys.Resolved[key] = code; break end
        end
    end
    if code then return code.Name, code end
    return nil
end
function ActionKeys.Press(code)
    if not code then return false end
    local press, release = getgenv().keypress, getgenv().keyrelease
    if #code.Name == 1 and type(press) == "function" and type(release) == "function" then
        local byte = string.byte(code.Name)
        local ok = pcall(press, byte)
        if ok then
            task.delay(0.08, function() pcall(release, byte) end)
            return true
        end
    end
    local ok, manager = pcall(function() return game:GetService("VirtualInputManager") end)
    if not ok or not manager then return false end
    local pressed = pcall(function() manager:SendKeyEvent(true, code, false, game) end)
    if pressed then task.delay(0.08, function() pcall(function() manager:SendKeyEvent(false, code, false, game) end) end) end
    return pressed
end

local function stompKeyCode(fallback)
    local name, code = ActionKeys.Resolve(S.AutoStomp_Key)
    if code then return name, code end
    local ok, service = pcall(function() return game:GetService("ContextActionService") end)
    if ok and service then
        local boundOk, bound = pcall(function() return service:GetAllBoundActionInfo() end)
        if boundOk and type(bound) == "table" then
            for actionName, info in pairs(bound) do
                if string.find(string.lower(tostring(actionName)), "stomp", 1, true) and type(info) == "table" then
                    for _, input in pairs(info.inputTypes or info.InputTypes or {}) do
                        if typeof(input) == "EnumItem" and input.EnumType == Enum.KeyCode then return input.Name, input end
                    end
                end
            end
        end
    end
    return ActionKeys.Resolve(fallback or "E")
end

local function sendStompKey(fallback)
    local _, code = stompKeyCode(fallback)
    return ActionKeys.Press(code)
end

-- Core from the supplied stomp script; no separate menu, workers or return teleport.
function STOMP.ResolveRemote()
    if STOMP.Remote and STOMP.Remote.Parent then return STOMP.Remote, STOMP.Kind end
    if STOMP.Remote then STOMP.ScanAt = 0 end
    STOMP.Remote, STOMP.Kind = nil, nil
    local now = os.clock()
    if now < STOMP.ScanAt then return nil end
    STOMP.ScanAt = now + 1
    local storage = game:GetService("ReplicatedStorage")
    local main = storage:FindFirstChild("MainEvent", true)
    if main and main:IsA("RemoteEvent") then
        STOMP.Remote, STOMP.Kind = main, "MainEvent"
    else
        local stomp = storage:FindFirstChild("Stomp", true)
        if stomp and stomp:IsA("RemoteEvent") then STOMP.Remote, STOMP.Kind = stomp, "Stomp" end
    end
    return STOMP.Remote, STOMP.Kind
end
function STOMP.Fire()
    if WHITELIST.IsCharacter(STOMP.Target) then return false end
    local remote, kind = STOMP.ResolveRemote()
    if not remote then return false end
    return pcall(function()
        if kind == "MainEvent" then remote:FireServer("Stomp") else remote:FireServer() end
    end)
end

local function tryStompAction(fallback)
    if WHITELIST.IsCharacter(STOMP.Target) then return false end
    if STOMP.Fire() then return true end
    local button = findStompButton()
    local fire = getgenv().firesignal
    if button and type(fire) == "function" then
        local ok = pcall(fire, button.MouseButton1Click)
        if ok then return true end
    end
    return sendStompKey(fallback)
end

function STOMP.Valid(character)
    local humanoid = getHumanoid(character)
    return character ~= nil and humanoid ~= nil and humanoid.Health > 0
        and not WHITELIST.IsCharacter(character)
        and not isDeadEntity(character, character) and isKnocked(character) and getHRP(character) ~= nil
end
function STOMP.Step(character, owner, fallback)
    if not STOMP.Valid(character) then
        if STOMP.Target == character then STOMP.Reset() end
        return false
    end
    local root, localHumanoid = getHRP(), getHumanoid()
    if not root or not localHumanoid or localHumanoid.Health <= 0 then return false end
    local now = os.clock()
    local targetRoot = getHRP(character)
    if not targetRoot then return false end
    -- Use the player's root center, never an aim part or the enlarged hitbox surface.
    local originalSize = hitboxSaved[targetRoot]
    if originalSize and targetRoot.Size ~= originalSize then targetRoot.Size = originalSize end
    root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 2.5, 0))
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    if STOMP.Target ~= character or STOMP.Owner ~= owner then
        STOMP.Target, STOMP.Owner, STOMP.StartedAt = character, owner, now
        STOMP.ReadyAt, STOMP.ShotsLeft = now + 0.04, 2
        return false
    end
    if now < STOMP.ReadyAt then return false end
    if STOMP.ShotsLeft == 0 then STOMP.ShotsLeft = 2 end
    local sent = tryStompAction(fallback)
    STOMP.ShotsLeft -= 1
    STOMP.ReadyAt = now + (STOMP.ShotsLeft > 0 and 0.04 or 0.9)
    return sent
end

rageStompAction = function(character, fallback)
    return STOMP.Step(character, "Rage", fallback)
end
rageReloadAction = function()
    local _, code = ActionKeys.Resolve(S.Rage_ReloadKey or "R")
    return ActionKeys.Press(code)
end


local function updateAutoStomp(dt)
    if S.Rage_Enabled or not S.AutoStomp_Enabled then
        if STOMP.Owner == "Auto" then STOMP.Reset() end
        return
    end
    local root, humanoid = getHRP(), getHumanoid()
    if not root or not humanoid or humanoid.Health <= 0 or rageInputBlocked() then
        if STOMP.Owner == "Auto" then STOMP.Reset() end
        return
    end
    local now = os.clock()
    local victim = STOMP.Owner == "Auto" and STOMP.Target or nil
    local victimPlayer = victim and Players:GetPlayerFromCharacter(victim)
    if not victimPlayer or victimPlayer == LocalPlayer or not STOMP.Valid(victim) or isDeadEntity(victimPlayer, victim)
        or (rageStompIgnore[victim] or 0) > now then victim = nil end
    if victim and now - STOMP.StartedAt >= 3 then
        rageStompIgnore[victim] = now + 4
        STOMP.Reset()
        victim = nil
    end
    if not victim then
        if STOMP.Owner == "Auto" then STOMP.Reset() end
        local shortest = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            local character = player.Character
            if player ~= LocalPlayer and character and STOMP.Valid(character)
                and not isDeadEntity(player, character) and (rageStompIgnore[character] or 0) <= now then
                local distance = (getHRP(character).Position - root.Position).Magnitude
                if distance < shortest then shortest, victim = distance, character end
            end
        end
    end
    if not victim then return end
    CurrentTargetPart = victim:FindFirstChild("Head") or getHRP(victim)
    CurrentTargetPlayer = Players:GetPlayerFromCharacter(victim)
    currentTargetPos = CurrentTargetPart.Position
    STOMP.Step(victim, "Auto", S.AutoStomp_Key)
end

local function updateHitbox()
    if not S.Hitbox_Enabled then
        if next(hitboxSaved) ~= nil then
            for part, size in pairs(hitboxSaved) do
                pcall(function()
                    part.Size = size
                end)
            end
            hitboxSaved = setmetatable({}, { __mode = "k" })
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if WHITELIST.IsPlayer(player) then
                    if hitboxSaved[hrp] then hrp.Size = hitboxSaved[hrp]; hitboxSaved[hrp] = nil end
                else
                    if hitboxSaved[hrp] == nil then hitboxSaved[hrp] = hrp.Size end
                    local finishing = STOMP.Target == player.Character
                        or (S.Rage_Enabled and S.Rage_AutoStomp and rageLockedPlayer == player and isKnocked(player.Character))
                    local size = S.Hitbox_Size
                    local desired = finishing and hitboxSaved[hrp] or Vector3.new(size, size, size)
                    if hrp.Size ~= desired then hrp.Size = desired end
                end
            end
        end
    end
end

-- ============================================================
-- INFINITE AMMO / NO RELOAD
-- ============================================================

local HINTS = {
    Ammo = { "ammo", "clip", "magazine", "mag", "bullet", "reserve", "patron", "патрон", "запас" },
    Reload = { "reload", "перезаряд" },
    Caps = { "Max", "MaxAmmo", "AmmoMax", "MaxClip", "ClipSize", "MagSize", "Capacity" },
}

local reloadBypass = false

local ammoPeaks = setmetatable({}, { __mode = "k" })
local attributePeaks = setmetatable({}, { __mode = "k" })

local function matchesHint(name, hints)
    local lower = string.lower(name)
    for _, hint in ipairs(hints) do
        if string.find(lower, hint, 1, true) then
            return true
        end
    end
    return false
end

local function findAmmoCap(object)
    for _, attribute in ipairs(HINTS.Caps) do
        local value = object:GetAttribute(attribute)
        if type(value) == "number" and value > 0 then
            return value
        end
    end

    local parent = object.Parent
    if parent then
        for _, attribute in ipairs(HINTS.Caps) do
            local value = parent:GetAttribute(attribute)
            if type(value) == "number" and value > 0 then
                return value
            end
        end

        for _, name in ipairs({ "MaxAmmo", "Max", "AmmoMax", "ClipSize", "MagSize" }) do
            local sibling = parent:FindFirstChild(name)
            if sibling and (sibling:IsA("IntValue") or sibling:IsA("NumberValue")) and sibling.Value > 0 then
                return sibling.Value
            end
        end
    end

    return nil
end

local function scanContainers()
    local containers = {}
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if character then
        table.insert(containers, character)
    end
    if backpack then
        table.insert(containers, backpack)
    end
    return containers
end

local function refillAmmo()
    for _, root in ipairs(scanContainers()) do
        local objects = root:GetDescendants()
        table.insert(objects, root)

        for _, object in ipairs(objects) do
            if (object:IsA("IntValue") or object:IsA("NumberValue")) and matchesHint(object.Name, HINTS.Ammo) then
                local peak = ammoPeaks[object] or object.Value
                local cap = findAmmoCap(object)
                if cap then
                    peak = math.max(peak, cap)
                end
                peak = math.max(peak, object.Value)
                ammoPeaks[object] = peak

                if object.Value < peak then
                    object.Value = peak
                end
            elseif S.NoReload_Enabled and object:IsA("BoolValue") and matchesHint(object.Name, HINTS.Reload) then
                if object.Value then
                    object.Value = false
                end
            end

            local attributes = object:GetAttributes()
            for name, value in pairs(attributes) do
                if type(value) == "number" and matchesHint(name, HINTS.Ammo) then
                    local peaks = attributePeaks[object]
                    if not peaks then
                        peaks = {}
                        attributePeaks[object] = peaks
                    end

                    local peak = math.max(peaks[name] or value, value)
                    peaks[name] = peak

                    if value < peak then
                        pcall(function()
                            object:SetAttribute(name, peak)
                        end)
                    end
                elseif S.NoReload_Enabled and type(value) == "boolean" and value and matchesHint(name, HINTS.Reload) then
                    pcall(function()
                        object:SetAttribute(name, false)
                    end)
                end
            end
        end
    end
end

local ammoClock = 0

local function updateAmmo(dt)
    if AMMO_LOCKED then
        return
    end
    if not (S.Ammo_Enabled or S.NoReload_Enabled) then
        return
    end

    ammoClock -= dt
    if ammoClock > 0 then
        return
    end

    ammoClock = 0.05
    pcall(refillAmmo)
end

-- Boom Hood: spamming the ReloadWeapon remote keeps the magazine topped up.
local reloadSpamClock = 0
local reloadRemoteCache = {}
local reloadRemoteScanTime = 0

local function getReloadRemotes()
    local now = tick()
    if now - reloadRemoteScanTime >= 5 then
        reloadRemoteScanTime = now
        local found = {}
        local storage = game:GetService("ReplicatedStorage")

        local function scan(parent, depth)
            if depth > 3 or #found >= 8 then
                return
            end
            for _, child in ipairs(parent:GetChildren()) do
                local isRemote = child:IsA("RemoteEvent")
                    or child:IsA("UnreliableRemoteEvent")
                    or child:IsA("RemoteFunction")
                if isRemote and matchesHint(child.Name, HINTS.Reload) then
                    table.insert(found, child)
                elseif child:IsA("Folder") or child:IsA("Model") then
                    scan(child, depth + 1)
                end
                if #found >= 8 then
                    return
                end
            end
        end

        pcall(scan, storage, 0)
        reloadRemoteCache = found
    end
    return reloadRemoteCache
end

local function triggerReloadSpam()
    for _, remote in ipairs(getReloadRemotes()) do
        reloadBypass = true
        pcall(function()
            if remote:IsA("RemoteFunction") then
                remote:InvokeServer()
            else
                remote:FireServer()
            end
        end)
        reloadBypass = false
    end
end

local function updateReloadSpam(dt)
    if AMMO_LOCKED then
        reloadSpamClock = 0
        return
    end
    if not (S.Ammo_Enabled and S.Ammo_ReloadSpam) then
        reloadSpamClock = 0
        return
    end

    reloadSpamClock -= dt
    if reloadSpamClock > 0 then
        return
    end

    reloadSpamClock = math.max(0.1, S.Reload_SpamInterval)
    pcall(triggerReloadSpam)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not alive() then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and S.Ammo_Enabled and not AMMO_LOCKED then
        pcall(refillAmmo)
    end
end)

-- ============================================================
-- NAME CALL HOOK: INSTAKILL + TP BULLET
-- ============================================================

HINTS.Damage = {
    "damage", "dmg", "hit", "attack", "shoot", "fire", "bullet",
    "slash", "punch", "melee", "swing", "stab", "weapon", "удар",
}
HINTS.Bullet = {
    "bullet", "shoot", "shot", "fire", "projectile", "beam", "ray",
    "tracer", "gun", "weapon", "пуля",
}

local HookAvailable = false
local restoreHook = function() end
local hookOriginal = nil

-- Silent aim fallback: steer hitscan shots made through Workspace:Raycast /
-- FindPartOnRay so they land on the silent target regardless of camera
local SILENT_RAY_REACH = 22

local function silentRayDirection(origin, direction, headPosition, targetPosition)
    if typeof(origin) ~= "Vector3" or typeof(direction) ~= "Vector3" then
        return nil
    end
    if direction.Magnitude < 25 then
        return nil
    end
    if (origin - headPosition).Magnitude > SILENT_RAY_REACH then
        return nil
    end

    local toTarget = targetPosition - origin
    local distance = toTarget.Magnitude
    if distance < 1 then
        return nil
    end

    return toTarget.Unit * math.max(direction.Magnitude, distance + 2)
end

local function rewriteSilentRay(method, args)
    if INSTA and INSTA.Owns() then return false end
    local targetPart = CurrentTargetPart
    if not targetPart or not targetPart.Parent then
        return false
    end
    if WHITELIST.IsTarget(targetPart, CurrentTargetPlayer) then return false end
    local humanoid = targetPart.Parent:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false
    end

    local character = LocalPlayer.Character
    local head = character and (character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart"))
    if not head then
        return false
    end
    local headPosition = head.Position
    local targetPosition = targetPart.Position

    if method == "Raycast" then
        local direction = silentRayDirection(args[1], args[2], headPosition, targetPosition)
        if direction then
            args[2] = direction
            return true
        end
        return false
    end

    local ray = args[1]
    if typeof(ray) == "Ray" then
        local direction = silentRayDirection(ray.Origin, ray.Direction, headPosition, targetPosition)
        if direction then
            args[1] = Ray.new(ray.Origin, direction)
            return true
        end
    end
    return false
end

local function nameMatches(instance, hints)
    local name = instance.Name
    if type(name) ~= "string" then
        return false
    end
    return matchesHint(name, hints)
end

local function installHook()
    if HookAvailable then
        return
    end
    if EXPLOITS_LOCKED and AMMO_LOCKED then
        return
    end
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then
        return
    end

    local success, original = pcall(function()
        return hookmetamethod(game, "__namecall", function(self, ...)
            if EXPLOITS_LOCKED and AMMO_LOCKED then
                return hookOriginal(self, ...)
            end
            local active = S.Instakill_Enabled or S.TP_Bullet_Enabled or S.Ammo_Enabled
                or S.NoReload_Enabled or S.Aimbot_Mode == "Silent"
            if not active then
                return hookOriginal(self, ...)
            end
            if typeof(self) ~= "Instance" then
                return hookOriginal(self, ...)
            end

            local method = getnamecallmethod()

            if S.Aimbot_Mode == "Silent" and not internalRay
                and (method == "Raycast" or method == "FindPartOnRay"
                    or method == "FindPartOnRayWithIgnoreList"
                    or method == "FindPartOnRayWithWhitelist") then
                local args = table.pack(...)
                local changedOk, changed = pcall(rewriteSilentRay, method, args)
                if changedOk and changed then
                    return hookOriginal(self, table.unpack(args, 1, args.n))
                end
                return hookOriginal(self, ...)
            end

            if S.Ammo_Enabled and method == "Activate" and self:IsA("Tool") then
                pcall(refillAmmo)
                return hookOriginal(self, ...)
            end

            if S.NoReload_Enabled and not reloadBypass and nameMatches(self, HINTS.Reload) then
                return nil
            end

            if method ~= "FireServer" and method ~= "InvokeServer" and method ~= "Fire" then
                return hookOriginal(self, ...)
            end

            local args = table.pack(...)
            local changed = false

            if S.TP_Bullet_Enabled and currentTargetPos and not WHITELIST.IsTarget(CurrentTargetPart, CurrentTargetPlayer)
                and nameMatches(self, HINTS.Bullet) then
                local origin = getHRP()
                local originPosition = origin and origin.Position or nil
                for index = 1, args.n do
                    local value = args[index]
                    local kind = typeof(value)
                    if kind == "Vector3" then
                        if not originPosition or (value - originPosition).Magnitude <= 160 then
                            args[index] = currentTargetPos
                            changed = true
                        end
                    elseif kind == "CFrame" then
                        if not originPosition or (value.Position - originPosition).Magnitude <= 160 then
                            args[index] = CFrame.new(currentTargetPos) * (value - value.Position)
                            changed = true
                        end
                    end
                end
            end

            if changed then
                return hookOriginal(self, table.unpack(args, 1, args.n))
            end
            return hookOriginal(self, ...)
        end)
    end)

    if not success then
        return
    end

    local old = original
    hookOriginal = old
    HookAvailable = true

    restoreHook = function()
        pcall(function()
            local meta = getrawmetatable(game)
            if meta and old then
                setreadonly(meta, false)
                meta.__namecall = old
                setreadonly(meta, true)
            end
        end)
        HookAvailable = false
    end

    getgenv().__SupremeHubRestoreHook = restoreHook
end

-- ============================================================
-- TP BULLET: RAYCAST MODULE HOOK
-- ============================================================

HINTS.Raycast = { "cast", "castThrough", "raycast", "Raycast", "rayCast", "RayCast" }
local RAY = {
    hookList = {},
    hooked = false,
    hookClock = 0,
    bulletData = {},
    targetCache = { time = 0, part = nil },
}

local function getBulletTPTarget()
    if INSTA and INSTA.Owns() then return nil end
    if S.Aimbot_Mode == "Silent" and CurrentTargetPart then
        local part = CurrentTargetPart
        if WHITELIST.IsTarget(part, CurrentTargetPlayer) then return nil end
        local character = part.Parent
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if part.Parent and humanoid and humanoid.Health > 0 then
            return part
        end
        return nil
    end
    if EXPLOITS_LOCKED then
        return nil
    end
    if not S.TP_Bullet_Enabled then
        return nil
    end

    local now = os.clock()
    if now - RAY.targetCache.time >= 0.05 then
        RAY.targetCache.time = now
        RAY.targetCache.part = findCursorTarget("Center")
    end
    local part = RAY.targetCache.part
    if part and part.Parent and not WHITELIST.IsCharacter(part.Parent) then
        return part
    end
    return nil
end

local function getModuleFunction(module, key)
    local ok, fn = pcall(rawget, module, key)
    if ok and type(fn) == "function" then
        return fn
    end
    local indexedOk, indexed = pcall(function()
        return module[key]
    end)
    if indexedOk and type(indexed) == "function" then
        return indexed
    end
    return nil
end

local function findRaycastModules()
    local strict = {}
    local loose = {}
    if type(getgc) ~= "function" then
        return strict
    end

    local ok, garbage = pcall(getgc, true)
    if not ok or type(garbage) ~= "table" then
        return strict
    end

    for _, object in ipairs(garbage) do
        if type(object) == "table" then
            local cast = getModuleFunction(object, "cast")
            local castThrough = getModuleFunction(object, "castThrough")
            if cast and castThrough then
                table.insert(strict, object)
            elseif cast then
                table.insert(loose, object)
            end
            if #strict >= 8 then
                break
            end
        end
    end

    if #strict > 0 then
        return strict
    end

    local limited = {}
    for index = 1, math.min(#loose, 8) do
        limited[index] = loose[index]
    end
    return limited
end

local function rewriteBulletArgs(args, targetPart)
    if not targetPart or not targetPart.Parent or WHITELIST.IsCharacter(targetPart.Parent) then return false end
    local character = LocalPlayer.Character
    local head = character and character:FindFirstChild("Head")
    if not head then
        head = getHRP()
    end
    if not head then
        return false
    end

    local headPosition = head.Position
    local originIndex, originPosition
    local directionIndex, directionValue

    for index = 1, args.n do
        local value = args[index]
        local kind = typeof(value)
        if kind == "Vector3" then
            if not originIndex then
                originIndex, originPosition = index, value
            else
                directionIndex, directionValue = index, value
                break
            end
        elseif kind == "CFrame" and not originIndex then
            originIndex, originPosition = index, value.Position
        end
    end

    if not originIndex or not directionIndex then
        return false
    end
    if S.Aimbot_Mode ~= "Silent" and (originPosition - headPosition).Magnitude > S.TP_Bullet_Range then
        return false
    end

    local length = math.max(directionValue.Magnitude, 1)
    local newOrigin = headPosition + (targetPart.Position - headPosition).Unit * 2
    local newDirection = (targetPart.Position - newOrigin).Unit * length

    if typeof(args[originIndex]) == "CFrame" then
        local rotation = args[originIndex] - originPosition
        args[originIndex] = CFrame.new(newOrigin) * rotation
    else
        args[originIndex] = newOrigin
    end
    args[directionIndex] = newDirection

    RAY.bulletData.Origin = newOrigin
    RAY.bulletData.Direction = newDirection
    RAY.bulletData.Target = targetPart.Position
    RAY.bulletData.Character = targetPart.Parent
    pcall(function()
        _G._bulletTPData = RAY.bulletData
    end)
    getgenv()._bulletTPData = RAY.bulletData
    return true
end

local function tryHookRaycast(hookFn, module, key)
    local fn = getModuleFunction(module, key)
    if not fn then
        return
    end

    for _, entry in ipairs(RAY.hookList) do
        if entry.hooked == fn then
            return
        end
    end

    local original
    local wrapper
    wrapper = function(...)
        local tpActive = S.TP_Bullet_Enabled and not EXPLOITS_LOCKED
        if not tpActive and S.Aimbot_Mode ~= "Silent" then
            return original(...)
        end

        local targetPart = getBulletTPTarget()
        if not targetPart then
            return original(...)
        end

        local args = table.pack(...)
        local changedOk, changed = pcall(rewriteBulletArgs, args, targetPart)
        if changedOk and changed then
            return original(table.unpack(args, 1, args.n))
        end
        return original(...)
    end

    local hookedOk, previous = pcall(hookFn, fn, wrapper)
    if hookedOk and type(previous) == "function" then
        original = previous
        table.insert(RAY.hookList, { hooked = fn, wrapper = wrapper, original = previous })
    end
end

local function installRaycastHooks()
    if RAY.hooked then
        return true
    end

    local hookFn = getgenv().hookfunction or hookfunction
    if type(hookFn) ~= "function" then
        RAY.hooked = HookAvailable
        return RAY.hooked
    end

    local modules = findRaycastModules()
    if #modules == 0 then
        -- Game raycasts through Workspace:Raycast/FindPartOnRay are already
        -- handled by the namecall hook, so silent aim can still work
        RAY.hooked = HookAvailable
        return RAY.hooked
    end

    for _, module in ipairs(modules) do
        for _, key in ipairs(HINTS.Raycast) do
            pcall(tryHookRaycast, hookFn, module, key)
        end
    end

    RAY.hooked = #RAY.hookList > 0 or HookAvailable
    return RAY.hooked
end

local function restoreRaycastHooks()
    local hookFn = getgenv().hookfunction or hookfunction
    if type(hookFn) == "function" then
        for _, entry in ipairs(RAY.hookList) do
            pcall(function()
                hookFn(entry.wrapper, entry.original)
            end)
        end
    end
    RAY.hookList = {}
    RAY.hooked = false
end

getgenv().__SupremeHubRestoreRaycast = restoreRaycastHooks

INSTA = (function()
    local I = {
        Config = {
            SilentAim = true, CamLock = false, FOV = 300, Prediction = 0.13,
            TargetPart = "Head", IgnoreWalls = true, TeamCheck = false,
            IgnoreKO = true, IgnoreGrab = true, HealthCheck = true,
            AutoFire = true, FireRate = 0.04, Instakill = true,
            InstakillAll = false, InstakillRange = 0, InstakillCooldown = 0.08,
            ForceKill = true, LocalHealth = false, OnlySelected = true,
            UseGunHook = true, Highlight = true, ShowFOV = true,
            RefreshRate = 0.03, Debug = true,
        },
        Selected = {}, Ids = {}, BoundIds = {}, KnownNames = {},
        LocalKilled = setmetatable({}, {__mode = "k"}),
        Queue = {}, Target = nil, Player = nil, LastShot = -math.huge,
        ScanClock = 0, KillClock = 0, VisualClock = 0, HookClock = 0,
        MouseHookOk = false, GunHookOk = false, GunInstalling = false,
        GunHooks = {}, Connections = {}, Highlights = {}, Destroyed = false,
        Status = "Ready", CameraFallback = false,
    }
    local C = I.Config
    local mouse = LocalPlayer:GetMouse()

    function I.Owns()
        return alive() and not I.Destroyed and S.Instakill_Enabled
            and not S.Rage_Enabled and not STOMP.Target
    end
    function I.Character(player)
        local character = player and player.Character
        if character and character.Parent then return character end
        local fallback = player and workspace:FindFirstChild(player.Name)
        if fallback and fallback:FindFirstChildWhichIsA("Humanoid", true) then return fallback end
        return nil
    end
    function I.Humanoid(character)
        return character and (character:FindFirstChildOfClass("Humanoid")
            or character:FindFirstChildWhichIsA("Humanoid", true)) or nil
    end
    function I.Root(character)
        if not character then return nil end
        local root = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
        if root and root:IsA("BasePart") then return root end
        return character:FindFirstChildWhichIsA("BasePart", true)
    end
    function I.RememberPlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local lower = string.lower(player.Name)
                I.KnownNames[player.UserId] = player.Name
                if I.Selected[lower] and (not I.BoundIds[lower] or I.BoundIds[lower] == player.UserId) then
                    I.BoundIds[lower], I.Ids[player.UserId] = player.UserId, true
                end
            end
        end
    end
    function I.IsSelected(player)
        if not player then return false end
        local lower = string.lower(player.Name)
        return I.Ids[player.UserId] == true or (I.Selected[lower] == true
            and (not I.BoundIds[lower] or I.BoundIds[lower] == player.UserId))
    end
    function I.Selection()
        I.RememberPlayers()
        local result, seen = {}, {}
        for lower in pairs(I.Selected) do
            local id = I.BoundIds[lower]
            local name = (id and I.KnownNames[id]) or lower
            if not seen[string.lower(name)] then table.insert(result, name); seen[string.lower(name)] = true end
        end
        for id in pairs(I.Ids) do
            local name = I.KnownNames[id]
            if name and not seen[string.lower(name)] then table.insert(result, name); seen[string.lower(name)] = true end
        end
        table.sort(result, function(a,b) return string.lower(a) < string.lower(b) end)
        return result
    end
    function I.Names()
        local names, seen = {}, {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then table.insert(names, player.Name); seen[string.lower(player.Name)] = true end
        end
        for _, name in ipairs(I.Selection()) do
            if not seen[string.lower(name)] then table.insert(names, name); seen[string.lower(name)] = true end
        end
        table.sort(names, function(a,b) return string.lower(a) < string.lower(b) end)
        return names
    end
    function I.ClearTarget()
        if CurrentTargetPart == I.Target then
            CurrentTargetPart, CurrentTargetPlayer, currentTargetPos = nil, nil, nil
        end
        I.Target, I.Player = nil, nil
    end
    function I.ApplySelection(values)
        if I.RestoreLocalHealth then I.RestoreLocalHealth() end
        I.Selected, I.Ids = {}, {}
        if type(values) == "table" then
            for _, name in ipairs(values) do
                if type(name) == "string" and name ~= "" then I.Selected[string.lower(name)] = true end
            end
        end
        I.RememberPlayers()
        I.Queue = {}
        I.ClearTarget()
        I.ScanClock = 0
    end
    function I.SelectAll()
        local names = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not WHITELIST.IsPlayer(player) then table.insert(names, player.Name) end
        end
        I.ApplySelection(names)
    end
    function I.ClearSelection() I.ApplySelection({}) end
    function I.Resolve(player)
        if not player or player == LocalPlayer or player.Parent ~= Players then return nil, nil, "Offline" end
        if WHITELIST.IsPlayer(player) then return nil, nil, "Whitelist" end
        local character = I.Character(player)
        if not character then return nil, nil, "No character" end
        local humanoid = I.Humanoid(character)
        if not humanoid then return nil, nil, "No Humanoid" end
        local marked = I.LocalKilled[humanoid]
        if humanoid.Health > 0 and marked then I.LocalKilled[humanoid] = nil; marked = nil end
        if C.HealthCheck and (humanoid.Health ~= humanoid.Health or (humanoid.Health <= 0 and not marked)) then
            return nil, humanoid, "Dead", character
        end
        if C.TeamCheck and LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team then
            return nil, humanoid, "Team", character
        end
        if C.IgnoreKO then
            local body = character:FindFirstChild("BodyEffects")
            local ko = body and (body:FindFirstChild("K.O") or body:FindFirstChild("KO"))
            local knocked = ko and ko:IsA("BoolValue") and ko.Value == true
            if humanoid.PlatformStand then knocked = true end
            local ok, state = pcall(function() return humanoid:GetState() end)
            if ok and state == Enum.HumanoidStateType.Physics then knocked = true end
            if knocked then return nil, humanoid, "K.O", character end
        end
        if C.IgnoreGrab and character:FindFirstChild("GRABBING_CONSTRAINT") then
            return nil, humanoid, "Grabbed", character
        end
        local part = character:FindFirstChild(C.TargetPart)
        if not part or not part:IsA("BasePart") then part = I.Root(character) end
        if not part then return nil, humanoid, "No part", character end
        return part, humanoid, "OK", character
    end
    function I.Visible(character, part)
        if C.IgnoreWalls then return true end
        local camera = workspace.CurrentCamera
        if not camera then return false end
        local params = RaycastParams.new()
        params.FilterType, params.IgnoreWater = Enum.RaycastFilterType.Exclude, true
        params.FilterDescendantsInstances = LocalPlayer.Character and {LocalPlayer.Character} or {}
        local origin = camera.CFrame.Position
        internalRay = true
        local ok, result = pcall(function() return workspace:Raycast(origin, part.Position - origin, params) end)
        internalRay = false
        return ok and (not result or result.Instance:IsDescendantOf(character))
    end
    function I.Eligible(player, selectedOnly)
        if selectedOnly and not I.IsSelected(player) then return nil end
        local part, humanoid, reason, character = I.Resolve(player)
        if not part then return nil end
        local camera = workspace.CurrentCamera
        if not camera then return nil end
        if C.InstakillRange > 0 and (part.Position - camera.CFrame.Position).Magnitude > C.InstakillRange then return nil end
        if not I.Visible(character, part) then return nil end
        return part, humanoid, reason, character
    end
    function I.Ready()
        local humanoid = I.Humanoid(I.Character(LocalPlayer))
        return humanoid and humanoid.Health > 0 and not UserInputService:GetFocusedTextBox()
    end
    function I.FindTarget()
        if not I.Ready() then return nil end
        local camera = workspace.CurrentCamera
        if not camera then return nil end
        -- Explicit batch action visits the selected accounts, one shot per update interval.
        while #I.Queue > 0 do
            local player = I.Queue[1]
            local part = I.IsSelected(player) and I.Eligible(player, true)
            if part then return part, player end
            table.remove(I.Queue, 1)
        end
        if C.InstakillAll and I.Player then
            local part = I.Eligible(I.Player, C.OnlySelected)
            if part then return part, I.Player end
        end
        local center = UserInputService:GetMouseLocation()
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2 + 36)
        end
        local bestPart, bestPlayer, best = nil, nil, C.InstakillAll and math.huge or C.FOV
        local preferredPart, preferredPlayer, preferred = nil, nil, best
        for _, player in ipairs(Players:GetPlayers()) do
            local part = I.Eligible(player, C.OnlySelected)
            if part then
                local distance
                if C.InstakillAll then
                    distance = (part.Position - camera.CFrame.Position).Magnitude
                else
                    local screen, onScreen = camera:WorldToScreenPoint(part.Position)
                    if onScreen and screen.Z > 0 then distance = (Vector2.new(screen.X, screen.Y) - center).Magnitude end
                end
                if distance and distance <= best then bestPart, bestPlayer, best = part, player, distance end
                if distance and I.IsSelected(player) and distance <= preferred then
                    preferredPart, preferredPlayer, preferred = part, player, distance
                end
            end
        end
        if not C.InstakillAll and preferredPart then return preferredPart, preferredPlayer end
        return bestPart, bestPlayer
    end
    function I.HookTarget()
        if not I.Owns() or not I.Ready() then return nil end
        local part = I.Eligible(I.Player, C.OnlySelected)
        if not part or part ~= I.Target then return nil end
        return part, I.Player, part.Position + part.AssemblyLinearVelocity * C.Prediction
    end
    function I.MouseValue(object, key)
        if not C.SilentAim or (key ~= "Hit" and key ~= "Target" and key ~= "UnitRay") then return nil, false end
        if object ~= mouse and not (typeof(object) == "Instance" and object:IsA("Mouse")) then return nil, false end
        local part, _, position = I.HookTarget()
        if not part then return nil, false end
        if key == "Target" then return part, true end
        if key == "Hit" then return part.CFrame + (position - part.Position), true end
        local camera = workspace.CurrentCamera
        local direction = camera and position - camera.CFrame.Position
        if not direction or direction.Magnitude <= 0 then return nil, false end
        return Ray.new(camera.CFrame.Position, direction.Unit), true
    end
    function I.InstallMouseHook()
        if I.MouseHookOk or I.Destroyed then return I.MouseHookOk end
        local original, wrapper
        wrapper = (newcclosure or function(fn) return fn end)(function(object, key)
            local ok, value, changed = pcall(I.MouseValue, object, key)
            if ok and changed then return value end
            return original(object, key)
        end)
        local ok = pcall(function()
            if type(hookmetamethod) == "function" then
                original = hookmetamethod(game, "__index", wrapper)
            else
                local meta = getrawmetatable(game)
                original = meta.__index
                setreadonly(meta, false); meta.__index = wrapper; setreadonly(meta, true)
            end
            assert(type(original) == "function", "Mouse index unavailable")
        end)
        I.MouseHookOk = ok
        if ok then I.MouseOriginal, I.MouseWrapper = original, wrapper end
        I.CameraFallback = not ok
        return ok
    end
    function I.InstallGunHook()
        if I.Destroyed or I.GunInstalling or I.GunHookOk or not C.UseGunHook or not I.Owns() then return end
        if type(hookfunction) ~= "function" then return end
        I.GunInstalling = true
        task.spawn(function()
            local ok, failure = pcall(function()
                local storage = game:GetService("ReplicatedStorage")
                local modules = storage:FindFirstChild("Modules")
                for _, name in ipairs({"GunHandler", "GunModule", "WeaponHandler", "GunSystem"}) do
                    local module = (modules and modules:FindFirstChild(name)) or storage:FindFirstChild(name)
                    if module and module:IsA("ModuleScript") then
                        local handler = require(module)
                        -- require may yield across disable, unload or replacement character.
                        if not I.Owns() or not C.UseGunHook then return end
                        local fn = type(handler) == "table" and rawget(handler, "shoot")
                        if type(fn) == "function" then
                            local original, wrapper
                            wrapper = (newcclosure or function(f) return f end)(function(...)
                                local args = table.pack(...)
                                local payload = args[1]
                                local part, _, position
                                if C.UseGunHook and C.SilentAim then part, _, position = I.HookTarget() end
                                if part and type(payload) == "table" and rawget(payload, "Shooter") == LocalPlayer.Character then
                                    local copy = table.clone(payload)
                                    copy.AimPosition, copy.Hit = position, part
                                    args[1] = copy
                                    original(table.unpack(args, 1, args.n))
                                    return position, part, Vector3.new(0, 1, 0)
                                end
                                return original(...)
                            end)
                            original = hookfunction(fn, wrapper)
                            if type(original) == "function" then
                                table.insert(I.GunHooks, {Fn = fn, Wrapper = wrapper, Original = original})
                                I.GunHookOk = true
                                I.Status = "Weapon: " .. module.Name .. ".shoot"
                                return
                            end
                        end
                    end
                end
                I.Status = "Weapon module not found"
            end)
            I.GunInstalling = false
            if not ok then I.Status = "Weapon hook unavailable"; if C.Debug then warn("[Supreme Instakill] " .. tostring(failure)) end end
        end)
    end
    function I.RestoreLocalHealth()
        for humanoid, saved in pairs(I.LocalKilled) do
            if humanoid.Parent then
                pcall(function()
                    if humanoid.MaxHealth == 0 then humanoid.MaxHealth = saved.MaxHealth end
                    if humanoid.Health == 0 then humanoid.Health = saved.Health end
                end)
            end
            I.LocalKilled[humanoid] = nil
        end
    end
    function I.ForceKill(player)
        if not C.LocalHealth or not I.Owns() then return false end
        local part, humanoid, _, character = I.Resolve(player)
        if not part or WHITELIST.IsPlayer(player) then return false end
        if not I.LocalKilled[humanoid] then
            I.LocalKilled[humanoid] = {Character = character, Health = humanoid.Health, MaxHealth = humanoid.MaxHealth}
        end
        pcall(function() humanoid.Health = 0 end)
        if humanoid.Health > 0 then pcall(function() humanoid:TakeDamage(humanoid.Health) end) end
        if humanoid.Health > 0 and C.ForceKill then
            pcall(function() humanoid.MaxHealth = 0; humanoid.Health = 0 end)
        end
        return true
    end
    function I.FireGun()
        if not I.HookTarget() then return false end
        local now = os.clock()
        if now - I.LastShot < C.FireRate then return false end
        local tool = getEquippedTool()
        if not tool then I.Status = "Equip a gun"; return false end
        I.LastShot = now
        local ok = pcall(function() tool:Activate() end)
        return ok
    end
    function I.QueueSelected()
        if not S.Instakill_Enabled or I.Destroyed then return false end
        local queue = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if I.IsSelected(player) and I.Eligible(player, true) then table.insert(queue, player) end
        end
        table.sort(queue, function(a,b) return a.UserId < b.UserId end)
        I.Queue = queue; I.ScanClock = 0; I.ClearTarget()
        return #queue > 0
    end
    function I.SetEnabled(value)
        S.Instakill_Enabled = value == true and not I.Destroyed
        I.ClearTarget(); I.ScanClock, I.KillClock = 0, 0
        I.Queue = {}
        if S.Instakill_Enabled then
            I.InstallMouseHook(); I.InstallGunHook()
        else
            I.RestoreLocalHealth()
        end
        if I.Render then I.Render() end
    end
    function I.SetOption(key, value)
        if C[key] == nil then return end
        if type(C[key]) == "number" and (type(value) ~= "number" or value ~= value or math.abs(value) == math.huge) then return end
        if type(C[key]) == "boolean" then value = value == true end
        if key == "TargetPart" and type(value) ~= "string" then return end
        C[key] = value
        I.ScanClock = 0
        I.ClearTarget()
        if key == "LocalHealth" and not value then I.RestoreLocalHealth() end
        if key == "UseGunHook" and value then I.InstallGunHook() end
    end
    function I.Update(dt)
        if not I.Owns() or not I.Ready() then
            I.ClearTarget()
            I.RestoreLocalHealth()
            return
        end
        I.ScanClock -= dt
        if I.ScanClock <= 0 or #I.Queue > 0 or not I.HookTarget() then
            I.ScanClock = math.max(0.01, C.RefreshRate)
            I.Target, I.Player = I.FindTarget()
        end
        CurrentTargetPart, CurrentTargetPlayer = I.Target, I.Player
        currentTargetPos = I.Target and I.Target.Position or nil
        I.HookClock -= dt
        if C.UseGunHook and not I.GunHookOk and I.HookClock <= 0 then
            I.HookClock = 3; I.InstallGunHook()
        end
        local part = I.HookTarget()
        if not part then return end
        local manual = #I.Queue > 0
        I.KillClock -= dt
        local killDue = C.Instakill and I.KillClock <= 0
        if killDue then
            I.KillClock = math.max(0.02, C.InstakillCooldown)
            if C.LocalHealth and C.InstakillAll then
                for _, player in ipairs(Players:GetPlayers()) do
                    if I.Eligible(player, C.OnlySelected) then I.ForceKill(player) end
                end
            elseif C.LocalHealth then I.ForceKill(I.Player) end
        end
        if manual or C.AutoFire or killDue then
            if I.FireGun() and manual then table.remove(I.Queue, 1); I.ClearTarget(); I.ScanClock = 0 end
        end
    end
    function I.StatusText()
        if not S.Instakill_Enabled then return "Instakill: off" end
        if S.Rage_Enabled then return "Paused: Rage owns combat" end
        if STOMP.Target then return "Paused: stomping" end
        local name = I.Player and I.Player.Name or "none"
        return "Target: " .. name .. " | M:" .. (I.MouseHookOk and "1" or "0") .. " G:" .. (I.GunHookOk and "1" or "0")
    end
    function I.PlayerInfoText()
        return string.format("Selected: %d | Queue: %d | %s", #I.Selection(), #I.Queue, I.Status)
    end
    function I.HookStatusText()
        return "Mouse: " .. (I.MouseHookOk and "active" or "off")
            .. " | Gun: " .. (I.GunHookOk and "active" or "waiting")
    end
    function I.PlayerInfoLines()
        local rows = {}
        local camera = workspace.CurrentCamera
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local part, humanoid, reason, character = I.Resolve(player)
                local root = part or I.Root(character or I.Character(player))
                local distance = root and camera and math.floor((root.Position - camera.CFrame.Position).Magnitude)
                local text = reason == "OK" and (tostring(math.floor(humanoid.Health)) .. " HP") or reason
                if humanoid and I.LocalKilled[humanoid] then text = "local HP effect" end
                table.insert(rows, {Name = player.Name, Player = player, Selected = I.IsSelected(player),
                    Text = player.Name .. " | " .. text .. (distance and (" | " .. distance .. "st") or "")})
            end
        end
        table.sort(rows, function(a,b) return string.lower(a.Name) < string.lower(b.Name) end)
        return rows
    end
    function I.BuildVisuals()
        if I.Gui or I.Destroyed then return end
        local parent = LocalPlayer:FindFirstChild("PlayerGui")
        if not parent then return end
        local gui = Instance.new("ScreenGui")
        gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = "SupremeInstakillFX", false, true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = parent
        local circle = Instance.new("Frame")
        circle.AnchorPoint, circle.BackgroundTransparency, circle.BorderSizePixel = Vector2.new(0.5,0.5), 1, 0
        circle.Parent = gui
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1,0); corner.Parent = circle
        local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(90,140,255); stroke.Thickness = 1.5; stroke.Parent = circle
        local folder = Instance.new("Folder"); folder.Name = "SupremeInstakillHighlights"; folder.Parent = workspace
        I.Gui, I.Circle, I.Folder = gui, circle, folder
    end
    function I.Render()
        if I.Destroyed then return end
        if not S.Instakill_Enabled and not I.Gui then return end
        I.BuildVisuals()
        local camera = workspace.CurrentCamera
        local active = I.Owns() and I.Ready()
        if I.Circle then
            local center = UserInputService:GetMouseLocation()
            if camera and UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2 + 36)
            end
            I.Circle.Position = UDim2.fromOffset(center.X, center.Y)
            I.Circle.Size = UDim2.fromOffset(C.FOV * 2, C.FOV * 2)
            I.Circle.Visible = active and C.ShowFOV and not C.InstakillAll
        end
        local part = I.HookTarget()
        if camera and part and (C.CamLock or (C.SilentAim and I.CameraFallback)) and not S.Spectate_Enabled then
            local position = part.Position + part.AssemblyLinearVelocity * C.Prediction
            if (position - camera.CFrame.Position).Magnitude > 0 then
                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, position)
            end
        end
        for player, highlight in pairs(I.Highlights) do
            if player.Parent ~= Players then highlight:Destroy(); I.Highlights[player] = nil
            else highlight.Enabled = false end
        end
        if not active or not C.Highlight or not I.Folder then return end
        for _, player in ipairs(Players:GetPlayers()) do
            local selected = I.IsSelected(player)
            if player ~= LocalPlayer and not WHITELIST.IsPlayer(player) and (selected or player == I.Player) then
                local character = I.Character(player)
                if character then
                    local highlight = I.Highlights[player]
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.FillTransparency, highlight.OutlineTransparency = 0.7, 0.2
                        highlight.Parent = I.Folder; I.Highlights[player] = highlight
                    end
                    highlight.Adornee, highlight.Enabled = character, true
                    highlight.FillColor = player == I.Player and Color3.fromRGB(90,140,255) or Color3.fromRGB(80,220,120)
                    highlight.OutlineColor = Color3.fromRGB(230,240,255)
                end
            end
        end
    end
    function I.Invalidate()
        I.ClearTarget(); I.ScanClock = 0
        for index = #I.Queue, 1, -1 do
            if WHITELIST.IsPlayer(I.Queue[index]) or I.Queue[index].Parent ~= Players then table.remove(I.Queue, index) end
        end
        I.RestoreLocalHealth()
    end
    function I.Destroy()
        if I.Destroyed then return end
        I.SetEnabled(false)
        I.Destroyed = true
        I.RestoreLocalHealth()
        for _, connection in ipairs(I.Connections) do connection:Disconnect() end
        if I.MouseHookOk then
            pcall(function()
                local meta = getrawmetatable(game)
                if meta.__index == I.MouseWrapper then
                    setreadonly(meta,false); meta.__index = I.MouseOriginal; setreadonly(meta,true)
                end
            end)
        end
        if type(hookfunction) == "function" then
            for _, entry in ipairs(I.GunHooks) do pcall(hookfunction, entry.Fn, entry.Original) end
        end
        if I.Gui then I.Gui:Destroy() end
        if I.Folder then I.Folder:Destroy() end
        I.Gui, I.Circle, I.Folder, I.Highlights = nil, nil, nil, {}
    end
    table.insert(I.Connections, Players.PlayerRemoving:Connect(function(player)
        if I.Player == player then I.ClearTarget() end
        local highlight = I.Highlights[player]
        if highlight then highlight:Destroy(); I.Highlights[player] = nil end
        for index = #I.Queue, 1, -1 do if I.Queue[index] == player then table.remove(I.Queue,index) end end
    end))
    return I
end)() -- INSTA_MODULE_END


-- ============================================================
-- MAIN LOOPS
-- ============================================================

local fpsFrames = 0
local fpsValue = 0

task.spawn(function()
    while alive() do
        task.wait(1)
        fpsValue = fpsFrames
        fpsFrames = 0
    end
end)

local fovCircle = nil
if HasDrawing then
    local ok, circle = pcall(Drawing.new, "Circle")
    if ok then
        fovCircle = circle
        fovCircle.Thickness = 1
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Transparency = 1
        fovCircle.Filled = false
        fovCircle.Visible = false
    else
        HasDrawing = false
    end
end

local silentCircle = nil
if HasDrawing then
    local ok, circle = pcall(Drawing.new, "Circle")
    if ok then
        silentCircle = circle
        silentCircle.Thickness = 1
        silentCircle.Color = Color3.fromRGB(255, 90, 90)
        silentCircle.Transparency = 1
        silentCircle.Filled = false
        silentCircle.Visible = false
    end
end

RunService.RenderStepped:Connect(function(dt)
    if not alive() then
        return
    end

    fpsFrames += 1

    local camera = workspace.CurrentCamera
    local character = LocalPlayer.Character
    if not camera or not getHRP(character) then
        return
    end

    refreshRayFilter()
    local mouse = UserInputService:GetMouseLocation()

    INSTA.Render()
    updateAimbot(dt, mouse)
    updateSpinbot(dt)
    updateSpeedAndJump()
    updateFly(dt)
    updateNoclip()
    updateAntiFling()

    if fovCircle then
        fovCircle.Visible = S.Aim_ShowFOV
        if S.Aim_ShowFOV then
            fovCircle.Position = mouse
            fovCircle.Radius = S.Aim_FOV
            fovCircle.Color = S.FOV_Color
        end
    end

    if silentCircle then
        silentCircle.Visible = S.Silent_ShowFOV
        if S.Silent_ShowFOV then
            silentCircle.Position = mouse
            silentCircle.Radius = S.Silent_FOV
            silentCircle.Color = S.Silent_FOV_Color
        end
    end

    if S.Fullbright_Enabled then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
        Lighting.Brightness = OriginalBrightness
    end

    for id in pairs(ESP_Cache) do
        hideESP(id)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                drawESP(tostring(player.UserId), player.Character, hrp, player.Name, player.Team, false)
            end
        end
    end

    updateArrows()

    for npc in pairs(Tracked_NPCs) do
        if npc.Parent then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and hrp then
                drawESP(npc, npc, hrp, npc.Name, nil, true)
            else
                Tracked_NPCs[npc] = nil
                clearEntityESP(npc)
            end
        else
            Tracked_NPCs[npc] = nil
            clearEntityESP(npc)
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if not alive() then
        return
    end

    updateAutoShot(dt)
    updateAutoStomp(dt)
    INSTA.Update(dt)
    updateRage(dt)
    updateAmmo(dt)
    updateReloadSpam(dt)
    updateHitbox()
    INSTA.VisualClock += dt
    if INSTA.VisualClock >= 0.5 then
        INSTA.VisualClock = 0
        if INSTA.StatusLabel then INSTA.StatusLabel:SetText(INSTA.StatusText()) end
        if INSTA.InfoLabel then INSTA.InfoLabel:SetText(INSTA.PlayerInfoText()) end
        if INSTA.RefreshPlayerRows then INSTA.RefreshPlayerRows() end
    end
    updateAntiRagdoll()
    if S.AntiStomp_Enabled then
        updateAntiStomp(dt)
    end

    if (S.Aimbot_Mode == "Silent" or (S.TP_Bullet_Enabled and not EXPLOITS_LOCKED)) and not RAY.hooked then
        RAY.hookClock -= dt
        if RAY.hookClock <= 0 then
            RAY.hookClock = 3
            installHook()
            installRaycastHooks()
        end
    end
end)

-- ============================================================
-- UI
-- ============================================================

WHITELIST.OnChanged = function()
    if INSTA then INSTA.Invalidate() end
    if WHITELIST.IsTarget(CurrentTargetPart, CurrentTargetPlayer) or WHITELIST.IsPlayer(rageLockedPlayer) then
        clearRageTarget(true)
    end
    if WHITELIST.IsCharacter(STOMP.Target) then STOMP.Reset() end
    RAY.targetCache.part, RAY.targetCache.time = nil, 0
    table.clear(RAY.bulletData)
    pcall(function() _G._bulletTPData = nil end)
    getgenv()._bulletTPData = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if WHITELIST.IsPlayer(player) and player.Character then
            local root = getHRP(player.Character)
            if root and hitboxSaved[root] then
                local original = hitboxSaved[root]
                pcall(function() root.Size = original end)
                hitboxSaved[root] = nil
            end
        end
    end
end

Library.MenuKeybind = tostring(Enum.KeyCode.F2)

local LOGO = "rbxassetid://134242818164054"
local ICONS = {
    Combat = "rbxassetid://87563802520297",
    Visuals = "rbxassetid://100033680381365",
    Move = "rbxassetid://114551690399915",
    Client = "rbxassetid://93142176757189",
    Menu = "rbxassetid://73803440257131",
    Player = "rbxassetid://93142176757189",
}

local flagCounter = 0
local flagMap = {}
local syncingAimMode = false
local function flag(name)
    flagCounter += 1
    local generated = string.format("supreme_%s_%d", name, flagCounter)
    flagMap[name] = generated
    return generated
end

local Window = Library:Window({
    Name = "DEV TESTING HUB",
    SubName = "SUPREME - RAGE v6.2",
    Logo = LOGO,
})

-- Smooth open: expands from a point on every open, then keeps the saved size
if Window.Items and Window.Items["MainFrame"] and Window.Items["MainFrame"].Instance then
    local mainFrame = Window.Items["MainFrame"].Instance
    MenuFrame = mainFrame
    local lastSize = mainFrame.Size
    local lastPos = mainFrame.Position
    local openTween = nil
    local openScale = Instance.new("UIScale")
    openScale.Scale = 1
    openScale.Parent = mainFrame

    local function stopOpenTween()
        if openTween then
            pcall(function()
                openTween:Cancel()
            end)
            openTween = nil
        end
    end

    local function playOpenAnimation()
        stopOpenTween()
        mainFrame.Size = lastSize
        mainFrame.Position = lastPos
        openScale.Scale = 0
        openTween = TweenService:Create(
            openScale,
            TweenInfo.new(0.36, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Scale = 1 }
        )
        openTween:Play()
    end

    function Window:SetOpen(open)
        local frame = self.Items["MainFrame"].Instance

        if not open then
            lastSize = frame.Size
            lastPos = frame.Position
            frame.Visible = false
            stopOpenTween()
            openScale.Scale = 1
            self.IsOpen = false
            MenuOpen = false
            return
        end

        if self.IsOpen and frame.Visible then
            return
        end

        self.IsOpen = true
        MenuOpen = true
        frame.Visible = true
        playOpenAnimation()
    end

    -- Library already made the frame visible at creation, replay the animation
    playOpenAnimation()
end
Window:SetOpen(true)

-- Shared UI handles (kept in scope for the live status loop / unload button)
local hookStatus
local fpsLabel, pingLabel, targetLabel, musicStatusLabel
local menuSection
local bindsReady = false
local bindEntries = {}
local keyName

Window:Group("Бой")
local CombatPage = Window:Page({ Name = "Combat", Icon = ICONS.Combat })
Window:Group("Визуал")
local VisualsPage = Window:Page({ Name = "Visuals", Icon = ICONS.Visuals })
Window:Group("Движение")
local MovementPage = Window:Page({ Name = "Movement", Icon = ICONS.Move })
Window:Group("Игроки")
local PlayerPage = Window:Page({ Name = "Players", Icon = ICONS.Player })
Window:Group("Система")
local ClientPage = Window:Page({ Name = "Client", Icon = ICONS.Client })
Window:Group("Меню")
local MenuPage = Window:Page({ Name = "Menu", Icon = ICONS.Menu })

do
(function()
-- Combat: Aimbot
local aimSection = CombatPage:Section({ Name = "Aimbot", Side = 1, Tab = "Aimbot" })
local aimExtraSection = CombatPage:Section({ Name = "FOV", Side = 2, Tab = "Aimbot" })

aimSection:Toggle({
    Name = "Aimbot (RMB)",
    Flag = flag("aimbot"),
    Default = false,
    Callback = function(value)
        S.Aimbot_Enabled = value
    end,
})

aimSection:Toggle({
    Name = "Wall Check",
    Flag = flag("aim_wall"),
    Default = true,
    Callback = function(value)
        S.Aimbot_WallCheck = value
    end,
})

aimSection:Toggle({
    Name = "Target NPCs",
    Flag = flag("aim_npc"),
    Default = false,
    Callback = function(value)
        S.Aimbot_TargetNPCs = value
    end,
})

aimSection:Toggle({
    Name = "Team Check",
    Flag = flag("aim_team"),
    Default = true,
    Callback = function(value)
        S.Aimbot_TeamCheck = value
    end,
})

aimSection:Toggle({
    Name = "Prediction",
    Flag = flag("aim_pred"),
    Default = false,
    Callback = function(value)
        S.Aimbot_Prediction = value
    end,
})

aimSection:Dropdown({
    Name = "Aimbot mode",
    Flag = flag("aim_mode"),
    Items = { "Normal", "Silent" },
    Default = "Normal",
    Multi = false,
    Callback = function(value)
        S.Aimbot_Mode = value

        if syncingAimMode then
            return
        end

        local target = flagMap["silent_aim"]
        if target and Library.SetFlags[target] then
            syncingAimMode = true
            pcall(Library.SetFlags[target], value == "Silent")
            syncingAimMode = false
        end
    end,
})

aimSection:Dropdown({
    Name = "Aim part",
    Flag = flag("aim_part"),
    Items = { "Head", "Torso", "Nearest" },
    Default = "Head",
    Multi = false,
    Callback = function(value)
        S.Aim_Part = value
    end,
})

aimSection:Slider({
    Name = "Smoothing",
    Flag = flag("aim_smooth"),
    Min = 0.05,
    Max = 1,
    Default = 0.25,
    Decimals = 0.05,
    Callback = function(value)
        S.Aim_Smoothing = value
    end,
})

aimSection:Slider({
    Name = "FOV",
    Flag = flag("aim_fov"),
    Min = 50,
    Max = 800,
    Default = 150,
    Decimals = 1,
    Callback = function(value)
        S.Aim_FOV = value
    end,
})

aimSection:Slider({
    Name = "Bullet Speed (prediction)",
    Flag = flag("aim_speed"),
    Min = 100,
    Max = 5000,
    Default = 1500,
    Decimals = 10,
    Callback = function(value)
        S.Aim_BulletSpeed = value
    end,
})

aimExtraSection:Toggle({
    Name = "Show FOV Circle",
    Flag = flag("aim_showfov"),
    Default = false,
    Callback = function(value)
        S.Aim_ShowFOV = value
    end,
})

aimExtraSection:Label("FOV Color"):Colorpicker({
    Flag = flag("aim_fovcolor"),
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        S.FOV_Color = color
    end,
})

aimExtraSection:Label("ПКМ — наводиться, Insert / V / F2 — меню")

aimExtraSection:Toggle({
    Name = "Hitbox Expander",
    Flag = flag("hitbox"),
    Default = false,
    Callback = function(value)
        S.Hitbox_Enabled = value
    end,
})

aimExtraSection:Slider({
    Name = "Hitbox size",
    Flag = flag("hitbox_size"),
    Min = 2,
    Max = 20,
    Default = 6,
    Decimals = 1,
    Callback = function(value)
        S.Hitbox_Size = value
    end,
})

-- Combat: Silent aim
local silentSection = CombatPage:Section({ Name = "Silent aim", Side = 2, Tab = "Aimbot" })

silentSection:Toggle({
    Name = "Silent aim",
    Flag = flag("silent_aim"),
    Default = false,
    Callback = function(value)
        if syncingAimMode then
            return
        end

        local target = flagMap["aim_mode"]
        if target and Library.SetFlags[target] then
            syncingAimMode = true
            pcall(Library.SetFlags[target], value and "Silent" or "Normal")
            syncingAimMode = false
        else
            S.Aimbot_Mode = value and "Silent" or "Normal"
        end
    end,
})

silentSection:Dropdown({
    Name = "Silent target part",
    Flag = flag("silent_part"),
    Items = { "Head", "Torso", "Nearest" },
    Default = "Head",
    Multi = false,
    Callback = function(value)
        S.Silent_AimPart = value
    end,
})

silentSection:Slider({
    Name = "Silent FOV",
    Flag = flag("silent_fov"),
    Min = 20,
    Max = 800,
    Default = 300,
    Decimals = 1,
    Callback = function(value)
        S.Silent_FOV = value
    end,
})

silentSection:Slider({
    Name = "Silent range",
    Flag = flag("silent_range"),
    Min = 50,
    Max = 2000,
    Default = 500,
    Decimals = 10,
    Callback = function(value)
        S.Silent_Range = value
    end,
})

silentSection:Toggle({
    Name = "Silent wall check",
    Flag = flag("silent_wall"),
    Default = false,
    Callback = function(value)
        S.Silent_WallCheck = value
    end,
})

silentSection:Toggle({
    Name = "Show silent FOV",
    Flag = flag("silent_showfov"),
    Default = false,
    Callback = function(value)
        S.Silent_ShowFOV = value
    end,
})

silentSection:Label("Silent FOV color"):Colorpicker({
    Flag = flag("silent_fovcolor"),
    Default = Color3.fromRGB(255, 90, 90),
    Callback = function(color)
        S.Silent_FOV_Color = color
    end,
})

silentSection:Label("Пули летят в цель без ПКМ (в пределах FOV)")

-- Combat: Shooting
local shotSection = CombatPage:Section({ Name = "Auto Shot", Side = 1, Tab = "Shooting" })
local ammoSection = CombatPage:Section({ Name = "Ammo", Side = 2, Tab = "Shooting" })

shotSection:Toggle({
    Name = "Auto Shot",
    Flag = flag("autoshot"),
    Default = false,
    Callback = function(value)
        S.AutoShot_Enabled = value
    end,
})

shotSection:Slider({
    Name = "Shots per second",
    Flag = flag("autoshot_rate"),
    Min = 1,
    Max = 30,
    Default = 12,
    Decimals = 1,
    Callback = function(value)
        S.AutoShot_Rate = value
    end,
})

shotSection:Toggle({
    Name = "Only with target",
    Flag = flag("autoshot_target"),
    Default = true,
    Callback = function(value)
        S.AutoShot_RequireTarget = value
    end,
})

shotSection:Dropdown({
    Name = "Fire mode",
    Flag = flag("autoshot_mode"),
    Items = { "Tool", "Mouse" },
    Default = "Tool",
    Multi = false,
    Callback = function(value)
        S.AutoShot_Mode = value
    end,
})

shotSection:Label("Tool — tool:Activate(), Mouse — mouse1click")

ammoSection:Toggle({
    Name = "Infinite Ammo",
    Flag = flag("ammo_inf"),
    Default = false,
    Callback = function(value)
        S.Ammo_Enabled = value and not AMMO_LOCKED
    end,
})

ammoSection:Toggle({
    Name = "No Reload",
    Flag = flag("ammo_noreload"),
    Default = false,
    Callback = function(value)
        S.NoReload_Enabled = value and not AMMO_LOCKED
    end,
})

ammoSection:Toggle({
    Name = "Reload remote spam",
    Flag = flag("ammo_reloadspam"),
    Default = true,
    Callback = function(value)
        S.Ammo_ReloadSpam = value
    end,
})

ammoSection:Slider({
    Name = "Reload interval",
    Flag = flag("ammo_reloadint"),
    Min = 0.1,
    Max = 2,
    Default = 0.7,
    Decimals = 0.05,
    Suffix = " s",
    Callback = function(value)
        S.Reload_SpamInterval = value
    end,
})

ammoSection:Button({
    Name = "Refill now",
    Callback = function()
        pcall(refillAmmo)
        pcall(triggerReloadSpam)
        notify("Ammo refill triggered")
    end,
})

ammoSection:Label("Boom Hood: ReloadWeapon spam while Infinite Ammo is on")
ammoSection:Label("Reload calls are blocked while No Reload is on")

if ammoSection.Items and ammoSection.Items["Section"] then
    createWorkCover(ammoSection.Items["Section"].Instance, {
        TextSize = 30,
        Rotation = -24,
        Transparency = 0.5,
        Corner = 15,
        ZIndex = 50,
    })
end

local autoStompSection = CombatPage:Section({ Name = "Auto Stomp", Side = 2, Tab = "Shooting" })

autoStompSection:Toggle({
    Name = "Auto Stomp",
    Flag = flag("autostomp"),
    Default = false,
    Callback = function(value)
        S.AutoStomp_Enabled = value
        if not value and STOMP.Owner == "Auto" then STOMP.Reset() end
    end,
})


-- Reserve removed option IDs so later saved settings retain their existing flags.
flag("autostomp_range")
flag("autostomp_rate")
flag("autostomp_knocked")
autoStompSection:Label("Knocked targets across the server; no distance limit")

autoStompSection:Textbox({
    Name = "Stomp key (optional)",
    Flag = flag("autostomp_key"),
    Default = "",
    Callback = function(value)
        S.AutoStomp_Key = string.upper(tostring(value or ""))
    end,
})

autoStompSection:Label("Клавиша используется только как запасной способ стомпа")

-- Combat: Rage
local rageSection = CombatPage:Section({ Name = "Rage v6.2", Side = 1, Tab = "Rage" })
local rageExtraSection = CombatPage:Section({ Name = "Rage settings", Side = 2, Tab = "Rage" })

rageSection:Toggle({
    Name = "Full Rage",
    Flag = flag("rage"),
    Default = false,
    Callback = function(value)
        S.Rage_Enabled = value
    end,
})

rageSection:Toggle({
    Name = "Auto Stomp in Rage",
    Flag = "supreme_rage_autostomp",
    Default = true,
    Callback = function(value) S.Rage_AutoStomp = value end,
})
rageSection:Toggle({
    Name = "Auto Reload in Rage",
    Flag = "supreme_rage_autoreload",
    Default = true,
    Callback = function(value) S.Rage_AutoReload = value end,
})
rageSection:Toggle({
    Name = "Rage team check",
    Flag = "supreme_rage_teamcheck",
    Default = false,
    Callback = function(value) S.Rage_TeamCheck = value; rageLockedPlayer = nil end,
})
rageExtraSection:Textbox({
    Name = "Stomp key (fallback)",
    Flag = "supreme_rage_stompkey",
    Default = "E",
    Callback = function(value) S.Rage_StompKey = tostring(value or "E") end,
})
rageExtraSection:Textbox({
    Name = "Reload key",
    Flag = "supreme_rage_reloadkey",
    Default = "R",
    Callback = function(value) S.Rage_ReloadKey = tostring(value or "R") end,
})

rageSection:Dropdown({
    Name = "Target mode",
    Flag = flag("rage_mode"),
    Items = { "Nearest", "Selected", "All" },
    Default = "Nearest",
    Multi = false,
    Callback = function(value)
        S.Rage_Mode = value
        rageLockedPlayer = nil
    end,
})

local function ragePlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then table.insert(names, player.Name) end
    end
    table.sort(names)
    table.insert(names, 1, "None")
    return names
end

local ragePlayerDropdown = rageSection:Dropdown({
    Name = "Target player",
    Flag = flag("rage_target"),
    Items = ragePlayerNames(),
    Default = "None",
    Multi = false,
    Callback = function(value)
        S.Rage_TargetName = value
        rageLockedPlayer = nil
    end,
})

local function refreshRagePlayers()
    if alive() then ragePlayerDropdown:Refresh(ragePlayerNames()) end
end
Library:Connect(Players.PlayerAdded, refreshRagePlayers)
Library:Connect(Players.PlayerRemoving, function(player)
    if rageLockedPlayer == player then rageLockedPlayer = nil end
    task.defer(refreshRagePlayers)
end)
rageSection:Label("Selected / All: enable Full Rage; new targets need HP >= 1")
rageSection:Label("All: finish current victim, then choose the nearest living player")

rageSection:Toggle({
    Name = "Spin on target",
    Flag = flag("rage_spin"),
    Default = false,
    Callback = function(value)
        S.Rage_Spin = value
    end,
})


flag("rage_range") -- Removed search limit; preserve subsequent saved flag IDs.
rageExtraSection:Label("No target distance limit in any Rage mode")

rageExtraSection:Slider({
    Name = "Rage attacks / sec",
    Flag = flag("rage_rate"),
    Min = 1,
    Max = 60,
    Default = 15,
    Decimals = 1,
    Callback = function(value)
        S.Rage_Rate = value
    end,
})

rageExtraSection:Slider({
    Name = "Orbit radius",
    Flag = flag("rage_orbitradius"),
    Min = 3,
    Max = 40,
    Default = 8,
    Decimals = 1,
    Suffix = " studs",
    Callback = function(value)
        S.Rage_OrbitRadius = value
    end,
})

rageExtraSection:Slider({
    Name = "Orbit speed",
    Flag = flag("rage_orbitspeed"),
    Min = 2,
    Max = 40,
    Default = 12,
    Decimals = 1,
    Callback = function(value)
        S.Rage_OrbitSpeed = value
    end,
})

rageExtraSection:Slider({
    Name = "Orbit height",
    Flag = flag("rage_orbitheight"),
    Min = 0,
    Max = 20,
    Default = 5,
    Decimals = 1,
    Suffix = " studs",
    Callback = function(value)
        S.Rage_OrbitHeight = value
    end,
})

rageSection:Label("Down target, teleport, stomp twice, then find the next living player")

do
    local whitelistSection = CombatPage:Section({ Name = "Whitelist", Side = 2, Tab = "Rage" })
    local whitelistFlag = "supreme_whitelist_players"
    local dropdown
    local updating = false

    local function selectionCopy(values)
        local result = {}
        if type(values) == "table" then
            for _, name in ipairs(values) do table.insert(result, name) end
        end
        return result
    end

    local function refreshWhitelist()
        if not alive() or not dropdown or updating then return end
        updating = true
        local ok, err = pcall(function()
            WHITELIST.Refresh()
            local selected = selectionCopy(WHITELIST.Selection())
            dropdown:Refresh(WHITELIST.Names())
            dropdown:Set(selected)
        end)
        updating = false
        if not ok then warn("Whitelist list refresh failed: " .. tostring(err)) end
    end

    dropdown = whitelistSection:Dropdown({
        Name = "Protected players",
        Flag = whitelistFlag,
        Items = WHITELIST.Names(),
        Default = {},
        Multi = true,
        Callback = function(values)
            if updating then return end
            local selected = selectionCopy(values)
            WHITELIST.Apply(selected)
            if dropdown then refreshWhitelist() end
        end,
    })
    WHITELIST.UpdateUI = refreshWhitelist
    whitelistSection:Button({
        Name = "Clear whitelist",
        Callback = function()
            WHITELIST.Apply({})
            refreshWhitelist()
        end,
    })
    whitelistSection:Label("Selected players are skipped by aim, Rage, Stomp and hitboxes")
    Library:Connect(Players.PlayerAdded, function() refreshWhitelist() end)
    Library:Connect(Players.PlayerRemoving, function()
        task.defer(function() refreshWhitelist() end)
    end)
end

-- Combat: Exploits
do
    local mainSection = CombatPage:Section({ Name = "Instakill v6.2", Side = 1, Tab = "Exploits" })
    local targetsSection = CombatPage:Section({ Name = "Targets", Side = 2, Tab = "Exploits" })
    local aimSection = CombatPage:Section({ Name = "Aim / shooting", Side = 1, Tab = "Exploits" })
    local checksSection = CombatPage:Section({ Name = "Checks / visuals", Side = 2, Tab = "Exploits" })

    mainSection:Toggle({
        Name = "Instakill",
        Flag = flag("instakill"),
        Default = false,
        Callback = function(value) INSTA.SetEnabled(value) end,
    })
    -- Keep existing generated config IDs stable after replacing the old mag dump.
    flag("instakill_rate")
    flag("instakill_range")
    flag("instakill_mult")

    local function toggle(section, name, key)
        return section:Toggle({
            Name = name,
            Flag = "supreme_instakill_" .. string.lower(key),
            Default = INSTA.Config[key] == true,
            Callback = function(value) INSTA.SetOption(key, value == true) end,
        })
    end
    local function slider(section, name, key, minimum, maximum, step, suffix)
        return section:Slider({
            Name = name,
            Flag = "supreme_instakill_" .. string.lower(key),
            Min = minimum,
            Max = maximum,
            Default = INSTA.Config[key],
            Decimals = step,
            Suffix = suffix or "",
            Callback = function(value) INSTA.SetOption(key, value) end,
        })
    end

    toggle(mainSection, "Instakill shots", "Instakill")
    toggle(mainSection, "All players (includes new joins)", "InstakillAll")
    toggle(mainSection, "Only selected", "OnlySelected")
    toggle(mainSection, "Auto fire", "AutoFire")
    slider(mainSection, "Fire interval", "FireRate", 0.02, 1, 0.01, " s")
    slider(mainSection, "Instakill interval", "InstakillCooldown", 0.02, 1, 0.01, " s")
    slider(mainSection, "Range (0 = unlimited)", "InstakillRange", 0, 600, 1, " studs")
    toggle(mainSection, "Local HP effect (visual)", "LocalHealth")
    toggle(mainSection, "Force local HP effect", "ForceKill")
    mainSection:Label("Local HP does not confirm server damage")
    mainSection:Label("Rage and active Stomp take priority")
    INSTA.StatusLabel = mainSection:Label(INSTA.StatusText())

    local dropdown
    local updating = false
    local function selectionCopy(values)
        local copy = {}
        if type(values) == "table" then
            for _, name in ipairs(values) do
                if type(name) == "string" then table.insert(copy, name) end
            end
        end
        return copy
    end
    local function refreshTargets()
        if not alive() or not dropdown or updating then return end
        updating = true
        local ok, failure = pcall(function()
            local names = selectionCopy(INSTA.Names())
            local selected = selectionCopy(INSTA.Selection())
            dropdown:Refresh(names)
            dropdown:Set(selected)
            if INSTA.RefreshPlayerRows then INSTA.RefreshPlayerRows() end
        end)
        updating = false
        if not ok then warn("Instakill target list refresh failed: " .. tostring(failure)) end
    end
    dropdown = targetsSection:Dropdown({
        Name = "Target players",
        Flag = "supreme_instakill_players",
        Items = selectionCopy(INSTA.Names()),
        Default = {},
        Multi = true,
        Callback = function(values)
            if updating then return end
            INSTA.ApplySelection(selectionCopy(values))
            refreshTargets()
        end,
    })
    INSTA.RefreshUI = refreshTargets
    targetsSection:Button({
        Name = "Select all",
        Callback = function() INSTA.SelectAll(); refreshTargets() end,
    })
    targetsSection:Button({
        Name = "Clear selection",
        Callback = function() INSTA.ClearSelection(); refreshTargets() end,
    })
    targetsSection:Button({
        Name = "Fire selected",
        Callback = function()
            if not INSTA.QueueSelected() then notify("Select an eligible target and equip a gun") end
        end,
    })
    targetsSection:Label("Only selected + empty list = no target")
    targetsSection:Label("All mode follows the next eligible player")
    targetsSection:Label("Whole server: turn off Only selected")
    targetsSection:Label("Whitelist is applied before every action")

    INSTA.InfoLabel = targetsSection:Label(INSTA.PlayerInfoText())
    -- The library exposes SetVisibility rather than the label's Instances.
    -- Reuse ordered native rows, hide surplus rows, and let the section scroll.
    local infoRows = {}
    function INSTA.RefreshPlayerRows()
        if not alive() then return end
        local lines = INSTA.PlayerInfoLines()
        for index, data in ipairs(lines) do
            local row = infoRows[index]
            if not row then row = targetsSection:Label(data.Text); infoRows[index] = row end
            row:SetText(data.Text)
            row:SetVisibility(INSTA.Config.Debug == true)
        end
        for index = #lines + 1, #infoRows do infoRows[index]:SetVisibility(false) end
    end
    INSTA.RefreshPlayerRows()
    Library:Connect(Players.PlayerAdded, function() task.defer(refreshTargets) end)
    Library:Connect(Players.PlayerRemoving, function() task.defer(refreshTargets) end)

    toggle(aimSection, "Silent Aim", "SilentAim")
    toggle(aimSection, "Cam Lock", "CamLock")
    toggle(aimSection, "Weapon shoot hook", "UseGunHook")
    slider(aimSection, "FOV", "FOV", 30, 900, 1, " px")
    slider(aimSection, "Prediction", "Prediction", 0, 0.4, 0.01, " s")
    aimSection:Dropdown({
        Name = "Target part",
        Flag = "supreme_instakill_targetpart",
        Items = { "Head", "HumanoidRootPart", "UpperTorso", "Torso" },
        Default = INSTA.Config.TargetPart,
        Multi = false,
        Callback = function(value) INSTA.SetOption("TargetPart", value) end,
    })
    slider(aimSection, "Target refresh", "RefreshRate", 0.01, 0.25, 0.01, " s")
    aimSection:Label("No Mouse hook: Cam Lock fallback")
    hookStatus = aimSection:Label("Hook: checking...")

    toggle(checksSection, "Ignore walls", "IgnoreWalls")
    toggle(checksSection, "Team check", "TeamCheck")
    toggle(checksSection, "Skip K.O", "IgnoreKO")
    toggle(checksSection, "Skip grabbed", "IgnoreGrab")
    toggle(checksSection, "Health check", "HealthCheck")
    toggle(checksSection, "Target / selected highlights", "Highlight")
    toggle(checksSection, "Show FOV", "ShowFOV")
    toggle(checksSection, "Diagnostics", "Debug")

    -- The imported script does not implement the older TP Bullet feature.
    local tpSection = CombatPage:Section({ Name = "TP Bullet", Side = 2, Tab = "Exploits" })
    tpSection:Toggle({
        Name = "TP Bullet (raycast)",
        Flag = flag("tpbullet"),
        Default = false,
        Callback = function(value)
            S.TP_Bullet_Enabled = value and not EXPLOITS_LOCKED
            if EXPLOITS_LOCKED then return end
            if value then
                notify(installRaycastHooks() and "TP Bullet: raycast hooked" or "Raycast module not found")
            end
        end,
    })
    tpSection:Slider({
        Name = "Max origin distance",
        Flag = flag("tpbullet_range"),
        Min = 2,
        Max = 60,
        Default = 12,
        Decimals = 1,
        Suffix = " studs",
        Callback = function(value) S.TP_Bullet_Range = value end,
    })
    if EXPLOITS_LOCKED and tpSection.Items and tpSection.Items["Section"] then
        createWorkCover(tpSection.Items["Section"].Instance, {
            TextSize = 24, Rotation = -24, Transparency = 0.5, Corner = 15, ZIndex = 50,
        })
    end
end

end)() -- COMBAT_UI_INIT_END
end

do
-- Visuals
local espPlayersSection = VisualsPage:Section({ Name = "Players", Side = 1, Tab = "ESP" })
local espNpcSection = VisualsPage:Section({ Name = "NPC", Side = 1, Tab = "ESP" })
local espExtraSection = VisualsPage:Section({ Name = "Settings", Side = 2, Tab = "ESP" })
local worldSection = VisualsPage:Section({ Name = "World", Side = 1, Tab = "World" })

espPlayersSection:Toggle({
    Name = "Player ESP",
    Flag = flag("esp_players"),
    Default = false,
    Callback = function(value)
        S.ESP_Enabled = value
    end,
})

espPlayersSection:Toggle({
    Name = "Player Tracers",
    Flag = flag("tracers_players"),
    Default = false,
    Callback = function(value)
        S.Tracers_Enabled = value
    end,
})

espPlayersSection:Toggle({
    Name = "Enemy arrows",
    Flag = flag("esp_arrows"),
    Default = false,
    Callback = function(value)
        S.ESP_Arrows = value
    end,
})

espPlayersSection:Slider({
    Name = "Arrow radius",
    Flag = flag("esp_arrow_radius"),
    Min = 80,
    Max = 500,
    Default = 140,
    Decimals = 1,
    Suffix = " px",
    Callback = function(value)
        S.ESP_ArrowRadius = value
    end,
})

espNpcSection:Toggle({
    Name = "NPC ESP",
    Flag = flag("esp_npc"),
    Default = false,
    Callback = function(value)
        S.NPC_ESP_Enabled = value
    end,
})

espNpcSection:Toggle({
    Name = "NPC Tracers",
    Flag = flag("tracers_npc"),
    Default = false,
    Callback = function(value)
        S.NPC_Tracers_Enabled = value
    end,
})

espExtraSection:Toggle({
    Name = "Show health",
    Flag = flag("esp_health"),
    Default = false,
    Callback = function(value)
        S.ESP_Health = value
    end,
})

espExtraSection:Slider({
    Name = "Player max distance",
    Flag = flag("esp_dist"),
    Min = 100,
    Max = 5000,
    Default = 5000,
    Decimals = 10,
    Callback = function(value)
        S.ESP_MaxDistance = value
    end,
})

espExtraSection:Slider({
    Name = "NPC max distance",
    Flag = flag("esp_npc_dist"),
    Min = 100,
    Max = 5000,
    Default = 1500,
    Decimals = 10,
    Callback = function(value)
        S.NPC_ESP_MaxDistance = value
    end,
})

local espStyleSection = VisualsPage:Section({ Name = "Style", Side = 2, Tab = "ESP" })

espStyleSection:Label("Visible player color"):Colorpicker({
    Flag = flag("esp_color_visible"),
    Default = S.ESP_VisibleColor,
    Callback = function(color)
        S.ESP_VisibleColor = color
    end,
})

espStyleSection:Label("Enemy color"):Colorpicker({
    Flag = flag("esp_color_enemy"),
    Default = S.ESP_EnemyColor,
    Callback = function(color)
        S.ESP_EnemyColor = color
    end,
})

espStyleSection:Label("Team color"):Colorpicker({
    Flag = flag("esp_color_team"),
    Default = S.ESP_TeamColor,
    Callback = function(color)
        S.ESP_TeamColor = color
    end,
})

espStyleSection:Label("NPC color"):Colorpicker({
    Flag = flag("esp_color_npc"),
    Default = S.ESP_NPCColor,
    Callback = function(color)
        S.ESP_NPCColor = color
    end,
})

espStyleSection:Slider({
    Name = "Line thickness",
    Flag = flag("esp_thickness"),
    Min = 1,
    Max = 6,
    Default = 1.5,
    Decimals = 0.1,
    Callback = function(value)
        S.ESP_Thickness = value
    end,
})

espStyleSection:Slider({
    Name = "Text size",
    Flag = flag("esp_textsize"),
    Min = 10,
    Max = 28,
    Default = 14,
    Decimals = 1,
    Callback = function(value)
        S.ESP_TextSize = value
    end,
})

espStyleSection:Toggle({
    Name = "Filled boxes",
    Flag = flag("esp_filled"),
    Default = false,
    Callback = function(value)
        S.ESP_BoxFilled = value
    end,
})

espStyleSection:Dropdown({
    Name = "Box style",
    Flag = flag("esp_boxstyle"),
    Items = { "Full", "Corners" },
    Default = "Full",
    Multi = false,
    Callback = function(value)
        S.ESP_BoxStyle = value
    end,
})

espStyleSection:Dropdown({
    Name = "Tracer from",
    Flag = flag("esp_tracerfrom"),
    Items = { "Bottom", "Center" },
    Default = "Bottom",
    Multi = false,
    Callback = function(value)
        S.ESP_TracerFrom = value
    end,
})

espStyleSection:Toggle({
    Name = "Show name",
    Flag = flag("esp_showname"),
    Default = true,
    Callback = function(value)
        S.ESP_ShowName = value
    end,
})

espStyleSection:Toggle({
    Name = "Show distance",
    Flag = flag("esp_showdistance"),
    Default = true,
    Callback = function(value)
        S.ESP_ShowDistance = value
    end,
})

espStyleSection:Toggle({
    Name = "Text outline",
    Flag = flag("esp_textoutline"),
    Default = true,
    Callback = function(value)
        S.ESP_TextOutline = value
    end,
})

if not HasDrawing then
    espExtraSection:Label("Drawing API unavailable — ESP disabled")
end

worldSection:Toggle({
    Name = "Fullbright",
    Flag = flag("fullbright"),
    Default = false,
    Callback = function(value)
        S.Fullbright_Enabled = value
    end,
})

worldSection:Toggle({
    Name = "Anti-AFK",
    Flag = flag("antiafk"),
    Default = false,
    Callback = function(value)
        S.AntiAFK_Enabled = value
    end,
})

worldSection:Toggle({
    Name = "World snow",
    Flag = flag("world_snow"),
    Default = false,
    Callback = function(value)
        S.World_SnowEnabled = value
    end,
})

worldSection:Dropdown({
    Name = "World effect",
    Flag = flag("world_fxtype"),
    Items = { "Snow", "Stars", "Bubbles", "Confetti" },
    Default = "Snow",
    Multi = false,
    Callback = function(value)
        S.World_FxType = value
    end,
})

worldSection:Slider({
    Name = "World amount",
    Flag = flag("world_amount"),
    Min = 10,
    Max = 150,
    Default = 50,
    Decimals = 1,
    Callback = function(value)
        S.World_SnowAmount = value
    end,
})

worldSection:Slider({
    Name = "World speed",
    Flag = flag("world_speed"),
    Min = 20,
    Max = 250,
    Default = 90,
    Decimals = 1,
    Callback = function(value)
        S.World_SnowSpeed = value
    end,
})

worldSection:Slider({
    Name = "World brightness",
    Flag = flag("world_brightness"),
    Min = 10,
    Max = 100,
    Default = 80,
    Decimals = 1,
    Suffix = " %",
    Callback = function(value)
        S.World_FxBrightness = value
    end,
})

worldSection:Label("World snow works with the menu closed")
end

do
(function()
-- Movement
local spinSection = MovementPage:Section({ Name = "Spinbot", Side = 1, Tab = "Movement" })
local stompSection = MovementPage:Section({ Name = "Anti-Stomp", Side = 1, Tab = "Movement" })

spinSection:Toggle({
    Name = "Spinbot",
    Flag = flag("spin"),
    Default = false,
    Callback = function(value)
        S.Spinbot_Enabled = value
    end,
})

spinSection:Slider({
    Name = "Spin speed",
    Flag = flag("spin_speed"),
    Min = 90,
    Max = 2000,
    Default = 720,
    Decimals = 10,
    Suffix = " °/s",
    Callback = function(value)
        S.Spinbot_Speed = value
    end,
})

spinSection:Toggle({
    Name = "Tilt",
    Flag = flag("spin_tilt"),
    Default = false,
    Callback = function(value)
        S.Spinbot_Tilt = value
    end,
})

stompSection:Toggle({
    Name = "Anti-Stomp",
    Flag = flag("stomp"),
    Default = false,
    Callback = function(value)
        S.AntiStomp_Enabled = value
    end,
})

stompSection:Slider({
    Name = "Detection radius",
    Flag = flag("stomp_radius"),
    Min = 3,
    Max = 20,
    Default = 7,
    Decimals = 1,
    Callback = function(value)
        S.AntiStomp_Radius = value
    end,
})

stompSection:Toggle({
    Name = "Anti-Ragdoll",
    Flag = flag("stomp_ragdoll"),
    Default = true,
    Callback = function(value)
        S.AntiStomp_NoRagdoll = value
    end,
})

local speedSection = MovementPage:Section({ Name = "Speed", Side = 2, Tab = "Movement" })
local jumpSection = MovementPage:Section({ Name = "Jump", Side = 2, Tab = "Movement" })
local flySection = MovementPage:Section({ Name = "Fly", Side = 2, Tab = "Movement" })
local moveExtraSection = MovementPage:Section({ Name = "Extra", Side = 2, Tab = "Movement" })
local teleportSection = MovementPage:Section({ Name = "Teleport", Side = 2, Tab = "Movement" })

speedSection:Toggle({
    Name = "Speed",
    Flag = flag("speed"),
    Default = false,
    Callback = function(value)
        S.Speed_Enabled = value
    end,
})

setSpeedEnabled = function(value)
    local setter = Library.SetFlags[flagMap["speed"]]
    if setter then setter(value) else S.Speed_Enabled = value end
end
speedSection:Label("Applies once; stops if the game resets speed")

speedSection:Slider({
    Name = "Walkspeed",
    Flag = flag("speed_value"),
    Min = 16,
    Max = 120,
    Default = 60,
    Decimals = 1,
    Callback = function(value)
        S.Speed_Value = value
    end,
})

jumpSection:Toggle({
    Name = "Jump Power",
    Flag = flag("jump"),
    Default = false,
    Callback = function(value)
        S.Jump_Enabled = value
    end,
})

jumpSection:Slider({
    Name = "Jump power",
    Flag = flag("jump_value"),
    Min = 50,
    Max = 500,
    Default = 90,
    Decimals = 1,
    Callback = function(value)
        S.Jump_Value = value
    end,
})

flySection:Toggle({
    Name = "Fly",
    Flag = flag("fly"),
    Default = false,
    Callback = function(value)
        S.Fly_Enabled = value
    end,
})

flySection:Slider({
    Name = "Fly speed",
    Flag = flag("fly_speed"),
    Min = 20,
    Max = 1500,
    Default = 300,
    Decimals = 1,
    Callback = function(value)
        S.Fly_Speed = value
    end,
})

flySection:Label("WASD — полёт, Space — вверх, L.Ctrl — вниз")

moveExtraSection:Toggle({
    Name = "Infinite Jump",
    Flag = flag("infjump"),
    Default = false,
    Callback = function(value)
        S.InfiniteJump_Enabled = value
    end,
})

moveExtraSection:Toggle({
    Name = "Noclip",
    Flag = flag("noclip"),
    Default = false,
    Callback = function(value)
        S.Noclip_Enabled = value
    end,
})

moveExtraSection:Toggle({
    Name = "Anti-Fling",
    Flag = flag("antifling"),
    Default = false,
    Callback = function(value)
        S.AntiFling_Enabled = value
    end,
})

teleportSection:Button({
    Name = "TP to nearest player",
    Callback = function()
        if teleportToNearestPlayer() then
            notify("Teleported to nearest player")
        else
            notify("Player not found")
        end
    end,
})

teleportSection:Label("Teleports move in short steps so the game does not flag them")

-- Players
local playerActionsSection = PlayerPage:Section({ Name = "Actions", Side = 1, Tab = "Players" })
local spectateSection = PlayerPage:Section({ Name = "Spectator", Side = 2, Tab = "Players" })

playerActionsSection:Label("Client-side actions only")
playerActionsSection:Label("Drop / Kick other players is not available")

playerActionsSection:Button({
    Name = "TP to nearest player",
    Callback = function()
        if teleportToNearestPlayer() then
            notify("Teleported to nearest player")
        else
            notify("Player not found")
        end
    end,
})

local playerListLabel = playerActionsSection:Label("Players: —")
local playerListFrame = nil
local playerRowButtons = {}
local playerListSignature = ""

local function refreshPlayerList(force)
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player)
        end
    end
    table.sort(players, function(a, b)
        return string.lower(a.Name) < string.lower(b.Name)
    end)

    local signature = {}
    for _, player in ipairs(players) do
        table.insert(signature, player.Name)
    end
    local newSignature = table.concat(signature, "|")
    if not force and newSignature == playerListSignature then
        return
    end
    playerListSignature = newSignature

    for _, row in ipairs(playerRowButtons) do
        row:Destroy()
    end
    playerRowButtons = {}

    if playerListFrame then
        for index, player in ipairs(players) do
            local row = Instance.new("TextButton")
            row.Name = player.Name
            row.Size = UDim2.new(1, -4, 0, 26)
            row.BackgroundColor3 = Library.Theme.Element or Library.Theme.Inline or Library.Theme.Background
            row.BackgroundTransparency = 0.25
            row.BorderSizePixel = 0
            row.AutoButtonColor = true
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.TextSize = 13
            row.Font = Enum.Font.Gotham
            row.TextColor3 = Library.Theme.Text
            row.Text = string.format("  %s  [%s]", player.Name, player.Team and player.Team.Name or "—")
            row.LayoutOrder = index

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = row

            pcall(function()
                row.MouseButton1Click:Connect(function()
                    S.Spectate_Name = player.Name
                    S.Spectate_Enabled = true
                    startSpectateByName(player.Name)
                    notify("Spectating: " .. player.Name)
                end)
            end)
            row.Parent = playerListFrame
            table.insert(playerRowButtons, row)
        end
    end

    playerListLabel:SetText(string.format("Players (%d) — click a row to spectate", #players))
end

local playerListContent = playerActionsSection.Items and playerActionsSection.Items["Content"]
if playerListContent then
    playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Name = "PlayerList"
    playerListFrame.Size = UDim2.new(1, 0, 0, 220)
    playerListFrame.BackgroundColor3 = Library.Theme.Inline or Library.Theme.Background
    playerListFrame.BackgroundTransparency = 0.45
    playerListFrame.BorderSizePixel = 0
    playerListFrame.ScrollBarThickness = 2
    playerListFrame.ScrollBarImageColor3 = Library.Theme.Outline
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerListFrame.ClipsDescendants = true
    playerListFrame.LayoutOrder = 5

    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 4)
    listPadding.PaddingBottom = UDim.new(0, 4)
    listPadding.PaddingLeft = UDim.new(0, 4)
    listPadding.PaddingRight = UDim.new(0, 4)
    listPadding.Parent = playerListFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 3)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = playerListFrame

    playerListFrame.Parent = playerListContent.Instance
    refreshPlayerList(true)
end

task.spawn(function()
    while alive() do
        task.wait(2)
        pcall(refreshPlayerList)
    end
end)

playerActionsSection:Button({
    Name = "Refresh player list",
    Callback = function()
        refreshPlayerList(true)
    end,
})

playerActionsSection:Button({
    Name = "Spectate nearest player",
    Callback = function()
        local hrp = getHRP()
        local best = nil
        local bestDistance = nil
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local otherHrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if otherHrp and humanoid and humanoid.Health > 0 then
                    local distance = hrp and (otherHrp.Position - hrp.Position).Magnitude or 0
                    if not bestDistance or distance < bestDistance then
                        best = player
                        bestDistance = distance
                    end
                end
            end
        end

        if not best then
            notify("Player not found")
            return
        end

        S.Spectate_Name = best.Name
        S.Spectate_Enabled = true
        startSpectateByName(best.Name)
    end,
})

spectateSection:Textbox({
    Name = "Target name",
    Flag = flag("spectate_name"),
    Default = "",
    Callback = function(value)
        S.Spectate_Name = value
    end,
})

spectateSection:Toggle({
    Name = "Spectate",
    Flag = flag("spectate"),
    Default = false,
    Callback = function(value)
        S.Spectate_Enabled = value
        if value then
            startSpectateByName(S.Spectate_Name or "")
        else
            stopSpectating()
        end
    end,
})

spectateSection:Button({
    Name = "Stop spectating",
    Callback = stopSpectating,
})

spectateSection:Button({
    Name = "Teleport to target",
    Callback = function()
        if teleportToPlayerByName(S.Spectate_Name or "") then
            notify("Teleported to target")
        else
            notify("Target not found")
        end
    end,
})

end)() -- MOVEMENT_PLAYERS_UI_INIT_END
end


do
local adminSection = PlayerPage:Section({ Name = "Admins online", Side = 2, Tab = "Players" })
adminSection:Toggle({
    Name = "Admin detector", Flag = "supreme_admin_detector", Default = true,
    Callback = function(value) ADMIN.SetEnabled(value) end,
})
adminSection:Toggle({
    Name = "Show admins panel", Flag = "supreme_admin_panel", Default = true,
    Callback = function(value) ADMIN.ShowPanel = value; ADMIN.Render() end,
})
adminSection:Toggle({
    Name = "Notify on admin join", Flag = "supreme_admin_notify", Default = true,
    Callback = function(value) ADMIN.NotifyEnabled = value end,
})
adminSection:Toggle({
    Name = "Join sound", Flag = "supreme_admin_sound", Default = true,
    Callback = function(value) ADMIN.SoundEnabled = value; if not value then ADMIN.StopSound() end end,
})
adminSection:Textbox({
    Name = "Alert audio ID", Flag = "supreme_admin_soundid", Default = "6753645454",
    Callback = function(value)
        local id = ADMIN.NormalizeSoundId(value)
        if id then ADMIN.SoundId = id else notify("Enter a valid Roblox Audio ID") end
    end,
})
adminSection:Slider({
    Name = "Alert volume", Flag = "supreme_admin_volume", Min = 0, Max = 3, Default = 1, Decimals = 0.1,
    Callback = function(value) ADMIN.Volume = value end,
})
adminSection:Toggle({
    Name = "Possible staff by symbols", Flag = "supreme_admin_symbols", Default = false,
    Callback = function(value)
        ADMIN.UseSymbols = value
        ADMIN.Cache = {}
        if not value then
            for id, entry in pairs(ADMIN.Entries) do
                if entry.Confidence == "possible" then ADMIN.Entries[id] = nil end
            end
        end
        if ADMIN.Started then ADMIN.Scan(true) end
        ADMIN.Render()
    end,
})
adminSection:Button({Name = "Test join sound", Callback = function()
    if not ADMIN.PlayAlert(true) then notify("Alert sound could not be played") end
end})
adminSection:Button({Name = "Rescan admins", Callback = function() ADMIN.Scan(true) end})
adminSection:Button({Name = "Stop admin spectate", Callback = function() stopSpectating(); ADMIN.Render() end})
adminSection:Label("Click a row in the admins panel to spectate")
adminSection:Label("Rules copied from the supplied script; symbols are unverified")
ADMIN.Start()
end

do
-- Client
local infoSection = ClientPage:Section({ Name = "Session", Side = 1, Tab = "Client" })
menuSection = ClientPage:Section({ Name = "Menu", Side = 1, Tab = "Client" })

fpsLabel = infoSection:Label("FPS: —")
pingLabel = infoSection:Label("Ping: —")
targetLabel = infoSection:Label("Target: —")
local drawingLabel = infoSection:Label(HasDrawing and "Drawing: ready" or "Drawing: missing")

menuSection:Label("Menu: F2 / V / Insert")
menuSection:Label("Fly: WASD · Space вверх · L.Ctrl вниз")
menuSection:Label("Unload restores lighting, movement, drawings and hooks")

local bindsSection = ClientPage:Section({ Name = "Binds", Side = 2, Tab = "Client" })
bindsSection:Label("F2 / V / Insert — open / close menu")
bindsSection:Label("RMB — aimbot")
bindsSection:Label("LMB — instant ammo refill")
bindsSection:Label("WASD / Space / L.Ctrl — fly")

local musicSection = ClientPage:Section({ Name = "Music", Side = 2, Tab = "Client" })
musicStatusLabel = musicSection:Label("No playing music")

musicSection:Slider({
    Name = "Volume scale",
    Flag = flag("music_volume"),
    Min = 0,
    Max = 2,
    Default = 1,
    Decimals = 0.05,
    Callback = function(value)
        S.Music_Volume = value
        applyMusicVolume()
    end,
})

musicSection:Button({
    Name = "Pause",
    Callback = function()
        pauseMusic()
        musicStatusLabel:SetText("Paused")
    end,
})

musicSection:Button({
    Name = "Resume",
    Callback = function()
        resumeMusic()
        musicStatusLabel:SetText(getMusicListText())
    end,
})

musicSection:Button({
    Name = "Switch track",
    Callback = function()
        local sound = switchMusic()
        if sound then
            musicStatusLabel:SetText("Playing: " .. sound.Name)
        else
            musicStatusLabel:SetText("No playing music")
        end
    end,
})

musicSection:Button({
    Name = "Stop",
    Callback = function()
        stopMusic()
        musicStatusLabel:SetText("Stopped")
    end,
})

musicSection:Label("Controls in-game Sound instances only")
musicSection:Label("SoundCloud web API is blocked by Roblox")
end

-- ============================================================
-- BINDS
-- ============================================================

do
local BindsPage = Window:Page({ Name = "Binds", Icon = ICONS.Client })
local bindFunctionsSection = BindsPage:Section({ Name = "Functions", Side = 1, Tab = "Binds" })
local bindActionsSection = BindsPage:Section({ Name = "Actions", Side = 1, Tab = "Binds" })
local bindListSection = BindsPage:Section({ Name = "Keybind list", Side = 2, Tab = "Binds" })

bindListSection:Label("F2 / V / Insert — menu")
bindListSection:Label("RMB — aimbot hold")
bindListSection:Label("LMB — ammo refill")
bindListSection:Label("WASD / Space / L.Ctrl — fly")

keyName = function(keybind)
    local key = keybind.Key
    if key == nil or key == "" then
        return "None"
    end
    local text = tostring(key)
    text = text:gsub("^Enum%.KeyCode%.", "")
    text = text:gsub("^Enum%.UserInputType%.", "")
    return text
end

local function registerBind(name, keybind, isActive)
    local label = bindListSection:Label(name .. " — None")
    table.insert(bindEntries, {
        Name = name,
        Keybind = keybind,
        IsActive = isActive or function() return false end,
        Label = label,
        LastText = "",
    })
end

local function addToggleBind(title, stateKey, flagName)
    local keybind
    keybind = bindFunctionsSection:Label(title):Keybind({
        Flag = flag("bind_" .. flagName),
        Mode = "Toggle",
        Callback = function(value)
            if not bindsReady then
                return
            end
            if EXPLOITS_LOCKED and stateKey == "TP_Bullet_Enabled" then
                S[stateKey] = false
                notify(title .. ": IN WORK")
                return
            end
            local target = flagMap[flagName]
            if not target or not Library.SetFlags[target] then
                return
            end
            if keybind and keybind.Mode == "Hold" then
                Library.SetFlags[target](value == true)
            else
                Library.SetFlags[target](not (S[stateKey] == true))
            end
        end,
    })
    registerBind(title, keybind, function()
        if stateKey == "TP_Bullet_Enabled" and EXPLOITS_LOCKED then
            return false
        end
        return S[stateKey] == true
    end)
end

local function addModeBind(title)
    local keybind
    keybind = bindFunctionsSection:Label(title):Keybind({
        Flag = flag("bind_silent_aim"),
        Mode = "Toggle",
        Callback = function(value)
            if not bindsReady then
                return
            end
            local newMode
            if keybind and keybind.Mode == "Hold" then
                newMode = value and "Silent" or "Normal"
            else
                newMode = (S.Aimbot_Mode == "Silent") and "Normal" or "Silent"
            end
            local target = flagMap["aim_mode"]
            if target and Library.SetFlags[target] then
                Library.SetFlags[target](newMode)
            else
                S.Aimbot_Mode = newMode
            end
        end,
    })
    registerBind(title, keybind, function()
        return S.Aimbot_Mode == "Silent"
    end)
end

local function addActionBind(title, action)
    local keybind
    keybind = bindActionsSection:Label(title):Keybind({
        Flag = flag("action_" .. title),
        Mode = "Toggle",
        Callback = function(value)
            if not bindsReady then
                return
            end
            if keybind and keybind.Mode == "Hold" and value ~= true then
                return
            end
            action()
        end,
    })
    -- One-shot actions have no enabled state, so they stay out of the active-functions overlay.
    registerBind(title, keybind)
end

addToggleBind("Aimbot", "Aimbot_Enabled", "aimbot")
addModeBind("Silent aim")
addToggleBind("Rage", "Rage_Enabled", "rage")
addToggleBind("Player ESP", "ESP_Enabled", "esp_players")
addToggleBind("Tracers", "Tracers_Enabled", "tracers_players")
addToggleBind("TP Bullet", "TP_Bullet_Enabled", "tpbullet")
addToggleBind("Hitbox", "Hitbox_Enabled", "hitbox")
addToggleBind("Auto Stomp", "AutoStomp_Enabled", "autostomp")
addToggleBind("Anti-Ragdoll", "AntiStomp_NoRagdoll", "stomp_ragdoll")
addToggleBind("Instakill", "Instakill_Enabled", "instakill")
addToggleBind("Speed", "Speed_Enabled", "speed")
addToggleBind("Fly", "Fly_Enabled", "fly")
addToggleBind("Infinite Jump", "InfiniteJump_Enabled", "infjump")
addToggleBind("Noclip", "Noclip_Enabled", "noclip")
addToggleBind("Fullbright", "Fullbright_Enabled", "fullbright")

addActionBind("Switch track", function()
    local sound = switchMusic()
    if sound then
        notify("Playing: " .. sound.Name)
    end
    return sound ~= nil
end)

bindListSection:Button({
    Name = "Reset all binds",
    Callback = function()
        for _, entry in ipairs(bindEntries) do
            entry.Keybind:Reset()
            entry.LastText = entry.Name .. " — None [Toggle]"
            entry.Label:SetText(entry.LastText)
        end
        notify("Бинды сброшены")
    end,
})
bindListSection:Label("Right-click a key to change mode")
bindsReady = true
end

-- ============================================================
-- SCREEN OVERLAYS: WATERMARK + KEYBIND LIST
-- ============================================================

local Overlays = (function()
    local function getParent()
        local ok, parent = pcall(function()
            if type(gethui) == "function" then
                return gethui()
            end
            return game:GetService("CoreGui")
        end)
        if ok and parent then
            return parent
        end
        return LocalPlayer:FindFirstChild("PlayerGui")
    end

    local parent = getParent()
    if not parent then
        return {
            update = function() end,
            destroy = function() end,
            setWatermarkVisible = function() end,
            setKeybindVisible = function() end,
        }
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SupremeOverlays"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 20
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent

    local dragState = nil

    local function makeDraggable(frame)
        pcall(function()
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragState = {
                        Frame = frame,
                        Start = input.Position,
                        Origin = frame.Position,
                        Input = input,
                    }
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End
                            and dragState and dragState.Input == input then
                            dragState = nil
                        end
                    end)
                end
            end)
        end)
    end

    Library:Connect(UserInputService.InputChanged, function(input)
        if dragState and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragState.Start
            dragState.Frame.Position = UDim2.new(
                dragState.Origin.X.Scale, dragState.Origin.X.Offset + delta.X,
                dragState.Origin.Y.Scale, dragState.Origin.Y.Offset + delta.Y
            )
        end
    end)

    local theme = Library.Theme or {}

    local function color(name, fallback)
        local value = theme[name]
        if typeof(value) == "Color3" then
            return value
        end
        return fallback
    end
    -- Watermark
    local wm = Instance.new("Frame")
    wm.Name = "Watermark"
    wm.AnchorPoint = Vector2.new(0.5, 0)
    wm.Position = UDim2.new(0.5, 0, 0, 16)
    wm.AutomaticSize = Enum.AutomaticSize.X
    wm.Size = UDim2.fromOffset(0, 34)
    wm.BackgroundColor3 = color("Background", Color3.fromRGB(20, 22, 30))
    wm.BackgroundTransparency = 0.08
    wm.BorderSizePixel = 0
    wm.ZIndex = 2
    wm.Parent = gui
    makeDraggable(wm)

    local wmCorner = Instance.new("UICorner")
    wmCorner.CornerRadius = UDim.new(0, 10)
    wmCorner.Parent = wm

    local wmPadding = Instance.new("UIPadding")
    wmPadding.PaddingLeft = UDim.new(0, 8)
    wmPadding.PaddingRight = UDim.new(0, 10)
    wmPadding.Parent = wm

    local wmLayout = Instance.new("UIListLayout")
    wmLayout.FillDirection = Enum.FillDirection.Horizontal
    wmLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    wmLayout.Padding = UDim.new(0, 8)
    wmLayout.SortOrder = Enum.SortOrder.LayoutOrder
    wmLayout.Parent = wm

    local icon = Instance.new("Frame")
    icon.LayoutOrder = 1
    icon.Size = UDim2.fromOffset(24, 24)
    icon.BackgroundTransparency = 1
    icon.Parent = wm

    local wmBarrel = Instance.new("Frame")
    wmBarrel.Size = UDim2.fromOffset(15, 3)
    wmBarrel.Position = UDim2.fromOffset(6, 9)
    wmBarrel.BackgroundColor3 = color("Text", Color3.fromRGB(255, 255, 255))
    wmBarrel.BorderSizePixel = 0
    wmBarrel.ZIndex = 3
    wmBarrel.Parent = icon

    local wmSlide = Instance.new("Frame")
    wmSlide.Size = UDim2.fromOffset(10, 4)
    wmSlide.Position = UDim2.fromOffset(5, 6)
    wmSlide.BackgroundColor3 = color("Accent", Color3.fromRGB(210, 40, 50))
    wmSlide.BorderSizePixel = 0
    wmSlide.ZIndex = 3
    wmSlide.Parent = icon

    local wmGrip = Instance.new("Frame")
    wmGrip.Size = UDim2.fromOffset(4, 9)
    wmGrip.Position = UDim2.fromOffset(8, 12)
    wmGrip.Rotation = 18
    wmGrip.BackgroundColor3 = color("Accent", Color3.fromRGB(210, 40, 50))
    wmGrip.BorderSizePixel = 0
    wmGrip.ZIndex = 3
    wmGrip.Parent = icon

    local wmMoney = Instance.new("TextLabel")
    wmMoney.Size = UDim2.fromOffset(10, 12)
    wmMoney.Position = UDim2.fromOffset(18, -3)
    wmMoney.BackgroundTransparency = 1
    wmMoney.Font = Enum.Font.GothamBold
    wmMoney.Text = "$"
    wmMoney.TextSize = 13
    wmMoney.TextColor3 = Color3.fromRGB(90, 235, 130)
    wmMoney.ZIndex = 3
    wmMoney.Parent = icon

    local function separator(order)
        local line = Instance.new("Frame")
        line.LayoutOrder = order
        line.Size = UDim2.fromOffset(1, 16)
        line.BackgroundColor3 = color("Outline", Color3.fromRGB(80, 80, 90))
        line.BorderSizePixel = 0
        line.Parent = wm
        return line
    end

    local function watermarkLabel(order, text, size, bold)
        local label = Instance.new("TextLabel")
        label.LayoutOrder = order
        label.AutomaticSize = Enum.AutomaticSize.X
        label.Size = UDim2.fromOffset(0, 16)
        label.BackgroundTransparency = 1
        label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
        label.Text = text
        label.TextSize = size
        label.TextColor3 = color("Text", Color3.fromRGB(255, 255, 255))
        label.Parent = wm
        return label
    end

    separator(2)
    local wmName = watermarkLabel(3, "SUPREME", 16, true)
    separator(4)
    local wmUser = watermarkLabel(5, LocalPlayer.Name, 13, false)
    separator(6)
    local wmFps = watermarkLabel(7, "0 FPS", 13, false)
    separator(8)
    local wmTime = watermarkLabel(9, "00:00:00", 13, false)
    -- Keybind list
    local kb = Instance.new("Frame")
    kb.Name = "KeybindList"
    kb.Position = UDim2.fromOffset(20, 150)
    kb.Size = UDim2.fromOffset(250, 0)
    kb.AutomaticSize = Enum.AutomaticSize.Y
    kb.BackgroundColor3 = color("Background", Color3.fromRGB(20, 22, 30))
    kb.BackgroundTransparency = 0.1
    kb.BorderSizePixel = 0
    kb.ZIndex = 2
    kb.Parent = gui
    makeDraggable(kb)

    local kbCorner = Instance.new("UICorner")
    kbCorner.CornerRadius = UDim.new(0, 10)
    kbCorner.Parent = kb

    local kbPadding = Instance.new("UIPadding")
    kbPadding.PaddingTop = UDim.new(0, 8)
    kbPadding.PaddingBottom = UDim.new(0, 8)
    kbPadding.PaddingLeft = UDim.new(0, 10)
    kbPadding.PaddingRight = UDim.new(0, 10)
    kbPadding.Parent = kb

    local kbLayout = Instance.new("UIListLayout")
    kbLayout.Padding = UDim.new(0, 3)
    kbLayout.SortOrder = Enum.SortOrder.LayoutOrder
    kbLayout.Parent = kb
    local kbTitle = Instance.new("TextLabel")
    kbTitle.LayoutOrder = 1
    kbTitle.Size = UDim2.new(1, 0, 0, 16)
    kbTitle.BackgroundTransparency = 1
    kbTitle.Font = Enum.Font.GothamBold
    kbTitle.TextXAlignment = Enum.TextXAlignment.Left
    kbTitle.Text = "KEYBINDS"
    kbTitle.TextSize = 13
    kbTitle.TextColor3 = color("Accent", Color3.fromRGB(210, 40, 50))
    kbTitle.Parent = kb

    local kbRows = {}
    local kbRowsByEntry = {}
    local keybindVisible = S.KeybindList_Enabled == true

    local function updateActiveRows()
        local rows, present = {}, {}
        for _, entry in ipairs(bindEntries) do
            local ok, enabled = false, false
            if entry.IsActive then ok, enabled = pcall(entry.IsActive) end
            if ok and enabled == true then
                local row = kbRowsByEntry[entry]
                if not row then
                    local frame = Instance.new("Frame")
                    frame.Name = "BindRow"
                    frame.Size = UDim2.new(1, 0, 0, 15)
                    frame.BackgroundTransparency = 1
                    frame.Parent = kb
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Font = Enum.Font.Gotham
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.TextTruncate = Enum.TextTruncate.AtEnd
                    label.TextSize = 12
                    label.Parent = frame
                    row = { Frame = frame, Label = label, Entry = entry }
                    kbRowsByEntry[entry] = row
                end
                table.insert(rows, row)
                present[entry] = true
                row.Frame.LayoutOrder = #rows + 1
                row.Label.TextColor3 = S.Overlay_TextColor or color("Text", Color3.fromRGB(255, 255, 255))
                local key = entry.Keybind and keyName(entry.Keybind) or "None"
                local mode = entry.Keybind and entry.Keybind.Mode or "Toggle"
                local text = string.format("%s — %s [%s]", entry.Name, key, mode)
                if row.Label.Text ~= text then row.Label.Text = text end
            end
        end
        for entry, row in pairs(kbRowsByEntry) do
            if not present[entry] then
                row.Frame:Destroy()
                kbRowsByEntry[entry] = nil
            end
        end
        kbRows = rows
        kb.Visible = keybindVisible and #kbRows > 0
    end

    updateActiveRows()
    local function applyColors()
        local bg = S.Overlay_BGColor or color("Background", Color3.fromRGB(20, 22, 30))
        local textColor = S.Overlay_TextColor or color("Text", Color3.fromRGB(255, 255, 255))
        wm.BackgroundColor3 = bg
        kb.BackgroundColor3 = bg
        wmName.TextColor3 = textColor
        wmUser.TextColor3 = textColor
        wmFps.TextColor3 = textColor
        wmTime.TextColor3 = textColor
        kbTitle.TextColor3 = color("Accent", Color3.fromRGB(210, 40, 50))
        wmBarrel.BackgroundColor3 = textColor
        for _, row in ipairs(kbRows) do
            row.Label.TextColor3 = textColor
        end
    end
    local function update()
        wmUser.Text = LocalPlayer.Name
        wmFps.Text = tostring(fpsValue) .. " FPS"
        wmTime.Text = os.date("%H:%M:%S")
        applyColors()
        updateActiveRows()
    end
    local function setWatermarkVisible(visible)
        wm.Visible = visible
    end

    local function setKeybindVisible(visible)
        keybindVisible = visible == true
        updateActiveRows()
    end

    setWatermarkVisible(S.Watermark_Enabled)
    setKeybindVisible(S.KeybindList_Enabled)
    update()
    local keybindClock = 0
    Library:Connect(RunService.Heartbeat, function(dt)
        if not alive() then return end
        keybindClock += dt
        if keybindClock < 0.1 then return end
        keybindClock = 0
        updateActiveRows()
    end)

    task.spawn(function()
        while alive() do
            task.wait(1)
            pcall(update)
        end
    end)

    return {
        update = update,
        destroy = function()
            dragState = nil
            gui:Destroy()
        end,
        setWatermarkVisible = setWatermarkVisible,
        setKeybindVisible = setKeybindVisible,
    }
end)()

-- Locked legacy features use section covers; the imported Instakill is available.
local WorkOverlay = { destroy = function() end }


do
-- Menu customization
local backdropSection = MenuPage:Section({ Name = "Фон при открытии", Side = 1, Tab = "Menu" })
local snowSection = MenuPage:Section({ Name = "Снег", Side = 1, Tab = "Menu" })
local colorSection = MenuPage:Section({ Name = "Цвета интерфейса", Side = 2, Tab = "Menu" })

backdropSection:Label("Мягкое затемнение игры, пока меню открыто")

backdropSection:Toggle({
    Name = "Затемнение фона",
    Flag = flag("menu_dim"),
    Default = true,
    Callback = function(value)
        S.Menu_DimEnabled = value
    end,
})

backdropSection:Slider({
    Name = "Сила затемнения",
    Flag = flag("menu_dimstrength"),
    Min = 5,
    Max = 100,
    Default = 45,
    Decimals = 1,
    Suffix = " %",
    Callback = function(value)
        S.Menu_DimStrength = value
    end,
})

backdropSection:Label("Цвет затемнения"):Colorpicker({
    Flag = flag("menu_dimcolor"),
    Default = S.Menu_DimColor,
    Callback = function(color)
        S.Menu_DimColor = color
    end,
})

snowSection:Label("Частицы идут по фону, пока меню открыто")

snowSection:Toggle({
    Name = "Снег",
    Flag = flag("menu_snow"),
    Default = true,
    Callback = function(value)
        S.Menu_SnowEnabled = value
    end,
})

snowSection:Slider({
    Name = "Количество",
    Flag = flag("menu_snowamount"),
    Min = 10,
    Max = 150,
    Default = 60,
    Decimals = 1,
    Callback = function(value)
        S.Menu_SnowAmount = value
    end,
})

snowSection:Slider({
    Name = "Скорость",
    Flag = flag("menu_snowspeed"),
    Min = 20,
    Max = 250,
    Default = 90,
    Decimals = 1,
    Callback = function(value)
        S.Menu_SnowSpeed = value
    end,
})

snowSection:Dropdown({
    Name = "Эффект",
    Flag = flag("menu_fxtype"),
    Items = { "Snow", "Stars", "Bubbles", "Confetti" },
    Default = "Snow",
    Multi = false,
    Callback = function(value)
        S.Menu_FxType = value
    end,
})

snowSection:Slider({
    Name = "Яркость",
    Flag = flag("menu_fxbrightness"),
    Min = 10,
    Max = 100,
    Default = 80,
    Decimals = 1,
    Suffix = " %",
    Callback = function(value)
        S.Menu_FxBrightness = value
    end,
})

local patternSection = MenuPage:Section({ Name = "Узор фона", Side = 2, Tab = "Menu" })

patternSection:Dropdown({
    Name = "Pattern",
    Flag = flag("menu_pattern"),
    Items = { "None", "Gradient", "Grid", "Dots", "Scanlines", "Diagonal", "Crosshatch" },
    Default = "None",
    Multi = false,
    Callback = function(value)
        S.Menu_BGPattern = value
    end,
})

patternSection:Slider({
    Name = "Заметность узора",
    Flag = flag("menu_pattern_opacity"),
    Min = 2,
    Max = 35,
    Default = S.Menu_PatternOpacity,
    Decimals = 1,
    Suffix = " %",
    Callback = function(value)
        S.Menu_PatternOpacity = value
    end,
})

patternSection:Label("Gradient color A"):Colorpicker({
    Flag = flag("menu_grad_a"),
    Default = S.Menu_BGGradientA,
    Callback = function(color)
        S.Menu_BGGradientA = color
    end,
})

patternSection:Label("Gradient color B"):Colorpicker({
    Flag = flag("menu_grad_b"),
    Default = S.Menu_BGGradientB,
    Callback = function(color)
        S.Menu_BGGradientB = color
    end,
})

patternSection:Slider({
    Name = "Gradient rotation",
    Flag = flag("menu_grad_rot"),
    Min = 0,
    Max = 360,
    Default = 0,
    Decimals = 1,
    Suffix = " °",
    Callback = function(value)
        S.Menu_BGGradientRot = value
    end,
})

local overlaySection = MenuPage:Section({ Name = "Оверлеи", Side = 2, Tab = "Menu" })

overlaySection:Toggle({
    Name = "Watermark",
    Flag = flag("overlay_watermark"),
    Default = true,
    Callback = function(value)
        S.Watermark_Enabled = value
        Overlays.setWatermarkVisible(value)
    end,
})

overlaySection:Toggle({
    Name = "Keybind list on screen",
    Flag = flag("overlay_binds"),
    Default = true,
    Callback = function(value)
        S.KeybindList_Enabled = value
        Overlays.setKeybindVisible(value)
    end,
})

overlaySection:Label("Цвет плашек"):Colorpicker({
    Flag = flag("overlay_bg"),
    Default = S.Overlay_BGColor or Library.Theme.Background,
    Callback = function(color)
        S.Overlay_BGColor = color
        Overlays.update()
    end,
})

overlaySection:Label("Цвет текста оверлеев"):Colorpicker({
    Flag = flag("overlay_text"),
    Default = S.Overlay_TextColor or Library.Theme.Text,
    Callback = function(color)
        S.Overlay_TextColor = color
        Overlays.update()
    end,
})

overlaySection:Label("Плашки можно перетаскивать мышью")

local THEME_NAMES = {
    Background = "Фон",
    Outline = "Обводка",
    Inline = "Внутренний фон",
    Accent = "Акцент",
    Text = "Текст",
    Element = "Элементы",
}

for themeKey, themeValue in pairs(Library.Theme) do
    colorSection:Label(THEME_NAMES[themeKey] or tostring(themeKey)):Colorpicker({
        Flag = "theme_" .. tostring(themeKey),
        Default = themeValue,
        Alpha = 0,
        Callback = function(color)
            Library.Theme[themeKey] = color
            Library:ChangeTheme(themeKey, color)
        end,
    })
end

colorSection:Label("Цвета применяются сразу, без перезагрузки")
end

-- ============================================================
-- MENU FX: DIM + SNOW
-- ============================================================

local MenuFX = (function()
local function getOverlayParent()
    local ok, parent = pcall(function()
        if type(gethui) == "function" then
            return gethui()
        end
        return game:GetService("CoreGui")
    end)
    if ok and parent then
        return parent
    end
    return LocalPlayer:FindFirstChild("PlayerGui")
end

local overlayParent = getOverlayParent()
local fxGui = nil
local dimFrame = nil
local snowFrame = nil
local worldFrame = nil
local patternFrame = nil
local dimTween = nil

if overlayParent then
    fxGui = Instance.new("ScreenGui")
    fxGui.Name = "SupremeMenuFX"
    fxGui.IgnoreGuiInset = true
    fxGui.ResetOnSpawn = false
    fxGui.DisplayOrder = 1
    fxGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    dimFrame = Instance.new("Frame")
    dimFrame.Name = "Dim"
    dimFrame.Size = UDim2.fromScale(1, 1)
    dimFrame.BackgroundColor3 = Color3.fromRGB(4, 5, 10)
    dimFrame.BackgroundTransparency = 1
    dimFrame.BorderSizePixel = 0
    dimFrame.ZIndex = 1
    dimFrame.Active = false
    dimFrame.Parent = fxGui

    snowFrame = Instance.new("Frame")
    snowFrame.Name = "Snow"
    snowFrame.Size = UDim2.fromScale(1, 1)
    snowFrame.BackgroundTransparency = 1
    snowFrame.BorderSizePixel = 0
    snowFrame.ZIndex = 2
    snowFrame.Visible = false
    snowFrame.ClipsDescendants = false
    snowFrame.Parent = fxGui

    worldFrame = Instance.new("Frame")
    worldFrame.Name = "WorldSnow"
    worldFrame.Size = UDim2.fromScale(1, 1)
    worldFrame.BackgroundTransparency = 1
    worldFrame.BorderSizePixel = 0
    worldFrame.ZIndex = 2
    worldFrame.Visible = false
    worldFrame.ClipsDescendants = false
    worldFrame.Parent = fxGui

    patternFrame = Instance.new("Frame")
    patternFrame.Name = "Pattern"
    patternFrame.Size = UDim2.fromScale(1, 1)
    patternFrame.BackgroundTransparency = 1
    patternFrame.BorderSizePixel = 0
    patternFrame.ZIndex = 1
    patternFrame.Visible = false
    patternFrame.ClipsDescendants = false
    patternFrame.Parent = fxGui

    fxGui.Parent = overlayParent
end

local particlePalette = {
    Color3.fromRGB(255, 215, 90),
    Color3.fromRGB(120, 255, 170),
    Color3.fromRGB(120, 200, 255),
    Color3.fromRGB(255, 130, 180),
    Color3.fromRGB(255, 255, 255),
}

local menuLayer = { Frame = snowFrame, Flakes = {}, Type = nil, Brightness = nil }
local worldLayer = { Frame = worldFrame, Flakes = {}, Type = nil, Brightness = nil }

local function createFlake(layer, fxType, brightness)
    local frame = Instance.new("Frame")
    local kind = fxType or "Snow"
    local rise = false
    local spin = 0
    local baseSpeed

    if kind == "Stars" then
        local size = math.random(3, 7)
        frame.Size = UDim2.fromOffset(size, size)
        frame.Rotation = 45
        frame.BackgroundColor3 = Color3.fromRGB(190, 225, 255)
        baseSpeed = math.random(12, 38)
        spin = math.random(-40, 40)
    elseif kind == "Bubbles" then
        local size = math.random(3, 8)
        frame.Size = UDim2.fromOffset(size, size)
        frame.BackgroundColor3 = Color3.fromRGB(150, 220, 255)
        baseSpeed = math.random(20, 55)
        rise = true
    elseif kind == "Confetti" then
        frame.Size = UDim2.fromOffset(math.random(2, 4), math.random(5, 9))
        frame.BackgroundColor3 = particlePalette[math.random(1, #particlePalette)]
        frame.Rotation = math.random(0, 360)
        baseSpeed = math.random(45, 110)
        spin = math.random(-180, 180)
    else
        local size = math.random(2, 5)
        frame.Size = UDim2.fromOffset(size, size)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        baseSpeed = math.random(28, 85)
    end

    local alpha = 1 - math.clamp((brightness or 80) / 100, 0, 1)
    frame.BackgroundTransparency = math.clamp(alpha + math.random() * 0.3, 0, 0.96)
    frame.BorderSizePixel = 0
    frame.ZIndex = 2

    if kind ~= "Confetti" then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = frame
    end

    frame.Parent = layer.Frame

    return {
        Frame = frame,
        X = math.random(),
        Y = math.random(-400, 700),
        BaseSpeed = baseSpeed,
        Sway = math.random(10, 28),
        Phase = math.random() * math.pi * 2,
        PhaseSpeed = math.random(8, 22) / 10,
        Rise = rise,
        Spin = spin,
    }
end

local function clearFlakes(layer)
    for _, flake in ipairs(layer.Flakes) do
        if flake.Frame then
            flake.Frame:Destroy()
        end
    end
    layer.Flakes = {}
end

local function syncFlakeCount(layer, desired, fxType, brightness)
    if layer.Type ~= fxType or layer.Brightness ~= brightness then
        clearFlakes(layer)
        layer.Type = fxType
        layer.Brightness = brightness
    end

    while #layer.Flakes > desired do
        local flake = table.remove(layer.Flakes)
        if flake and flake.Frame then
            flake.Frame:Destroy()
        end
    end
    while #layer.Flakes < desired do
        table.insert(layer.Flakes, createFlake(layer, fxType, brightness))
    end
end

local function updateLayer(layer, dt, amount, speed, fxType, brightness)
    if not layer.Frame or not layer.Frame.Visible then
        return
    end

    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    syncFlakeCount(layer, math.floor(amount), fxType, brightness)

    local speedScale = math.max(0.1, speed / 90)
    for _, flake in ipairs(layer.Flakes) do
        local direction = flake.Rise and -1 or 1
        flake.Y += direction * flake.BaseSpeed * speedScale * dt
        flake.Phase += flake.PhaseSpeed * dt
        if flake.Spin ~= 0 then
            flake.Frame.Rotation = flake.Frame.Rotation + flake.Spin * dt
        end

        if flake.Rise then
            if flake.Y < -10 then
                flake.Y = viewport.Y + 10
                flake.X = math.random()
            end
        elseif flake.Y > viewport.Y + 8 then
            flake.Y = -8
            flake.X = math.random()
        end

        local x = flake.X * viewport.X + math.sin(flake.Phase) * flake.Sway
        flake.Frame.Position = UDim2.fromOffset(x, flake.Y)
    end
end

local currentPattern = "None"
local currentPatternOpacity = nil
local patternGradient = nil

local function patternOpacity()
    return math.clamp((S.Menu_PatternOpacity or 8) / 100, 0.02, 0.35)
end

local function clearPattern()
    if not patternFrame then
        return
    end
    for _, child in ipairs(patternFrame:GetChildren()) do
        child:Destroy()
    end
    patternGradient = nil
end

local function buildPatternGradient()
    if not patternFrame then
        return
    end
    patternFrame.BackgroundTransparency = 1 - patternOpacity()
    patternFrame.BackgroundColor3 = S.Menu_BGGradientA or Color3.fromRGB(4, 5, 10)

    patternGradient = Instance.new("UIGradient")
    patternGradient.Rotation = S.Menu_BGGradientRot or 0
    patternGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, S.Menu_BGGradientA or Color3.fromRGB(4, 5, 10)),
        ColorSequenceKeypoint.new(1, S.Menu_BGGradientB or Color3.fromRGB(20, 22, 35)),
    })
    patternGradient.Parent = patternFrame
end

local function buildPatternGrid()
    if not patternFrame then
        return
    end
    local color = Color3.fromRGB(255, 255, 255)
    local transparency = 1 - patternOpacity()

    for i = 1, 11 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 1, 1, 0)
        line.Position = UDim2.new(i / 12, 0, 0, 0)
        line.BackgroundColor3 = color
        line.BackgroundTransparency = transparency
        line.BorderSizePixel = 0
        line.Parent = patternFrame
    end

    for i = 1, 7 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, i / 8, 0)
        line.BackgroundColor3 = color
        line.BackgroundTransparency = transparency
        line.BorderSizePixel = 0
        line.Parent = patternFrame
    end
end

local function buildPatternDots()
    if not patternFrame then
        return
    end
    local color = Color3.fromRGB(255, 255, 255)
    local transparency = 1 - patternOpacity()

    for x = 1, 10 do
        for y = 1, 6 do
            local dot = Instance.new("Frame")
            dot.Size = UDim2.fromOffset(3, 3)
            dot.Position = UDim2.new(x / 11, -1, y / 7, -1)
            dot.BackgroundColor3 = color
            dot.BackgroundTransparency = transparency
            dot.BorderSizePixel = 0

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = dot

            dot.Parent = patternFrame
        end
    end
end

local function buildPatternScanlines()
    if not patternFrame then
        return
    end
    local opacity = patternOpacity()
    patternFrame.BackgroundTransparency = 1 - opacity
    patternFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

    local transparency = 1 - opacity
    patternGradient = Instance.new("UIGradient")
    patternGradient.Rotation = 0
    local color = Color3.fromRGB(255, 255, 255)
    local keypoints = {}
    local steps = 19
    for i = 0, steps do
        local alpha = i / steps
        local c = (i % 2 == 0) and color or Color3.fromRGB(0, 0, 0)
        table.insert(keypoints, ColorSequenceKeypoint.new(alpha, c))
    end
    patternGradient.Color = ColorSequence.new(keypoints)
    patternGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, transparency),
        NumberSequenceKeypoint.new(1, transparency),
    })
    patternGradient.Parent = patternFrame
end

local function buildPatternDiagonal(crosshatch)
    if not patternFrame then
        return
    end
    local transparency = 1 - patternOpacity()
    local function addLine(xScale, rotation)
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Size = UDim2.new(0, 1, 1.5, 0)
        line.Position = UDim2.new(xScale, 0, 0.5, 0)
        line.Rotation = rotation
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BackgroundTransparency = transparency
        line.BorderSizePixel = 0
        line.Parent = patternFrame
    end
    for i = -2, 12 do
        local x = i / 10
        addLine(x, 35)
        if crosshatch then
            addLine(x, -35)
        end
    end
end

local function syncPattern(force)
    if not patternFrame then
        return
    end

    local pattern = S.Menu_BGPattern or "None"
    local opacity = S.Menu_PatternOpacity or 8
    if pattern ~= currentPattern or opacity ~= currentPatternOpacity or force then
        currentPattern = pattern
        currentPatternOpacity = opacity
        clearPattern()

        if pattern == "Gradient" then
            buildPatternGradient()
        elseif pattern == "Grid" then
            buildPatternGrid()
        elseif pattern == "Dots" then
            buildPatternDots()
        elseif pattern == "Scanlines" then
            buildPatternScanlines()
        elseif pattern == "Diagonal" then
            buildPatternDiagonal(false)
        elseif pattern == "Crosshatch" then
            buildPatternDiagonal(true)
        end
    elseif pattern == "Gradient" and patternGradient then
        patternGradient.Rotation = S.Menu_BGGradientRot or 0
        patternGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, S.Menu_BGGradientA or Color3.fromRGB(4, 5, 10)),
            ColorSequenceKeypoint.new(1, S.Menu_BGGradientB or Color3.fromRGB(20, 22, 35)),
        })
    end

    patternFrame.Visible = (pattern ~= "None") and (Window.IsOpen == true)
end

local menuFx = { open = nil, dim = nil }

local function dimTargetTransparency()
    if not S.Menu_DimEnabled then
        return 1
    end
    local strength = math.clamp(S.Menu_DimStrength / 100, 0, 1)
    return 1 - strength * 0.8
end

local function applyDim(force)
    if not dimFrame then
        return
    end

    dimFrame.BackgroundColor3 = S.Menu_DimColor or Color3.fromRGB(4, 5, 10)

    local target = dimTargetTransparency()
    if not force and menuFx.dim == target then
        return
    end
    menuFx.dim = target

    if dimTween then
        pcall(function()
            dimTween:Cancel()
        end)
    end

    dimTween = TweenService:Create(
        dimFrame,
        TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { BackgroundTransparency = target }
    )
    dimTween:Play()
end

local function setMenuEffects(open)
    if not fxGui then
        return
    end

    menuFx.open = open

    if open then
        applyDim(true)
        if snowFrame then
            snowFrame.Visible = S.Menu_SnowEnabled
        end
        syncPattern(true)
    else
        if dimTween then
            pcall(function()
                dimTween:Cancel()
            end)
        end
        dimTween = TweenService:Create(
            dimFrame,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = 1 }
        )
        dimTween:Play()
        menuFx.dim = 1

        if snowFrame then
            snowFrame.Visible = false
        end
        if patternFrame then
            patternFrame.Visible = false
        end
    end
end

RunService.RenderStepped:Connect(function(dt)
    if not Running or not fxGui then
        return
    end

    local open = Window.IsOpen == true
    if open ~= menuFx.open then
        setMenuEffects(open)
    elseif open then
        if snowFrame then
            snowFrame.Visible = S.Menu_SnowEnabled
        end
        applyDim(false)
        syncPattern(false)
    end

    if open then
        updateLayer(menuLayer, dt, S.Menu_SnowAmount, S.Menu_SnowSpeed, S.Menu_FxType, S.Menu_FxBrightness)
    end

    if worldFrame then
        worldFrame.Visible = S.World_SnowEnabled == true
        updateLayer(worldLayer, dt, S.World_SnowAmount, S.World_SnowSpeed, S.World_FxType, S.World_FxBrightness)
    end
end)

local function destroyMenuFx()
    if dimTween then
        pcall(function()
            dimTween:Cancel()
        end)
        dimTween = nil
    end
    if fxGui then
        fxGui:Destroy()
    end
    fxGui = nil
    dimFrame = nil
    snowFrame = nil
    worldFrame = nil
    patternFrame = nil
    patternGradient = nil
    currentPattern = "None"
    currentPatternOpacity = nil
    clearFlakes(menuLayer)
    clearFlakes(worldLayer)
end

return { destroy = destroyMenuFx }
end)()

local function unload()
    if not Running then
        return
    end
    Running = false
    bindsReady = false

    S.Aimbot_Enabled = false
    S.AutoShot_Enabled = false
    S.Instakill_Enabled = false
    S.TP_Bullet_Enabled = false
    S.Rage_Enabled = false
    STOMP.Reset()
    S.Ammo_Enabled = false
    S.NoReload_Enabled = false
    S.Hitbox_Enabled = false
    S.AutoStomp_Enabled = false
    S.Spinbot_Enabled = false
    S.Speed_Enabled = false
    S.Jump_Enabled = false
    S.Fly_Enabled = false
    S.Noclip_Enabled = false
    S.AntiFling_Enabled = false
    S.InfiniteJump_Enabled = false
    S.AntiStomp_Enabled = false
    S.AntiStomp_NoRagdoll = false
    S.AntiRagdoll_Enabled = false
    S.Spectate_Enabled = false
    S.ESP_Enabled = false
    S.Tracers_Enabled = false
    S.NPC_ESP_Enabled = false
    S.NPC_Tracers_Enabled = false
    S.Fullbright_Enabled = false
    S.AntiAFK_Enabled = false

    pcall(stopSpectating)
    pcall(ADMIN.Destroy)
    pcall(INSTA.Destroy)
    pcall(restoreHook)
    getgenv().__SupremeHubRestoreHook = nil

    pcall(restoreRaycastHooks)
    getgenv().__SupremeHubRestoreRaycast = nil

    pcall(MenuFX.destroy)
    pcall(Overlays.destroy)
    pcall(WorkOverlay.destroy)

    for id in pairs(ESP_Cache) do
        clearEntityESP(id)
    end
    for id in pairs(ESP_ArrowCache) do
        clearArrowEntry(id)
    end
    arrowsActive = false
    if fovCircle then
        pcall(function()
            fovCircle:Remove()
        end)
        fovCircle = nil
    end
    if silentCircle then
        pcall(function()
            silentCircle:Remove()
        end)
        silentCircle = nil
    end

    Lighting.Ambient = OriginalAmbient
    Lighting.Brightness = OriginalBrightness

    pcall(stopFly)

    local humanoid = getHumanoid()
    local saved = humanoid and movementSaved[humanoid]
    if humanoid and saved then
        pcall(function()
            if saved.SpeedApplied and humanoid.WalkSpeed == saved.SpeedTarget then
                humanoid.WalkSpeed = saved.WalkSpeed
            end
            if saved.JumpApplied then
                humanoid.UseJumpPower = saved.UseJumpPower
                humanoid.JumpPower = saved.JumpPower
                humanoid.JumpHeight = saved.JumpHeight
            end
            humanoid.PlatformStand = false
        end)
    end

    for part, value in pairs(noclipSaved) do
        pcall(function()
            part.CanCollide = value
        end)
    end

    for part, size in pairs(hitboxSaved) do
        pcall(function()
            part.Size = size
        end)
    end

    if ragdollStatesDisabled then
        setRagdollStates(true)
        ragdollStatesDisabled = false
    end

    if Library then
        pcall(function()
            Library:Unload()
        end)
    end

    if getgenv().__SupremeHubGen == GEN then
        getgenv().__SupremeHubGen = nil
    end
    if getgenv().__SupremeHubCleanup == unload then
        getgenv().__SupremeHubCleanup = nil
    end
end

menuSection:Button({
    Name = "Unload script",
    Callback = unload,
})

getgenv().__SupremeHubCleanup = unload
if getgenv().__SupremeHubRestoreHook then
    restoreHook = getgenv().__SupremeHubRestoreHook
end

installHook()
installRaycastHooks()
if hookStatus then
    hookStatus:SetText(INSTA.HookStatusText())
end

-- Menu input is handled once by the library (F2 / V / Insert).

-- Live status
task.spawn(function()
    while alive() do
        task.wait(1)
        if not alive() then
            break
        end

        local ping = getPing(LocalPlayer)
        local targetName = CurrentTargetPlayer and CurrentTargetPlayer.Name
            or (CurrentTargetPart and CurrentTargetPart.Parent and CurrentTargetPart.Parent.Name)
            or "—"

        pcall(function()
            fpsLabel:SetText("FPS: " .. tostring(fpsValue))
            pingLabel:SetText("Ping: " .. (ping and (ping .. " ms") or "—"))
            targetLabel:SetText("Target: " .. targetName)
            hookStatus:SetText(INSTA.HookStatusText())
            if musicStatusLabel then
                musicStatusLabel:SetText(getMusicListText())
            end
            for _, entry in ipairs(bindEntries) do
                local text = string.format("%s — %s [%s]", entry.Name, keyName(entry.Keybind), entry.Keybind.Mode)
                if text ~= entry.LastText then
                    entry.LastText = text
                    entry.Label:SetText(text)
                end
            end
            applyMusicVolume()
            ADMIN.Render()
            if S.Spectate_Enabled and S.Spectate_Target then
                if not S.Spectate_Target.Parent then
                    stopSpectating()
                    notify("Spectate target left")
                elseif S.Spectate_Target.Character then
                    local humanoid = S.Spectate_Target.Character:FindFirstChildOfClass("Humanoid")
                    local camera = workspace.CurrentCamera
                    if camera and humanoid and camera.CameraSubject ~= humanoid then
                        camera.CameraSubject = humanoid
                    end
                end
            end
        end)
    end
end)

notify("RAGE v6.2 loaded · Insert / V / F2")
