#!/vendor/bin/sh
# Copyright (C) 2022 The LineageOS Project
# Copyright (C) 2026 Paranoid Android
# SPDX-License-Identifier: Apache-2.0

calibration_file=/mnt/vendor/persist/engineermode/tri_state_hall_data
calibration_node=/proc/tristatekey/hall_data_calib

[ -r "$calibration_file" ] && [ -w "$calibration_node" ] || exit 0
calibration_data=$(tr ';' ',' < "$calibration_file") || exit 1
[ -n "$calibration_data" ] || exit 0
printf '%s' "$calibration_data" > "$calibration_node"
