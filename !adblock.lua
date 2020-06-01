--Больше скриптов от автора можно найти в группе ВК: http://vk.com/qrlk.mods
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name("ADBLOCK")
script_version("01.06.2020")
script_author("qrlk")
script_description("/ads")
-------------------------------------var----------------------------------------
math.randomseed(os.time())
local prefix = '['..string.upper(thisScript().name)..']: '
local sampev = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local data = inicfg.load({
  options =
  {
    showad = true,
    toggle = true,
  },
}, 'adblock')
local ffi = require('ffi')
local id = -1
local ads1 = "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n"
local adnicks = {}
local adnomers = {}
local allads = {}
local coolads = {}
local blocked = 0
local adscount = 0
local LSN = 0
local SFN = 0
local LVN = 0
local color = 0x348cb2
local servers = {
  ["185.169.134.20"] = "Sаmp-Rр",
  ["185.169.134.11"] = "Sаmp-Rр",
  ["185.169.134.34"] = "Sаmp-Rр",
  ["185.169.134.22"] = "Sаmp-Rр",
  ["185.169.134.67"] = "Evolve-Rp",
  ["185.169.134.68"] = "Evolve-Rp",
  ["185.169.134.91"] = "Evolve-Rp",
  ["176.32.37.58"] = "ImperiaL",
  ["play.imperial-rpg.ru"] = "ImperiaL",
  ["54.37.142.72"] = "Advance-Rp",
  ["54.37.142.73"] = "Advance-Rp",
  ["54.37.142.74"] = "Advance-Rp",
  ["54.37.142.75"] = "Advance-Rp",
  ["51.83.207.240"] = "Diamond-Rp",
  ["51.75.33.152"] = "Diamond-Rp",
  ["51.83.207.241"] = "Diamond-Rp",
  ["51.75.33.153"] = "Diamond-Rp",
  ["51.83.207.242"] = "Diamond-Rp",
  ["51.83.207.243"] = "Diamond-Rp",
  ["51.75.33.154"] = "Diamond-Rp",
  ["185.169.134.3"] = "Arizona-Rp",
  ["185.169.134.4"] = "Arizona-Rp",
  ["185.169.134.43"] = "Arizona-Rp",
  ["185.169.134.44"] = "Arizona-Rp",
  ["185.169.134.45"] = "Arizona-Rp",
  ["185.169.134.5"] = "Arizona-Rp",
  ["185.169.134.59"] = "Arizona-Rp",
  ["185.169.134.61"] = "Arizona-Rp",
  ["185.169.134.107"] = "Arizona-Rp",
  ["185.169.134.109"] = "Arizona-Rp",
  ["185.169.134.166"] = "Arizona-Rp",
  ["185.169.134.171"] = "Arizona-Rp",
  ["185.169.134.172"] = "Arizona-Rp",
  ["185.169.134.83"] = "Trinity-Rp",
  ["185.169.134.84"] = "Trinity-Rp",
  ["185.169.134.85"] = "Trinity-Rp",
}
-------------------------------------MAIN---------------------------------------
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end


  while sampGetCurrentServerAddress() == nil do wait(100) sampAddChatMessage("text", color) end
  mode = servers[sampGetCurrentServerAddress()]

  -- вырежи тут, если хочешь отключить проверку обновлений
  update("http://qrlk.me/dev/moonloader/adblock/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods", "adblockchangelog")
	openchangelog("adblockchangelog", "http://qrlk.me/changelog/adblock")
  -- вырежи тут, если хочешь отключить проверку обновлений


  mode = servers[sampGetCurrentServerAddress()]
  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  if mode ~= nil then sampAddChatMessage(("ADBLOCK v"..thisScript().version.." successfully loaded! /ads - show hidden ads! /tads - toggle! Mode: "..mode..". <> by qrlk."), color)
  else
    sampAddChatMessage(("ADBLOCK v"..thisScript().version.." not loaded! Reason: unknown server. <> by qrlk."), 0xFF4500)
  end
  -- вырезать тут, если хочешь отключить сообщение при входе в игру

  if mode == nil then thisScript():unload() end

  if data.options.showad == true then
    sampAddChatMessage("[ADBLOCK]: Внимание! У нас появилась группа ВКонтакте: vk.com/qrlk.mods", - 1)
    sampAddChatMessage("[ADBLOCK]: Подписавшись на неё, вы сможете получать новости об обновлениях,", - 1)
    sampAddChatMessage("[ADBLOCK]: новых скриптах, а так же учавствовать в розыгрышах платных скриптов!", - 1)
    sampAddChatMessage("[ADBLOCK]: Это сообщение показывается один раз для каждого скрипта. Спасибо за внимание.", - 1)
    data.options.showad = false
    inicfg.save(data, "adblock")
  end

  sampRegisterChatCommand("ads", ads)
  sampRegisterChatCommand("tads",
    function()
      data.options.toggle = not data.options.toggle
      inicfg.save(data, "adblock")
      sampAddChatMessage("Скрытие объяв в чате: "..tostring(data.options.toggle), 0x348cb2)
    end
  )

  while true do
    wait(0)
    if Enable and (mode == "Sаmp-Rр" or mode == "Evolve-Rp") then
      sampSendChat("/ad "..floodtext)
      wait(1100)
    end
  end
end


--------------------------------------------------------------------------------
-----------------------------РЕЖИМЫ ПОД КАЖДЫЙ СЕРВЕР---------------------------
--------------------------------------------------------------------------------
--samp-rp
function samprp(text)
  trigger = false
  --sampAddChatMessage(text, - 1) -- это выводит в чат объяву, которую скрипт вносит в диалог
  for i = #allads - 25, #allads do
    if allads[i] ~= nil and text == allads[i] then trigger = true blocked = blocked + 1 break end
  end
  if trigger == false then
    id = id + 1
    allads[id] = text
    adtext = string.sub(text, 13, string.find(text, " Прислал: ") - 2)
    if string.find(text, " Тел: .") then
      adnick = string.sub(text, string.find(text, " Прислал: ") + 10, string.find(text, " Тел: ") - 2)
      adnomer = string.sub(text, string.find(text, " Тел: ") + 6, string.len(text))
    else
      adnick = "ERROR"
      adnomer = "ERROR"
    end
    adnicks[id] = adnick
    adnomers[id] = adnomer
    if string.find(string.rlower(adtext), "куплю") then color = "{FFFF00}" end
    if string.find(string.rlower(adtext), "продам") then color = "{00FF00}" end
    if string.find(string.rlower(adtext), "сто") then color = "{800080}" end
    if string.find(string.rlower(adtext), "станция") then color = "{800080}" end
    if string.find(string.rlower(adtext), "мастерская") then color = "{800080}" end
    if string.find(string.rlower(adtext), "ферма") then color = "{800080}" end
    if string.find(string.rlower(adtext), "farm") then color = "{800080}" end
    if string.find(string.rlower(adtext), "казино") then color = "{FF0000}" end
    if not string.find(string.rlower(adtext), "ферма") and not string.find(string.rlower(adtext), "farm") and not string.find(string.rlower(adtext), "сто") and not string.find(string.rlower(adtext), "станция") and not string.find(string.rlower(adtext), "мастерская") and not string.find(string.rlower(adtext), "продам") and not string.find(string.rlower(adtext), "куплю") and not string.find(string.rlower(adtext), "казино") then color = "{00FFFF}" end
    coolads[id] = color.."["..id.."]\t"..color.."["..os.date("%H:%M:%S").."] "..adtext.."\t"..color..adnick.."\t"..color..string.format("%s", adnomer).."\n"
  end
  trigger = false
end
--advance-rp
function advancerp(text)
  trigger = false
  --sampAddChatMessage(text, - 1) -- это выводит в чат объяву, которую скрипт вносит в диалог
  if not string.find(text, "Отправила") then
    for i = #allads - 25, #allads do
      if allads[i] ~= nil and text == allads[i] then trigger = true blocked = blocked + 1 break end
    end
    if trigger == false then
      id = id + 1
      allads[id] = text
      adtext = string.sub(text, 6, string.find(text, " | Отправил ", 1, true) - 1)
      adnick = string.sub(text, string.find(text, "| Отправил ", 1, true) + 11, string.find(text, "тел.", 1, true) - 3)
      adnick = string.sub(adnick, 1, string.find(adnick, "[", 1, true) - 1)
      adnomer = string.sub(text, string.find(text, "(тел. ", 1, true) + 6, string.len(text) - 1)
      adnicks[id] = adnick
      adnomers[id] = adnomer
      if string.find(string.rlower(adtext), "куплю") then color = "{FFFF00}" end
      if string.find(string.rlower(adtext), "продам") then color = "{00FF00}" end
      if not string.find(string.rlower(adtext), "продам") and not string.find(string.rlower(adtext), "куплю") then color = "{00FFFF}" end
      coolads[id] = color.."["..id.."]\t"..color.."["..os.date("%H:%M:%S").."] "..adtext.."\t"..color..adnick.."\t"..color..string.format("%s", adnomer).."\n"
    end
    trigger = false
  end
end
--diamond-rp
function diamondrp(text)
  trigger = false
  --sampAddChatMessage(text, - 1) -- это выводит в чат объяву, которую скрипт вносит в диалог
  if not string.find(text, "Отправила") then
    for i = #allads - 25, #allads do
      if allads[i] ~= nil and text == allads[i] then trigger = true blocked = blocked + 1 break end
    end
    if trigger == false then
      id = id + 1
      allads[id] = text
      adtext = string.sub(text, 1, string.find(text, " Отправитель:", 1, true) - 1)
      adnick = string.sub(text, string.find(text, " Отправитель:", 1, true) + 14, string.find(text, "тел.", string.len(text) - 15, true) - 3)
      adnomer = string.sub(text, string.find(text, "(тел. ", 1, true) + 6, string.len(text) - 1)
      adnicks[id] = adnick
      adnomers[id] = adnomer
      if string.find(string.rlower(adtext), "куплю") then color = "{FFFF00}" end
      if string.find(string.rlower(adtext), "продам") then color = "{00FF00}" end
      if not string.find(string.rlower(adtext), "продам") and not string.find(string.rlower(adtext), "куплю") then color = "{00FFFF}" end
      coolads[id] = color.."["..id.."]\t"..color.."["..os.date("%H:%M:%S").."] "..adtext.."\t"..color..adnick.."\t"..color..string.format("%s", adnomer).."\n"
    end
    trigger = false
  end
end
--arizona-rp
function arizonarp(text)
  trigger = false
  --sampAddChatMessage(text, - 1) -- это выводит в чат объяву, которую скрипт вносит в диалог
  if not string.find(text, "Отправила") then
    for i = #allads - 25, #allads do
      if allads[i] ~= nil and text == allads[i] then trigger = true blocked = blocked + 1 break end
    end
    if trigger == false then
      id = id + 1
      allads[id] = text
      adtext, adnick, adnomer = string.match(text, "Объявление: (.+) Отправил: (%g+)%[%d+%] Тел. (%d+)")
      adnicks[id] = adnick
      adnomers[id] = adnomer
      if string.find(string.rlower(adtext), "куплю") then color = "{FFFF00}" end
      if string.find(string.rlower(adtext), "продам") then color = "{00FF00}" end
      if not string.find(string.rlower(adtext), "продам") and not string.find(string.rlower(adtext), "куплю") then color = "{00FFFF}" end
      coolads[id] = color.."["..id.."]\t"..color.."["..os.date("%H:%M:%S").."] "..adtext.."\t"..color..adnick.."\t"..color..string.format("%s", adnomer).."\n"
    end
    trigger = false
  end
end
--trinity-rp
function trinityrp(text)
  trigger = false
  --sampAddChatMessage(text, - 1) -- это выводит в чат объяву, которую скрипт вносит в диалог
  if not string.find(text, "Тел.") then
    adtext = string.sub(text, string.find(text, "]", 1, true) + 10, string.len(text))
  else
    adnick = string.sub(text, string.find(text, "{ffffff}", 1, true) + 8, string.find(text, "{EEA9B8} Тел.", 1, true) - 1)
    if string.find(text, "{EEA9B8}", string.find(text, "Тел. {ffffff}", 1, true), true) then
      adnomer = string.sub(text, string.find(text, "Тел. {ffffff}", 1, true) + 13, string.find(text, "{EEA9B8}", string.find(text, "Тел. {ffffff}", 1, true), true) - 1)
    else
      adnomer = string.sub(text, string.find(text, "Тел. {ffffff}", 1, true) + 13, text:len())
    end
  end
  if adtext ~= nil and adnick ~= nil then
    id = id + 1
    adscount = adscount + 1
    allads[id] = text
    adnicks[id] = adnick
    adnomers[id] = adnomer
    if string.find(string.rlower(adtext), "куплю") then color = "{FFFF00}" end
    if string.find(string.rlower(adtext), "продам") then color = "{00FF00}" end
    if not string.find(string.rlower(adtext), "продам") and not string.find(string.rlower(adtext), "куплю") then color = "{00FFFF}" end
    coolads[id] = color.."["..id.."]\t"..color.."["..os.date("%H:%M:%S").."] "..adtext.."\t"..color..adnick.."\t"..color..string.format("%s", adnomer).."\n"
    ads1 = "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n"..color.."["..id.."]\t"..color.."["..os.date("%H:%M:%S").."] "..adtext.."\t"..color..adnick.."\t"..color..string.format("%s", adnomer).."\n"..string.gsub(ads1, "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n", "")
    adtext = nil
    adnick = nil
    adnick = nil
  end
  trigger = false
end
--imperial RPG
function imperial(text1)
  trigger = false
  --	sampAddChatMessage(text, - 1) -- это выводит в чат объяву, которую скрипт вносит в диалог
  for i = #allads - 35, #allads do
    if allads[i] ~= nil and text1 == allads[i] then trigger = true blocked = blocked + 1 break end
  end
  if trigger == false then
    id = id + 1
    allads[id] = text1
    adtext = string.sub(text1, 11, string.find(text1, "]:") - 13)
    adnick = string.sub(text1, string.find(text1, "]: ") + 3, string.find(text1, "%[(%d+)%]") - 1)
    adnomer = string.sub(text1, string.find(text1, "%[(%d+)%]") + 1, (string.len(text1) - 1))
    adnicks[id] = adnick
    adnomers[id] = adnomer
    if string.find(string.rlower(adtext), "куплю") then color = "{FFFF00}" end
    if string.find(string.rlower(adtext), "продам") then color = "{00FF00}" end
    if not string.find(string.rlower(adtext), "продам") and not string.find(string.rlower(adtext), "куплю") then color = "{00FFFF}" end
    coolads[id] = color.."["..id.."]\t"..color.."["..os.date("%H:%M:%S").."] "..adtext.."\t"..color..adnick.."\t"..color..string.format("%s", adnomer).."\n"
    ads1 = "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n"..color.."["..id.."]\t"..color.."["..os.date("%H:%M:%S").."] "..adtext.."\t"..color..adnick.."\t"..color..string.format("%s", adnomer).."\n"..string.gsub(ads1, "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n", "")
  end
  trigger = false
end
--------------------------------------------------------------------------------
----------------------ДИАЛОГ ОБЪЯВ И ВСЕ ЧТО СВЯЗАНО С НИМ----------------------
--------------------------------------------------------------------------------
--активация диалога, выключение флудерки
function ads()
  if Enable then
    Enable = false
  else
    lua_thread.create(adss)
  end
end
--диалог /ads
function adss()
  if (mode == "Sаmp-Rр" or mode == "Evolve-Rp" or mode == "ImperiaL" or mode == "Advance-Rp" or mode == "Diamond-Rp" or mode == "Arizona-Rp" or mode == "Trinity-Rp") then
    if tab == nil then tab = 1 end
    length = #coolads - (tab - 1) * 25
    ads1 = "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n"
    lastid = nil
    for i = length, length - 25, - 1 do
      if coolads[i] ~= nil then
        ads1 = ads1..coolads[i]
        if lastid == nil then lastid = i end
        if i > lastid then lastid = i end
      end
    end
    sampShowDialog(5125, "{348cb2}"..thisScript().name.." v"..thisScript().version.."   LSN: "..LSN..". SFN: "..SFN..". LVN: "..LVN..".   Blocked: "..blocked.."/"..adscount..".   Tab: "..tab..".   Use arrows to control.", ads1, "Выбрать", "Закрыть", 5)
    dialog = sampGetDialogText()
    while sampIsDialogActive(5125) do
      wait(0)
      if wasKeyPressed(37) then
        if tab ~= 1 then
          tab = tab - 1
          if tab == nil then tab = 1 end
          length = #coolads - (tab - 1) * 25
          ads1 = "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n"
          lastid = nil
          for i = length, length - 25, - 1 do
            if coolads[i] ~= nil then
              if lastid == nil then lastid = i end
              ads1 = ads1..coolads[i]
              if i > lastid then lastid = i end
            end
          end
          sampShowDialog(5125, "{348cb2}"..thisScript().name.." v"..thisScript().version.."   LSN: "..LSN..". SFN: "..SFN..". LVN: "..LVN..".   Blocked: "..blocked.."/"..adscount..".   Tab: "..tab..".   Use arrows to control.", ads1, "Выбрать", "Закрыть", 5)
          dialog = sampGetDialogText()
        end
      end
      if wasKeyPressed(39) then
        if tab ~= math.ceil(#coolads / 25) then
          tab = tab + 1
          if tab == nil then tab = 1 end
          length = #coolads - (tab - 1) * 25
          ads1 = "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n"
          lastid = nil
          for i = length, length - 25, - 1 do
            if coolads[i] ~= nil then
              if lastid == nil then lastid = i end
              if i > lastid then lastid = i end
              ads1 = ads1..coolads[i]
            end
          end
          sampShowDialog(5125, "{348cb2}"..thisScript().name.." v"..thisScript().version.."   LSN: "..LSN..". SFN: "..SFN..". LVN: "..LVN..".   Blocked: "..blocked.."/"..adscount..".   Tab: "..tab..".   Use arrows to control.", ads1, "Выбрать", "Закрыть", 5)
          dialog = sampGetDialogText()
        end
      end
    end
    local resultMain, buttonMain, typ = sampHasDialogRespond(5125)
    if buttonMain == 1 and typ == 0 then
      if mode == "Sаmp-Rр" or mode == "Evolve-Rp" then
        sampShowDialog(9890, "Флудер /ad", "Введите текст объявления и нажмите \"Флудить\".\nВведите /ads, чтобы остановить флудер.", "Флудить", "Закрыть", 1)
        while sampIsDialogActive(9890) do wait(100) end
        local resultMain, buttonMain, typ = sampHasDialogRespond(9890)
        if buttonMain == 1 then
          if sampGetCurrentDialogEditboxText(9890) ~= "" then
            floodtext = sampGetCurrentDialogEditboxText(9890)
            Enable = true
          end
        else
          ads()
        end
      else
        sampShowDialog(9899, "{348cb2}"..thisScript().name.." v"..thisScript().version, "Флудер /ad не поддерживает ваш проект.", "Окей")
      end
    elseif buttonMain == 1 and ads1 ~= "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n" and typ == 1 then
      sampShowDialog(9891, "Поиск в /ads", "Введите текст для поиска и нажмите \"Найти\".\nМожно вбивать ники, номера и текст объявления.", "Найти", "Закрыть", 1)
      while sampIsDialogActive(9891) do wait(100) end
      local resultMain, buttonMain, typ = sampHasDialogRespond(9891)
      if buttonMain == 1 then
        if sampGetCurrentDialogEditboxText(9891) ~= "" then
          zapros = sampGetCurrentDialogEditboxText(9891)
          result = "ID\tОбъявление\tПрислал\tНомер\n"
          scount = 0
          snicks = {}
          snomers = {}
          for i = 0, #coolads do
            i = #coolads - i
            if string.find(string.rlower(coolads[i]), string.rlower(sampGetCurrentDialogEditboxText(9891)), 1, true) then
              result = result..coolads[i]
              snicks[scount] = adnicks[i]
              snomers[scount] = adnomers[i]
              scount = scount + 1
            end
          end
          if scount < 25 then
            wait(400)
            searchres()
          else
            sampShowDialog(9899, "{348cb2}"..thisScript().name.." v"..thisScript().version, "По запросу \""..zapros.."\" найдено слишком много объявлений.\nНайдено: "..scount.." совпадений.\nПопробуйте уточнить запрос.", "Окей")
          end
        else
          ads()
        end
      else
        ads()
      end
    elseif buttonMain == 1 and ads1 ~= "ID\tОбъявление\tПрислал\tНомер\n \tПодать объявление\n \tПоиск по объявлениям\n" and typ > 1 and mode ~= "Arizona-Rp" then
      for i = 0, 1001 do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == adnicks[lastid - typ + 2] then
          sampShowDialog(9899, "Получатель: "..adnicks[lastid - typ + 2], "Введите текст смски и нажмите \"Отправить\".", "Отправить", "Закрыть", 1)
          while sampIsDialogActive(9899) do wait(100) end
          local resultMain, buttonMain, typ = sampHasDialogRespond(9899)
          if buttonMain == 1 then
            if sampGetCurrentDialogEditboxText(9899) ~= "" then
              if (mode == "ImperiaL") then sampSendChat("/pm "..i.." "..sampGetCurrentDialogEditboxText(9899)) end
              if (mode == "Advance-Rp" or mode == "Diamond-Rp" or mode == "Arizona-Rp" or mode == "Trinity-Rp") then sampSendChat("/sms "..adnomers[lastid - typ + 2].." "..sampGetCurrentDialogEditboxText(9899)) end
              if (mode == "Sаmp-Rр" or mode == "Evolve-Rp") then sampSendChat("/t "..i.." "..sampGetCurrentDialogEditboxText(9899)) end
              ads()
            end
          else
            ads()
          end
          break
        end
        if i == 1001 then sampShowDialog(9899, "{348cb2}"..thisScript().name.." v"..thisScript().version, "Игрок "..adnicks[lastid - typ + 2].." оффлайн.", "Окей") break end
      end
    end
  end
end
--диалог с результатами поиска
function searchres()
  sampShowDialog(4145, "{348cb2}"..thisScript().name.." v"..thisScript().version.." Запрос: "..zapros..". Найдено: "..scount..".", result, "Выбрать", "Закрыть", 5)
  while sampIsDialogActive(4145) do wait(100) end
  local resultMain, buttonMain, typ = sampHasDialogRespond(4145)
  if buttonMain == 1 and scount ~= 0 and mode ~= "Arizona-Rp" then
    for i = 0, 1001 do
      if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == snicks[typ] then
        sampShowDialog(9899, "Получатель: "..snicks[typ], "Введите текст смски и нажмите \"Отправить\".", "Отправить", "Закрыть", 1)
        while sampIsDialogActive(9899) do wait(100) end
        local resultMain, buttonMain, typ = sampHasDialogRespond(9899)
        if buttonMain == 1 then
          if sampGetCurrentDialogEditboxText(9899) ~= "" then
            if (mode == "Sаmp-Rр" or mode == "Evolve-Rp") then sampSendChat("/t "..i.." "..sampGetCurrentDialogEditboxText(9899)) end
            if (mode == "Advance-Rp" or mode == "Diamond-Rp" or mode == "Arizona-Rp" or mode == "Trinity-Rp") then sampSendChat("/sms "..adnomers[typ].." "..sampGetCurrentDialogEditboxText(9899)) end
            if (mode == "ImperiaL") then sampSendChat("/pm "..i.." "..sampGetCurrentDialogEditboxText(9899)) end
            wait(400)
            searchres()
          end
        else
          wait(500)
          searchres()
        end
        break
      end
      if i == 1001 then sampShowDialog(9899, "{348cb2}"..thisScript().name.." v"..thisScript().version, "Игрок "..snicks[typ].." оффлайн.", "Окей") break end
    end
  else
    ads()
  end
end
--------------------------------------------------------------------------------
-------------------------------------HOOK---------------------------------------
--------------------------------------------------------------------------------
function sampev.onServerMessage(color, text)
  --samp-rp и вольво
  if mode == "Sаmp-Rр" then
    if color == 14221567 and string.find(text, "Объявление:") then
      if not string.find(text, "101.1", 1, true) and not string.find(text, "102.2", 1, true) and not string.find(text, "103.3", 1, true) and not string.find(text, "radio") and not string.find(text, "FM") and not string.find(text, "Свободная") and not string.find(text, "Эфир") and not string.find(text, "чайтесь") and not string.find(text, "News") then
        lua_thread.create(samprp, text)
      else
        blocked = blocked + 1
      end
      if data.options.toggle == true then return false end
    end
    if color == 14221567 and string.find(text, "сотрудник") then
      if string.find(text, "LV") then LVN = LVN + 1 end
      if string.find(text, "LS") then LSN = LSN + 1 end
      if string.find(text, "SF") then SFN = SFN + 1 end
      adscount = adscount + 1
      if data.options.toggle == true then return false end
    end
  end
  if mode == "Evolve-Rp" then
    if color == 14221512 and string.find(text, "Объявление:") then
      if not string.find(text, "101.1", 1, true) and not string.find(text, "102.2", 1, true) and not string.find(text, "103.3", 1, true) and not string.find(text, "radio") and not string.find(text, "FM") and not string.find(text, "Свободная") and not string.find(text, "Эфир") and not string.find(text, "чайтесь") and not string.find(text, "News") then
        lua_thread.create(samprp, text)
      else
        blocked = blocked + 1
      end
      if data.options.toggle == true then return false end
    end
    if color == 14221512 and string.find(text, "сотрудник") then
      if string.find(text, "LV") then LVN = LVN + 1 end
      if string.find(text, "LS") then LSN = LSN + 1 end
      if string.find(text, "SF") then SFN = SFN + 1 end
      adscount = adscount + 1
      if data.options.toggle == true then return false end
    end
  end
  --адванс рп
  if mode == "Advance-Rp" then
    if color == 13369599 and string.find(text, "Отправил") then
      if string.find(text, "LV |") then LVN = LVN + 1 end
      if string.find(text, "LS |") then LSN = LSN + 1 end
      if string.find(text, "SF |") then SFN = SFN + 1 end
      adscount = adscount + 1
      lua_thread.create(advancerp, text)
      if data.options.toggle == true then return false end
    end
    if color == 10027263 and string.find(text, "сотрудник") then
      if data.options.toggle == true then return false end
    end
  end
  --даймонд рп
  if mode == "Diamond-Rp" then
    if color == 16711935 and string.find(text, "Отправитель") then
      lua_thread.create(diamondrp, text)
      local temptext = string.sub(text, 1, 5)
      if string.find(temptext, "LV") then LVN = LVN + 1 end
      if string.find(temptext, "LS") then LSN = LSN + 1 end
      if string.find(temptext, "SF") then SFN = SFN + 1 end
      adscount = adscount + 1
      if data.options.toggle == true then return false end
    end
    if color == 866792362 and string.find(text, "Объявление проверил") then
      if data.options.toggle == true then return false end
    end
  end
  --аризона рп
  if mode == "Arizona-Rp" then
    if color == 1941201407 and string.find(text, "Отправил") then
      adscount = adscount + 1
      lua_thread.create(arizonarp, text)
      if data.options.toggle == true then return false end
    end
    if color == 1941201407 and string.find(text, "сотрудник СМИ") then
      if string.find(text, "LV") then LVN = LVN + 1 end
      if string.find(text, "LS") then LSN = LSN + 1 end
      if string.find(text, "SF") then SFN = SFN + 1 end
      if data.options.toggle == true then return false end
    end
    text2 = text
    if string.find(text2, "{C17C2D}") then
      if string.find(text2, "сотрудник СМИ") then
        if string.find(text2, "LV") then LVN = LVN + 1 end
        if string.find(text2, "LS") then LSN = LSN + 1 end
        if string.find(text2, "SF") then SFN = SFN + 1 end
        if data.options.toggle == true then return false end
      end
    end
    text3 = text
    if string.find(text3, "{FCAA4D}[VIP]", 1, true) then
      if string.find(text3, "ение") then
        adscount = adscount + 1
        lua_thread.create(arizonarp, string.sub(text3, 15, string.len(text3)))
        if data.options.toggle == true then return false end
      end
    end
  end
  --тринити рп
  if mode == "Trinity-Rp" then
    if color == -290866945 and string.find(text, "[Реклама", 1, true) then
      lua_thread.create(trinityrp, text)
      if data.options.toggle == true then return false end
    end
  end
  --империал рпг
  if mode == "ImperiaL" then
    if color == 332279551 and string.find(text, "[Реклама]", 1, true) and string.find(text, "]:", 1, true) then
      lua_thread.create(imperial, text)
      adscount = adscount + 1
      if data.options.toggle == true then return false end
    end
  end
end
--------------------------------------------------------------------------------
----------------------------------RUSSTRING-------------------------------------
--------------------------------------------------------------------------------
local russian_characters = {
  [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}
function string.rlower(s)
  s = s:lower()
  local strlen = s:len()
  if strlen == 0 then return s end
  s = s:lower()
  local output = ''
  for i = 1, strlen do
    local ch = s:byte(i)
    if ch >= 192 and ch <= 223 then -- upper russian characters
      output = output .. russian_characters[ch + 32]
    elseif ch == 168 then -- Ё
      output = output .. russian_characters[184]
    else
      output = output .. string.char(ch)
    end
  end
  return output
end
function string.rupper(s)
  s = s:upper()
  local strlen = s:len()
  if strlen == 0 then return s end
  s = s:upper()
  local output = ''
  for i = 1, strlen do
    local ch = s:byte(i)
    if ch >= 224 and ch <= 255 then -- lower russian characters
      output = output .. russian_characters[ch - 32]
    elseif ch == 184 then -- ё
      output = output .. russian_characters[168]
    else
      output = output .. string.char(ch)
    end
  end
  return output
end
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update(php, prefix, url, komanda)
	komandaA=komanda
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  local ffi = require 'ffi'
  ffi.cdef[[
	int __stdcall GetVolumeInformationA(
			const char* lpRootPathName,
			char* lpVolumeNameBuffer,
			uint32_t nVolumeNameSize,
			uint32_t* lpVolumeSerialNumber,
			uint32_t* lpMaximumComponentLength,
			uint32_t* lpFileSystemFlags,
			char* lpFileSystemNameBuffer,
			uint32_t nFileSystemNameSize
	);
	]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  serial = serial[0]
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
	if thisScript().name == "ADBLOCK" then
		if mode == nil then mode = "unsupported" end
		php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&m='..mode..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
	else
		php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
	end
  downloadUrlToFile(php, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            if info.changelog ~= nil then
              changelogurl = info.changelog
            end
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix, komanda)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      if komandaA ~= nil then
                        sampAddChatMessage((prefix..'Обновление завершено! Подробнее об обновлении - /'..komandaA..'.'), color)
                      end
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function openchangelog(komanda, url)
  sampRegisterChatCommand(komanda,
    function()
      lua_thread.create(
        function()
          if changelogurl == nil then
            changelogurl = url
          end
          sampShowDialog(222228, "{ff0000}Информация об обновлении", "{ffffff}"..thisScript().name.." {ffe600}собирается открыть свой changelog для вас.\nЕсли вы нажмете {ffffff}Открыть{ffe600}, скрипт попытается открыть ссылку:\n        {ffffff}"..changelogurl.."\n{ffe600}Если ваша игра крашнется, вы можете открыть эту ссылку сами.", "Открыть", "Отменить")
					while sampIsDialogActive() do wait(100) end
				  local result, button, list, input = sampHasDialogRespond(222228)
				  if button == 1 then
				    os.execute('explorer "http://qrlk.me/changelog/adblock"')
				  end
        end
      )
    end
  )
end
