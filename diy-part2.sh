#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Add the user's Lucky source (contains both lucky and luci-app-lucky).
set -e
if [ ! -d package/luci-app-lucky ]; then
    git clone --depth 1 https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky
fi
# Ensure the custom LuCI install hook has a destination directory.
python3 - <<'LUCKY_PATCH'
from pathlib import Path
p = Path("package/luci-app-lucky/luci-app-lucky/Makefile")
s = p.read_text()
needle = "\t$(INSTALL_BIN) ./root/usr/bin/luckyarch $(1)/usr/bin/luckyarch"
if needle in s and "$(INSTALL_DIR) $(1)/usr/bin" not in s:
    p.write_text(s.replace(needle, "\t$(INSTALL_DIR) $(1)/usr/bin\n" + needle))
LUCKY_PATCH
