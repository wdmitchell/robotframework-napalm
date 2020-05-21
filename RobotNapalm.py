from napalm import get_network_driver
from robot.api.deco import keyword

@keyword('Napalm Connect')
def napalm_coonect(device, login, password):
    driver = get_network_driver('junos')
    device = driver(device, login, password)
    device.open()
    return device

@keyword('Get BGP Peer State')
def get_bgp_peer_state(device, peer_ip):
    bgp_peers = device.get_bgp_neighbors_detail()
    for context in bgp_peers:
        for asn in bgp_peers[context]:
            for peer in bgp_peers[context][asn]:
                if peer['remote_address'] == peer_ip:
                    if peer['up'] == True:
                        return "UP"

    return 'None'

@keyword('Execute Operational Command')
def execute_op_command(device, command):
    command = ['clear bgp neighbor all']
    return device.cli(command)
