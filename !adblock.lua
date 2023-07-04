require "lib.moonloader"
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name("ADBLOCK")
script_version("25.06.2022-srpfix")
script_author("qrlk")
script_description("/ads")
script_url("https://github.com/qrlk/adblock")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://ecd9cd07f8cb4f50ad12ee54e3ffe294@o1272228.ingest.sentry.io/6529708" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/adblock/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/adblock"
    end
  end
end
-------------------------------------var----------------------------------------
math.randomseed(os.time())
local prefix = '['..string.upper(thisScript().name)..']: '
local sampev = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local data = inicfg.load({
  options =
  {
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
  ["95.181.158.74"] = "Samp-Rp",
  ["95.181.158.63"] = "Samp-Rp",
  ["95.181.158.69"] = "Samp-Rp",
  ["95.181.158.77"] = "Samp-Rp",
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
  ["185.169.134.173"] = "Arizona-Rp",
  ["185.169.134.83"] = "Trinity-Rp",
  ["185.169.134.84"] = "Trinity-Rp",
  ["185.169.134.85"] = "Trinity-Rp"
}

local serversNames = {
  ["SRP"] = "Samp-Rp",
  ["Samp-Rp"] = "Samp-Rp",
  ["Evolve"] = "Evolve-Rp",
  ["ImperiaL"] = "ImperiaL",
  ["Advance"] = "Advance-Rp",
  ["Diamond"] = "Diamond-Rp",
  ["Arizona"] = "Arizona-Rp",
  ["Trinity"] = "Trinity-Rp"
}

function getModeByServerName(sname)
  for k, v in pairs(serversNames) do
    if string.find(sname, k, 1, true) then
      return v
    end
  end
end
-------------------------------------MAIN---------------------------------------
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end

  while sampGetCurrentServerAddress() == nil do wait(100) end

  -- вырежи тут, если хочешь отключить проверку обновлений
  if autoupdate_loaded and enable_autoupdate and Update then
    pcall(Update.check, Update.json_url, Update.prefix, Update.url)
  end
  -- вырежи тут, если хочешь отключить проверку обновлений

  while sampGetCurrentServerName() == "SA-MP" do wait(100) end
  mode = servers[sampGetCurrentServerAddress()] or getModeByServerName(sampGetCurrentServerName())
  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  if mode ~= nil then
    sampAddChatMessage(("ADBLOCK v"..thisScript().version.." successfully loaded! /ads - show hidden ads! /tads - toggle! Mode: "..mode..". <> by qrlk."), color)
  else
    sampAddChatMessage(("ADBLOCK v"..thisScript().version.." not loaded! Reason: unknown server. <> by qrlk."), 0xFF4500)
  end
  -- вырезать тут, если хочешь отключить сообщение при входе в игру

  if mode == nil then thisScript():unload() end

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
    if Enable and (mode == "Samp-Rp" or mode == "Evolve-Rp") then
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
  if (mode == "Samp-Rp" or mode == "Evolve-Rp" or mode == "ImperiaL" or mode == "Advance-Rp" or mode == "Diamond-Rp" or mode == "Arizona-Rp" or mode == "Trinity-Rp") then
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
      if mode == "Samp-Rp" or mode == "Evolve-Rp" then
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
              if (mode == "Samp-Rp" or mode == "Evolve-Rp") then sampSendChat("/t "..i.." "..sampGetCurrentDialogEditboxText(9899)) end
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
            if (mode == "Samp-Rp" or mode == "Evolve-Rp") then sampSendChat("/t "..i.." "..sampGetCurrentDialogEditboxText(9899)) end
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
  if mode == "Samp-Rp" then
    if color == 14221567 and string.find(text, "Объявление:") then
      if not string.find(text, "101.1", 1, true) and not string.find(text, "102.2", 1, true) and not string.find(text, "103.3", 1, true) and not string.find(text, "radio") and not string.find(text, "FM") and not string.find(text, "Свободная") and not string.find(text, "Эфир") and not string.find(text, "чайтесь") and not string.find(text, "News") then
        lua_thread.create(samprp, text)
      else
        blocked = blocked + 1
      end
      if data.options.toggle == true then return false end
    end
    if color == 14221567 and string.find(text, "Редакция News") then
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