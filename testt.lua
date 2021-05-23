require "lib.moonloader"
local dlstatus = require("moonloader").download_status
local inicfg = require("inicfg")

local isUpdateState = false

local scriptVersion = 2

local updateUrl = "https://gta-trinity.github.io/update.ini"
local updatePath = getWorkingDirectory().."/update.ini"

local scriptUrl = "https://gta-trinity.github.io/testt.lua"
local scriptPath = thisScript().path

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    downloadUrlToFile(updateUrl, updatePath, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, updatePath)
            if tonumber(updateIni.info.version) > scriptVersion then
                sampAddChatMessage("Есть обновление!", -1)
                sampAddChatMessage("Процесс скачивания...", -1)
                isUpdateState = true
            end
            os.remove(updatePath)
        end
    end)
    sampAddChatMessage("OKAY 2.0!", -1)
    while true do
        wait(0)
        if isUpdateState then
            downloadUrlToFile(scriptUrl, scriptPath, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end