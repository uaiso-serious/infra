install Ubuntu 24.04 NVIDIA drivers:

https://projectable.me/ubuntu-24-04-nvidia-drivers-ollama/

remove nvidia stuff
```bash
sudo apt-get remove --purge 'libnvidia-.*'  
sudo apt-get remove --purge '^nvidia-.*'  
sudo apt-get remove --purge '^libnvidia-.*'  
sudo apt-get remove --purge '^cuda-.*'  
sudo apt clean  
sudo apt autoremove  
```

install nvidia driver 570
```bash
sudo add-apt-repository ppa:graphics-drivers/ppa --yes  
sudo apt-get update

update-pciids

sudo apt-get install nvidia-driver-570 -y  
sudo apt-get reinstall linux-headers-$(uname -r)

sudo update-initramfs -u  
```

check dkms status, reboot
```bash
sudo dkms status  
sudo reboot  
```

check nvidia driver
```bash
sudo nvidia-smi 
```

install cuda toolkit and nvidia gds
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb  
sudo dpkg -i cuda-keyring_1.1-1_all.deb

sudo apt-get update

sudo apt-get install cuda-toolkit -y  
sudo apt-get install nvidia-gds -y  
```

check dkms status, reboot
```bash
sudo dkms status  
sudo reboot  
```

Install Docker
```bash
sudo apt-get install curl apt-transport-https ca-certificates software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg  
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update  
sudo apt-get install docker-ce -y  
```

Install Nvidia Container Toolkit
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update  
sudo apt-get install nvidia-container-toolkit -y

sudo systemctl restart docker  
```
