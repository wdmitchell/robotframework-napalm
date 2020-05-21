from napalm import get_network_driver
from robot.api.deco import keyword

@keyword('Napalm Connect')
def napalm_coonect(device, login, password):
    driver = get_network_driver('junos')
    device = driver(device, login, password)
    device.open()
    return device

@keyword('Ping Neighbor')
def ping(device, peer_ip):
    ping_results = device.ping(peer_ip, count=5)
    for result in ping_results:
        if "success" in result:
            return "Successful"

    return 'None'



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

@keyword('Get OSPF Neighbor State')
def get_ospf_neighbor_state(device, peer_ip):
    command = ['show ospf neighbor']
    # command will contain outputs with \n stored with in it.
    neighbors = {} # Creating a dictionary so we can split the output and reformat it.
    ospf_neighbors = device.cli(command)
    for response in ospf_neighbors.values():
        for line in response.split('\n'):
            if len(line.strip()) == 0:
                next;
            elif "Address" in line:
                next;
            else:
              (neighbor,interface,state,neighbor_id,priority,deadtimer) = line.split()
              neighbors[neighbor] = interface,state,neighbor_id,priority,deadtimer
    for values in neighbors.values():
        if peer_ip in values:
            if "Full" in values:
                return "UP"
    return 'None'

@keyword('Clear BGP Neighbor All')
def clear_bgp_neighbor_all(device):
    command = ['clear bgp neighbor all']
    return device.cli(command)

@keyword('Clear OSPF Neighbor All')
def clear_ospf_neighbor_all(device):
    command = ['clear ospf neighbor all']
    return device.cli(command)
