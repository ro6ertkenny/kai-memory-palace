# Hardware Overview

This document describes the complete physical hardware used to build the Raspberry Pi
Kubernetes cluster, including compute, power, networking, storage, enclosure, and
assembly considerations.

The goal of this build was to create a **realistic, reproducible, headless Kubernetes
lab** that mirrors production-style infrastructure as closely as possible using
affordable hardware.

---

## Compute Nodes

### Raspberry Pi Boards

- **Raspberry Pi 4 Model B (2GB RAM)** × 4
  - CPU: Quad-core ARM Cortex-A72 (64-bit)
  - RAM: 2 GB LPDDR4
  - Networking: Gigabit Ethernet
  - USB: 2× USB 3.0, 2× USB 2.0
  - Video: Dual micro-HDMI
  - Storage: microSD (boot media)
  - Operating System: Ubuntu Server (installed separately)

**Acquisition Notes:**  
These units were sourced as new old stock in sealed packaging. Purchasing multiple
identical boards ensured hardware uniformity across the cluster while keeping costs
reasonable for a learning-focused Kubernetes environment.

**Rationale:**  
The Raspberry Pi 4 Model B provides sufficient compute capacity to support a multi-node
Kubernetes cluster while remaining intentionally resource-constrained. This encourages
efficient scheduling, realistic capacity planning, and operational discipline rather
than reliance on excess hardware.

---

## Headless Build (No Monitor or Keyboard)

This Kubernetes cluster was built and operated **entirely headless**.

At no point during provisioning or operation were the following used:
- Monitor
- Keyboard
- Mouse

All interaction with the Raspberry Pi nodes was performed remotely via:
- SSH
- Network-based provisioning
- Remote administration tools

**Rationale:**  
Headless operation mirrors real-world server and cloud environments, where physical
console access is uncommon or unavailable. Building the cluster this way enforces good
operational habits, including:
- Proper network configuration
- Reliable remote access
- Clear separation between physical hardware and logical control

This approach also improves reproducibility and scalability, as nodes can be added,
replaced, or rebuilt without requiring local peripherals.

---

## Storage (Boot Media)

- **SanDisk Ultra microSDHC UHS-I (Class 10)** × 4
  - Capacity: 32 GB per node
  - Speed class: Class 10 (UHS-I)
  - Approximate read speed: up to 48 MB/s
  - Form factor: microSD (SD adapter included)

**Rationale:**  
32 GB per node provides sufficient capacity for Ubuntu Server, Kubernetes components,
and container runtime data while keeping the build simple and easily reproducible.

**Storage Considerations:**  
microSD cards are a known reliability constraint in Raspberry Pi environments. To
mitigate this risk, the cluster emphasizes stable power delivery, controlled shutdowns,
and conservative write workloads. Storage can be replaced or upgraded in the future if
the cluster evolves toward heavier persistence requirements.

---

## Enclosure & Cooling

### Cluster Case

- **GeeekPi 4-Layer Raspberry Pi Cluster Case** × 1
  - Capacity: up to 4 Raspberry Pi boards
  - Materials: acrylic plates with aluminum standoffs
  - Cooling: 4× cooling fans
  - Heatsinks included
  - Open-frame, stackable design

**Included Components:**
- Acrylic plates
- Cooling fans
- Multiple heatsinks
- Metal protective top cover
- Mounting hardware and screwdriver

**Rationale:**  
Active cooling is critical for sustained Kubernetes workloads on Raspberry Pi hardware.
This enclosure prioritizes airflow, accessibility, and thermal stability over
aesthetics, making it suitable for continuous operation and experimentation.

---

### ⚠️ Assembly Reminder

> **Install heatsinks before mounting boards into the cluster case.**
>
> The cluster enclosure relies on direct contact between the heatsinks and active
> airflow from the cooling fans. Installing heatsinks after stacking the boards is
> significantly more difficult and may require partial disassembly.
>
> This step is easy to overlook during initial assembly and is best completed
> immediately after unboxing each Raspberry Pi.

---

## Power Delivery

### USB-C Power Adapter

- **UGREEN Nexode USB-C Charger (100W)** × 1
  - Total output: up to 100W
  - Ports: 4× USB-C
  - Technology: GaN (Gallium Nitride)
  - Input: 100–240V AC

**Rationale:**  
A single high-quality power adapter simplifies power management while providing
sufficient headroom for all cluster nodes. GaN technology offers improved efficiency
and thermal performance compared to traditional chargers.

---

### USB-C Power Cables

- **USB-C to USB-C braided cables (60W / 3A)** × 4
  - Short-length cables to reduce clutter
  - Rated for proper current delivery
  - Maximum voltage: 20V

**Rationale:**  
Short, high-quality cables reduce voltage drop and cable clutter in a compact cluster
enclosure. Using cables rated well above the Raspberry Pi’s actual power draw improves
electrical stability under load.

---

## Networking

### Ethernet Switch

- **TP-Link TL-SG105 — 5-Port Gigabit Unmanaged Switch** × 1
  - Ports: 5× 10/100/1000 Mbps RJ45
  - Auto-negotiation and Auto-MDI/MDIX
  - Fanless metal enclosure

**Rationale:**  
An unmanaged gigabit switch provides reliable, low-latency connectivity between cluster
nodes without introducing configuration complexity. This aligns with the project’s goal
of keeping infrastructure simple, transparent, and reproducible.

---

### Ethernet Cabling

- **Cat6 Ethernet Patch Cables (1 ft)** × 4
  - Category: Cat 6
  - Connector: RJ45 (male-to-male)
  - Rated throughput: up to 10 Gbps
  - Frequency: 500 MHz
  - Gauge: 26 AWG

**Rationale:**  
Short Cat6 patch cables minimize signal loss, reduce cable clutter, and improve airflow
within the cluster enclosure. Although the Raspberry Pi 4 Ethernet interface is limited
to 1 Gbps, Cat6 cabling ensures reliability and future compatibility.

---

## Power Stability Considerations

> **Voltage stability is more important than raw wattage.**

Early testing reinforced that undervoltage conditions can cause filesystem corruption,
unexplained node instability, or unexpected reboots. This cluster intentionally uses:
- Over-rated USB-C power delivery
- Short cable runs
- Active cooling

These design choices prioritize reliability and operational clarity over cost or
minimalism.

---

## Finished Assembly

The completed cluster consists of four Raspberry Pi nodes stacked in a compact,
actively cooled enclosure, powered via a centralized USB-C GaN charger and connected
through a dedicated Gigabit Ethernet switch.

A photo of the completed hardware build is included in the repository and referenced
in the README for visual context.

---

## Summary

This hardware configuration represents a balanced, intentionally constrained Kubernetes
environment designed for learning, experimentation, and operational understanding
rather than raw performance.

All components were selected to support stability, reproducibility, and long-term
maintainability.
