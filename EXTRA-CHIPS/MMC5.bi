#include "crt.bi"


'type as bus _bus 





   
type MMC5
	 
	 declare constructor()
	   
	   
	lengthloadvalues(32) as uint8_t => { 10, 254, 20,  2, 40,  4, 80,  6,_
							       				 160,   8, 60, 10, 14, 12, 26, 14,_
							         			  12,  16, 24, 18, 48, 20, 96, 22,_
							                   192,  24, 72, 26, 16, 28, 32, 30}
							                    
	 dutycycles(4,8) as uint8_t = { {0, 1, 0, 0, 0, 0, 0, 0},_
    	 									 {0, 1, 1, 0, 0, 0, 0, 0},_
    	 									 {0, 1, 1, 1, 1, 0, 0, 0},_
    	 									 {1, 0, 0, 1, 1, 1, 1, 1}}
	   
	   
	   
    declare sub _reset() ' finished
	 declare sub _cycle() 'finished 
	 declare sub cyclePulse1()'finished 
	 declare sub cyclePulse2() 'finished 
    declare sub clockquarter() ' finished
    declare sub clockhalf() ' finished
    declare function mix() as double ' finished
    declare function getOutput() as int8_t 'as outputs ptr  'any ptr' MAYBE


    
'APU VARIABLES///////////////////
	
	_output(29781) as double
	_outputoffset as uint32_t
	

	step5Mode as boolean
	interruptInhibit as boolean
	   
	 _audiocounter as int16_t  
	 _lastoutput as int16_t 
	 _pcmreadmode as bool
	 _pcmirqenabled as bool  
	 _currentOutput as int8_t
	 _pcmOutput as uint8_t 
	 _isMmc5Square as bool = true

	'pulse 1
	 p1Timer as uint32_t = 0
    p1TimerValue as uint32_t = 0
    p1Duty as double = 0
    p1DutyIndex as uint32_t = 0
    p1Output as double = 0
    p1CounterHalt as boolean = false
    p1Counter as uint32_t = 0
    p1Volume as uint32_t = 0
    p1ConstantVolume as boolean = false
    p1Decay as uint32_t = 0
    p1EnvelopeCounter as uint32_t = 0
    p1EnvelopeStart as boolean = false
    p1SweepEnabled as boolean = false
    p1SweepPeriod as uint32_t = 0
    p1SweepNegate as boolean = false
    p1SweepShift as int32_t = 0
    p1SweepTimer as int32_t = 0
    p1SweepTarget as int32_t = 0
    p1SweepMuting as boolean = true
    p1SweepReload as boolean = false
	
	'pulse 2
	 p2Timer as uint32_t = 0
    p2TimerValue as uint32_t = 0
    p2Duty as uint32_t = 0
    p2DutyIndex as uint32_t = 0
    p2Output as double = 0
    p2CounterHalt as boolean = false
    p2Counter as uint32_t = 0
    p2Volume as uint32_t = 0
    p2ConstantVolume as boolean = false
    p2Decay as uint32_t = 0
    p2EnvelopeCounter as uint32_t = 0
    p2EnvelopeStart as boolean = false
    p2SweepEnabled as boolean = false
    p2SweepPeriod as uint32_t = 0
    p2SweepNegate as boolean = false
    p2SweepShift as int32_t = 0
    p2SweepTimer as int32_t = 0
    p2SweepTarget as int32_t = 0
    p2SweepMuting as boolean = true
    p2SweepReload as boolean = false
	  
	  
	enablePulse2 as boolean
	enablePulse1  as boolean
	 
	  
	  _timer as uint16_t
	  _period as uint16_t
	  
	  
	  
	 bus as _Bus ptr

	  
	declare sub ConnectBus(n as any ptr)
	
   'registers




 '//////////////////////////////////////////////////////////////////////////////////////////////	
    
declare sub clock()
declare sub square1_clock()
declare sub square2_clock()

	Declare Function _read(adr As uint16_t,rdonly as boolean = false) As uint8_t
	Declare Function _write(adr As uint16_t,value As uint8_t) As boolean
     
   declare sub p1tickenvelope()
   declare sub p2tickenvelope()
      declare  sub p1ticklengthcounter()
declare sub p2ticklengthcounter()

 declare sub  p1reloadcounter
  declare sub  p2reloadcounter
end type



#include "MMC5.bas"