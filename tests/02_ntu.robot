*** Settings ***
Documentation   NTU Test Cases

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
${PASSWORD}=    cisco
${SECRET}=    cisco

*** Keywords ***
Connect device
  ${napalm-connection-NTU1}=   Napalm Connect Cisco IOS  ${NTU1}  ${LOGIN}  ${PASSWORD}   ${SECRET}
  Set Suite Variable  ${napalm-connection-NTU1}

*** Test Cases ***
T02.1 Ping VL-PE1 Router Admin VRF Interface from NTU1
  [Tags]  ROUTER  PING  NTU

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-NTU1}    10.170.1.1
  Should Be Equal  Successful  ${peer_ping_state}

T02.2 Ping VL-PE2 Router Admin VRF Interface from NTU1
  [Tags]  ROUTER  PING  NTU

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-NTU2}    10.170.2.1
  Should Be Equal  Successful  ${peer_ping_state}

