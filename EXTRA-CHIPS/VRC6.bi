
#include "crt.bi"


'type as bus _bus 

type vrc6regs
	r0 as uint8_t
	r1 as uint8_t
	r2 as uint8_t
   	
   	
   	
End Type




   
type VRC6 
	 
	 declare constructor()
	   
	 'nes as any ptr 
	  

	  
	 bus as _Bus ptr
	 'NSF as _NSF ptr
	  
	declare sub ConnectBus(n as any ptr)
	
   'registers

 pulse1regs as vrc6regs
 pulse2regs as vrc6regs


p1volume as uint8_t
p1dutycycle as uint8_t
p1ignoreduty as bool
p1enabled as bool

p1frequency as uint16_t = 1
p1step as uint8_t

p2volume as uint8_t
p2dutycycle as uint8_t
p2ignoreduty as bool
p2enabled as bool

p2frequency as uint16_t = 1
p2step as uint8_t

p1frequencyShift as uint8_t
p2frequencyShift as uint8_t


p1timer as int32_t = 1
p2timer as int32_t = 1


accumulatorrate as uint8_t
accumulator as uint8_t
Sawfrequency as uint16_t = 1
sawregs as vrc6regs
Sawstep as uint8_t
Sawtimer as int32_t = 1
SawfrequencyShift as uint8_t
Sawenabled as bool

'sound_enabled as boolean




 '//////////////////////////////////////////////////////////////////////////////////////////////	
    
declare sub clock()

	Declare Function _read(adr As uint16_t,rdonly as boolean = false) As uint8_t
	Declare Function _write(adr As uint16_t,value As uint8_t) As boolean


Declare sub pulse1_clock 
Declare sub pulse2_clock  

      
      
	Declare Function GetP1Volume as uint8_t 
   Declare Function GetP2Volume as uint8_t
   

   
   Declare sub SetP1FrequencyShift( _shift as uint8_t)
   Declare sub SetP2FrequencyShift( _shift as uint8_t)
   
   haltaudio as bool
   

Declare sub Saw_clock
Declare sub SetSawFrequencyShift( _shift as uint8_t)
Declare Function GetSawVolume as uint8_t

   'declare function phase(audio_ram() as uint8_t) as uint32_t
   'declare sub write_phase(audio_ram() as uint8_t,_phase as uint32_t) 
   'declare function frequency(audio_ram() as uint8_t) as uint32_t
   'declare function length(audio_ram() as uint8_t) as uint32_t
   'declare function wave_address(audio_ram() as uint8_t) as uint8_t
   'declare function volume(audio_ram() as uint8_t) as uint8_t
  
   'declare function audio_sample(audio_Ram() as uint8_t,_sample_index as uint8_t) as uint8_t
   
end type



#include "VRC6.bas"