*** Settings ***
Documentation   Test script to get values from router
...             Requires NAPALM (pip install napalm)

Library     RobotNapalm.py
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
TEST BGP PEER FLAP
  [Documentation]   Check if BGP peer is UP, clear BGP sessions, check again
#   ${ospf_peer_ip}= Set Variable   10.0.0.2
#   ${command} = Set Variable    clear ospf neighbor all

  ${peer_state}=     Get BGP Peer State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}

  Execute Operational Command   ${napalm-connection-PE1}    "clear bgp neighbor all"
  Sleep     100s

  ${peer_state}=     Get BGP Peer State    ${napalm-connection-PE1}    10.0.0.2
  Should Be Equal  UP  ${peer_state}
