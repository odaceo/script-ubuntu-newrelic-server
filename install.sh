#!/bin/bash

# Copyright Odaceo 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Init variables
LicenseKey=${1}
Hostname=${2:-''}
Labels=${3:-''}

# Check preconditions
if [ -z "${LicenseKey}" ]; then
    echo 'The License Key is required.'
    exit 1
fi

# Configure the New Relic apt repository
echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | sudo tee /etc/apt/sources.list.d/newrelic.list

# Trust the New Relic GPG key
wget -O- https://download.newrelic.com/548C16BF.gpg | sudo apt-key add -

# Update your local package index
sudo apt-get update

# Install Servers for Linux
sudo apt-get install -y newrelic-sysmond

# Configure your New Relic license key
sudo nrsysmond-config --set license_key=${LicenseKey}

# Configure the New Relic hostname
if test -n "${Hostname}"; then
  sudo sed -i "s|^[#]*hostname=.*|hostname=${Hostname}|" /etc/newrelic/nrsysmond.cfg
else
  sudo sed -i "s|^[#]*hostname=.*|#hostname=|" /etc/newrelic/nrsysmond.cfg  
fi

# Configure the New Relic labels
if test -n "${Labels}"; then
  sudo sed -i "s|^[#]*labels=.*|labels=${Labels}|" /etc/newrelic/nrsysmond.cfg
else
  sudo sed -i "s|^[#]*labels=.*|#labels=|" /etc/newrelic/nrsysmond.cfg
fi

# Start nrsysmond
sudo systemctl restart newrelic-sysmond
