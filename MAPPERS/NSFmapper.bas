#Include Once "windows.bi"
#Include Once "containers/vector.bi"
#include Once "file.bi"

#include "crt.bi"

Type UINT8T As uint8_t 
MVectorTemplate(UINT8T)


Type NSFMapper 

banked As boolean 

origbanks As uint8_t Ptr

loadaddr As uint16_t
banks(7) As uint8_t 'Ptr = New uint8_t(7)
data1 As TVECTORUINT8T
romdata  As TVECTORUINT8T ' Ptr' = New uint8_t(&H8000) ' change to vector
maxBanks As uint8_t

prgram(&H2000) As uint8_t' Ptr' = New uint8_t(&H2000)' change to vector

Declare Constructor(bytes_data As TVECTORUINT8T ,loadadr As uint32_t,banked1 As boolean,banks() As uint8_t)




Declare function read_NSF(adr As uint16_t) As uint8_t 
Declare function write_NSF(adr As uint16_t, Val As uint8_t) As boolean
Declare sub resetMapper_NSF() 



End Type






Constructor NSFMapper(bytes_data as TVECTORUINT8T, loadadr As uint32_t,banked1 As boolean,banks() As uint8_t)
 
this.banked = banked1

this.origbanks = @banks(0)




this.loadaddr = loadadr
this.data1.resize(bytes_data.size(),0):this.data1 = bytes_data 

this.maxBanks = 1


	
resetMapper_NSF()

End Constructor

'FINISHED
function NSFMapper.read_NSF(adr As uint16_t) As uint8_t
	
	If adr < &H6000 Then
	Return FALSE
	End If
	
	If adr < &H8000 Then
		
		Return this.prgram(adr And &H1FFF)
		
		
		
	End If
	
If this.banked Then
		Dim As uint8_t banknum = (adr Shr 12)-8
		'return romData.at(this.banks(bankNum) * &H1000 + (adr and &Hfff))
		return romData[this.banks(bankNum) * &H1000 + (adr and &Hfff)]
	Else
		'Return this.romData.at(adr and &H7fff)
		Return this.romData[adr and &H7fff]
End If
	
End Function


'FINISHED
Function NSFMapper.write_NSF(adr As uint16_t, val1 As uint8_t) As boolean
	'
	If Adr < &H5FF8 Then
		Return FALSE
	EndIf
	If Adr < &H6000 Then
		this.banks(adr - &H5ff8) = val1 mod this.maxBanks
		Return FALSE
	EndIf
	If Adr < &H8000 Then
		this.prgram(adr and &H1fff) = Val1
		Return FALSE
	EndIf

	Return FALSE
End function


'FINISHED
Sub nsfmapper.resetmapper_nsf()
	
	'For i As uint16 = 0 To ubound(prgram)-1	
	'	this.prgram(i) = 0	
	'Next


	
'
erase this.prgram

for i As uint8_t = 0 To 8-1      
this.banks(i) = this.origBanks[i]  
Next
  
	If this.banked Then
 		this.loadAddr and= &Hfff
		Dim totalData As uint16_t = (this.data1.size() - &H80) + this.loadAddr
		this.maxBanks = ceil(totalData / &H1000)  
		'dim romdata(this.maxBanks * &H1000) as uint8_t
		this.romdata.resize(this.maxBanks * &H1000,0)
		for i as uint32_t = this.loadaddr to this.romdata.size()
			if &H80 + (i - this.loadAddr) >=  this.data1.size()  then
		
		   exit for
	end if
		this.romdata[i] = this.data1[&H80 +(i-this.loadAddr)]
		
		Next
	
	else

'works correctly//////////////////////////////////////////////////

	'dim romdata(&H8000) as uint8_t
	this.romdata.clear()
	this.romdata.resize(&H8000,0)
	
	
	for i as uint32_t = this.loadAddr to &H10000
		

		if &H80 + (i - this.loadAddr) >= this.data1.size() then
		
			exit for
			
		end if
				
				
			
				

			
	this.romdata[i-&H8000] = this.data1[&H80 + (i-this.loadAddr)]
	
  'print i-&H8000
 ' sleep
		
	Next
		'print this.romdata[(this.loadAddr-&H8000)+300]
	
	EndIf
	
'/////////////////////////////////////////////////////////////////	
End Sub
















'If this.banked Then
	'this.loadAddr and= &Hfff
	'Dim totalData As uint16_t = (ubound(this.data1) - &H80) + this.loadAddr
	''	
	''TODO WIP
	'Print "this audio is banked WIP"
	'Else
	'	romdata.resize(&H8000)
	'For i As uint16_t = this.loadaddr To  &H10000 -1  
	'If &H80 +	(i - this.loadaddr) >= ubound(this.data1) Then
	'	
	'	Exit For
	'Else
	'	romData.assign(i - &H8000,this.data1(&H80 + (i - this.loadAddr))) 

	'End If

   '
	'Next

'sleep
