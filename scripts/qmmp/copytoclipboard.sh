#!/bin/sh
qmmp --no-start  --nowplaying "%f" | sed -E "s|(.*)\[.*|\1|" | wl-copy
