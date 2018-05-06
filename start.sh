#Built script from these tutorials
#access point tutorial
#https://pimylifeup.com/raspberry-pi-wireless-access-point/
#nodogsplash tutorial
#https://pimylifeup.com/raspberry-pi-captive-portal/

sudo apt-get update
sudo apt-get upgrade

#Install DHCP and DNS Server
sudo apt-get -y install hostapd dnsmasq

#Stop services for configuration
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

echo "interface wlan0" | sudo tee --append /etc/dhcpcd.conf
echo 'static ip_address=192.168.220.1/24' | sudo tee --append /etc/dhcpcd.conf
echo 'static routers=192.168.220.0' | sudo tee --append /etc/dhcpcd.conf

sudo service dhcpcd restart

sudo cp hostaconfig.txt /etc/hostapd/hostapd.conf

#Replace line 10 of hostapd config to point to correct config file
sudo sed -i '10s/.*/DAEMON_CONF="/etc/hostapd/hostapd.conf"/' /etc/default/hostapd
sudo sed -i '19s/.*/DAEMON_CONF="/etc/hostapd/hostapd.conf"/' /etc/init.d/hostapd

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

#Setup dnsmasq service conf
sudo cp dnsmasq.txt /etc/dnsmasq.conf

#Setting up forwarding from wifi to ethernet
sudo sed -i '28s/.*/net.ipc4.ip_forward=1/' /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

#Setup iptables, NAT between wlan and th0
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT


#Save rules on reboot
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

#Load iptables
sudo sed -i '19s/.*/"iptables-restore < /etc/iptables.ipv4.nat"/' /etc/rc.local

#Restart services
sudo service hostapd start
sudo service dnsmasq start

git clone https://github.com/nodogsplash/nodogsplash.git ~/nodogsplash

#Install dependencies for nodogsplash to compile
sudo apt-get install libmicrohttpd-dev

cd ~/nodogsplash
make
sudo make install

#Setup nodogsplash
sudo echo "GatewayInterface wlan0" > /etc/nodogsplash/nodogsplash.conf
sudo echo "GatewayAddress 192.168.220.1" > /etc/nodogsplash/nodogsplash.conf
sudo echo "MaxClients 250" > /etc/nodogsplash/nodogsplash.conf
sudo echo "ClientIdleTimeout 480" > /etc/nodogsplash/nodogsplash.conf

#Run captive portal
sudo nodogsplash

#Reboot pi
sudo reboot
