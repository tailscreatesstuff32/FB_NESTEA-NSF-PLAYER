
#include once "VRC6.bi"


dim shared finalVRC6output as double'int32_t


constructor VRC6





End Constructor



sub VRC6.pulse1_clock
	
	
		if this.p1enabled then
		this.p1timer-=1
		if this.p1timer = 0 then
			this.p1step = (this.p1step + 1) and &H0F 
			this.p1timer = (this.p1frequency shr this.p1frequencyShift) + 1 
			
		EndIf
		
	EndIf
	
End Sub

sub VRC6.pulse2_clock
	
	
		if this.p2enabled then
		this.p2timer-=1
		if this.p2timer = 0 then
			this.p2step = (this.p2step + 1) and &H0F 
			this.p2timer = (this.p2frequency shr this.p2frequencyShift) + 1 
			
		EndIf
		
		EndIf
	
End Sub

sub VRC6.clock()
dim outputlevel1 as int32_t
	if haltaudio = false then
	this.pulse1_clock
	this.pulse2_clock
	this.Saw_clock
	end if
	
	
	'this.GetP1Volume() + 
'this.Getp1Volume() + this.GetP2Volume() + 		
outputLevel1 = this.GetSawVolume() + this.Getp1Volume() + this.GetP2Volume() 
	
	finalVRC6output = 0.00752 * outputLevel1
	
	
End Sub


function VRC6.GetP1Volume() as uint8_t
	if(this.p1enabled = false)  then
			return 0 
	elseif(this.p1ignoreDuty) then
			return this.p1volume 
		  else  
			return iif(this.p1step <= this.p1dutyCycle, this.p1volume, 0) 
	end if
	
	
End Function


function VRC6.GetP2Volume() as uint8_t
		if(this.p2enabled = false)  then
			return 0 
		elseif(this.p2ignoreDuty) then
			return this.p2volume 
		  else  
			return iif(this.p2step <= this.p2dutyCycle, this.p2volume, 0) 
		end if
	
	
End Function

sub VRC6.ConnectBus(n as any ptr)
	
  this.bus = n
	
End Sub


sub VRC6.SetP1FrequencyShift(_shift as uint8_t)
	this.p1frequencyShift = _shift
	
End Sub
sub VRC6.SetSawFrequencyShift(_shift as uint8_t)
	this.SawfrequencyShift = _shift
	
End Sub

sub VRC6.SetP2FrequencyShift(_shift as uint8_t)
	this.p2frequencyShift = _shift
	
End Sub
function VRC6._write(adr as uint16_t, value as uint8_t) as boolean
		dim frequencyshift as uint8_t
		
	if adr = &H9000 then
		this.pulse1regs.R0 = value 
		this.p1volume = (value and &H0F)
		this.p1dutycycle = (value and &H70) shr 4
		this.p1ignoreduty = iif((value and &H80) = &H80,true,false)
		
	EndIf
	

	
	
	


	
		if adr = &H9001 then
		this.pulse1regs.R1 = value 
		this.p1frequency = (this.p1frequency and &H0F00) or value
		
		
		EndIf
		
	if adr = &H9002 then
		this.pulse1regs.R2 = value 
		this.p1frequency = (this.p1frequency and &HFF) or ((value and &H0F) shl 8)
		this.p1enabled = iif((value and &H80) = &H80,true,false)
		
		if this.p1enabled = false then
			this.p1step = 0
	
		EndIf
		
	EndIf
	
	if adr = &H9003 then
		
				this.haltAudio = iif((value and &H01) = &H01,true,false) 
				frequencyShift = iif((value and &H04) =  &H04,8,iif((value and &H02) =  &H02,4,0))
				this.Setp1FrequencyShift(frequencyShift) 
				'Setp2FrequencyShift(frequencyShift) 
			'	sawSetFrequencyShift(frequencyShift) 
			
		
		
	EndIf
	'
	
	
	
	if adr = &HA000 then
		this.pulse2regs.R0 = value 
		p2volume = (value and &H0F)
		p2dutycycle = (value and &H70) shr 4
	   this.p2ignoreduty = iif((value and &H80) = &H80,true,false)
		
		
	EndIf
	
	
		if adr = &HA001 then
		this.pulse2regs.R1 = value 
		this.p2frequency = (this.p2frequency and &H0F00) or value
		
		
		EndIf
	if adr = &HA002 then
		this.pulse2regs.R2 = value 
			 
		this.p2frequency = (this.p2frequency and &HFF) or ((value and &H0F) shl 8)
		this.p2enabled = iif((value and &H80) = &H80,true,false)
		
		if p2enabled = false then
			this.p2step = 0
	
		EndIf
		
		
	EndIf
	
		if adr = &HB000 then
		this.Sawregs.R0 = value 
		accumulatorRate = value and &H3F
		
		
	EndIf
	
	
		if adr = &HB001 then
		this.Sawregs.R1 = value 
		Sawfrequency = (Sawfrequency and &H0F00) or value
		
		
		EndIf
	if adr = &HB002 then
		this.Sawregs.R2 = value 
		Sawfrequency = (Sawfrequency and &HFF) or ((value and &H0F) shl 8)
		Sawenabled = iif((value and &H80) = &H80,true,false)
		
		if (Sawenabled = false) then
			
			accumulator = 0
			Sawstep = 0
			
			
		EndIf
		
		
	EndIf
	
End Function
	
	
	function VRC6.GetSawVolume() as uint8_t
if(Sawenabled = false) then
			return 0 
		  else  
			'//"The high 5 bits of the accumulator are then output (provided the channel is enabled by having the E bit set)."
			return accumulator shr 3 
		 
end if
End Function

sub VRC6.Saw_clock()
	
		if(Sawenabled)  then  
			Sawtimer-=1
			if(Sawtimer = 0)  then
				Sawstep = (Sawstep + 1) mod 14 
				Sawtimer = (Sawfrequency shr SawfrequencyShift) + 1 

				if(Sawstep = 0)  then
					accumulator = 0 
				  elseif((Sawstep and &H01) = &H00)  then
					accumulator += accumulatorRate
				end if
			end if
		end if
	end sub
	

