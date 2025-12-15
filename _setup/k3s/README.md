
Install k3s
https://docs.k3s.io/installation

Install NVIDIA GPU Operator on k3s
https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/25.3.3/getting-started.html

```bash
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update
```

install the GPU Operator with containerd settings for k3s:
```bash
helm install --wait nvidiagpu \
-n gpu-operator --create-namespace \
--set toolkit.env[0].name=CONTAINERD_CONFIG \
--set toolkit.env[0].value=/var/lib/rancher/k3s/agent/etc/containerd/config.toml \
--set toolkit.env[1].name=CONTAINERD_SOCKET \
--set toolkit.env[1].value=/run/k3s/containerd/containerd.sock \
--set toolkit.env[2].name=CONTAINERD_RUNTIME_CLASS \
--set toolkit.env[2].value=nvidia \
--set toolkit.env[3].name=CONTAINERD_SET_AS_DEFAULT \
--set-string toolkit.env[3].value=true \
nvidia/gpu-operator
```

create the persistent volume folder to easy debug:
```bash
sudo mkdir -p /mnt/data/n8n
sudo chmod -R 777 /mnt/data
```

edit coredns-custom.yaml with your k3s ipv4 address
```text
*          IN A      <your-k3s-ipv4>
```

deploy the custom coredns config to resolve k3s-ia-lab.lan domains inside cluster:
```bash
kubectl apply -f coredns-custom.yaml
```
