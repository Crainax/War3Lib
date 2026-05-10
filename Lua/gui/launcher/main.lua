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
local versionStateFile = arg[3]

local state = {
	action = "start",
	version = "VERSION_ALPHA",
	compiler = "jasshelper",
}

local groups = {}
local summaryLabel
local win

local actionItems = {
	{ value = "start", title = "全量启动" },
	{ value = "incremental", title = "增量启动" },
	{ value = "compile", title = "仅编译" },
	{ value = "legacy", title = "老地图启动" },
}

local versionItems = {
	{ value = "VERSION_ALPHA", title = "内测" },
	{ value = "VERSION_BETA", title = "公测" },
	{ value = "VERSION_UNITTEST", title = "单元测试" },
	{ value = "VERSION_RELEASE", title = "正式" },
}

local compilerItems = {
	{ value = "jasshelper", title = "jasshelper" },
	{ value = "vjassc",     title = "vjassc" },
}

local titles = {
	action = {},
	version = {},
	compiler = {},
}

local function registerTitles(groupName, items)
	for _, item in ipairs(items) do
		titles[groupName][item.value] = item.title
	end
end

registerTitles("action", actionItems)
registerTitles("version", versionItems)
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

local versionState = readKeyValueFile(versionStateFile)

local function normalizeHistoryAction(history)
	if history.action == "compile" then
		return "compile"
	elseif history.action == "incremental" then
		return "incremental"
	elseif history.action == "legacy" or history.launchMode == "direct" then
		return "legacy"
	elseif history.launchMode == "fast" or history.launchMode == "slow" then
		return "incremental"
	end
	return "start"
end

local function loadHistory()
	local history = readKeyValueFile(historyFile)
	local action = normalizeHistoryAction(history)
	if titles.action[action] then
		state.action = action
	end
	if titles.version[history.version] then
		state.version = history.version
	end
	if titles.compiler[history.compiler] then
		state.compiler = history.compiler
	else
		state.compiler = "jasshelper"
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
local fontTiny = createFont(11, "normal")

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
	if state.action == "legacy" then
		summaryLabel:settext(string.format("%s / %s / 不走编译", actionText, versionText))
	else
		summaryLabel:settext(string.format("%s / %s / %s", actionText, versionText, titles.compiler[state.compiler]))
	end
end

local function refreshCompilerEnabled()
	local enabled = state.action ~= "legacy"
	for _, item in ipairs(groups.compiler or {}) do
		item.button:setenabled(enabled)
		if item.button.setcolor then
			item.button:setcolor(enabled and "#FFFFFF" or "#888888")
		end
	end
end

local function refreshChecks()
	for groupName, items in pairs(groups) do
		for _, item in ipairs(items) do
			item.button:setchecked(item.value == state[groupName])
		end
	end
	refreshCompilerEnabled()
end

local function selectGroup(groupName, value)
	if groupName == "compiler" and state.action == "legacy" then
		return
	end
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

local function versionStateValue(version, name)
	local value = versionState[version .. "_" .. name]
	if value and value ~= "" then
		return value
	end
	return "无记录"
end

local function makeVersionCell(item)
	local cell = makeContainer({
		Width = 175,
		Height = 82,
		Margin = 4,
		FlexDirection = "column",
		AlignItems = "center",
	}, nil)
	local button = makeRadioButton("version", item, 154)
	cell:addchildview(button)
	cell:addchildview(makeLabel("[上次全量]" .. versionStateValue(item.value, "full"), {
		Width = 168,
		Height = 17,
		MarginTop = 2,
	}, fontTiny, "#FFFFFF"))
	cell:addchildview(makeLabel("[上次修改]" .. versionStateValue(item.value, "modified"), {
		Width = 168,
		Height = 17,
	}, fontTiny, "#FFFFFF"))
	return cell
end

local function makeVersionGroup(parent)
	local section = makeContainer({
		Height = 128,
		MarginLeft = 22,
		MarginRight = 22,
		MarginTop = 10,
		FlexDirection = "column",
	}, "#242936")
	parent:addchildview(section)

	section:addchildview(makeLabel("版本", {
		Height = 30,
		MarginLeft = 12,
		MarginTop = 8,
	}, fontGroup, "#FFFFFF"))

	local row = makeContainer({
		Height = 86,
		MarginLeft = 8,
		MarginRight = 8,
		FlexDirection = "row",
		AlignItems = "center",
	}, nil)
	section:addchildview(row)
	for _, item in ipairs(versionItems) do
		row:addchildview(makeVersionCell(item))
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

	local title = makeLabel("异度幻世篇2启动", {
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

	makeGroup(root, "启动动作", "action", actionItems, 160)
	makeVersionGroup(root)
	makeGroup(root, "编译器", "compiler", compilerItems, 160)

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
		Width = 520,
		Height = 42,
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

	refreshChecks()
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
win:setcontentsize({ width = 800, height = 520 })
win:center()
function win.onclose()
	gui.MessageLoop.quit()
end

win:activate()
gui.MessageLoop.run()
