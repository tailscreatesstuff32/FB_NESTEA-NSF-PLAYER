
#include "crt.bi"


'type as bus _bus 

type N163 
	 
	 declare constructor()
	   
	 'nes as any ptr 
	  
	  _internalRam(&H80) as uint8_t
	  _channeloutput(8) as  int16_t
	  _ramposition as uint8_t = 0
	  _autoincrement as bool = false
	  _updatecounter as uint8_T = 0
	  _currentChannel as int8_T = 7
	  _lastoutput as int16_T = 0
	  _disablesound as bool = false
	  
	  
	  
	 bus as _Bus ptr

	  
	declare sub ConnectBus(n as any ptr)
	
   'registers
  

  enum soundreg
  		FrequencyLow = &H0 
		PhaseLow = &H1 
		FrequencyMid = &H02 
		PhaseMid = &H03 
		FrequencyHigh = &H04 
		WaveLength = &H04 
		PhaseHigh = &H05 
		WaveAddress = &H06 
		Volume = &H07
  End Enum



declare sub clock()
 	



'internal_ram_addr2 as uint8_T




'phase as uint32_t
'freq as uint8_t
'length as uint8_t
'sample_address as uint8_t




 '//////////////////////////////////////////////////////////////////////////////////////////////	
    

	Declare Function _read(adr As uint16_t) As uint8_t
	Declare sub _write(adr As uint16_t,value As uint8_t) 'As boolean
	Declare Function GetFrequency(channel as integer) as uint32_t
	Declare Function Getphase(channel as integer) as uint32_t
	Declare sub Setphase(channel as integer,phase as uint32_t )' as uint32_t
	Declare Function GetWaveAddress(channel as integer) as uint8_t
   Declare Function GetWaveLength(channel as integer) as uint8_t
   Declare Function GetNumberOfChannels() as uint8_t
   Declare Function GetVolume(channel as integer) as uint8_t
   declare sub updatechannel(channel as integer)' as uint8_t
   Declare Function GetInternalRam() as uint8_t ptr
   declare sub updateoutputlevel()' as uint8_t
   
   
 
end type



#include "N163.bas"