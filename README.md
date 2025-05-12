# A/B Rootfs with SD Card-Based Recovery – Proof of Concept

This project demonstrates a **robust software update and recovery mechanism** for embedded systems using:

- **U-Boot** for boot control and environment
- **SWUpdate** for dual rootfs (A/B) updates
- **systemd** for userspace orchestration
- **systemd-networkd** for networking
- **OpenSSH** for remote access
- A **dedicated recovery mechanism** triggered by the presence of an SD card containing a recovery image

---

## 🚀 Goals

- Provide a resilient, field-updatable system with failover via A/B rootfs layout
- Enable full rootfs recovery via a specially prepared SD card, even if both internal rootfs slots are corrupted
- Validate the approach on Raspberry Pi 5 as a prototype for future systems with onboard flash storage

---

## 🧱 Architecture Overview

### 🔧 Bootloader: U-Boot

- Loads boot script from `/boot/boot.scr`
- Uses `rpipart` environment variable to select rootfs slot (partition 2 or 3)
- Detects `/recoveryMode/recovery.squashfs` on partition 4
- If found, replaces `rootfs.squashfs` on both A and B slots before continuing normal boot

### 📦 Updates: SWUpdate

- Updates are applied as `.swu` bundles using the `rawfile` and `bootloader` strategies
- Supports dual-slot layout for reliable rollbacks
- Leaves the recovery partition untouched

### 🛠 Services: systemd + networkd

- Rootfs includes `systemd-networkd` for basic IP/DHCP setup
- `sshd` is enabled for debugging or remote management
- A systemd one-shot service (`clear-recovery-flag`) runs on first boot **after recovery**, logs the event, and:
  - Clears the `recovery_success` U-Boot env flag
  - Optionally removes the `recovery.squashfs` trigger to avoid re-running recovery

---

## 💾 Partition Layout

| Partition | Purpose              | Filesystem | Mount Point  |
|-----------|----------------------|------------|--------------|
| p1        | Boot + U-Boot        | FAT32/ext4 | `/boot`      |
| p2        | Rootfs Slot A        | ext4       | `/` (active) |
| p3        | Rootfs Slot B        | ext4       | (inactive)   |
| p4        | Recovery (read-only) | ext4       | `/media`     |

---

## 🔁 Recovery Flow

1. On boot, U-Boot checks `mmc 0:4` for `recoveryMode/recovery.squashfs`
2. If present:
   - Overwrites `rootfs.squashfs` on both slot A (p2) and B (p3)
   - Sets `recovery_success=1` in U-Boot env
3. systemd service detects `recovery_success=1`, then:
   - Logs `/var/log/recovery-applied.log`
   - Drops marker `/etc/.recovery_applied`
   - Clears the env flag and optionally deletes the trigger file

---

## 🧪 How to Trigger Recovery

1. Prepare an SD card with an ext4 partition (`p4`)
2. Copy a valid squashfs rootfs image to: /recoveryMode/recovery.squashfs
3. Insert the card and reboot
4. Monitor serial output or check `/var/log/recovery-applied.log` after boot

---

## 🔐 Security Note

This is a PoC. Production implementations should:
- Authenticate or verify recovery images (e.g., hash or signature)
- Lock or secure access to `/boot.scr` and U-Boot environment

---

