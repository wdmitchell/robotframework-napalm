from napalm import get_network_driver
from robot.api.deco import keyword

@keyword('Napalm Connect Juniper')
def napalm_connect_juniper(device, login, password):
    driver = get_network_driver('junos')
    device = driver(device, login, password)
    device.open()
    return device

@keyword('Napalm Connect Cisco IOS')
def napalm_connect_cisco_ios(device, login, password, secret):
    driver = get_network_driver('ios')
    optional_args = {'secret': secret}
    device = driver(device, login, password, optional_args=optional_args)
    device.open()
    return device


@keyword('Ping Neighbor')
def ping(device, peer_ip):
    ping_results = device.ping(peer_ip, count=2)
    if "success" in ping_results:
        return "Successful"
    return ping_results


@keyword('Get BGP Received Routes')
def get_bgp_received_routes(device, peer_ip):
    bgp_peers = device.get_bgp_neighbors_detail(peer_ip)
    for context in bgp_peers:
            for asn in bgp_peers[context]:
                for peer in bgp_peers[context][asn]:
                    return peer['received_prefix_count']

    return peer['received_prefix_count']

@keyword('Get Route Origin ASN')
def get_route_origin_asn(device,route):
    route_check = device.get_route_to(destination=route)
    return route_check[route][0]['protocol_attributes']['as_path']


@keyword('Get BGP Peer State')
def get_bgp_peer_state(device, peer_ip):
    bgp_peers = device.get_bgp_neighbors_detail()
    for context in bgp_peers:
        for asn in bgp_peers[context]:
            for peer in bgp_peers[context][asn]:
                if peer['remote_address'] == peer_ip:
                    if peer['up'] == True:
                        return "UP"

    return peer

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
    return line

@keyword('Clear BGP Neighbor Juniper')
def clear_bgp_neighbor_juniper(device, peer_ip):
    command = ['clear bgp neighbor ' + peer_ip]
    return device.cli(command)

@keyword('Clear BGP Neighbor Cisco')
def clear_bgp_neighbor_cisco(device, peer_ip):
    command = ['clear ip bgp ' + peer_ip + ' all']
    return device.cli(command)

@keyword('Clear OSPF Neighbor All')
def clear_ospf_neighbor_all(device):
    command = ['clear ospf neighbor all']
    return device.cli(command)

@keyword('Get Chassis Alarms')
def get_chassis_alarms_state(device):
    command = ['show chassis alarms']
    chassis_alarms = device.cli(command)
    for values in chassis_alarms.values():
        if "No alarms currently active" in values:
            return "No Alarms"
    return chassis_alarms

@keyword('Get System Alarms')
def get_system_alarms_state(device):
    command = ['show system alarms']
    system_alarms = device.cli(command)
    for values in system_alarms.values():
        if "No alarms currently active" in values:
            return "No Alarms"
    return system_alarms
