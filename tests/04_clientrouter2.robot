*** Settings ***
Documentation   Client Test Cases

Library     RouterNapalm.py
Test setup  Connect device

*** Variables ***

${PE1}=     192.168.1.250
${PE2}=     192.168.1.249
${NTU1}=     192.168.1.248
${NTU2}=     192.168.1.247
${CLIENTROUTER1}=      192.168.1.246
${CLIENTROUTER2}=      192.168.1.245
${EXTERNALROUTER}=     192.168.1.244

${LOGIN}=   admin
${PASSWORD}=    cisco
${SECRET}=    cisco

*** Keywords ***
Connect device
  ${napalm-connection-CLIENTROUTER2}=   Napalm Connect Cisco IOS  ${CLIENTROUTER2}  ${LOGIN}  ${PASSWORD}   ${SECRET}
  Set Suite Variable  ${napalm-connection-CLIENTROUTER2}

*** Test Cases ***
T04.1 Ping VL-PE1 Router from Client Router 2
  [Tags]  CLIENT  PING

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-CLIENTROUTER2}    10.0.0.1
  Should Be Equal  Successful  ${peer_ping_state}

T04.2 Ping VL-PE2 Router from Client Router 2
  [Tags]  CLIENT  PING

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-CLIENTROUTER2}    10.0.0.2
  Should Be Equal  Successful  ${peer_ping_state}

T04.3 Ping 8.8.8.8 Router from Client Router 2
  [Tags]  CLIENT  PING    EXTERNAL

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-CLIENTROUTER2}    8.8.8.8
  Should Be Equal  Successful  ${peer_ping_state}

T04.4 Check Client Router 2 BGP comes back after flap
  [Tags]  BGP   CLIENT  ROUTER

  ${peer_state}=     Get BGP Peer State    ${napalm-connection-CLIENTROUTER2}    172.16.1.2
  Should Be Equal  UP  ${peer_state}

  Clear BGP Neighbor Cisco   ${napalm-connection-CLIENTROUTER2}   172.16.1.2
  Sleep     60s

  ${peer_state}=     Get BGP Peer State    ${napalm-connection-CLIENTROUTER2}    172.16.1.2
  Should Be Equal  UP  ${peer_state}

T04.5 Check if default route only being received on Client Router 2
  [Tags]  BGP   CLIENT  ROUTER

  ${peer_state}=     Get BGP Received Routes    ${napalm-connection-CLIENTROUTER2}    172.16.1.2
  Should Be True   ${peer_state}  = 1

