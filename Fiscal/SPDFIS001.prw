#include 'protheus.ch'
#include 'parmtype.ch'


User Function SPDFIS001
Local aTipo := ParamIXB[1]


AADD(aTipo, {"II|IN|MP","01"})
AADD(aTipo, {"BN|EM","02"})
AADD(aTipo, {"PP","03"})
AADD(aTipo, {"PA|PF","04"})
AADD(aTipo, {"SP","05"})
AADD(aTipo, {"PI","06"})
AADD(aTipo, {"MC","07"})
AADD(aTipo, {"AI|PV","08"})
AADD(aTipo, {"GE|MO|SV","09"})
AADD(aTipo, {"OI","10"})
AADD(aTipo, {"BU|FI|GG|GN|IA|IM|KT|ME|MM|SL|SM|SU","99"})

Return aTipo	

/*
#include 'protheus.ch'
#include 'parmtype.ch'



User Function SPDFIS001
Local aTipo := ParamIXB[1]


alert("Ponto de entrada SPDFIS001")

aTipo    :=    { {"II|IN|MP","01"},;
                 {"BN|EM","02"},;
                 {"PP","03"},;
                 {"PA|PF","04"},;
                 {"SP","05"},;
                 {"PI","06"},;
                 {"MC","07"},;
                 {"AI|P","08"},;
                 {"GE|MO|SV","09"},;
                 {"OI","10"},;
                 {"BU|FI|GG|GN|IA|IM|KT|ME|MM|SL|SM|SU","99"} }
                
          
AADD(aTipo, {"II|IN|MP","01"})
AADD(aTipo, {"BN|EM","02"})
AADD(aTipo, {"PP","03"})
AADD(aTipo, {"PA|PF","04"})
AADD(aTipo, {"SP","05"})
AADD(aTipo, {"PI","06"})
AADD(aTipo, {"MC","07"})
AADD(aTipo, {"AI|PV","08"})
AADD(aTipo, {"GE|MO|SV","09"})
AADD(aTipo, {"OI","10"})
AADD(aTipo, {"BU|FI|GG|GN|IA|IM|KT|ME|MM|SL|SM|SU","99"})


          
AADD(aTipo, {"II|IN|MP","88"})
AADD(aTipo, {"BN|EM","88"})
AADD(aTipo, {"PP","88"})
AADD(aTipo, {"PA|PF","88"})
AADD(aTipo, {"SP","88"})
AADD(aTipo, {"PI","88"})
AADD(aTipo, {"MC","88"})
AADD(aTipo, {"AI|PV","88"})
AADD(aTipo, {"GE|MO|SV","88"})
AADD(aTipo, {"OI","88"})
AADD(aTipo, {"BU|FI|GG|GN|IA|IM|KT|ME|MM|SL|SM|SU","88"})







aTipo    :=    {{"AI","01"},;
                {"BN","01"},;
                {"BU","01"},;
                {"FI","01"},;
                {"GG","01"},;
                {"IM","01"},;
                {"IN","01"},;
                {"MC","01"},;
                {"MO","01"},;
                {"MP","01"},;
                {"OI","01"},;
                {"PA","01"},;
                {"PF","01"},;
                {"PV","01"},;
                {"SP","01"},;
                {"SV","01"} }
                
                
aTipo    :=    { {"ME","00"},;
                      {"MP","01"},;
                      {"PA","04"},;
                      {"MC","07"},;
                      {"MO","09"} }

aTipo    :=    { {"ME|PA|MC","00"},;
                      {"MP","01"},;
                      {"MO","09"} }                      
                      


Return aTipo	
*/
