--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name("ADBLOCK")
script_version("1.3")
script_author("rubbishman")
script_description("/ads")
-------------------------------------var----------------------------------------
local sampev = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
id = -1
ads1 = "ID\tОбъявление\tПрислал\tНомер\n"
adnicks = {}
color = 0x348cb2
-------------------------------------MAIN---------------------------------------
function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
	update()
	while update ~= false do wait(100) end
	sampAddChatMessage(("ADBLOCK by rubbishman successfully loaded! /ads - show hidden ads!"), color)
	sampRegisterChatCommand("ads", ads)
	while true do
		wait(0)
	end
end
--обработка скрытой объявы
function new(text)
	--sampAddChatMessage(text, - 1)
	id = id + 1
	adtext = string.sub(text, 13, string.find(text, " Прислал: ") - 2)
	adnick = string.sub(text, string.find(text, " Прислал: ") + 10, string.find(text, " Тел: ") - 2)
	adnomer = string.sub(text, string.find(text, " Тел: ") + 6, string.len(text))
	adnicks[id] = adnick
	ads1 = "ID\tОбъявление\tПрислал\tНомер\n".."["..id.."]\t["..os.date("%H:%M:%S").."] "..adtext.."\t"..adnick.."\t"..string.format("%s", adnomer).."\n"..string.gsub(ads1, "ID\tОбъявление\tПрислал\tНомер\n", "")
	if id > 35 then ads1 = string.sub(ads1, 1, (string.find(ads1, "\n%["..(id - 35).."%]") - 1)) end
end
--активация списка скрытых объявлений
function ads()
	lua_thread.create(adss)
end
--список скрытых объявлений
function adss()
	sampShowDialog(5125, "{348cb2}"..thisScript().name.." v"..thisScript().version, ads1, "Выбрать", "Закрыть", 5)
	dialog = sampGetDialogText()
	lastid = id
	while sampIsDialogActive(5125) do wait(100) end
	local resultMain, buttonMain, typ = sampHasDialogRespond(5125)
	if buttonMain == 1 and typ ~= nil then
		for i = 0, 1001 do
			if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == adnicks[lastid - typ] then
				sampShowDialog(9899, "Получатель: "..adnicks[lastid - typ], "Введите текст смски и нажмите \"Отправить\".", "Отправить", "Закрыть", 1)
				while sampIsDialogActive(9899) do wait(100) end
				local resultMain, buttonMain, typ = sampHasDialogRespond(9899)
				if buttonMain == 1 then
					if sampGetCurrentDialogEditboxText(9899) ~= "" then
						sampSendChat("/t "..i.." "..sampGetCurrentDialogEditboxText(9899))
					end
				else
					ads()
				end
				break
			end
			if i == 1001 then sampShowDialog(9899, "{348cb2}"..thisScript().name.." v"..thisScript().version, "Игрок "..adnicks[lastid - typ].." оффлайн.", "Окей") break end
		end
	end
end
--------------------------------------------------------------------------------
-------------------------------------HOOK---------------------------------------
--------------------------------------------------------------------------------
function sampev.onServerMessage(color, text)
	if color == 14221512 and string.find(text, "Объявление:") then
		lua_thread.create(new, text)
		return false
	end
	if color == 14221512 and string.find(text, "сотрудник") then
		return false
	end
end
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update()
	local fpath = os.getenv('TEMP') .. '\\adblock-version.json'
	downloadUrlToFile('http://rubbishman.ru/dev/samp/adblock/version.json', fpath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
		local f = io.open(fpath, 'r')
		if f then
			local info = decodeJson(f:read('*a'))
			updatelink = info.updateurl
			if info and info.latest then
				version = tonumber(info.latest)
				if version > tonumber(thisScript().version) then
					lua_thread.create(goupdate)
				else
					update = false
				end
			end
		end
	end
end)
end
--скачивание актуальной версии
function goupdate()
sampAddChatMessage(("[ADBLOCK]: Обнаружено обновление. Попробую обновиться.."), color)
sampAddChatMessage(("[ADBLOCK]: Текущая версия: "..thisScript().version..". Новая версия: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
	if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
	sampAddChatMessage(("[ADBLOCK]: Обновление завершено!"), color)
	thisScript():reload()
end
end)
end
