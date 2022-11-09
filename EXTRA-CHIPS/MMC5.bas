#include once "MMC5.bi"

dim shared MMC5_pulse1_reg0 as uint8_t 
dim shared MMC5_pulse1_reg1 as uint8_t 
dim shared MMC5_pulse1_reg2 as uint8_t 
dim shared MMC5_pulse1_reg3 as uint8_t 

dim shared MMC5_pulse2_reg0 as uint8_t 
dim shared MMC5_pulse2_reg1 as uint8_t 
dim shared MMC5_pulse2_reg2 as uint8_t 
dim shared MMC5_pulse2_reg3 as uint8_t 




 '//////////////////////////////////////////////////////////////////////////////////////////////	
    























constructor MMC5()




End Constructor

sub MMC5.square1_clock
	
	'		if(_timer == 0) {
	'		_dutyPos = (_dutyPos - 1) & 0x07;
	'		//"Frequency values less than 8 do not silence the MMC5 pulse channels; they can output ultrasonic frequencies."
	'		_currentOutput = _dutySequences[_duty][_dutyPos] * GetVolume();
	'		_timer = _period;
	'	} else {
	'		_timer--;
	'	}
	''}
	'			if this.p2TimerValue <> 0 then
	'	this.p2TimerValue-=1
	'else
	'this.p2TimerValue = (this.p2Timer * 2) + 1
	' this.p2DutyIndex += 1
	' this.p2DutyIndex and= &H7
	'EndIf
	'
	'_currentOutput  = this.dutycycles(this.p2Duty,this.p2DutyIndex)
	
	
	'
	'	if(this._timer = 0) then
	'		this.p2DutyIndex = (this.p2DutyIndex - 1) and &H07 
	'		'//"Frequency values less than 8 do not silence the MMC5 pulse channels; they can output ultrasonic frequencies."
	'		this._currentOutput = this.dutycycles(this.p2Duty,this.p2DutyIndex) * this.GetVolume() 
	'		_timer = _period 
	'	 else 
	'		this._timer-=1
	'	end if
	'end if
	'
	
	
End Sub

sub MMC5.square2_clock
	
			if(this._timer = 0) then
			this.p2DutyIndex = (this.p2DutyIndex - 1) and &H07 
			'//"Frequency values less than 8 do not silence the MMC5 pulse channels; they can output ultrasonic frequencies."
			this._currentOutput = this.dutycycles(this.p2Duty,this.p2DutyIndex)' * this.GetVolume() 
			_timer = _period 
		 else 
			this._timer-=1
		end if
	'end if
	'		if this.p1TimerValue <> 0 then
	'	this.p1TimerValue-=1
	'else
	'this.p1TimerValue = (this.p1Timer * 2) + 1
	' this.p1DutyIndex += 1
	' this.p1DutyIndex and= &H7
	'EndIf
	'
	'_currentOutput  = this.dutycycles(this.p1Duty,this.p1DutyIndex)
	'
End Sub


sub MMC5.p1ticklengthcounter()
	'if(_p1lengthCounter > 0 and  _p1lengthCounterHalt = false) then
	'		_p1lengthCounter-=1
	'		end if
	
End Sub


sub MMC5.p2ticklengthcounter()
			
			'if(_p2lengthCounter > 0 and  _p2lengthCounterHalt = false) then
			'_p2lengthCounter-=1
			'	end if
				
End Sub


sub MMC5.p1tickenvelope()
	'		if(_start) {
	'		_divider--;
	'		if(_divider < 0) {
	'			_divider = _volume;
	'			if(_counter > 0) {
	'				_counter--;
	'			} else if(_lengthCounterHalt) {
	'				_counter = 15;
	'			}
	'		}
	'	} else {
	'		_start = false;
	'		_counter = 15;
	'		_divider = _volume;
	'	}			
	'			
	'			
	'	
	'EndIf
	'
End Sub

sub MMC5.p2tickenvelope()

	'			if(_start) {
	'		_divider--;
	'		if(_divider < 0) {
	'			_divider = _volume;
	'			if(_counter > 0) {
	'				_counter--;
	'			} else if(_lengthCounterHalt) {
	'				_counter = 15;
	'			}
	'		}
	'	} else {
	'		_start = false;
	'		_counter = 15;
	'		_divider = _volume;
	'	}			
	'			
	'			
	'	
	'EndIf
	
End Sub
	


sub MMC5.p1reloadcounter
	
	'if(_p1lengthCounterReloadValue)  then
	'		if(_p1lengthCounter = _p1lengthCounterPreviousValue) then
	'			_p1lengthCounter = _p1lengthCounterReloadValue 
	'		end if
	'		_p1lengthCounterReloadValue = 0
	'	end if

	'	_p1lengthCounterHalt = _p1newHaltValue

End Sub

sub MMC5.p2reloadcounter
		'if(_p2lengthCounterReloadValue)  then
		'	if(_p21lengthCounter = _p2lengthCounterPreviousValue) then
		'		_p2lengthCounter = _p2lengthCounterReloadValue 
		'	end if
		'	_p2lengthCounterReloadValue = 0
		'end if

		'_p2lengthCounterHalt = _p2newHaltValue

End Sub
function MMC5.GetOutput() as int8_t
	return _currentOutput

End function

sub MMC5.clock
	
	this._audiocounter-=1
	this.square1_clock
	this.square2_clock
	
	if _audiocounter <=0 then
		
		
		p1ticklengthcounter()
		p2ticklengthcounter()
		p1tickenvelope()
		p2tickenvelope()

		
	
	end if
	
	dim summedOutput as int16_t '-(_square.GetOutput() + _square.GetOutput() + _pcmOutput)
	
	if(summedoutput <> _lastoutput) then
		
		_lastOutput = summedOutput
		
		
	End If
	
				
		
		 p1reloadcounter
		 p2reloadcounter
		
	
End Sub



sub MMC5.ConnectBus(n as any ptr)
	
  this.bus = n
	
End Sub

function MMC5._read(adr As uint16_t,rdonly as boolean = false) As uint8_t
dim value as uint8_t = 0

         
 
       	
       	if adr = &H5010 then
       	'WIP IRQ and read mode
       	return 0
       	
       	EndIf
  
 	
       	if adr = &H5015 then
       	'WIP IRQ and read mode
       	dim status as uint8_t
       	status or= iif(this.p1Counter > 0,true,false)
       	status or= iif(this.p2Counter > 0,true,false)
       	return status
       	
       	
       	EndIf
  





	

End Function
	







function MMC5._write(adr as uint16_t, value as uint8_t) as boolean

		    
          
         if adr = &H5000 then
         	
         MMC5_pulse1_reg0 = value	
         this.p1Duty = (value and &HC0) shr 6
			this.p1Volume = value and &HF
			this.p1CounterHalt = iif((value and &H20)  > 0,true,false)
			this.p1ConstantVolume = iif((value and &H10) > 0,true,false)
         	
         	
      	
         EndIf
         
         
            if adr = &H5001 then
      	MMC5_pulse1_reg1 = value
      	
      	'MMC5 has no sweep functionality
      	
      	
         EndIf
         
         
             if adr = &H5002 then
      	MMC5_pulse1_reg2 = value
        this.p1Timer and= &H700 
        this.p1Timer or= value
        
             EndIf
             
         
         if adr = &H5003 then
      	MMC5_pulse1_reg3 = value
      this.p1Timer and= &Hff
        this.p1Timer or= (value and &H7) shl 8 
        this.p1DutyIndex = 0 
        if (this.enablePulse1) then
          this.p1Counter = this.lengthLoadValues((value and &Hf8) shr 3)
          '  setconsoletitle( str( this.p2Counter))
       
        end if
     
        this.p1EnvelopeStart = true 
                 EndIf
         
         
  
      if adr = &H5004 then
      	MMC5_pulse2_reg0 = value
         this.p2Duty = (value and &HC0) shr 6
			this.p2Volume = value and &HF
			this.p2CounterHalt = iif((value and &H20)  > 0,true,false)
			this.p2ConstantVolume = iif((value and &H10) > 0,true,false)
      	
         EndIf
         
         
            if adr = &H5005 then
      	MMC5_pulse2_reg1 = value

        
         EndIf
         
         
             if adr = &H5006 then
      	MMC5_pulse2_reg2 = value
        this.p2Timer and= &H700 
        this.p2Timer or= value
         EndIf
         
         if adr = &H5007 then
      	MMC5_pulse2_reg3 = value
      	 this.p2Timer and= &Hff
        this.p2Timer or= (value and &H7) shl 8 
        this.p2DutyIndex = 0 
        if (this.enablePulse2) then
          this.p2Counter = this.lengthLoadValues((value and &Hf8) shr 3)
          '  setconsoletitle( str( this.p2Counter))
       
        end if
     
        this.p1EnvelopeStart = true 
                 EndIf
         
  
       	
       	if adr = &H5010 then
       	'WIP IRQ and read mode
       	_pcmReadMode = iif(value and &H01 = &H01,true,false)
       	_pcmIrqEnabled = iif(value and &H80 = &H80,true,false)
       	EndIf
       	
   	if adr = &H5011 then
       	'WIP IRQ and read mode
       			if(_pcmReadMode = false)  then
					if(value <> 0) then
						this._pcmOutput = value 
       			end if
				end if
   	EndIf
   	
  	if adr = &H5015 then
  		this.enablePulse1 = iif(value and &H01 = &H01,true,false)
  		this.enablePulse2 = iif(value and &H01 = &H01,true,false)
   	EndIf
	
End Function