*** Settings ***
Documentation   Router Test Cases

Library     RouterNapalm.py
Test setup  Connect device

*** Variables ***

${PE1}=     192.168.1.55
${PE2}=     10.170.2.1
${LOGIN}=   admin
${PASSWORD}=    Juniper!

*** Keywords ***
Connect device
  ${napalm-connection-PE1}=   Napalm Connect  ${PE1}  ${LOGIN}  ${PASSWORD}
  Set Suite Variable  ${napalm-connection-PE1}

*** Test Cases ***
T01.1 Ping VL-PE1 Router Management Interface
  [Documentation]   Check ping is working to PE management interface
  [Tags]  ROUTER, PING

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-PE1}    192.168.1.55
  Should Be Equal  Successful  ${peer_ping_state}

T01.2 Ping VL-PE2 Loopback Interface
  [Documentation]   Check ping is working to the Neighbor PE router
  [Tags]  ROUTER, PING

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  Successful  ${peer_ping_state}


T01.3 Check OSPF comes back after flap
  [Documentation]   Check if OSPF is up, clear OSPF sessions, check again
  [Tags]  OSPF, ROUTER

  ${peer_state}=     Get OSPF Neighbor State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}

  Clear OSPF Neighbor All   ${napalm-connection-PE1}
  Sleep     60s

  ${peer_state}=     Get OSPF Neighbor State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}


T01.4 Check BGP comes back after flap
  [Documentation]   Check if BGP peer is UP, clear BGP sessions, check again
  [Tags]  BGP, ROUTER

  ${peer_state}=     Get BGP Peer State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}

  Clear BGP Neighbor All   ${napalm-connection-PE1}
  Sleep     60s

  ${peer_state}=     Get BGP Peer State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}
