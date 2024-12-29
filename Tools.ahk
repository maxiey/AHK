#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

I_Icon = %A_ScriptDir%\icons\Tools.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

#SingleInstance, Force	;dont want multiple 
#MaxThreadsPerHotkey 3

; Autoclicker
~Right & Numpad4::
ToggleAutoclicker := !ToggleAutoclicker
Loop
{
	If (!ToggleAutoclicker)
		Break
	Click
	Sleep 1 ; Make this number higher for slower clicks, lower for faster.
}
Return

; Autoclicker R Click
~Right & Numpad5::
ToggleAutoclickerR := !ToggleAutoclickerR
Loop
{
	If (!ToggleAutoclickerR)
		Break
	Click, Right
	Sleep 1 ; Make this number higher for slower clicks, lower for faster.
}
Return

; Hold LMB
~Right & Numpad1:: Click, Down

; Hold RMB
~Right & Numpad2:: Click, Right, Down

; Spam Space While Holding Alt
;Space::
;While GetKeyState("Space","P")
;	Send, {Space}
;Return