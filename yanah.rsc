# apr/02/2019 00:13:15 by RouterOS 6.43.13
# software id = 
#
#
#
/interface list
add name=WAN
add name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip dhcp-server
add disabled=no interface=ether1 name=server1
/interface list member
add interface=ether1 list=WAN
add list=LAN
/ip address
add address=10.3.0.254/24 interface=ether2 network=10.3.0.0
add address=10.5.0.254/24 interface=ether1 network=10.5.0.0
add address=10.1.0.254/24 interface=ether3 network=10.1.0.0
add address=10.5.0.19/24 interface=ether1 network=10.5.0.0
/ip dhcp-client
add dhcp-options=hostname,clientid disabled=no interface=ether4
add dhcp-options=hostname,clientid disabled=no interface=ether1
/ip firewall address-list
add address=10.1.0.254 list=Green
add address=10.3.0.254 list=orange
add address=10.5.0.254 list=red
/ip firewall filter
add action=drop chain=input comment="input chain invalid drop" \
    connection-state=invalid
add action=accept chain=input comment="input chain established accept" \
    connection-state=established
add action=accept chain=input comment="input chain protocol icmp accept" \
    protocol=icmp
add action=accept chain=input comment="input chain src-address 10.1.0.0/24" \
    src-address=10.1.0.0/24
add action=drop chain=input comment="input Default Policy Drop"
add action=drop chain=forward comment=\
    "RULE NUMBER 0// drop invalid connections" connection-state=invalid \
    dst-port="" protocol=tcp
add action=accept chain=forward comment=\
    "RULE NUMER 1// permit www Green --> Orange" dst-address=10.3.0.254 \
    dst-address-list=orange dst-port=80 protocol=tcp src-address=10.1.0.254 \
    src-address-list=Green
add action=accept chain=forward comment=\
    "RULE NUMBER 2// permit ssh Green --> Orange" dst-address=10.3.0.254 \
    dst-address-list=orange dst-port=22 protocol=tcp src-address=10.1.0.254 \
    src-address-list=Green
add action=accept chain=forward dst-address=10.3.0.254 dst-address-list=\
    orange protocol=tcp src-address=10.1.0.254 src-address-list=Green \
    src-port=22
add action=accept chain=forward comment=\
    "RULE NUMBER 3// permit ftp Green --> Orange" dst-address=10.3.0.254 \
    dst-address-list=orange dst-port=21 protocol=tcp src-address=10.1.0.254 \
    src-address-list=Green
add action=accept chain=forward comment=\
    "RULE NUMBER 4// permit www Green --> Red" dst-address=10.5.0.254 \
    dst-address-list=red dst-port=80 protocol=tcp src-address=10.1.0.254 \
    src-address-list=Green
add action=accept chain=forward comment=\
    "RULE NUMBER 5// permit ssh Green --> Red" dst-address=10.5.0.254 \
    dst-address-list=red dst-port=22 protocol=tcp src-address=10.1.0.254 \
    src-address-list=Green
add action=accept chain=forward dst-address=10.5.0.254 dst-address-list=red \
    protocol=tcp src-address=10.1.0.254 src-address-list=Green src-port=22
add action=accept chain=forward comment=\
    "RULE NUMBER 6// permit www Red --> Orange" dst-address=10.3.0.254 \
    dst-address-list=orange dst-port=80 protocol=tcp src-address=10.5.0.254 \
    src-address-list=red
add action=accept chain=forward comment=\
    "RULE NUMBER 7// permit ftp Red --> Orange" dst-address=10.3.0.254 \
    dst-address-list=orange dst-port=21 protocol=tcp src-address=10.5.0.254 \
    src-address-list=red
add action=accept chain=forward comment=\
    "RULE NUMBER 8// permit ssh Red --> Orange, note: tcp 2222" dst-address=\
    10.3.0.254 dst-address-list=orange dst-port=2222 protocol=tcp \
    src-address=10.5.0.254 src-address-list=red
add action=accept chain=forward dst-address=10.3.0.254 dst-address-list=\
    orange protocol=tcp src-address=10.5.0.254 src-address-list=red src-port=\
    2222
add action=accept chain=forward comment="RULE NUMBER 9// permit chatsession Re\
    d --> Green,  note: udp 9999 met netcat tool" dst-address=10.1.0.254 \
    dst-address-list=Green dst-port=9999 protocol=udp src-address=10.5.0.254 \
    src-address-list=red
add action=accept chain=forward dst-address=10.1.0.254 dst-address-list=Green \
    protocol=udp src-address=10.5.0.254 src-address-list=red src-port=9999
add action=drop chain=forward comment=\
    "RULE NUMBER FDP// Forward chain, Default policy Drop"
/ip firewall nat
add action=src-nat chain=scrnat dst-address=10.5.0.19 out-interface=ether1 \
    src-address=10.1.0.0/24 to-addresses=10.5.0.19
add action=src-nat chain=scrnat dst-address=10.5.0.19 out-interface=ether1 \
    src-address=10.3.0.0/24 to-addresses=10.5.0.19
add action=src-nat chain=scrnat dst-address=10.5.0.19 out-interface=ether1 \
    src-address=10.3.0.0/24 to-addresses=10.3.0.0/24
add action=dst-nat chain=dstnat dst-address=10.5.0.19 in-interface=ether1 \
    src-address=10.1.0.0/24 to-addresses=10.1.0.0/24
add action=dst-nat chain=dstnat dst-address=10.5.0.19 in-interface=ether1 \
    src-address=10.3.0.0/24 to-addresses=10.3.0.0/24
/ip route
add distance=1 gateway=10.5.0.1
add distance=1 dst-address=10.1.0.254/32 gateway=10.1.0.1
add distance=1 dst-address=10.3.0.254/32 gateway=10.3.0.1
add distance=1 dst-address=10.5.0.19/32 gateway=10.3.0.1
add distance=1 dst-address=10.5.0.19/32 gateway=10.1.0.1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system identity
set name=yanah-guard
