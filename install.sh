#!/bin/bash

# Configure the New Relic apt repository
echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | sudo tee /etc/apt/sources.list.d/newrelic.list

# Trust the New Relic GPG key
wget -O- https://download.newrelic.com/548C16BF.gpg | sudo apt-key add -

# Update your local package index
sudo apt-get update

# Install Servers for Linux
sudo apt-get install -y newrelic-sysmond

# Configure your New Relic license key
sudo nrsysmond-config --set license_key=${NEWRELIC_LICENSE_KEY}

# Configure the New Relic hostname
if test -n "${NEWRELIC_HOSTNAME}"
then
  sudo sed -i "s|^[#]*hostname=.*|hostname=${NEWRELIC_HOSTNAME}|" /etc/newrelic/nrsysmond.cfg
else
  sudo sed -i "s|^[#]*hostname=(.*)|#hostname=|" /etc/newrelic/nrsysmond.cfg  
fi

# Configure the New Relic labels
if test -n "${NEWRELIC_LABELS}"
then
  sudo sed -i "s|^[#]*labels=.*|labels=${NEWRELIC_LABELS}|" /etc/newrelic/nrsysmond.cfg
else
  sudo sed -i "s|^[#]*labels=.*|#labels=|" /etc/newrelic/nrsysmond.cfg
fi

# Start nrsysmond
sudo systemctl restart newrelic-sysmond
