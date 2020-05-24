*** Settings ***
Documentation   Router Test Cases

Library     RouterNapalm.py
Test setup  Connect device

*** Variables ***

${PE1}=     192.168.1.250
${PE2}=     192.168.1.249
${NTU1}=     192.168.1.248
${NTU2}=     192.168.1.247
${CLIENTROUTER1}=      192.168.1.246
${CLIENTROUTER1}=      192.168.1.245
${EXTERNALROUTER}=     192.168.1.244

${LOGIN}=   admin
${PASSWORD}=    Juniper!

*** Keywords ***
Connect device
  ${napalm-connection-PE1}=   Napalm Connect Juniper  ${PE1}  ${LOGIN}  ${PASSWORD}
  Set Suite Variable  ${napalm-connection-PE1}

*** Test Cases ***
T01.1 Ping VL-PE1 Router Management Interface
  [Tags]  ROUTER  PING

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-PE1}    192.168.1.250
  Should Be Equal  Successful  ${peer_ping_state}

T01.2 Ping VL-PE2 Loopback Interface
  [Tags]  ROUTER  PING

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  Successful  ${peer_ping_state}


T01.3 Check OSPF comes back after flap
  [Tags]  OSPF  ROUTER

  ${peer_state}=     Get OSPF Neighbor State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}

  Clear OSPF Neighbor All   ${napalm-connection-PE1}
  Sleep     60s

  ${peer_state}=     Get OSPF Neighbor State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}


T01.4 Check BGP comes back after flap
  [Tags]  BGP   ROUTER

  ${peer_state}=     Get BGP Peer State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}

  Clear BGP Neighbor Juniper   ${napalm-connection-PE1}   10.0.0.2
  Sleep     80s

  ${peer_state}=     Get BGP Peer State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}

T01.5 Check for Chassis Alarms
  [Tags]  ROUTER  ALARMS

  ${chassis_alarm_state}=     Get Chassis Alarms    ${napalm-connection-PE1}
  Should Be Equal  No Alarms  ${chassis_alarm_state}

T01.6 Check for System Alarms
  [Tags]  ROUTER  ALARMS

  ${system_alarm_state}=     Get System Alarms    ${napalm-connection-PE1}
  Should Be Equal  No Alarms  ${system_alarm_state}
