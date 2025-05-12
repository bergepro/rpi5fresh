#!/bin/sh

LOG_FILE="/var/log/recovery-applied.log"
MARKER="/etc/.recovery_applied"

if fw_printenv recovery_success | grep -q '=1'; then
    echo "Recovery detected — logging and cleaning up..."

    # Log timestamped message
    echo "Recovery applied at $(date -u)" >> "$LOG_FILE"

    # Drop marker file for external tools or humans
    echo "This system was recovered via U-Boot on $(date -u)" > "$MARKER"

    # Clear recovery flag from U-Boot env
    fw_setenv recovery_success

    # Optional: Remove persistent recovery trigger files
    if [ -f /media/recoveryMode/recovery.squashfs ]; then
        rm -rf /media/recoveryMode
    fi
fi
