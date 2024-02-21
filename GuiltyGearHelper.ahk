#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

I_Icon = %A_ScriptDir%\icons\GuiltyGearHelper.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

#SingleInstance, Force	;dont want multiple instances

SetNumLockState, AlwaysOn	; just in case

*NumpadEnd::Numpad1	; Shift changes Numpad's output to non-Numlock. AHK says no.
*NumpadDown::Numpad2
*NumpadPgDn::Numpad3
*NumpadLeft::Numpad4
*NumpadClear::Numpad5
*NumpadRight::Numpad6
*NumpadHome::Numpad7
*NumpadUp::Numpad8
*NumpadPgUp::Numpad9
