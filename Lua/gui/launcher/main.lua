local function normalizePath(value)
	return tostring(value or ""):gsub("\\", "/")
end

local function scriptDir()
	local source = debug.getinfo(1, "S").source
	source = source:gsub("^@", "")
	source = normalizePath(source)
	return source:match("^(.*)/[^/]+$") or "."
end

local launcherDir = scriptDir()
local libRoot = launcherDir:match("^(.*)/Lua/gui/launcher$")
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
	action = "start",
	version = "VERSION_ALPHA",
	launchMode = "normal",
	compiler = "jasshelper",
}

local groups = {}
local summaryLabel
local win

local actionItems = {
	{ value = "start", title = "启动地图" },
	{ value = "compile", title = "仅编译" },
}

local versionItems = {
	{ value = "VERSION_ALPHA", title = "内测" },
	{ value = "VERSION_BETA", title = "公测" },
	{ value = "VERSION_UNITTEST", title = "单元测试" },
	{ value = "VERSION_RELEASE", title = "正式" },
}

local launchModeItems = {
	{ value = "normal", title = "正常" },
	{ value = "direct", title = "直启" },
	{ value = "fast", title = "快启" },
	{ value = "slow", title = "慢启" },
}

local compilerItems = {
	{ value = "jasshelper", title = "jasshelper" },
	{ value = "vjassc", title = "vjassc" },
	{ value = "compare", title = "vjassc对比" },
}

local titles = {
	action = {},
	version = {},
	launchMode = {},
	compiler = {},
}

local function registerTitles(groupName, items)
	for _, item in ipairs(items) do
		titles[groupName][item.value] = item.title
	end
end

registerTitles("action", actionItems)
registerTitles("version", versionItems)
registerTitles("launchMode", launchModeItems)
registerTitles("compiler", compilerItems)

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
	for key, value in pairs(history) do
		if state[key] ~= nil and titles[key] and titles[key][value] then
			state[key] = value
		end
	end
end

loadHistory()

local function createFont(size, weight)
	return gui.Font.create("Microsoft YaHei UI", size, weight or "normal", "normal")
end

local fontTitle = createFont(24, "bold")
local fontGroup = createFont(17, "bold")
local fontNormal = createFont(16, "normal")
local fontSmall = createFont(15, "normal")

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
	if not summaryLabel then
		return
	end
	local actionText = titles.action[state.action]
	local versionText = titles.version[state.version]
	local modeText = titles.launchMode[state.launchMode]
	local compilerText = titles.compiler[state.compiler]
	if state.action == "compile" then
		summaryLabel:settext(string.format("%s / %s / %s", actionText, versionText, compilerText))
	else
		summaryLabel:settext(string.format("%s / %s / %s / %s", actionText, versionText, modeText, compilerText))
	end
end

local function refreshChecks()
	for groupName, items in pairs(groups) do
		for _, item in ipairs(items) do
			item.button:setchecked(item.value == state[groupName])
		end
	end
end

local function selectGroup(groupName, value)
	state[groupName] = value
	refreshChecks()
	updateSummary()
end

local function makeRadioButton(groupName, item, width)
	local button = gui.Button.create({ title = item.title, type = "radio" })
	button:setstyle({ Width = width, Height = 38, Margin = 4 })
	styleButton(button, fontNormal)
	button:setchecked(state[groupName] == item.value)
	function button:onclick()
		selectGroup(groupName, item.value)
	end
	groups[groupName] = groups[groupName] or {}
	groups[groupName][#groups[groupName] + 1] = {
		value = item.value,
		button = button,
	}
	return button
end

local function makeGroup(parent, title, groupName, items, buttonWidth)
	local section = makeContainer({
		Height = 88,
		MarginLeft = 22,
		MarginRight = 22,
		MarginTop = 10,
		FlexDirection = "column",
	}, "#242936")
	parent:addchildview(section)

	section:addchildview(makeLabel(title, {
		Height = 30,
		MarginLeft = 12,
		MarginTop = 8,
	}, fontGroup, "#FFFFFF"))

	local row = makeContainer({
		Height = 42,
		MarginLeft = 8,
		MarginRight = 8,
		FlexDirection = "row",
		AlignItems = "center",
	}, nil)
	section:addchildview(row)

	for _, item in ipairs(items) do
		row:addchildview(makeRadioButton(groupName, item, buttonWidth))
	end
end

local function writeSelection(status)
	local file, err = io.open(selectionFile, "w")
	if not file then
		error("write selection failed: " .. tostring(err))
	end
	file:write("status=", status, "\n")
	if status == "ok" then
		file:write("action=", state.action, "\n")
		file:write("version=", state.version, "\n")
		file:write("launchMode=", state.launchMode, "\n")
		file:write("compiler=", state.compiler, "\n")
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

local function createMainView()
	local root = makeContainer({
		FlexGrow = 1,
		FlexDirection = "column",
	}, "#1B1F2A")

	local caption = makeContainer({
		Height = 42,
		FlexDirection = "row",
		AlignItems = "center",
		JustifyContent = "space-between",
	}, "#0A8FBF")
	caption:setmousedowncanmovewindow(true)
	root:addchildview(caption)

	local title = makeLabel("Xlimon 启动矩阵", {
		Width = 300,
		Height = 36,
		MarginLeft = 16,
	}, fontTitle, "#F7FBFF")
	title:setmousedowncanmovewindow(true)
	caption:addchildview(title)

	local close = gui.Button.create("×")
	close:setstyle({ Width = 42, Height = 42 })
	styleButton(close, createFont(20, "bold"))
	function close:onclick()
		closeWindow()
	end
	caption:addchildview(close)

	makeGroup(root, "任务类型", "action", actionItems, 112)
	makeGroup(root, "版本", "version", versionItems, 112)
	makeGroup(root, "启动方式", "launchMode", launchModeItems, 112)
	makeGroup(root, "编译器", "compiler", compilerItems, 146)

	local bottom = makeContainer({
		Height = 82,
		MarginLeft = 22,
		MarginRight = 22,
		MarginTop = 10,
		FlexDirection = "row",
		AlignItems = "center",
		JustifyContent = "space-between",
	}, "#202531")
	root:addchildview(bottom)

	summaryLabel = makeLabel("", {
		Width = 410,
		Height = 42,
		MarginLeft = 14,
	}, fontSmall, "#FFFFFF")
	bottom:addchildview(summaryLabel)

	local buttons = makeContainer({
		Width = 200,
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
	function cancel:onclick()
		writeSelection("cancel")
		closeWindow()
	end
	buttons:addchildview(cancel)

	local launch = gui.Button.create("启动")
	launch:setstyle({ Width = 100, Height = 38 })
	styleButton(launch, fontNormal, "#000000")
	if launch.makedefault then
		launch:makedefault()
	end
	function launch:onclick()
		writeSelection("ok")
		closeWindow()
	end
	buttons:addchildview(launch)

	updateSummary()
	return root
end

win = gui.Window.create({ frame = false })
win:settitle("Xlimon Launcher")
win:setresizable(false)
win:setmaximizable(false)
win:setminimizable(false)
win:sethasshadow(true)
win:setcontentview(createMainView())
win:setcontentsize({ width = 700, height = 570 })
win:center()
function win.onclose()
	gui.MessageLoop.quit()
end
win:activate()
gui.MessageLoop.run()
