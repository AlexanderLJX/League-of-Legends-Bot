#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#InstallKeybdHook
#UseHook
;#IfWinActive League of Legends (TM) Client
#SingleInstance Force
#MaxThreadsPerHotkey 1


ListLines Off
SetBatchLines -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetControlDelay -1
SetDefaultMouseSpeed, 0
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

global instantoffensiveskill := ["d", "f"]
global offensiveskills := ["q", "e", "r"]
global casttime := 250
global missilespeed := 1200/1000
global offensiveskillproximity := 800
global defensiveskills := ["w"]
global lifesavingskills := []
global skillorder := ["r","q","e","w"]
global mutemode := 0
; The purpose of fastmode is to reduce the time in each loop, making q() activate more times per second
global fastmode := 1
global tethermode := 0
global tetherlength := 300
global offsets := 100
global attackspeed := 0.5

global redorblue := 1
global usedd := 1
global focusX := 961
global focusY := 510
global botnexusX := 1535
global botnexusY := 1046
global topnexusX := 1889
global topnexusY := 696
global nexusX := botnexusX
global nexusY := botnexusY
global chatboxX := 304 
global chatboxY := 758
global recall := 0
global died := 0
global revived := 0
global dead1 := 0
global dead2 := 0
global dead3 := 0
global dead4 := 0
global dead5 := 0
global maybedead2 := 0
global maybedead3 := 0
global maybedead4 := 0
global maybedead5 := 0
global allyhpY := 628
global allyhp2 := 1542
global allyhp3 := 1639
global allyhp4 := 1736
global allyhp5 := 1833
global ally2healthpercentage := 99
global ally3healthpercentage := 99
global ally4healthpercentage := 99
global ally5healthpercentage := 99
global following := 2
global basing := 0
global basingtick := 0
global recalling := 0
global recallingtick := 0
global shop := 1
global spelloffset := 50
global newgame := 0
global switchrandomplayer := 0
global callrole := 1
global inclient := 1
global afktick := 1
global playerdied := 0
global afkfoundX := 0
global afkfoundY := 0
global channellingtick := 0
global ischannelling := 0
global summonerX := 0
global summonerY := 0
global storX := 0
global storY := 0
global shortest := 0
global autotimer := 0
global storXoffset := 60
global storYoffset := 170



CodeTimer()
{

	Global CounterAfter
	Global CounterBefore
	Global freq
	
	If (CounterBefore != "")
	{
	DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
	DllCall("QueryPerformanceFrequency", "Int64*", freq)
	TimedDuration := (CounterAfter - CounterBefore) / freq * 1000
	CounterBefore := ""
	MsgBox %TimedDuration% ms have elapsed!
	Return TimedDuration
	}
	Else
	DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
}


; check death
; 855 1035
; 950 1055
checkdeath(){
ImageSearch, FoundX, FoundY, 805, 1035, 950, 1055, *5 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\checkdeath.bmp
if(ErrorLevel = 0){
if(dead1=0){
died := 1
}
dead1 := 1
}else{
if(dead1=1){
revived := 1
}
dead1 := 0
}
}


level(){
send {ctrl down}
Loop % skillorder.Length() {
send % skillorder[A_Index]
}
send {ctrl up}
}


q::
q()
return


q(){
send {f%following% up}
loopX := 0
loopY := 0
summonerfound := 0
enemyfound := 0
summonerX := 0
summonerY := 0
storX := 0
storY := 0
stortick := 0
shortest := offensiveskillproximity+300
distance := 3000
; find summoner
;PixelSearch, FoundX, FoundY, 0, 0, 1980, 1080, 0x63D35A, 0, Fast RGB
ImageSearch, FoundX, FoundY, loopX, loopY, 1980, 1080, *20 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\summonerlevelcap.bmp
if(ErrorLevel = 0){
summonerfound := 1
summonerX := FoundX
summonerY := FoundY
}
; find enemies
if(summonerfound = 1){
loop, 5
{
;PixelSearch, FoundX, FoundY, 0, 0, 1980, 1080, 0xCB6257, 0, Fast RGB
ImageSearch, FoundX, FoundY, loopX, loopY, 1980, 1080, *20 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\enemylevelcap.bmp
if(ErrorLevel = 0){
xsqrt := ((FoundX+storXoffset)-(summonerX+storXoffset))**2
ysqrt := ((FoundY+storYoffset)-(summonerY+storYoffset))**2
distance := Sqrt(xsqrt+ysqrt)
if(distance<shortest){
enemyfound := 1
shortest := distance
storX := FoundX
storY := FoundY
DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
}
loopY := FoundY + 30
}else{
break
}
}
}
if(enemyfound=1){
if(shortest<400){
send {t down}
autoattack((storX+storXoffset-20), (storY+storYoffset))
}
ImageSearch, FoundX, FoundY, summonerX-100, summonerY-100, summonerX+100, summonerY+100, *20 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\summonerlevelcap.bmp
if(ErrorLevel = 0){
summonerX := FoundX
summonerY := FoundY
}
ImageSearch, FoundX, FoundY, storX-100, storY-100, storX+100, storY+100, *20 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\enemylevelcap.bmp
;PixelSearch, FoundX, FoundY, storX-100, storY-100, storX+100, storY+100, 0xCB6257, 0, Fast RGB
if(ErrorLevel = 0){
DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
DllCall("QueryPerformanceFrequency", "Int64*", freq)
changetick := (CounterAfter - CounterBefore) / freq * 1000
changeXovertime := (FoundX-storX)/changetick
changeYovertime := (FoundY-storY)/changetick
predict1X := FoundX+(changeXovertime*casttime)
predict1Y := FoundY+(changeYovertime*casttime)
predict2X := predict1X
predict2Y := predict1Y
loop 10 {
xsq := ((predict2X+storXoffset)-(summonerX+storXoffset))**2
ysq := ((predict2Y+storYoffset)-(summonerY+storYoffset))**2
distance := Sqrt(xsq+ysq)
changeXdistance := changeXovertime*(distance/missilespeed)
changeYdistance := changeYovertime*(distance/missilespeed)
predict2X := predict1X + changeXdistance
predict2Y := predict1Y + changeYdistance
}
if(distance<offensiveskillproximity){
Mousemove, predict2X+storXoffset, predict2Y+storYoffset
Loop % offensiveskills.Length() {
send % offensiveskills[A_Index]
}
;chat("changetick: " . changetick)
;chat("X: " . predict2X)
;chat("Y: " . predict2Y)
sleep, 50
}
}
}
}

/*
autoattackenemy(){
if(shortest<400){
send {t down}
autoattack(storX+storXoffset, storY+storYoffset)
}
}
*/

autoattack(xpos,ypos){
if(summonerX=0){
return
}
distancefromally := sqrt(((summonerX+60-focusX-offsets)^2)+((summonerY-170-focusY+offsets)^2))
if(distancefromally<200){
if((A_TickCount-autotimer)>((1/attackspeed)*1000)){
Mousemove, xpos, ypos
send {RButton}
autotimer := A_TickCount
;sleep ((1/attackspeed)/3)
}
}
}

farm(){
minionX := 0
minionY := 0
foundminion := 0
if(shortest>1000){
send {t up}
loopY := 0
xone := 0
xtwo := 0
ytwo := 0
if(redorblue=0){
loopY := 0
xone := 1980
xtwo := 0
ytwo := 1090
}else{
loopY := 1080
xone := 0
xtwo := 1980
ytwo := 0
}
loop, 5
{
PixelSearch, FoundX, FoundY, xone, loopY, xtwo, ytwo, 0xC55A59, 0, Fast RGB
if(ErrorLevel = 0){
xsqrt := ((FoundX)-(summonerX+storXoffset))**2
ysqrt := ((FoundY)-(summonerY+storYoffset))**2
distance := Sqrt(xsqrt+ysqrt)
if(distance<shortest){
foundminion := 1
shortest := distance
minionX := FoundX
minionY := FoundY
}
if(redorblue=0){
loopY := FoundY + 10
}else{
loopY := FoundY - 10
}
}else{
break
}
if(foundminion=1){
;chat("minionX: " . minionX . "minionY: " . minionY)
autoattack(minionX, minionY)
}
}
}
}

;ward
ward(){
PixelSearch, FoundX, FoundY, 0, 0, 1980, 1080, 0x82303F, 2, Fast RGB
If (ErrorLevel = 0){
Mousemove, FoundX, FoundY
send {4}
sleep, 3000
}
}



;ally death detection
; 109E42
checkallyhealthpercentage(){
allycounter := 2
loop, 4 {
;chat(allycounter . " " . dead%allycounter%)
ImageSearch, FoundX, FoundY, allyhp%allycounter%-5, 600, allyhp%allycounter% + 10, 700, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\allyminimaphealthbar.bmp
If (ErrorLevel = 0){
maybedead%allycounter% := 0
PixelSearch, FoundX, FoundY, allyhp%allycounter% + 75, allyhpY, allyhp%allycounter% + 4, allyhpY+16, 0x08CA4A , 80, Fast RGB
If (ErrorLevel = 0){
ally%allycounter%healthpercentage := Round(((FoundX - (allyhp%allycounter% + 4))/67)*100)
;chat("Ally is at %" . ally%allycounter%healthpercentage . " health")
dead%allycounter% := 0
}
}else if (ErrorLevel = 1){
maybedead%allycounter% := maybedead%allycounter% + 1
if(maybedead%allycounter% > 2){
dead%allycounter% := 1	
}
}
allycounter := allycounter + 1
}
}




;heal
heal(){
PixelSearch, FoundX, FoundY, 855, 1045, 856, 1046, 0x010D07, 0, Fast RGB
If (ErrorLevel = 1){
Mousemove, focusX, focusY
send {LButton}
If (ally%following%healthpercentage < 80){
Loop % defensiveskills.Length() {
send % defensiveskills[A_Index]
}
}
}
}

;potion
potion(){
PixelSearch, FoundX, FoundY, 898, 1040, 908, 1050, 0x006E08, 5, Fast RGB
If (ErrorLevel = 1){
Loop % lifesavingskills.Length() {
send % lifesavingskills[A_Index]
}
}
;ImageSearch, FoundX, FoundY, 955, 1032, 1036, 1056, *5 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\summonermissinghealth.bmp
PixelSearch, FoundX, FoundY, 1007, 1043, 1008, 1044, 0x010D07, 3, Fast RGB
If (ErrorLevel = 0){
if (usedd=1){
send {1}
usedd := 0
SetTimer, usepotion, 15000
}
}
}

usepotion:
usedd := 1
return



chat(sentence){
if(mutemode=1){
	return
}
send {enter}
sleep, 100
send, %sentence%
sleep, 100
send {enter}
sleep, 100
}

initialize(){
chat("Initializing Bao bot v2.61....")

chat("Locating chat box....")
send {enter}
sleep, 200
ImageSearch, FoundX, FoundY, 0, 0, 1980, 1080, *20 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\teamchatbox.bmp
If (ErrorLevel = 0){
send {enter}
sleep, 100
chatboxX := FoundX - 400
chatboxY := FoundY - 50
chat("Chat box location: " . chatboxX . "x " . chatboxY . "y")
}else{
send {enter}
sleep, 20
}

chat("Detecting red or blue side...")
PixelSearch, FoundX, FoundY, 1595, 969, 1615, 989, 0x3287A4, 10, Fast RGB
If (ErrorLevel = 0){
redorblue := 1
nexusX := botnexusX
nexusY := botnexusY
offsets := 100
chat("Detected: Playing blue side")
}else{
redorblue := 0
nexusX := topnexusX
nexusY := topnexusY
offsets := -100
chat("Detected: Playing red side")
}

chat("Determining ally health bar locations...")
startsweepX := 0
allycounter := 2
loop 4 {
ImageSearch, FoundX, FoundY, startsweepX, 0, 1980, 1080, *40 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\allyminimaphealthbar.bmp
If (ErrorLevel = 0){
startsweepX := FoundX + 70
allyhp%allycounter% := FoundX
dead%allycounter% := 0
chat("Ally " . allycounter . " is at " . FoundX . "x " . FoundY . "y")
allycounter := allycounter + 1
}
}

chat("Bao bot command list: follow 2, follow 3, follow 4, follow 5, recall")
following := 2
switchrandomplayer := 0
chat("Brrr")
chat("Following default player 2")
}



checkfollow(){
send {x down}
sleep, 20
send {x up}
followNo := 6
Loop 4 {
followNo := followNo-1
ImageSearch, XPos2, YPos2, chatboxX, chatboxY, chatboxX+600, chatboxY+50, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\follow%followNo%.bmp
If (ErrorLevel = 0){
switchrandomplayer := 0
send {f%following% up}
chat("Brrr")
chat("Following player " . followNo . "{!}")
following := followNo
; drag click on the way
break
}
}
}

checkallystatus(){
;check if channelling
ImageSearch, XPos2, YPos2, focusX-100, focusY-400, focusX+100, focusY-100, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\channeling.bmp
If (ErrorLevel = 0){
if(ischannelling=0){
ischannelling := 1
channellingtick := A_TickCount
}
if((A_TickCount-channellingtick)>6000){
chat("Player " . following . " is channelling")
base()
}
}else{
ischanelling := 0
channellingtick := 0
}
;check if CCed

}

followplayer(){
; do not cancel autoattack
if(A_TickCount-autotimer>((1/attackspeed)/3)*1000){
send {f%following% up}
send {f%following% down}
Mousemove, focusX-offsets, focusY+offsets
send {RButton}
sleep, 20
}
}


checkgamestart(){
ImageSearch, XPos2, YPos2, 0, 0, 1980, 1080, *20 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\summonerlevelcap.bmp
If (ErrorLevel = 0){
return 1
}else{
return 0
}
}


afkdetection(){
ImageSearch, FoundX, FoundY, 1503, 669, 1980, 1080, *0 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\minimapwhitebox.bmp
If (ErrorLevel = 0){
if(FoundX=afkfoundX && FoundY=afkfoundY){
afktick := afktick + 1
if(afktick>50){
	afktick := 0
	chat("Player " . following . " is afk")
	switchrandomplayer := 1
}
}else{
afktick := 0
afkfoundX := FoundX
afkfoundY := FoundY
}
}	
}

switchrandomplayer(){
	if(switchrandomplayer = 1){
	switchrandomplayer := 0
	following := following + 1
	if(following=6){
	following := 2
	}
	chat("Switching to player " . following)
	}
}

;-----------------------------------START----------------------------------------

f1::
brloop = 0
Loop {
if WinActive("ahk_exe League of Legends.exe"){
if(inclient = 1){
inclient := 0
newgame = 1
}
if(newgame = 1){
if(checkgamestart() = 1){
	newgame := 0
	initialize()
	shop := 1
	basing := 0
}
sleep, 100
}

checkdeath()
if(died=1){
died := 0
basing := 0
recalling := 0
chat("I'm dead...")
}
if(revived=1){
revived := 0
basing := 0
recalling := 0
shop := 1
}

if(recalling=1){
if((A_TickCount-recallingtick)>10000){
recalling := 0
shop := 1
}
}else if(basing = 1){
	Mousemove, nexusX, nexusY
	send {RButton}
	sleep, 50
	checkfollow()
	switchrandomplayer()
	q()
	if((A_TickCount-basingtick)>7000){
	basing := 0
	recall()
	}
}else{
	if(shop = 1){
	shop := 0
	shop()
	}
	checkfollow()
	switchrandomplayer()
	q()
	farm()
	followplayer()
	heal()
	potion()
	level()
	checkrecall()
	afkdetection()
	checkallystatus()
	checkallyhealthpercentage()
}

if(brloop=1){
chat("Bao bot is stopping...")
return
}
}else{
;----------------------------------IN CLIENT-----------------------------------
inclient := 1
MouseMove, 10, 10
if(brloop=1){
return
}
ImageSearch, FoundX, FoundY, 650, 500, 1300, 1080, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\ok.bmp
if(ErrorLevel = 0){
MouseMove, FoundX, FoundY
send, {LButton down}
sleep, 100
send, {LButton up}
sleep, 100
}
ImageSearch, FoundX, FoundY, 650, 500, 1300, 1080, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\playagain.bmp
if(ErrorLevel = 0){
MouseMove, FoundX, FoundY
send, {LButton down}
sleep, 100
send, {LButton up}
sleep, 100
}
ImageSearch, FoundX, FoundY, 650, 500, 1300, 1080, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\findmatch.bmp
if(ErrorLevel = 0){
called := 0
MouseMove, FoundX, FoundY
send, {LButton down}
sleep, 100
send, {LButton up}
sleep, 100
}
ImageSearch, FoundX, FoundY, 650, 300, 1300, 1080, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\acceptmatch.bmp
if(ErrorLevel = 0){
called := 0
MouseMove, FoundX, FoundY
send, {LButton down}
sleep, 100
send, {LButton up}
sleep, 100
}
if(called = 0){
ImageSearch, FoundXX, FoundYY, 0, 500, 1000, 1080, *20 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\lobbyrunebox.bmp
if(ErrorLevel = 0){
called := 1
loop, 4 {
MouseMove, FoundXX-400, FoundYY+20
send, {LButton}
sleep, 50
send, sp
sleep, 50
send, {enter}
sleep, 50
}

MouseMove, FoundXX+440, FoundYY-676
sleep, 400
send, {LButton}
sleep, 300
send, lux
sleep, 300
send, {enter}
sleep, 200
MouseMove, FoundXX-40, FoundYY-600
sleep, 200
send, {LButton down}
sleep, 200
send, {LButton up}
sleep, 200
MouseMove, FoundXX+263, FoundYY-65
sleep, 100
send, {LButton down}
sleep, 100
send, {LButton up}
sleep, 100
}
}
}
}
return

'::
brloop = 1
return

checkrecall(){
ImageSearch, FoundX, FoundY, 304, 758, 611, 846, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\recall.bmp
If (ErrorLevel = 0){
chat("Roger that. I'm heading back to base.")
base()
return
}
PixelSearch, FoundX, FoundY, 805, 1045, 806, 1046, 0x010D07, 0, Fast RGB
If (ErrorLevel = 0){
chat("I'm low on health. I'm heading back to base")
base()
return
}
if(dead%following% = 1){
if(playerdied = 0){
	chat("Player " . following . " has died")
	switchrandomplayer := 1
	base()
	return
}
playerdied := 1
}else{
playerdied := 0
}
}


base(){
basing := 1
basingtick := A_TickCount
}

recall(){
recalling := 1
recallingtick := A_TickCount
chat("I'm channelling")
send {b}
}


shop(){
send {p}
sleep, 100
ImageSearch, FoundX, FoundY, 0, 0, 1980, 500, *100 C:\Users\Xander\Documents\AutoHotkey\miscellaneous\buildsinto.bmp
If (ErrorLevel = 0){
Mousemove, FoundX-138, FoundY
sleep, 50
send {LButton down}
sleep, 50
send {LButton up}
sleep, 50
itemXi := FoundX-589
itemYi := FoundY+205
itemXf := FoundX-301
itemYf := FoundY+323

moveX := 0
loop, 6
{
Mousemove, itemXi+moveX, itemYi
moveX := moveX + ((itemXf-itemXi)/5)
send {RButton down}
sleep, 50
send {RButton up}
sleep, 100
}
loop, 5
{
Mousemove, itemXi, itemYf
send {RButton down}
sleep, 50
send {RButton up}
sleep, 100
}
send {p down}
sleep, 20
send {p up}
sleep, 100
}
}


]::
MouseGetPos, xpos, ypos
Msgbox %xpos% %ypos%

