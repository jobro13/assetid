#!/usr/bin/lua

local Send = ({...})[1]
if not Send then
	error("enter a message")
end

local Port=3333
local User = os.getenv("BOTUSER")
local Pass = os.getenv("BOTPASS")

if not User or not Pass then
	error("env not set, cannot continue, set BOTUSER and BOTPASS")
end

local socket = require 'socket'
local socket=socket.tcp()
socket:settimeout(0.25)

local function read_until_timeout()
	local last,msg
	repeat
		msg, last =  socket:receive()
		print(msg,last)
	until last == "timeout"
end

local rut = read_until_timeout

socket:connect("127.0.0.1", Port)
rut()
socket:send(User.."\r\n")
rut()
socket:send(Pass.."\r\n")
rut()
socket:send(".msg #SurvivalGames " .. Send .. "\r\n")
rut()
socket:send(".quit\r\n")
--rut()
socket:close()
os.exit()
