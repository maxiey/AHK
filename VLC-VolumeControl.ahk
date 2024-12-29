;~ #NoTrayIcon
#Persistent
#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn ; Recommended for catching common errors.
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#UseHook
ListLines Off
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode RegEx
StringCaseSense Off 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

I_Icon = %A_ScriptDir%\icons\VLC-VolumeControl.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

OnExit("cleanup_before_exit")
SetFormat, Float, 0.3
global scrollIntensity := 1.5	; how hard volume is changed (base 1)
;global currentAudio := "Strip[4]"	; Strip 3 is VLC
global VMR_FUNCTIONS := {}
global VMR_DLL_DRIVE := "C:"
global VMR_DLL_DIRPATH := "Program Files (x86)\VB\Voicemeeter"
global VMR_DLL_FILENAME_32 := "VoicemeeterRemote.dll"
global VMR_DLL_FILENAME_64 := "VoicemeeterRemote64.dll"
global VMR_DLL_FULL_PATH := VMR_DLL_DRIVE . "\" . VMR_DLL_DIRPATH . "\"
Sleep, 500
if (A_Is64bitOS) {
VMR_DLL_FULL_PATH .= VMR_DLL_FILENAME_64
} else {
VMR_DLL_FULL_PATH .= VMR_DLL_FILENAME_32
}

; == START OF EXECUTION ==
; ========================

; Load the VoicemeeterRemote DLL:
; This returns a module handle
global VMR_MODULE := DllCall("LoadLibrary", "Str", VMR_DLL_FULL_PATH, "Ptr")
if (ErrorLevel || VMR_MODULE == 0)
die("Attempt to load VoiceMeeter Remote DLL failed.")

; Populate VMR_FUNCTIONS
add_vmr_function("Login")
add_vmr_function("Logout")
add_vmr_function("RunVoicemeeter")
add_vmr_function("SetParameterFloat")
add_vmr_function("GetParameterFloat")
add_vmr_function("IsParametersDirty")

; "Login" to Voicemeeter, by calling the function in the DLL named 'VBVMR_Login()'...
login_result := DllCall(VMR_FUNCTIONS["Login"], "Int")
if (ErrorLevel || login_result < 0)
die("VoiceMeeter Remote login failed.")

; If the login returns 1, that apparently means that Voicemeeter isn't running,
; so we start it; pass 1 to run Voicemeeter, 2 for Voicemeeter Banana, or 3 for Voicemeeter Potato:
if (login_result == 1) {
DllCall(VMR_FUNCTIONS["RunVoicemeeter"], "Int", 3, "Int")
if (ErrorLevel)
die("Attempt to run VoiceMeeter failed.")
Sleep 2000
}

; == HOTKEYS ==
; =============

;add your code here

; Media_Play_Pause::
; if (currentAudio = "Bus[0]")
; 	currentAudio := "Bus[1]"
; else if (currentAudio = "Bus[1]")
; 	currentAudio := "Strip[0]"
; else if (currentAudio = "Strip[0]")
; 	currentAudio := "Strip[1]"
; else
; 	currentAudio := "Bus[0]"
; return

*Volume_Up::
currentAudio := chooseStrip()
makeVoiceMeeterTopmost()
cLvl := readParam(currentAudio . ".Gain")
if (cLvl != ""){
	cLvl += scrollIntensity
	adjustVolLvl(currentAudio . ".Gain", cLvl)
}
return

*Volume_Down::
currentAudio := chooseStrip()
makeVoiceMeeterTopmost()
cLvl := readParam(currentAudio . ".Gain")
if (cLvl != ""){
	cLvl -= scrollIntensity
	adjustVolLvl(currentAudio . ".Gain", cLvl)
}
return

*Volume_Mute::
currentAudio := chooseStrip()
makeVoiceMeeterTopmost()
cM := readParam(currentAudio . ".Mute")
if (cM != "")
	adjustMute(currentAudio . ".Mute", cM)
return

; == Functions ==
; ===============
readParam(loc){
Loop
{
	pDirty := DLLCall(VMR_FUNCTIONS["IsParametersDirty"]) ;Check if parameters have changed. 
	if (pDirty==0) ;0 = no new paramters.
		break
	else if (pDirty<0) ;-1 = error, -2 = no server
		return ""
	else ;1 = New parameters -> update your display. (this only applies if YOU have a display, couldn't find any code to update VM display which can get off sometimes)
		if A_Index > 200
			return ""
		sleep, 20
}
tParamVal := 0.0
NumPut(0.0, tParamVal, 0, "Float")
statusLvl := DllCall(VMR_FUNCTIONS["GetParameterFloat"], "AStr", loc, "Ptr", &tParamVal, "Int")
tParamVal := NumGet(tParamVal, 0, "Float")
if (statusLvl < 0)
	return ""
else
	return tParamVal
}

adjustVolLvl(loc, tVol) {
if (tVol > 12.0)
	tVol = 12.0
else if (tVol < -60.0) 
	tVol = -60.0
DllCall(VMR_FUNCTIONS["SetParameterFloat"], "AStr", loc, "Float", tVol, "Int")
}

adjustMute(loc, tM) {
if (tM = 0)
	tM = 1
else
	tM = 0
DllCall(VMR_FUNCTIONS["SetParameterFloat"], "AStr", loc, "Float", tM, "Int")
}

chooseStrip() {	; decide which strip to control based on modifier keys being held
	downShift := GetKeyState("Shift", "P")
	downCtrl := GetKeyState("Control", "P")
	downAlt := GetKeyState("Alt", "P")
	
	if (downShift)
		return "Strip[5]"	; Desktop Audio
	else if (downCtrl)
		return "Strip[6]"	; Discord
	else if (downAlt)
		return "Strip[7]"	; Firefox
	else
		return "Strip[4]"	; default VLC
}

makeVoiceMeeterTopmost(){
	;weGotAWindow := false
	;windw = ""
	;
	;IfWinExist, ahk_ voicemeeter8x64.exe	; check for 64 bit running
	;{
	;	windw := "voicemeeter8x64.exe"
	;	weGotAWindow := true
	;}
	;
	;
	;IfWinExist, ahk_exe voicemeeter8.exe	; check for normal running
	;{
	;	windw := "voicemeeter8.exe"
	;	weGotAWindow := true
	;}
	
	;processNames := []
	;processNames.Push("voicemeeter8.exe")
	;processNames.Push("voicemeeter8x64.exe")
	;
	;for index, element in processNames ; Enumeration is the recommended approach in most cases.
	;{
	;	MsgBox % "ahk_exe: " . element . "`npid: " . WinExist("ahk_exe " . element)
	;	if WinExist("ahk_exe " . element)
	;		;WinActivate
	;		WinSet, AlwaysOnTop, On
	;		WinSet, AlwaysOnTop, Off
	;		MsgBox A
	;		Break
	;}
	if WinExist("ahk_exe voicemeeter8x64.exe"){
		WinSet, AlwaysOnTop, On
		WinSet, AlwaysOnTop, Off
		SetTimer, WindowToBottomAfterSetTime, Off
		SetTimer, WindowToBottomAfterSetTime, 4000
	}
	
	;WinActivate, ahk_exe voicemeeter8x64.exe
	;WinSet, AlwaysOnTop, On, ahk_id %wind%
	;WinSet, AlwaysOnTop, Off, ahk_id %wind%
	;MsgBox %wind%
	
	Return
}

WindowToBottomAfterSetTime:
SetTimer, WindowToBottomAfterSetTime, Off
if WinExist("ahk_exe voicemeeter8x64.exe"){
	WinSet, Bottom
}
Return

add_vmr_function(func_name) {
VMR_FUNCTIONS[func_name] := DllCall("GetProcAddress", "Ptr", VMR_MODULE, "AStr", "VBVMR_" . func_name, "Ptr")
if (ErrorLevel || VMR_FUNCTIONS[func_name] == 0)
	die("Failed to register VMR function " . func_name . ".")
}

cleanup_before_exit(exit_reason, exit_code) {
DllCall(VMR_FUNCTIONS["Logout"], "Int")
; OnExit functions must return 0 to allow the app to exit.
return 0
}

die(die_string:="UNSPECIFIED FATAL ERROR.", exit_status:=254) {
MsgBox 16, FATAL ERROR, %die_string%
ExitApp exit_status
}
