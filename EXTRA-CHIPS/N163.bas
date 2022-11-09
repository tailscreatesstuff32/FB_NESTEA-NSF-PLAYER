

#include once "N163.bi"

dim shared finalN163output as double
dim shared samplepos1 as uint8_t
constructor N163




End Constructor 
	


sub N163.clock()
if this._disablesound  = false then
	this._updateCounter+=1
	if(this._updateCounter = 15)  then
				this.UpdateChannel(_currentChannel) 

				this._updateCounter = 0 
				this._currentChannel-=1
				if(this._currentChannel < 7 - this.GetNumberOfChannels()) then
					this._currentChannel = 7 
				End If
	End If
End If
	
	
'	this.UpdateChannel(_currentChannel) 
	

	
End Sub


sub N163.updatechannel(channel as integer)
	
	 dim phase as uint32_t = this.GetPhase(channel) 
	 dim freq as  uint32_t = this.GetFrequency(channel) 
	 dim length as uint8_t  = this.GetWaveLength(channel) 
	 dim offset as uint8_t = this.GetWaveAddress(channel) 
	 dim volume as uint8_t = this.GetVolume(channel) 

		if(length = 0)  then
			phase = 0 
		 else  
			phase = (phase + freq) mod (length shl 16) 
		end if
		
		dim samplePosition as uint8_t = ((phase shr 16) + offset) and &HFF 
		
		'samplepos1 = samplePosition'_internalRam(samplePosition / 2)
		
		dim sample as int8_t
		if((samplePosition and &H01)) then
			sample = this._internalRam(samplePosition \ 2)  shr 4 
		 else 
			sample = this._internalRam(samplePosition \ 2) and &H0F 
		end if

samplepos1 = sample
		this._channelOutput(channel) = (sample - 8) * volume 
		this.UpdateOutputLevel() 
		this.SetPhase(channel, phase) 
	
	
End Sub

function N163._read(adr as uint16_t) as uint8_t
dim value as uint8_t = 0

select case (adr and &HF800)
	
	
	case &H4800
		
		value = this._internalRam(_ramPosition)
		if(this._autoIncrement)  then
					this._ramPosition = (this._ramPosition + 1) and &H7F 
		end if
	
	   
	
end select	
	
	return value
	

End Function
	
	
sub N163._write(adr as uint16_t, value as uint8_t)' as boolean

	select case (adr and &HF800) 
			case &H4800 
				this._internalRam(this._ramPosition) = value 
				if(this._autoIncrement) then
					this._ramPosition = (this._ramPosition + 1) and &H7F 
				end if
				 
			case &HE000 
				this._disableSound = iif((value and &H40) = &H40,true,false) 
				 
			case &HF800 
				this._ramPosition = value and &H7F 
				this._autoIncrement = iif((value and &H80) = &H80,true,false) 
			

		end select

End sub
  
  sub  N163.UpdateOutputLevel()
  dim i as integer
  dim _min as integer

		dim summedOutput as int16_t = 0 
		
		i = 7
		_min = 7 - this.GetNumberOfChannels()
		do while i >= _min
			
			summedOutput += this._channeloutput(i)
			i-=1 
		loop
		
		   'summedOutput += _channeloutput(7)
			summedOutput /= this.GetNumberOfChannels() + 1
			
			' 0.000982
			' 0.000482
			'finalN163output = summedOutput * 0.002982 '- this._lastOutput 
			
			finalN163output = summedOutput * 0.000482 '0.002982 
			
			
		'_console->GetApu()->AddExpansionAudioDelta(AudioChannel::Namco163, summedOutput - _lastOutput);
	this._lastOutput = summedOutput 
end sub		
		
		
function N163.Getfrequency(channel as integer) as uint32_t
		dim baseAddr as uint8_t = &H40 + channel * &H08 
	return (this._internalram(baseaddr + SoundReg.frequencyhigh) shl 16 ) or (this._internalram(baseaddr + SoundReg.frequencymid) shl 8 ) or this._internalram(baseaddr + SoundReg.frequencylow)
	
	
End Function


function N163.GetPhase(channel as integer) as uint32_t
	dim baseAddr as uint8_t = &H40 + channel * &H08 
	return (this._internalram(baseaddr + SoundReg.phasehigh) shl 16 ) or (this._internalram(baseaddr + SoundReg.phasemid) shl 8 ) or this._internalram(baseaddr + SoundReg.phaselow)
	
End Function

sub N163.SetPhase(channel as integer, phase as uint32_t) 
	dim baseAddr as uint8_t = &H40 + channel * &H08
	this._internalram(baseaddr + SoundReg.phasehigh) = (phase shr 16) and &HFF
	this._internalram(baseaddr + SoundReg.phasemid) = (phase shr 8) and &HFF
	this._internalram(baseaddr + SoundReg.phaselow) = phase and &HFF
	
	
End sub

 function N163.GetNumberOfChannels()as uint8_t
 	
 	return (this._internalram(&H7F) shr 4) and &H07
 	
 End Function

 	'
function N163.GetVolume(channel as integer) as uint8_t
	dim baseAddr as uint8_t = &H40 + channel * &H08
	
	return _internalRam(baseAddr + SoundReg.Volume) and &H0F
	
End Function
    
    
    
function N163.GetWaveLength(channel as integer) as uint8_t
	
	
	dim baseAddr as uint8_t = &H40 + channel * &H08
	return 256 - (this._internalRam(baseAddr + SoundReg.WaveLength) and &HFC)
	
End Function

 function N163.GetWaveAddress(channel as integer) as uint8_t
 	dim baseAddr as uint8_t = &H40 + channel * &H08
 	
 	return this._internalRam(baseAddr + SoundReg.WaveAddress)
 End Function
 
 
sub N163.ConnectBus(n as any ptr)
	
  this.bus = n
	
End Sub