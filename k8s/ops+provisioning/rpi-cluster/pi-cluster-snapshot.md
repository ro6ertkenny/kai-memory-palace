#  Cluster Snapshot (Baseline) ☸️

This document captures a baseline snapshot of cluster health and core components.  
It is intended for quick verification, troubleshooting, and future change tracking.

**Captured:12.19.25 @ 1:36PM

---

##  Cluster Endpoints

```text
Kubernetes control plane:
https://192.168.1.116:6443

CoreDNS service proxy:
https://192.168.1.116:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

---

##  Nodes

_Output of `kubectl get nodes -o wide`_

```text
NAME          STATUS   ROLES           AGE     VERSION    INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
rpi-master    Ready    control-plane   3d      v1.31.14   192.168.1.116   <none>        Ubuntu 22.04.5 LTS   5.15.0-1092-raspi   containerd://1.7.28
rpi-worker1   Ready    <none>          2d23h   v1.31.14   192.168.1.117   <none>        Ubuntu 22.04.5 LTS   5.15.0-1092-raspi   containerd://1.7.28
rpi-worker2   Ready    <none>          3d      v1.31.14   192.168.1.115   <none>        Ubuntu 22.04.5 LTS   5.15.0-1092-raspi   containerd://1.7.28
rpi-worker3   Ready    <none>          2d22h   v1.31.14   192.168.1.118   <none>        Ubuntu 22.04.5 LTS   5.15.0-1092-raspi   containerd://1.7.28
```

---

##  System Pods

_Output of `kubectl get pods -A`_

```text
NAMESPACE     NAME                                      READY   STATUS    RESTARTS      AGE
kube-system   calico-kube-controllers-b8d8894fb-2dwvg   1/1     Running   3 (29h ago)   3d
kube-system   calico-node-6f4th                         1/1     Running   3 (29h ago)   3d
kube-system   calico-node-hjcll                         1/1     Running   1 (25h ago)   3d
kube-system   calico-node-kb9dg                         1/1     Running   1 (29h ago)   2d23h
kube-system   calico-node-pkztk                         1/1     Running   1 (25h ago)   2d22h
kube-system   coredns-7c65d6cfc9-2t5rn                  1/1     Running   3 (29h ago)   3d
kube-system   coredns-7c65d6cfc9-nj9lh                  1/1     Running   3 (29h ago)   3d
kube-system   etcd-rpi-master                           1/1     Running   3 (29h ago)   3d
kube-system   kube-apiserver-rpi-master                 1/1     Running   3 (29h ago)   3d
kube-system   kube-controller-manager-rpi-master        1/1     Running   3 (29h ago)   3d
kube-system   kube-proxy-78ks6                          1/1     Running   1 (25h ago)   2d22h
kube-system   kube-proxy-dlkwl                          1/1     Running   3 (29h ago)   3d
kube-system   kube-proxy-mlnvh                          1/1     Running   1 (25h ago)   3d
kube-system   kube-proxy-xlhg5                          1/1     Running   1 (29h ago)   2d23h
kube-system   kube-scheduler-rpi-master                 1/1     Running   3 (29h ago)   3d
```

---

##  Health Interpretation

- All nodes report **Ready**
- Control plane components are healthy:
  - `etcd`
  - `kube-apiserver`
  - `kube-controller-manager`
  - `kube-scheduler`
- Cluster networking is operational:
  - Calico CNI (`calico-node`, `calico-kube-controllers`)
- DNS is functional:
  - CoreDNS pods are running
- Pod restarts align with recent node reboots and do **not** indicate active faults

This snapshot represents a stable baseline suitable for continued experimentation,
documentation, and workload deployment.
