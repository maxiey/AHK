#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

I_Icon = %A_ScriptDir%\icons\Gaeming.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

#SingleInstance, Force	;dont want multiple instances

;Thumb buttons are W and S (inlcuding Shift for sprint); RMB is Spacebar
XButton2::
Send, {w Down}
Send, {shift down}
return

XButton2 up::
Send, {w up}
Send, {shift up}
return

XButton1::
Send, {s Down}
Send, {shift down}
return

XButton1 up::
Send, {s up}
Send, {shift up}
return

RButton::Space

AppsKey::Click, Right