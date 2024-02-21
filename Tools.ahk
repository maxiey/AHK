#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

I_Icon = %A_ScriptDir%\icons\Tools.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

#SingleInstance, Force	;dont want multiple instances

;sed raw clipboard contents
^+y::
FileEncoding UTF-16
SendRaw %clipboard%
return

;spam RMB while holding Numpad9
Numpad9::
Settimer, SendRMB, 1
Return

Numpad9 up::
Settimer, SendRMB, off
Return

SendRMB:
Click, Right
Return

;spam LMB while holding Numpad8
Numpad8::
Settimer, SendLMB, 1
Return

Numpad8 up::
Settimer, SendLMB, off
Return

SendLMB:
Click, Left
Return

;spam LMB while holding Shift
*Space::
Settimer, SendSpacebar, 1
Return

*Space up::
Settimer, SendSpacebar, off
Return

SendSpacebar:
Send, {Space}
Return