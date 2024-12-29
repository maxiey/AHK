#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

I_Icon = %A_ScriptDir%\icons\NMS.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

#SingleInstance, Force	;dont want multiple instances

;My Collection of No Man's Sky Macros


;Crafting Count Booster D
Numpad7::
Send, +d
sleep 500
while GetKeyState("Numpad7", "P") {
	Send, {d down}
	SetKeyDelay, 10
	Send, {d up}
	SetKeyDelay, 10
}
return