sudo apt-get update
sudo apt-get install docker
sudo apt-get install docker.io -y
sudo groupadd docker
sudo usermod -aG docker ${USER}
sudo systemctl restart docker
