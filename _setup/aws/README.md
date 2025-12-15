# It's a work in progress, not fully working

g4dn.xlarge instance costs something around USD 0.6/hour, if you leave it running or you will pay around USD 450.00/month .

---

Read this docs for installing NVIDIA GPU driver, CUDA toolkit, and optionally NVIDIA Container Toolkit on Amazon Linux 2023:

https://repost.aws/articles/ARwfQMxiC-QMOgWykD9mco1w/how-do-i-install-nvidia-gpu-driver-cuda-toolkit-and-optionally-nvidia-container-toolkit-on-amazon-linux-2023-al2023

---

aws us-west-2 request a quota increase for "Running On-Demand G and VT instances" in the AWS Service Quotas console, ask for 4 vCPU, took me about 3h to increase:

https://us-west-2.console.aws.amazon.com/servicequotas/home/services/ec2/quotas/L-DB2E81BA

Configure g4dn.xlarge with Amazon Linux 2023 AMI, launch instance, security group allowing ssh and all traffic from your IP, key pair for ssh access.

inside the instance, run the nvidia setup script and reboot:
```bash
sudo dnf install git -y
git clone https://github.com/k3s-ia-lab/infra.git
./infra/_setup/aws/nvidia-aws-al2023.sh
sudo reboot
```

find your nvme device with 120GB:
```bash
lsblk
```
```text
NAME          MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1       259:0    0     8G  0 disk
├─nvme0n1p1   259:2    0     8G  0 part /
├─nvme0n1p127 259:3    0     1M  0 part
└─nvme0n1p128 259:4    0    10M  0 part /boot/efi
nvme1n1       259:1    0 116.4G  0 disk
└─nvme1n1p1   259:6    0 116.4G  0 part
```

create filesystem on /dev/nvme1n1 an changes for docker data:
```bash
parted /dev/nvme1n1 mklabel gpt mkpart primary ext4 0% 100%
mkfs.ext4 /dev/nvme1n1p1
blkid /dev/nvme1n1p1 | awk -F'[" ]' '/UUID/ {print "UUID="$3" /mnt ext4 defaults 0 2"}' >> /etc/fstab
mount /mnt
mkdir -p /mnt/docker-data
jq '. + {"data-root": "/mnt/docker-data"}' /etc/docker/daemon.json | sudo tee /etc/docker/daemon.json > /dev/null
systemctl restart docker
```


check nvidia installation:
```bash
nvidia-smi
nvidia-container-cli -V
docker run --rm --runtime=nvidia --gpus all public.ecr.aws/amazonlinux/amazonlinux:2023 nvidia-smi
```

another check:
```bash
docker run --rm --runtime=nvidia --gpus all nvcr.io/nvidia/k8s/cuda-sample:devicequery
```

test ollama container (can't run with 8gb of volume mount, must change docker data to /mnt/docker-data)
```bash
docker run -d --name ollama --rm --runtime=nvidia --gpus all -v /mnt/data/ollama:/root/.ollama -it ollama/ollama:0.13.2
docker exec -it ollama ollama run llama3.2:3b
docker stop ollama
```

setup k3s:
```bash
sudo ./infra/_setup/aws/k3s-ia-lab-aws-al2023.sh
```
edit /etc/fstab to automount  /dev/nvme0n1p1 into /mnt after rebooting

---
# Notes

This is a working progress setup

- warning messages when installing helm nvidia/gpu-operator
- ollama crashed inside pod when trying to run llama3.2:3b, need more investigation, but can use the ollama docker directly for now
