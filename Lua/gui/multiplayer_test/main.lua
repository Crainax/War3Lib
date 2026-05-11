local function normalizePath(value)
	return tostring(value or ""):gsub("\\", "/")
end

local function scriptDir()
	local source = debug.getinfo(1, "S").source
	source = source:gsub("^@", "")
	source = normalizePath(source)
	return source:match("^(.*)/[^/]+$") or "."
end

local guiDir = scriptDir()
local libRoot = guiDir:match("^(.*)/Lua/gui/multiplayer_test$")
if libRoot then
	local runtimeBin = libRoot .. "/Lua/gui/runtime/bin"
	package.cpath = runtimeBin .. "/?.dll;" .. package.cpath
end

local gui = require("yue.gui")

local selectionFile = arg[1]
if not selectionFile or selectionFile == "" then
	error("missing selection file")
end
local historyFile = arg[2]

local state = {
	players = 2,
}

local groups = {}
local summaryLabel
local win
local bindShortcutKeys
local finishSelection

local playerItems = {
	{ value = 2, title = "2人" },
	{ value = 3, title = "3人" },
	{ value = 4, title = "4人" },
	{ value = 5, title = "5人" },
	{ value = 6, title = "6人" },
}

local function readKeyValueFile(filePath)
	local result = {}
	if not filePath or filePath == "" then
		return result
	end
	local file = io.open(filePath, "r")
	if not file then
		return result
	end
	for line in file:lines() do
		local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
		if key then
			result[key] = value
		end
	end
	file:close()
	return result
end

local function loadHistory()
	local history = readKeyValueFile(historyFile)
	local players = tonumber(history.players)
	if players and players >= 2 and players <= 6 then
		state.players = players
	end
end

loadHistory()

local function createFont(size, weight)
	return gui.Font.create("Microsoft YaHei UI", size, weight or "normal", "normal")
end

local fontTitle = createFont(22, "bold")
local fontGroup = createFont(17, "bold")
local fontNormal = createFont(16, "normal")
local fontSmall = createFont(14, "normal")

local function setBackground(view, color)
	if view.setbackgroundcolor then
		view:setbackgroundcolor(color)
	end
end

local function makeContainer(style, color)
	local container = gui.Container.create()
	container:setstyle(style)
	if color then
		setBackground(container, color)
	end
	return container
end

local function makeLabel(text, style, font, color)
	local label = gui.Label.create(text)
	label:setstyle(style or {})
	label:setalign("start")
	if font then
		label:setfont(font)
	end
	label:setcolor(color or "#FFFFFF")
	return label
end

local function styleButton(button, font, textColor)
	if font then
		button:setfont(font)
	end
	if button.setcolor then
		button:setcolor(textColor or "#FFFFFF")
	end
end

local function updateSummary()
	if summaryLabel then
		summaryLabel:settext(string.format("本次启动 %d 个魔兽窗口", state.players))
	end
end

local function refreshChecks()
	for _, item in ipairs(groups.players or {}) do
		item.button:setchecked(item.value == state.players)
	end
end

local function selectPlayers(value)
	state.players = value
	refreshChecks()
	updateSummary()
end

local function makeRadioButton(item)
	local button = gui.Button.create({ title = item.title, type = "radio" })
	button:setstyle({ Width = 92, Height = 38, Margin = 4 })
	styleButton(button, fontNormal)
	bindShortcutKeys(button)
	button:setchecked(state.players == item.value)
	function button:onclick()
		selectPlayers(item.value)
	end
	groups.players = groups.players or {}
	groups.players[#groups.players + 1] = {
		value = item.value,
		button = button,
	}
	return button
end

local function writeSelection(status)
	local file, err = io.open(selectionFile, "w")
	if not file then
		error("write selection failed: " .. tostring(err))
	end
	file:write("status=", status, "\n")
	if status == "ok" then
		file:write("players=", tostring(state.players), "\n")
	end
	file:close()
end

local function closeWindow()
	if win then
		win:close()
	else
		gui.MessageLoop.quit()
	end
end

function finishSelection(status)
	writeSelection(status)
	closeWindow()
end

local function handleShortcutKey(event)
	local key = event and event.key
	if key == "Escape" or key == "Esc" then
		finishSelection("cancel")
		return true
	elseif key == "Enter" or key == "Return" then
		finishSelection("ok")
		return true
	end
	return false
end

function bindShortcutKeys(view)
	if not view or not view.onkeydown then
		return
	end
	function view:onkeydown(event)
		return handleShortcutKey(event)
	end
end

local function createMainView()
	local root = makeContainer({
		FlexGrow = 1,
		FlexDirection = "column",
	}, "#1B1F2A")
	root:setfocusable(true)
	bindShortcutKeys(root)

	local caption = makeContainer({
		Height = 42,
		FlexDirection = "row",
		AlignItems = "center",
		JustifyContent = "space-between",
	}, "#0A8FBF")
	caption:setmousedowncanmovewindow(true)
	root:addchildview(caption)

	local title = makeLabel("多人自动测试", {
		Width = 260,
		Height = 36,
		MarginLeft = 16,
	}, fontTitle, "#F7FBFF")
	title:setmousedowncanmovewindow(true)
	caption:addchildview(title)

	local close = gui.Button.create("×")
	close:setstyle({ Width = 42, Height = 42 })
	styleButton(close, createFont(20, "bold"))
	bindShortcutKeys(close)
	function close:onclick()
		closeWindow()
	end
	caption:addchildview(close)

	local section = makeContainer({
		Height = 108,
		MarginLeft = 22,
		MarginRight = 22,
		MarginTop = 18,
		FlexDirection = "column",
	}, "#242936")
	root:addchildview(section)

	section:addchildview(makeLabel("窗口数量", {
		Height = 30,
		MarginLeft = 12,
		MarginTop = 10,
	}, fontGroup, "#FFFFFF"))

	local row = makeContainer({
		Height = 46,
		MarginLeft = 8,
		MarginRight = 8,
		FlexDirection = "row",
		AlignItems = "center",
	}, nil)
	section:addchildview(row)

	for _, item in ipairs(playerItems) do
		row:addchildview(makeRadioButton(item))
	end

	local bottom = makeContainer({
		Height = 74,
		MarginLeft = 22,
		MarginRight = 22,
		MarginTop = 14,
		FlexDirection = "row",
		AlignItems = "center",
		JustifyContent = "space-between",
	}, "#202531")
	root:addchildview(bottom)

	summaryLabel = makeLabel("", {
		Width = 310,
		Height = 38,
		MarginLeft = 14,
	}, fontSmall, "#FFFFFF")
	bottom:addchildview(summaryLabel)

	local buttons = makeContainer({
		Width = 210,
		Height = 44,
		MarginRight = 8,
		FlexDirection = "row",
		AlignItems = "center",
		JustifyContent = "flex-end",
	}, nil)
	bottom:addchildview(buttons)

	local cancel = gui.Button.create("取消")
	cancel:setstyle({ Width = 84, Height = 38, MarginRight = 8 })
	styleButton(cancel, fontNormal, "#000000")
	bindShortcutKeys(cancel)
	function cancel:onclick()
		finishSelection("cancel")
	end
	buttons:addchildview(cancel)

	local launch = gui.Button.create("启动")
	launch:setstyle({ Width = 100, Height = 38 })
	styleButton(launch, fontNormal, "#000000")
	bindShortcutKeys(launch)
	if launch.makedefault then
		launch:makedefault()
	end
	function launch:onclick()
		finishSelection("ok")
	end
	buttons:addchildview(launch)

	refreshChecks()
	updateSummary()
	return root
end

win = gui.Window.create({ frame = false })
win:settitle("MultiPlayerTest")
win:setresizable(false)
win:setmaximizable(false)
win:setminimizable(false)
win:sethasshadow(true)
local mainView = createMainView()
win:setcontentview(mainView)
win:setcontentsize({ width = 600, height = 270 })
win:center()
function win.onclose()
	gui.MessageLoop.quit()
end

win:activate()
mainView:focus()
gui.MessageLoop.run()
