#!/bin/bash

echo "Creating diretory and symlinks.."
sudo mkdir /var/www/sch
sudo ln -s /usr/lib/cgi-bin/ /var/www/cgi-bin

echo "Copying files..."
sudo cp index.html /var/www/sch/
sudo cp style.css /var/www/sch/
sudo cp ./cgi-bin/* /usr/lib/cgi-bin/

echo "Done!"
