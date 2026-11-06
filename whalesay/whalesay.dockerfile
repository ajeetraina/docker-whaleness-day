# syntax=docker/dockerfile:1
# Overlay recipe for the whalesay mixin. Everything the whale needs is
# static, offline content, so it bakes into a `scratch` overlay rather than
# installing at create time — no network, no per-sandbox-create latency.
#
# MIGRATION NOTE: v2 shipped these files under the agent's home
# (~/.whalesay, ~/.local/bin via `files/`) and set `environment.variables.PATH`
# to prepend ~/.local/bin. In v3 a mixin's ENV *replaces* a variable on the
# composed image rather than prepending, so re-exporting PATH would drop the
# entries the base agent needs. Landing the wrapper in /usr/local/bin (already
# on every base's PATH) removes the PATH override entirely, and keeping the
# read-only data under /usr/local/share makes the whole overlay root-owned
# (0/0), which the kit-tck ownership audit expects.
FROM busybox:1.37 AS build
RUN mkdir -p /out/usr/local/bin /out/usr/local/share/whalesay/cows
COPY --chmod=0755 files/cowsay     /out/usr/local/share/whalesay/cowsay
COPY --chmod=0644 files/docker.cow /out/usr/local/share/whalesay/cows/docker.cow
# The `whalesay` wrapper and the interactive greeting — v2 `commands.initFiles`.
COPY --chmod=0755 files/whalesay   /out/usr/local/bin/whalesay
COPY --chmod=0644 files/greet.sh   /out/usr/local/share/whalesay/greet.sh

# The overlay: lands on any base.
FROM scratch
COPY --from=build /out /
# cowsay resolves `-f docker` against COWPATH; that's where the recipe put
# docker.cow. A kit-specific var — setting it clobbers nothing on the base.
ENV COWPATH=/usr/local/share/whalesay/cows
