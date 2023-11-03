local ffi = require "ffi"
local imgui = require "mimgui"
local encoding = require "encoding"
encoding.default = "CP1251"
local u8 = encoding.UTF8
local new = imgui.new
local faicons = require("fAwesome6")
local str = ffi.string
local inicfg = require 'inicfg'
local dlstatus = require('moonloader').download_status

update_state = false
update_found = false

local script_vers = 1.0
local script_vers_text = "v1.0"

local update_url = 'raw.githubusercontent.com/L1keARZ/Script/main/ArmyHelper.ini' -- Здесь укажите URL для обновления
local update_path = getWorkingDirectory() .. "/ArmyHelper.ini"

local script_url = '' -- Здесь укажите URL для скрипта
local script_path = thisScript().path

local tab = 1

local WinState = new.bool()

imgui.OnFrame(function()
    return WinState[0]
end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 700), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8"Помощник для руководства организаций", WinState)

    if imgui.Button(faicons("user")..u8" Информация",imgui.ImVec2(160, 60)) then
        tab = 1
    end

    if imgui.Button(faicons("keyboard")..u8" Биндер",imgui.ImVec2(160, 60)) then
        tab = 2
    end

    if imgui.Button(faicons("sliders")..u8" Настройки",imgui.ImVec2(160, 60)) then
        tab = 3
    end
    
    if imgui.Button(faicons("envelope")..u8" О скрипте",imgui.ImVec2(160, 60)) then
        tab = 4
    end

    imgui.SetCursorPos(imgui.ImVec2(175, 33))
    if imgui.BeginChild("Name##"..tab, imgui.ImVec2(700, 250), true) then
        imgui.EndChild()
    end

    imgui.End()
end)

function main()
    sampRegisterChatCommand("ahl", function()
        WinState[0] = not WinState[0]
    end)
    wait(-1)
end

function check_update()
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("{FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}"..updateIni.info.vers_text..". {FFFFFF}/update что-бы обновить", 0xFF0000)
                update_found = true
            end
            os.remove(update_path)
        end
    end)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    check_update()

    if update_found then
        sampRegisterChatCommand('update', function()
            update_state = true
        end)
    else
        sampAddChatMessage('{FFFFFF}Нет доступных обновлений!')
    end

    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}Скрипт {32CD32}успешно {FFFFFF}обновлён.", 0xFF0000)
                end
            end)
            break
        end
    end
end

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85("solid"), 14, config, iconRanges)
end)

function decor()
    imgui.SwitchContext()
    local ImVec4 = imgui.ImVec4
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1
    imgui.GetStyle().WindowRounding = 8
    imgui.GetStyle().ChildRounding = 8
    imgui.GetStyle().FrameRounding = 8
    imgui.GetStyle().PopupRounding = 8
    imgui.GetStyle().ScrollbarRounding = 8
    imgui.GetStyle().GrabRounding = 8
    imgui.GetStyle().TabRounding = 8
end