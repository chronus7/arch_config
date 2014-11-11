# -*- coding: utf-8 -*-
from i3pystatus import Status

status = Status(standalone=True)

# Time
status.register("clock",
                format="%Y-%b-%d %H:%M:%S")

# Battery
status.register("battery",
                not_present_text="AC",
                format="{status} {percentage:.1f}% {remaining}",
                status={"DIS": "↓",
                        "CHR": "↑",
                        "FULL": "="})

# Alsa
status.register("alsa",
                format="{muted}: {volume}",
                muted="M",
                unmuted="V",
                color_muted="#ffff00",
                color="#00ff00")

# Indicators
status.register("shell",
                command="~/scripts/leds.sh",
                color="#00ff00")

# Backlight
status.register("backlight",
                backlight="intel_backlight",
                format="BRI: {percentage:.1f}%")

# CPU
status.register("cpu_usage",
                format="CPU: {usage:2}%")
# status.register("cpu_usage_bar")

# Memory
status.register("mem",
                format="MEM: {percent_used_mem}%")

# Disk
status.register("disk",
                path="/",
                format="/ {used:3.0f}/{total:.0f}GiB")
status.register("disk",
                path="/home",
                format="/home {used:3.0f}/{total:.0f}GiB")

# WLAN
status.register("wireless",
                interface="wlp3s0",
                format_up="{interface}: {essid}")


status.run()
