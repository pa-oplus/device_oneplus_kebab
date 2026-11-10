#!/usr/bin/env python3
# Copyright (C) 2026 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
from pathlib import Path
import os
import sys

os.execv(sys.executable, [
    sys.executable,
    str(Path(__file__).with_name("extract-files.py")),
    "--regenerate_makefiles",
    *sys.argv[1:],
])
