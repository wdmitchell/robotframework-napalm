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
  ${napalm-connection-EXTERNALROUTER}=   Napalm Connect Cisco IOS  ${EXTERNALROUTER}  ${LOGIN}  ${PASSWORD}   ${SECRET}
  Set Suite Variable  ${napalm-connection-EXTERNALROUTER}

*** Test Cases ***
T05.1 Ping VL-PE1 Router from External Router
  [Tags]  EXTERNAL  PING

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-EXTERNALROUTER}    10.0.0.1
  Should Be Equal  Successful  ${peer_ping_state}

T05.2 Ping VL-PE2 Router from External Router
  [Tags]  EXTERNAL  PING

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-EXTERNALROUTER}    10.0.0.2
  Should Be Equal  Successful  ${peer_ping_state}

T05.3 Ping Client 1 Router from External Router
  [Tags]  EXTERNAL  PING    EXTERNAL

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-EXTERNALROUTER}    1.0.0.1
  Should Be Equal  Successful  ${peer_ping_state}

T05.4 Ping Client 2 Router from External Router
  [Tags]  EXTERNAL  PING    EXTERNAL

  ${peer_ping_state}=     Ping Neighbor    ${napalm-connection-EXTERNALROUTER}    2.0.0.2
  Should Be Equal  Successful  ${peer_ping_state}

T05.5 Check External Router not receiving private-asn routes
  [Tags]  BGP   CLIENT  EXTERNAL	REMOVE_PRIVATE_AS

  ${peer_state}=     Get Route Origin ASN    ${napalm-connection-EXTERNALROUTER}    1.0.0.0/24
  Should Be True   ${peer_state}  = 7575


T05.6 Check External Router is receiving AS 2 routes
  [Tags]  BGP   CLIENT  EXTERNAL	AS2

  ${peer_state}=     Get Route Origin ASN    ${napalm-connection-EXTERNALROUTER}    2.0.0.0/24
  Should Match Regexp    ${peer_state}  ^7575 2$
