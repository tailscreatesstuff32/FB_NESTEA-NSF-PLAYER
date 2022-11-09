dim shared audoutdata as integer' = freefile
audoutdata = freefile
dim shared paused as boolean = FALSE
'NSF player bus
#include "NSF.bi"
#include "NSF.bas"
#include once "windows.bi"
#include "AUDIO_NSF.bas"
#include "fbgfx.bi"

dim shared audio_hndler as AudioHandler ptr 
dim shared v as float
using fb

'audio_hndler = new AudioHandler(44100,AUDIO_S16SYS,2048,16)
'audio_hndler = new AudioHandler(48000,AUDIO_S16SYS,1024,16)

audio_hndler = new AudioHandler(48000,AUDIO_S16SYS,2048,16)
'audio_hndler = new AudioHandler(48000,AUDIO_F32SYS,2048,16)


'audio_hndler = new AudioHandler(48000,AUDIO_S16SYS,512,16)


''NSF player bus
'#include "BUS.bi"
'#include "BUS.bas"

dim shared player as NSFplayer

dim shared bytes1 as integer


dim shared loaded as boolean = FALSE 
dim shared pausedInBg as boolean = FALSE

dim shared offx as Integer
dim shared offy as Integer



'dim loopid as uint8_t
'const scrnwdth = 256
'const scrnhght = 240

'dim currentsong as uint8_t

'screenres(256*3,240*3,32,2)

'18 before
screen 19,32,2,GFX_FULLSCREEN or GFX_NO_FRAME or GFX_ALWAYS_ON_TOP


'Screen 18, 32, 4, (GFX_windowed) 
screenset(1,0)

dim shared keyprss(255) as boolean

	'Dim Shared NSFplayer1 As NSFplayer = NSFplayer()
	Dim Shared currentsong As uint8_t= 1	
MMapTemplate(UINT16T ,String)

Dim shared mapasm As  MAPNODEUINT16TSTRING Ptr
Dim shared map As  TMAPUINT16TSTRING

WIDTH 90, 40
WIDTH 90, 45
WIDTH 90, 46



declare SUB DrawAPU1 (x1 AS INTEGER, y1 AS INTEGER)
declare sub drawcode(x as integer ,y as integer ,nLiplayer as integer )
declare SUB DrawCpu (x1 AS INTEGER, y1 AS INTEGER)
declare sub drawtext1()
	'open "CONS:" for output as #1
	
locate ,,0	
'	Function  KEYPRESSED overload(vk_code As Integer) As bool
'	static Iskeyup(&HFF) As bool
'			
'	If  IIf(GetAsyncKeyState(vk_code) And &H8000, 1, 0) And iskeyup(vk_code) = TRUE Then
'		iskeyup(vk_code) = IIf(GetAsyncKeyState(vk_code) And &H8000, FALSE, TRUE)
'	Return TRUE
'	 
'	ElseIf IIf(GetAsyncKeyState(vk_code) And &H8000, 0, 1) And iskeyup(vk_code)= FALSE Then
'		iskeyup(vk_code) = IIf(GetAsyncKeyState(vk_code) And &H8000, FALSE, true)		
'		Return FALSE
'	End If
'	
'	Return FALSE			
'End Function
setmouse ,,0
	Function  KEYPRESSED overload(_KEYS As Ubyte) As bool
	'static Iskeyup(&HFF) As bool
						if multikey(_KEYS) = true and keyprss(_KEYS) = true then
				

keyprss(_KEYS) = false
Return keyprss(_KEYS)
						elseif multikey(_KEYS) = false and keyprss(_KEYS) = false then
				
keyprss(_KEYS) = true
 
	Return keyprss(_KEYS)
						end if

	
	Return true	
	End Function

	Function hex1 (n As uint32_t,  d As uint8_t) As  string
	
		 Dim s As String = String(d, "0")
		 Dim i As Integer 
		
		'for (int i = d - 1; i >= 0; i--, n >>= 4)
		i = d-1
		While i >= 0
			s[i] = Asc("0123456789ABCDEF", (n And &Hf)+1)  '[n And &HF]
				n shr= 4
			   i-=1
		Wend
		'	s[i] = "0123456789ABCDEF"[n & &HF];
		'Next
		
		return s
	End Function

sub sound_data_test(offset as integer ,v  as float)
	
	
	'for i as integer = 0 to audio_hndler->samplesperframe - 1	
   audio_hndler->sampleBuffer(offset) = v'((rnd * 2-1) *0.2) 'v'cast(float,v)'v 
	'next
	
	
	
End Sub

	
sub _fillrect(x as integer,y as integer,w as integer,h as integer,col1 as ulong)
	
	if w <> 0  then
	if h <> 0 then
		
	line (x,y)-(w+x-1,h+y-1),col1,BF
	end if
	end if
	
End Sub






sub drawSoundRam(x1 AS INTEGER, y1 AS INTEGER, addr AS uint16_t, nRows AS INTEGER, nColumns AS INTEGER)
	
	Color 255
	
    Dim nRamX As Integer = x1
     Dim nRamY As Integer = y1
     Dim sOffset As String
     Dim row As Integer
     Dim col As Integer 
    ' Dim addr As uint16_t
    
    FOR row = 0 TO nRows - 1
        sOffset = "$" + hex1(addr, 4) + ":"
        FOR col = 0 TO nColumns - 1


            sOffset = sOffset  + " " + hex1(player._read(&H4800,TRUE),2)

            addr+=1

        NEXT col

        LOCATE nRamY, nRamX


        PRINT sOffset
        nRamY = nRamY + 1
    NEXT row
	
End Sub




SUB DrawAPU2 (x1 AS INTEGER, y1 AS INTEGER)
	' Locate y1, x1
	'cls
	 	color rgb(128+64,0,0)
'Cls

'Locate y1, 50
Locate y1, 70

 color rgb(0,128,128)
print "2A02"

color rgb(128+64,0,0)

'Locate y1+1, 50
Locate y1+1, 70

'print "$4010: ";hex(dmc_reg1);" ";hex(dmc_reg2);" ";hex(dmc_reg3);" ";hex(dmc_reg4)
'print "sample length: ";player.apu.dmcSampleLength
'print "dmc output: ";player.apu.dmcoutput


print "$4000: ";hex1(pulsereg1.R0,2);" ";hex1(pulsereg1.R1,2);" ";hex1(pulsereg1.R2,2);" ";hex1(pulsereg1.R3,2)';" ";hex((p1_reg shr 8) and &HFF)'hex(p1_reg and &HFF)';" ";hex(p3reg);" ";hex(p4reg)
'Locate y1+2, 50
Locate y1+2, 70
print "$4004: ";hex1(pulsereg2.R0,2);" ";hex1(pulsereg2.R1,2);" ";hex1(pulsereg2.R2,2);" ";hex1(pulsereg2.R3,2)';" ";hex((p1_reg shr 8) and &HFF)'hex(p1_reg and &HFF)';" ";hex(p3reg);" ";hex(p4reg)

'Locate y1+3, 50
Locate y1+3, 70

'print "$4010: ";hex(dmc_reg1);" ";hex(dmc_reg2);" ";hex(dmc_reg3);" ";hex(dmc_reg4)
'print "sample length: ";player.apu.dmcSampleLength
'print "dmc output: ";player.apu.dmcoutput


print "$4008: ";hex1(_trireg.R0,2);" ";hex1(_trireg.R1,2);" ";hex1(_trireg.R2,2);" ";hex1(_trireg.R3,2)';" ";hex((p1_reg shr 8) and &HFF)'hex(p1_reg and &HFF)';" ";hex(p3reg);" ";hex(p4reg)


'Locate y1+4, 50
Locate y1+4, 70

'print "$4010: ";hex(dmc_reg1);" ";hex(dmc_reg2);" ";hex(dmc_reg3);" ";hex(dmc_reg4)
'print "sample length: ";player.apu.dmcSampleLength
'print "dmc output: ";player.apu.dmcoutput

print "$400C: ";hex1(_noisereg.R0,2);" ";hex1(_noisereg.R1,2);" ";hex1(_noisereg.R2,2);" ";hex1(_noisereg.R3,2)';" ";hex((p1_reg shr 8) and &HFF)'hex(p1_reg and &HFF)';" ";hex(p3reg);" ";hex(p4reg)

'Locate y1+5, 50
Locate y1+5, 70

print "$4010: ";hex1(_dmcreg.R0,2);" ";hex1(_dmcreg.R1,2);" ";hex1(_dmcreg.R2,2);" ";hex1(_dmcreg.R3,2)

'Locate y1+1, 69
Locate y1+1, 90
print "duty:";player.apu.p1Duty
'Locate y1+2, 69
Locate y1+2, 90
print "duty: ";player.apu.p2Duty



  Locate y1, x1
	''print
	Print "Title: ";player.nsffile.namesong 
   Locate y1+1, x1
	Print "Artist: ";player.nsffile.artist 
   Locate y1+2, x1
	Print "Copyright: ";player.nsffile.copyright 
	Locate y1+3, x1
   print
   '''
   Locate y1+4, x1
   Print "banked: "; Iif(player.nsffile.banking,TRUE,FALSE)
   print
   Locate y1+5, x1
	Print "Song ";currentsong;" of ";player.NSFfile.totalsongs 
	
	Locate y1+6, x1
	print
	
	Locate y1+7, x1
	print "Audio initialized, sample rate: "; audio_hndler->samples * 60
	Locate y1+8, x1
	
	if checkchip = DEF_APU then
	print "CHIPSET: ";"2A02"
	elseif checkchip = CHIPSET.N163 then
	print "CHIPSET: ";"2A02 + Namcot 163"
	'player.n163._write(&HE000,0)
	elseif checkchip = CHIPSET.VRC6 then
	print "CHIPSET: ";"2A02 + VRC6"
	elseif checkchip = CHIPSET.MMC5 then
		print "CHIPSET: ";"2A02 + MMC5"
	endif

'print "sample length: ";player.apu.dmcSampleLength
'print "dmc output: ";player.apu.dmcoutput




'Locate y1+6, 51
'print "N163"
'Locate y1+7, 51
'print "$00: ";hex1(player.n163.ram(0),2);" ";hex1(player.n163.ram(1),2);" ";hex1(player.n163.ram(2),2);" ";hex1(player.n163.ram(3),2);" ";hex1(player.n163.ram(4),2);" ";hex1(player.n163.ram(5),2);" ";hex1(player.n163.ram(6),2);" ";hex1(player.n163.ram(7),2)
'Locate y1+8, 51
'print "$08: ";hex1(player.n163.ram(8),2);" ";hex1(player.n163.ram(9),2);" ";hex1(player.n163.ram(10),2);" ";hex1(player.n163.ram(11),2);" ";hex1(player.n163.ram(12),2);" ";hex1(player.n163.ram(13),2);" ";hex1(player.n163.ram(14),2);" ";hex1(player.n163.ram(15),2)'Locate y1+10, 58
'Locate y1+9, 51
'print "$78: ";hex1(player.n163.ram(&H78),2);" ";hex1(player.n163.ram(&H79),2);" ";hex1(player.n163.ram(&H7A),2);" ";hex1(player.n163.ram(&H7B),2);" ";hex1(player.n163.ram(&H7C),2);" ";hex1(player.n163.ram(&H7D),2);" ";hex1(player.n163.ram(&H7E),2);" ";hex1(player.n163.ram(&H7F),2)
'Locate y1+10, 51
'print player.n163.internal_ram_auto_increment


   if player.VRC6_enabled then
	
	
	
	'Locate y1+7, 70
	'color rgb(0,128,128)
	'print finalVRC6output' outputlevel'player.VRC6.outputlevels
	
	Locate y1+8, 70
	color rgb(0,128,128)
	print "VRC6";
	color rgb(128+64,0,0)
	Locate y1+9, 70
	print "$9000: ";hex1(player.VRC6.pulse1regs.r0,2);" ";hex1(player.VRC6.pulse1regs.r1,2);" ";hex1(player.VRC6.pulse1regs.r2,2)
	Locate y1+10, 70
	print "$A000: ";hex1(player.VRC6.pulse2regs.r0,2);" ";hex1(player.VRC6.pulse2regs.r1,2);" ";hex1(player.VRC6.pulse2regs.r2,2)
	Locate y1+11, 70
	print "$B000: ";hex1(player.VRC6.sawregs.r0,2);" ";hex1(player.VRC6.sawregs.r1,2);" ";hex1(player.VRC6.sawregs.r2,2)

   
	

	
	
   EndIf





 if player.n163_enabled then
'locate y1+7,50
locate y1+18,70

  color rgb(0,128,128)
   print "N163"
 '  print "Namcot 163"
   	'drawsoundram(50,y1+8,&H0 ,16,8)
   	
   	drawsoundram(70,y1+19,&H0 ,16,8)
   

	
	
	'locate ,50
'
'locate ,70

'hex(player.n163.ram(&H7F)
'print  hex(player.n163.ram(&H7F))'hex(player.n163.internal_ram_addr) 'player.n163.sound_enabled ''player.N163._read(&HE000,TRUE) 'player.n163.ram(&H7F)''player.n163.sound_enabled 'player.n163.internal_ram_addr' player.n163.internal_ram_auto_increment 

'print  hex(player.n163.internal_ram_addr)

locate 15,70
'print hex1(player.n163.phase(player.n163.ram()),6);" ";hex1(player.n163.frequency(player.n163.ram()),6); _
'      " ";player.n163.wave_address(player.n163.ram());" ";player.n163.length(player.n163.ram()); _
'      " ";player.n163.volume(player.n163.ram()) ';" ";sample_index'  player.n163.volume 

'print hex1(player.n163.getphase(0),6);" ";hex1(player.n163.frequency(player.n163.ram()),6); _
'      " ";player.n163.wave_address(player.n163._internalram(());" ";player.n163.length(player.n163._internalram(()); _
'      " ";player.n163.volume(player.n163._internalram(()) ';" ";sample_index'  player.n163.volume 
	'dim sample as int8_t
	'samplepos1 = 3
	'	if((samplePos1 and &H01)) then
	'		sample = player.n163._internalRam(samplepos1 \ 2)  shr 4 
	'	'	print "true"
	'	 else 
	'		sample = player.n163._internalRam(samplepos1 \ 2) and &H0F 
	'		'print "false"
	'	end if
'print hex1(samplepos1,2) 'hex1(samplePos1,2) 'player.n163.GetWaveAddress(7)'player.n163.GetWaveLength(7)'0.00752 * player.n163._channeloutput(7)'finalN163output



 EndIf

 if player.MMC5_enabled then
	
	
	'
	'Locate y1+7, 70
	''color rgb(0,128,128)
	''print finalVRC6output' outputlevel'player.VRC6.outputlevels
	'
	'Locate y1+8, 70
	'color rgb(0,128,128)
	'print "MMC5";
	'color rgb(128+64,0,0)
	'Locate y1+9, 70
	'print "$5000: ";hex1(MMC5_pulse1_reg0,2);" ";hex1(MMC5_pulse1_reg1,2);" ";hex1(MMC5_pulse1_reg2,2);" ";hex1(MMC5_pulse1_reg3,2)
	'Locate y1+10, 70
	'print "$5004: ";hex1(MMC5_pulse2_reg0,2);" ";hex1(MMC5_pulse2_reg1,2);" ";hex1(MMC5_pulse2_reg2,2);" ";hex1(MMC5_pulse2_reg3,2)
	'
	' Locate y1+11, 70
 ' print "$5008: ";hex1(player.VRC6.sawregs.r0,2);" ";hex1(player.VRC6.sawregs.r1,2);" ";hex1(player.VRC6.sawregs.r2,2)

			'Locate y1+7, 50
	'color rgb(0,128,128)
	'print finalVRC6output' outputlevel'player.VRC6.outputlevels
	
	Locate y1+0, 50
	color rgb(0,128,128)
	print "MMC5";
	color rgb(128+64,0,0)
	Locate y1+1, 50
	print "$5000: ";hex1(MMC5_pulse1_reg0,2);" ";hex1(MMC5_pulse1_reg1,2);" ";hex1(MMC5_pulse1_reg2,2);" ";hex1(MMC5_pulse1_reg3,2)
	Locate y1+2, 50
	print "$5004: ";hex1(MMC5_pulse2_reg0,2);" ";hex1(MMC5_pulse2_reg1,2);" ";hex1(MMC5_pulse2_reg2,2);" ";hex1(MMC5_pulse2_reg3,2)
	
	
	
 EndIf


'print final1
'locate 13,70
'print _sample
'print sample_index


'EndIf


'if player.n163_enabled then
'	'drawsoundram(50,y1+6,&H0 ,16,8)	
'EndIf	

	
'	locate ,50
'
'print  player.n163.internal_ram_addr 'player.n163.sound_enabled ''player.N163._read(&HE000,TRUE) 'player.n163.ram(&H7F)''player.n163.sound_enabled 'player.n163.internal_ram_addr' player.n163.internal_ram_auto_increment 

'hex(_sample,2)  '_sample

'Locate 10
'Locate , , 1
'Print x1, y1, ""
      '  Locate y1+1, x1+1: Print "X";

END Sub



sub drawVisuals()
	
dim zoom as Integer

zoom = 3

'	

	drawAPU2(2,2)	
'	
'	
'	
'			 drawcpu(57,1)
'		drawcode(58,8,26)
'		   Locate 37, 3
'drawtext1()
'
'
'


'_fillrect(20,100,15 ,120,&H3f3f1f)
'
'_fillrect(35,100,15 ,120,&H1f1f3f)
'
'_fillrect(20,220,15 ,0,&Hffff7f)
'
'_fillrect(35, 100, 15, 10,&H7f7fff)

'pulse 1
'dim scale as uint32_t = iif(player.apu.p1ConstantVolume,player.apu.p1Volume,player.apu.p1Decay)
'scale = iif(player.apu.p1Counter = 0,0,scale)
'scale = scale * 120 / &HF
'_fillrect(20,100,15 ,120,&H3f3f1f)
'_fillrect(35,100,15 ,120,&H1f1f3f)
'_fillrect(20,220-scale,15 ,scale,&Hffff7f)
'scale = player.apu.p1Timer * 110 / &H7ff
'_fillrect(35, 100+scale, 15, 10,&H7f7fff)


dim scale as uint32_t = iif(player.apu.p1ConstantVolume,player.apu.p1Volume,player.apu.p1Decay)
scale = iif(player.apu.p1Counter = 0,0,scale)
scale = scale * 120 / &HF

'&H3f3f1f

_fillrect(20*zoom,100*zoom,15*zoom ,120*zoom,&H3f3f1f)
_fillrect(35*zoom,100*zoom,15*zoom ,120*zoom,&H1f1f3f)
_fillrect(20*zoom,(220-scale)*zoom,15*zoom ,scale*zoom,&Hffff7f)
scale = player.apu.p1Timer * 110 / &H7ff
_fillrect(35*zoom, (100+scale)*zoom, 15*zoom, 10*zoom,&H7f7fff)








''pulse 2
_fillrect(65*zoom,100*zoom,15*zoom ,120*zoom,&H3f3f1f)
_fillrect(80*zoom,100*zoom,15*zoom ,120*zoom,&H1f1f3f)
scale= iif(player.apu.p2ConstantVolume,player.apu.p2Volume,player.apu.p2Decay)
scale = iif(player.apu.p2Counter = 0,0,scale)
scale = scale * 120 / &HF
_fillrect(65*zoom,(220-scale)*zoom,15*zoom ,scale*zoom,&Hffff7f)
scale = player.apu.p2Timer * 110 / &H7ff
_fillrect(80*zoom, (100+scale)*zoom, 15*zoom, 10*zoom,&H7f7fff)

'triangle  
_fillrect(110*zoom,100*zoom,15*zoom ,120*zoom,&H3f3f1f)
_fillrect(125*zoom ,100*zoom,15*zoom ,120*zoom,&H1f1f3f)
scale = iif(player.apu.triCounter = 0 or player.apu.triLinearCounter = 0,0,1)
scale = scale * 120
_fillrect(110*zoom,(220-scale)*zoom ,15*zoom ,scale*zoom,&Hffff7f)
scale = player.apu.triTimer * 110 / &H7ff
_fillrect(125*zoom, (100+scale)*zoom, 15*zoom, 10*zoom,&H7f7fff)
'
'
''noise  
_fillrect(155*zoom,100*zoom,15*zoom ,120*zoom,&H3f3f1f)
_fillrect(170*zoom ,100*zoom,15*zoom ,120*zoom,&H1f1f3f)
scale= iif(player.apu.noiseConstantVolume,player.apu.noiseVolume,player.apu.noiseDecay)
scale = iif(player.apu.noiseCounter = 0,0,scale)
scale = scale * 120 / &HF
_fillrect(155*zoom,(220-scale)*zoom,15*zoom , scale*zoom,&Hffff7f)
scale = player.apu.noiseTimer * 110 / 4068
_fillrect(170*zoom, (100+scale)*zoom, 15*zoom, 10*zoom,&H7f7fff)
'



'DMC

_fillrect(200*zoom,100*zoom,15*zoom ,120*zoom,&H3f3f1f)
_fillrect(215*zoom,100*zoom,15*zoom ,120*zoom,&H1f1f3f)
scale = iif(player.apu.dmcBytesLeft = 0,0,1)
scale = scale * 120
_fillrect(200*zoom,(220-scale)*zoom,15*zoom ,zoom*scale,&Hffff7f)
 scale = player.apu.dmcTimer * 110 / 428
_fillrect(215*zoom, (100 + scale)*zoom, 15*zoom, 10*zoom,&H7f7fff)

'100*zoom+109
'






pcopy 0,1
   
End Sub



sub drawVisuals2(x1 as integer,y1 as integer)
	
dim zoom as Integer

zoom = 1

'	

	drawAPU2(2,2)	
'	
'	
'	
'			 drawcpu(57,1)
'		drawcode(58,8,26)
'		   Locate 37, 3
'drawtext1()
'
'
'


'_fillrect(20,100,15 ,120,&H3f3f1f)
'
'_fillrect(35,100,15 ,120,&H1f1f3f)
'
'_fillrect(20,220,15 ,0,&Hffff7f)
'
'_fillrect(35, 100, 15, 10,&H7f7fff)

'pulse 1
'dim scale as uint32_t = iif(player.apu.p1ConstantVolume,player.apu.p1Volume,player.apu.p1Decay)
'scale = iif(player.apu.p1Counter = 0,0,scale)
'scale = scale * 120 / &HF
'_fillrect(20,100,15 ,120,&H3f3f1f)
'_fillrect(35,100,15 ,120,&H1f1f3f)
'_fillrect(20,220-scale,15 ,scale,&Hffff7f)
'scale = player.apu.p1Timer * 110 / &H7ff
'_fillrect(35, 100+scale, 15, 10,&H7f7fff)


dim scale as uint32_t = iif(player.apu.p1ConstantVolume,player.apu.p1Volume,player.apu.p1Decay)
scale = iif(player.apu.p1Counter = 0,0,scale)
scale = scale * 120 / &HF

'&H3f3f1f

_fillrect((20*zoom)+x1,100*zoom+y1,15*zoom ,120*zoom,&H3f3f1f)
_fillrect((35*zoom)+x1,100*zoom+y1,15*zoom ,120*zoom,&H1f1f3f)
_fillrect((20*zoom)+x1,(220-scale)*zoom + y1,15*zoom ,scale*zoom,&Hffff7f)
scale = player.apu.p1Timer * 110 / &H7ff
_fillrect((35*zoom)+x1, (100+scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)








''pulse 2
_fillrect((65*zoom)+x1,100*zoom + y1,15*zoom ,120*zoom,&H3f3f1f)
_fillrect((80*zoom)+x1,100*zoom + y1,15*zoom ,120*zoom,&H1f1f3f)
scale= iif(player.apu.p2ConstantVolume,player.apu.p2Volume,player.apu.p2Decay)
scale = iif(player.apu.p2Counter = 0,0,scale)
scale = scale * 120 / &HF
_fillrect((65*zoom)+x1,(220-scale)*zoom + y1,15*zoom ,scale*zoom,&Hffff7f)
scale = player.apu.p2Timer * 110 / &H7ff
_fillrect((80*zoom)+x1, (100+scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)

'triangle  
_fillrect((110*zoom)+x1,100*zoom + y1,15*zoom ,120*zoom,&H3f3f1f)
_fillrect((125*zoom)+x1 ,100*zoom + y1,15*zoom ,120*zoom,&H1f1f3f)
scale = iif(player.apu.triCounter = 0 or player.apu.triLinearCounter = 0,0,1)
scale = scale * 120
_fillrect((110*zoom)+x1,(220-scale)*zoom + y1 ,15*zoom ,scale*zoom,&Hffff7f)
scale = player.apu.triTimer * 110 / &H7ff
_fillrect((125*zoom)+x1, (100+scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)
'
'
''noise  
_fillrect((155*zoom)+x1,100*zoom + y1,15*zoom ,120*zoom,&H3f3f1f)
_fillrect((170*zoom)+x1 ,100*zoom + y1,15*zoom ,120*zoom,&H1f1f3f)
scale= iif(player.apu.noiseConstantVolume,player.apu.noiseVolume,player.apu.noiseDecay)
scale = iif(player.apu.noiseCounter = 0,0,scale)
scale = scale * 120 / &HF
_fillrect((155*zoom)+x1,(220-scale)*zoom + y1,15*zoom , scale*zoom,&Hffff7f)
scale = player.apu.noiseTimer * 110 / 4068
_fillrect((170*zoom)+x1, (100+scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)
'



'DMC

_fillrect((200*zoom)+x1,100*zoom + y1,15*zoom,120*zoom,&H3f3f1f)
_fillrect((215*zoom)+x1,100*zoom + y1,15*zoom,120*zoom,&H1f1f3f)
scale = iif(player.apu.dmcBytesLeft = 0,0,1)
scale = scale * 120
_fillrect((200*zoom)+x1,(220-scale)*zoom + y1,15*zoom ,zoom*scale,&Hffff7f)
 scale = player.apu.dmcTimer * 110 / 428
_fillrect((215*zoom)+x1, (100 + scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)

'100*zoom+109
'
'///////////////////////////////////////////

'N163 

if player.n163_enabled then
_fillrect((((200+45)*zoom)+x1),100*zoom + y1,15*zoom ,120*zoom,&H3f3f1f)
_fillrect((((215+45)*zoom)+x1),100*zoom + y1,15*zoom ,120*zoom,&H1f1f3f)
scale = 0'player.n163.GetVolume(7) 'iif(player.apu.dmcBytesLeft = 0,GetVolume(7) ,1)
scale = 0'scale * 120 / &HF
_fillrect((((200+45)*zoom)+x1),(220-scale)*zoom + y1,15*zoom ,zoom*scale,&Hffff7f)
 scale = 0'player.n163.getfrequency(7) * 110 / &H7ff'0'player.apu.dmcTimer * 110 / 428
_fillrect((((215+45)*zoom)+x1), (100 + scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)
end if


'VRC6 

if player.VRC6_enabled then
_fillrect((((200+90)*zoom)+x1),100*zoom + y1,15*zoom ,120*zoom,&H3f3f1f)
_fillrect((((215+90)*zoom)+x1),100*zoom + y1,15*zoom ,120*zoom,&H1f1f3f)
scale = 0'iif(player.apu.dmcBytesLeft = 0,0,1)
scale = 0'scale * 120
_fillrect((((200+90)*zoom)+x1),(220-scale)*zoom + y1,15*zoom ,zoom*scale,&Hffff7f)
 scale = 0'player.apu.dmcTimer * 110 / 428
_fillrect((((215+90)*zoom)+x1), (100 + scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)


_fillrect((((200+135)*zoom)+x1),100*zoom + y1,15*zoom ,120*zoom,&H3f3f1f)
_fillrect((((215+135)*zoom)+x1),100*zoom + y1,15*zoom ,120*zoom,&H1f1f3f)
scale = 0'iif(player.apu.dmcBytesLeft = 0,0,1)
scale = 0'scale * 120
_fillrect((((200+135)*zoom)+x1),(220-scale)*zoom + y1,15*zoom ,zoom*scale,&Hffff7f)
 scale = 0'player.apu.dmcTimer * 110 / 428
_fillrect((((215+135)*zoom)+x1), (100 + scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)



_fillrect((((200+180)*zoom)+x1),100*zoom + y1,15*zoom ,120*zoom,&H3f3f1f)
_fillrect((((215+180)*zoom)+x1),100*zoom + y1,15*zoom ,120*zoom,&H1f1f3f)
scale = 0'iif(player.apu.dmcBytesLeft = 0,0,1)
scale = 0'scale * 120
_fillrect((((200+180)*zoom)+x1),(220-scale)*zoom + y1,15*zoom ,zoom*scale,&Hffff7f)
 scale = 0'player.apu.dmcTimer * 110 / 428
_fillrect((((215+180)*zoom)+x1), (100 + scale)*zoom + y1, 15*zoom, 10*zoom,&H7f7fff)

end if










pcopy 0,1
   
End Sub



sub runframe()
	
				
		''player.getSamples(audioHandler.sampleBuffer, audioHandler.samplesPerFrame)
		
		'for i as integer = 0 to audio_hndler->samplesperframe - 1
'			sound_data_test(i,((rnd * 2-1) * 0.2))
'next	
		
		

player.runframe()
player.getsamples(audio_hndler->sampleBuffer(), audio_hndler->samplesPerFrame)


'its same values and positions in export BUT
'the noticeable changes happen if either the value is truncated or
'it either rounds up or down if the max decimal place is either

'for i as integer = 0 to ubound(audio_hndler->samplebuffer) - 1
'print # audoutdata , str(audio_hndler->samplebuffer(i))
'next

';Put # audoutdata ,,*Cast(ubyte Ptr,@audio_hndler->sampleBuffer(0)),2


'bytes1 +=1
'if bytes1 = 2048  then
'	bytes1 = 0
'	
'else
'	
'EndIf



audio_hndler->nextBuffer()
	
  'offy = 200
  drawvisuals2(offx,offy)
	

	
'for i as integer = 0 to audio_hndler->samplesperframe - 1
'				v = (rnd * 2-1) *0.2
'audio_hndler->sampleBuffer(i) = v'(rnd * 2-1) *0.2
'next
'		
'print sizeof((rnd * 2-1) *0.2)
End Sub


sub pausing()
	
	
		if KEYPRESSED(FB.SC_SPACE) = false then
	
	if paused = true and loaded = true then
		
	audio_hndler->stop_aud() 
  'runframe()
  player.n163.clock()
    paused = false
    
	elseif paused = false and loaded = true then
 

 audio_hndler->start_aud()
	 paused = true
	
	end if
	
end if




 if(paused = true and loaded = true) then
 '		 audio_hndler->start_aud() 
  'sleep 1 

     		runframe()
    
   
  
 'elseif paused = false and loaded = true then
 '   
 '	
 EndIf




	' if(paused = true and loaded = true) then
	  
 '    
 ' audio_hndler->start_aud() 
 '
 ' 
 '   
 '  
 ' paused = false 
	' else if paused = false and loaded = true then

 'audio_hndler->stop_aud()
 '  '  paused = true
	' end if
		
End Sub
sub drawcode(x as integer ,y as integer ,nLiplayer as integer )
	
	








dim nOff as uint16_t

	 nOff=player.cpu.pc
	mapasm = map.findaddr(nOff)
	dim nLiney as Integer = (nLiplayer shr 1) * 1 + y
	
	color 255
	if mapasm <> null then
		color 10
		locate nLineY,x
			
	  print *mapasm->nData
	  'nOff+=1
	  color 255
	  while nliney < (nLiplayer *1) + y
	

	
	nOff+=1
	mapasm = map.findaddr(nOff)
	
	
	if mapasm <> null then
	nLineY += 1
	
	locate nLineY,x
	 print *mapasm->nData
	elseif nOff  = &HFFFF then
			nLineY += 1
	
	locate nLineY,x
	 print

	end if 
	 
	 
	wend 
	end if
	
	
		'mapasm = map.findaddr(player.cpu.pc)
	
	nliney = (nLiplayer shr 1) * 1 + y
	
	nOff=player.cpu.pc
	if mapasm <> null then

	  
	  while nliney > y
	
	
	
	nOff-=1
	mapasm = map.findaddr(nOff)
	
	
	if mapasm <> null  then
	nLineY -= 1	
	locate nLineY,x	 
	print *mapasm->nData
	elseif nOff = &HFFFF then
	nLineY -= 1	
	locate nLineY,x	 
	print 
	'	nOff-=1
	 'beep
	end if 
	 
	 
	  wend 
	end if

	

	

'next i
	
	
	
End Sub  


SUB DrawCpu (x1 AS INTEGER, y1 AS INTEGER)


    LOCATE y1, x1

Color 255
'11
    Print " status: ";
    Color(IIf(player.cpu.status And olc6502.N,10,12))
    PRINT " N ";
      Color(IIf(player.cpu.status And olc6502.V,10,12))
    PRINT " V ";
       Color(IIf(player.cpu.status And olc6502.U,10,12))
    PRINT " - ";
      Color(IIf(player.cpu.status And olc6502.B,10,12))
    PRINT " B ";
      Color(IIf(player.cpu.status And olc6502.D,10,12))
    PRINT " D ";
    Color(IIf(player.cpu.status And olc6502.I,10,12))
    PRINT " I ";
      Color(IIf(player.cpu.status And olc6502.Z,10,12))
    PRINT " Z ";
        Color(IIf(player.cpu.status And olc6502.C,10,12))
    PRINT " C "
    Color 255


    'Locate , x

   ' PRINT " ";getflag(N);" ";getflag(V);" ";getflag(U);" "; getflag(B);" ";getflag(D);" ";getflag(I);" "; getflag(Z);" ";getflag(C)
  
 '   Locate , x
   
    Locate y1+1, x1
    PRINT " PC: $"; LTRIM$(hex1(player.cpu.pc, 4)) + " [" + LTRIM$(STR$(player.cpu.pc)) + "]"
    Locate , x1
    PRINT " A: $"; LTRIM$(hex1(player.cpu.a, 2)) + " [" + LTRIM$(STR$(player.cpu.a)) + "]"
    Locate , x1
    PRINT " X: $"; LTRIM$(hex1(player.cpu.x, 2)) + " [" + LTRIM$(STR$(player.cpu.x)) + "]"
    Locate , x1
    PRINT " Y: $"; LTRIM$(hex1(player.cpu.y, 2)) + " [" + LTRIM$(STR$(player.cpu.y)) + "]"
    LOCATE , x1
    PRINT " Stack P: $"; LTRIM$(hex1(player.cpu.stkp, 4)) + " [" + LTRIM$(STR$(player.cpu.stkp)) + "]"




END Sub

SUB DrawAPU1 (x1 AS INTEGER, y1 AS INTEGER)
 Locate y1, x1
 
 	'print
 	color rgb(128+64,0,0)
 	'print "P1OUTPUT: ";player.apu._output(player.apu._outputoffset)
 	'
 	'print
 	'print audio_hndler->sampleBuffer(14)
 	'	print
 	
 	'	print "P1OUTPUT: ";player.apu.p1output
 	'print "P1OUTPUT: ";player.apu.p2output
 	'print "
 	'
 	
 	
 	'print
	'Print "Title: ";player.nsffile.namesong 

	'Print "Artist: ";player.nsffile.artist 

	'Print "Copyright: ";player.nsffile.copyright 
   'print
   '
   'Print "banked: "; Iif(player.nsffile.banking,TRUE,FALSE)
   print
	Print "Song ";currentsong;" of ";player.NSFfile.totalsongs 




'LOCATE y1, x1
'
'print "NOISE ENABLED: ";player.apu.enableNoise
'print "TRIANGLE ENABLED: ";player.apu.enableTriangle  
'print "PULSE1 ENABLED: ";player.apu.enablePulse1 
'print "PULSE2 ENABLED: ";player.apu.enablePulse2
'print "DMC ENABLED: ";player.apu.enablePulse2
'print "P1 OUTPUT: ";player.apu.p1output ' WORKING PROPERLY
'print "P2 OUTPUT: ";player.apu.p2output ' WORKING PROPERLY
'print "P1 COUNTER: ";player.apu.p1counter ' WORKING PROPERLY
'print "P2 COUNTER: ";player.apu.p2counter  ' WORKING PROPERLY

print "P1TIMER: ";player.apu.p1timer
print "P2TIMER: ";player.apu.p2timer
print "P1 SWEEP TARG: ";player.apu.p1SweepTarget
print "P2 SWEEP TARG: ";player.apu.p2SweepTarget
print
'print "output: ";player.apu._output(0)


print "apu output: ";player.apu._output(0)

print "buffer output: ";audio_hndler->samplebuffer(136)

 




print "final output: ";audio_hndler->inputbuffer(0)

print "pulse1 output: ";player.apu.p1output
print "apu p1ConstVol: ";player.apu.p1ConstantVolume


'that->inputbuffer(that->inputReadPos and &HFFF)

'print "TRI COUNTER: ";player.apu.tricounter ' WORKING PROPERLY
'print "NOISE COUNTER: ";player.apu.noisecounter ' WORKING PROPERLY
'print
'print "STEP 5 MODE: ";player.apu.step5mode ' WORKING PROPERLY
'print "INTERRUPTINHIBIT: ";player.apu.interruptInhibit ' WORKING PROPERLY
'print "FRAMECOUNTER: ";player.apu.framecounter' ' WORKING PROPERLY
'



END Sub






SUB DrawRam (x1 AS INTEGER, y1 AS INTEGER, addr AS uint16_t, nRows AS INTEGER, nColumns AS INTEGER)
	
	
	Color 255
	
    Dim nRamX As Integer = x1
     Dim nRamY As Integer = y1
     Dim sOffset As String
     Dim row As Integer
     Dim col As Integer 
    ' Dim addr As uint16_t

    FOR row = 0 TO nRows - 1
        sOffset = "$" + hex1(addr, 4) + ":"
        FOR col = 0 TO nColumns - 1


            sOffset = sOffset  + " " + hex1(player._read(addr, TRUE),2)

            addr+=1

        NEXT col

        LOCATE nRamY, nRamX


        PRINT sOffset
        nRamY = nRamY + 1
    NEXT row

END SUB


sub drawtheram()
	
		DrawRam 2, 1, &H0000, 16, 16

    DrawRam 2, 19, &H3FF0, 16, 16
End Sub


sub drawAPUvals()
	

	print "test"
	
	
	
End Sub

sub drawtext1()
		 drawcpu(57,1)
		drawcode(58,8,26)
		    Locate 37, 3
'
'
'
'
'
  print  "SPACE = Step Instruction    R = RESET    I = IRQ    N = NMI" ;
   Locate 38, 3
print  "N - next song    P - PREV song     R - RESET song     O - OPEN new song" ;

Locate 39, 3
print  "S - PAUSE/PLAY song";
	

 Locate 40, 3
 	print
 	Locate 41, 3
	Print "Title: ";player.nsffile.namesong;
	Locate 42, 3
	Print "Artist: ";player.nsffile.artist;
Locate 43, 3
	Print "Copyright: ";player.nsffile.copyright;
	Locate 44, 3
	Print "Song ";currentsong;" of ";player.NSFfile.totalsongs;
Locate 45, 3
	Print "banked: "; Iif(player.nsffile.banking,TRUE,FALSE)

End Sub
	
sub update()
	
	dim looping as boolean
	 

screen ,1,0
cls
screen ,0,1
cls
    'runframe()
    

   looping = true
   'paused = false
   'print FB.SC_N
   'pcopy 0 ,1
   'sleep  

   'currentsong = 11
   player.playsong(currentsong)
   
  ' offx = 64-45
   'offy = 0
   
   offx = 128
   
   'offy = 200
   
    offy = 320
drawVisuals2(offx,offy)


''open "auddata2.bin" for binary as audoutdata
'if fileexists("xnaut.txt") then
'	kill("xnaut.txt")
'EndIf
'
'open "xnaut.txt" for output as audoutdata
'
'	   	
   	     
  Dim As ULongInt curtimer, lasttimer, timerfreq 
  
Dim timertemp As ULongInt

QueryPerformanceFrequency(CPtr(Any Ptr, @timerfreq))

	'timerfreq = 1000
'if fileexists("sml2_overworld02.wav") then
'	kill("sml2_overworld01.wav")
'EndIf
'   open "sml2_overworld02.wav" for binary as audoutdata
'   
'if fileexists("kirby_19loop.bin") then
'	kill("kirby_19loop.bin")
'EndIf
'   open "kirby_19loop.bin" for binary as audoutdata
'   
'if fileexists("kirby_introtloop_testpulsestrinoise2.bin") then
'	kill("kirby_introtloop_testpulsestrinoise2.bin")
'EndIf
'   open "kirby_introtloop_testpulsestrinoise2.bin" for binary as audoutdata

'
'if fileexists("SML2.bin") then
'	kill("SML2.bin")
'EndIf
'   open "SML2.bin" for binary as audoutdata



'
'if fileexists("n163 sintest.bin") then
'	kill("n163 sintest.bin")
'EndIf
'   open "n163 sintest.bin" for binary as audoutdata
'
'if fileexists("n163 wavetest.bin") then
'	kill("n163 wavetest.bin")
'EndIf
'   open "n163 wavetest.bin" for binary as audoutdata
'
'if fileexists("n163_wavetest3.bin") then
'	kill("n163_wavetest3.bin")
'EndIf
'   open "n163_wavetest3.bin" for binary as audoutdata



'if fileexists("n163_wavetest3.txt") then
'	kill("n163_wavetest3.txt")
'EndIf
'   open "n163_wavetest3.txt" for output as audoutdata


'tested good for now?
'if fileexists("Xnaut Fortress FULL-test") then
'	kill("Xnaut Fortress FULL-test")
'EndIf
'  open "Xnaut Fortress FULL-test" for output as audoutdata
'
'


'tested good for now?
'if fileexists("Antasma FULL-test") then
'	kill("Antasma FULL-test")
'EndIf
'  open "Antasma FULL-test" for output as audoutdata
'


'if fileexists("shadow queen FULL-test") then
'	kill("shadow queen FULL-test")
'EndIf
'  open "shadow queen FULL-test" for output as audoutdata
'
'
'


'locate 0,0

'if fileexists("shovel knight-test") then
'	kill("shovel knight-test")
'EndIf
'  open "shovel knight-test" for output as audoutdata
'

'if fileexists("n163_sinwave1.bin") then
'	kill("n163_sinwave1.bin")
'EndIf
'  open "n163_sinwave1.bin" for output as audoutdata


'if fileexists("pokemon_gym_battle_full.bin") then
'	kill("pokemon_gym_battle_full.bin")
'EndIf
'  open "pokemon_gym_battle_full.bin" for output as audoutdata
'


'
'if fileexists("battleship1.bin") then
'	kill("battleship1.bin")
'EndIf
'  open "battleship1.bin" for output as audoutdata
'
'if fileexists("lava reef zone act2.raw") then
'	kill("lava reef zone act2.raw")
'EndIf
'  open "lava reef zone act2.raw" for output as audoutdata

'if fileexists("finalzone.raw") then
'	kill("finalzone.raw")
'EndIf
'  open "finalzone.raw" for output as audoutdata

'if fileexists("crisiscityclassic.raw") then
'	kill("crisiscityclassic.raw")
'EndIf
'  open "crisiscityclassic.raw" for output as audoutdata
'  

'if fileexists("aquatunnel.raw") then
'	kill("aquatunnel.raw")
'EndIf
'  open "aquatunnel.raw" for output as audoutdata
'  

'if fileexists("oedo castle.raw") then
'	kill("oedo castle.raw")
'EndIf
'  open "oedo castle.raw" for output as audoutdata

'
'  if fileexists("boss_freedom_test.raw") then
'	kill("boss_freedom_test.raw")
'EndIf
'  open "boss_freedom_test.raw" for output as audoutdata
'



'NOTE VRC6 is like mesen and has a issue that doesnt sound right

	do
		cls

		'player.apu.out1.apu_output(0)'
		
		' audio_hndler->sampleBuffer(1)
		'print player.apu.out1.apu_output(player.out1.outputOffset)
		
	
		
		' dim as uint64_t start1 =  SDL_GetPerformanceCounter() 
 
     
      pausing()

		if KEYPRESSED(FB.SC_R) = false then
   
	player.playsong(currentsong)
	drawVisuals2(offx,offy)
	'drawVisuals()
		end if

		
	'print # audoutdata , str(2000000)'str(audio_hndler->samplebuffer(136))
'	_KEY = FB.SC_N
'			if multikey(_KEY) = true and keyprss(_KEY) = true then
'				
'				cls
'				currentsong+=1 
'				
'   currentsong = iif(currentsong > player.NSFfile.totalsongs,player.NSFfile.totalsongs,currentsong)
'   
'	player.playsong(currentsong)
'		
' drawvisuals()
'
'keyprss(_KEY) = false
'
'			elseif multikey(_KEY) = false and keyprss(_KEY) = false then
'				
'keyprss(_KEY) = true
' 
'	
'			end if
'			
			
			
				if KEYPRESSED(FB.SC_P) = false then
				cls
				currentsong-=1 
				
   currentsong = iif(currentsong < 1,1,currentsong)
   
player.playsong(currentsong)
	
		drawVisuals2(offx,offy)
  'drawvisuals()
				end if
				
'	runframe()			
 'drawvisuals()
 '

 if KEYPRESSED(FB.SC_N) = false then
 	
 					cls
				currentsong+=1 
				
   currentsong = iif(currentsong > player.NSFfile.totalsongs,player.NSFfile.totalsongs,currentsong)
   
	player.playsong(currentsong)
		drawVisuals2(offx,offy)
 'drawvisuals()


 	
 	
 	
 	
 end if
 '
 
 
 'sleep(9)
 '	dim as uint64_t end1 	= SDL_GetPerformanceCounter()
 	
 	
    ' dim elapsed  as float = (end1 - start1) / cast(float,SDL_GetPerformanceFrequency())
         '  dim elapsedMS as float = (end1 - start1) / cast(float,SDL_GetPerformanceFrequency()) * 1000.0f

        ' SDL_Delay(16.666f - elapsedMS))
        
     '   SDL_Delay(1000 / 60)
     


do
		QueryPerformanceCounter(CPtr(Any Ptr, @curtimer))
					'curtimer = SDL_GetTicks()

		timertemp = Abs(Cast(ULongInt, curtimer) - Cast(ULongInt, lasttimer))
	
    	If timertemp >= Cast(ULongInt, timerfreq / 60) Then  exit do
'
loop
     	
     	lasttimer = curtimer
	'frame=frame+1
	
	
  'ScreenSync
  
  
  
	loop until inkey() = "q" or looping = false
	
	'close audoutdata
	
	
	
End Sub
	Sub loadNSFRom(filenme As String)
		
	
	
		If player.LoadNSFile(filenme,map) Then
		
			
			If loaded = false and paused = false Then
				  ' paused = not(paused)
				   
					loaded = TRUE
			currentsong = player.NSFfile.startsong 
			    audio_hndler->start_aud()
			    
			    
			
				update()
	    
				
		End if
		elseif filenme = "" then
			 print"invalid NSF file"
 pcopy 1,0
  sleep
	
		
			
		EndIf
		
		
	
		
		
		
		
		
		
		
End Sub
	sub init_nsf()

	'NSFplayer = NSFplayer()
   ' loadNSFRom("Super Mario Bros. 3 (1988-10-23)(Nintendo EAD)(Nintendo).nsf") '- WORKS
  'loadNSFRom("Mega Man 3 [RockMan 3 - Dr. Wily no Saigo!] (1990-09-28)(Capcom).nsf") '- WORKS
 '    loadNSFRom("Chip 'n Dale Rescue Rangers [Chip to Dale no Daisakusen] (1990-06-08)(Capcom).nsf") '- WORKS
	'loadNSFRom("C:\Users\Gamer\Desktop\Silver Surfer (EMU).zophar\Silver Surfer (SFX).nsf")' - WORKS
	   ' loadNSFRom("Mega Man 5 [RockMan 5 - Blues no Wana!] (1992-12-04)(Capcom).nsf") '- WORKS

	
	
			'loadNSFRom("Alfred Chicken (1993)(Twilight)(Mindscape).nsf")' - WORKS
			
			'loadNSFRom("testpulse2.nsf")' - WORKS
			'loadNSFRom("fortests2.nsf")
			

		'loadNSFRom("Captain Planet and the Planeteers (1991-09)(Gray Matter)(Mindscape).nsf")' - DOESNT WORKS

	 '  loadNSFRom("Dr. Mario (1990-07-27)(Nintendo R&D1)(Nintendo).nsf") 
	 'loadNSFRom("Mega Man 2 [RockMan 2 - Dr. Wily no Nazo] (1988-12-24)(Capcom).nsf")' - WORKS
	'loadNSFRom("SMB.nsf")

'	If  Then
		
'	Else
		'loadNSFRom("Castlevania 2 - Simon's Quest [Dracula 2 - Noroi no Fuuin] (1988-12)(Konami).nsf")
	
			
                 
             '    loadNSFRom("Vs. Shadow Queen.nsf")
		
		
	'EndIf
	'loadNSFRom("Incredible Crash Dummies, The (1993-09-23)(Software Creations)(LJN).nsf")' - WORKS
	'loadNSFRom("Tiny Toon Adventures (1991-12-20)(Konami).nsf") '- WORKS
	
	'loadNSFRom("Yoshi's Cookie (1992-11-21)(Tose)(Nintendo).nsf") '- WORKS
	
	'loadNSFRom("Kirby's Adventure [Hoshi no Kirby - Yume no Izumi no Monogatari] (1993-03-23)(HAL Laboratory)(Nintendo).nsf")' - WORKS
 	
 	'loadNSFRom("C:\Users\Gamer\Desktop\OLC-FREEBASIC-NESTEA--main-functional\EMU W SOUND\kirby_nsfs\kirby19_loop.nsf")' - WORKS

 
 'loadNSFRom("Journey to Silius [RAF World] (1990-08-10)(Sunsoft).nsf")
 'loadNSFRom("Felix the Cat (1992-10)(Shimada Kikaku)(Hudson).nsf") 
 
 'loadNSFRom("Mario is Missing! (1993-07)(Radical)(Software Toolworks).nsf") 
 

  
' loadNSFRom("advkirb3.nsf") 
	'  loadNSFRom("advkirb03.nsf") 
	' loadNSFRom("advkirb005.nsf")
	 
	' loadNSFRom("advkirb0003.nsf")
	 'loadNSFRom("DMG-APAE-USA_track06.nsf")
	 
	  'loadNSFRom("DMG-APAE-USA_track22.nsf") 'gym leader battle
	 
	  'loadNSFRom("DMG-APAE-USA_track23.nsf")
	 
	
	'loadNSFRom("Shovel_Knight_Music.nsf")'for testing
	 
	 'loadNSFRom("DMG-L6J_track020.nsf")
	

	 
	 
	' loadNSFRom("DMG-L6J_track13.nsf") 'PULSE2, NOISE
	 
	  	
	 
	   'loadNSFRom("DMG-L6J_track7.nsf")
	  'loadNSFRom("Vs. Shadow Queen_full.nsf")    
     'loadNSFRom("x naut fortress.nsf")
    'loadNSFRom("antasma.nsf") 
	 'loadNSFRom("DMG-APAE-USA_track06.nsf") 'pokemon gym
	 'loadNSFRom("DMG-L6J_track23.nsf") 'Macro Zone stage1   'PULSE1,PULSE2, NOISE, N163
	'loadNSFRom("DMG-L6J_track01.nsf") ' SML2 Athletic1
	'loadNSFRom("DMG-L6J_track20.nsf") ' SML2 Athletic2
	 'loadNSFRom("DMG-L6J_track17_loop.nsf") 'stage music 2
	  
	 ' loadNSFRom("DMG-L6J_track11.nsf")
	
	'loadNSFRom("n163_sintest.nsf")
	'loadNSFRom("sintest2.nsf")
	
	' loadNSFRom("sintest3.nsf")
	' loadNSFRom("sintest4.nsf")
	
	 
	 	 'loadNSFRom("alfchicken.nsf")
	
	 ' loadNSFRom("DMG-NBA_track00004.nsf") ' Battleship gameboy
	 
	' loadNSFRom("sky.nsf")
	
	
	'loadNSFRom("Sonic 3D Blast-ppz2.nsf")
	 'loadNSFRom("Sonic 3 & Knuckles VRC6 Part 1-ssz.nsf")
	'loadNSFRom("Sonic 3 & Knuckles VRC6 Part 1-FB1.nsf")
	'loadNSFRom("Sonic 3 & Knuckles VRC6 Part 2-AL.nsf ")
	'loadNSFRom("Sonic 3 & Knuckles VRC6 Part 2-BP.nsf ")
	'loadNSFRom("Sonic 3 & Knuckles VRC6 Part 1-SZ2.nsf")
	'loadNSFRom("Sonic 3 & Knuckles VRC6 Part 1-AI2.nsf")
	loadNSFRom("Sonic 3 & Knuckles VRC6 Part 1-TDZ.nsf")
	
	
	
	'loadNSFRom("Hidden Palace Zone.nsf") 
	
	     'loadNSFRom("VRC6- Lava Reef Act 1.nsf") 
	     
	 	    'loadNSFRom("Sonic_3_-_Hydrocity_Act_2.nsf") 
' loadNSFRom("finalZone.nsf") 
'loadNSFRom("Crisis City (Classic) - Sonic Generations [8-Bit,0CC MMC5+N163-3].nsf") 
 'loadNSFRom("Freedom Planet - Aqua Tunnel 1.nsf") 
'loadNSFRom("Boss - Freedom Planet.nsf") 
 'loadNSFRom("BL_mnsg_oedocastle.nsf") 
	'loadNSFRom("flyingbattery.nsf") 
	
	
	
	
	 'loadNSFRom("DMG-ABUE-USA_track10.nsf")
	  'loadNSFRom("DMG-ABUE-USA_track0010.nsf")
	 	 'loadNSFRom("DMG-APAE-USA_track21.nsf")
	 
	End Sub


init_nsf



    SDL_CloseAudioDevice(audio_hndler->audio_device)
    delete audio_hndler
    audio_hndler = null
     SDL_Quit()

'sleep