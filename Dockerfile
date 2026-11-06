# The classic docker/whalesay image, rebuilt on a Docker Hardened Image.
#
# The sbx workflow (see whalesay.sh / README) is the star of this repo, but
# this Dockerfile lets folks run the whale the traditional way too:
#     docker run --rm ajeetraina777/whaleness-day boo
#
# Base: the hardened, Alpine-based perl DHI instead of the plain `alpine`
# Docker Official Image. perl already ships in it (so no `apk add`), it runs
# as a nonroot user by default, and the digest pin keeps the build
# reproducible and scannable.
FROM dhi.io/perl:5.40-alpine@sha256:9050f2af224e9f4cf900118adf17ef6e69f76b581310974e248fad8295e9fb6d
# The hardened base runs as a nonroot user and keeps /usr/local/share
# unwritable by it, so escalate for the COPYs (otherwise BuildKit honors the
# nonroot USER and silently drops the write under /usr/local/share) and drop
# back to nonroot for runtime. Escalate by numeric `USER 0`, not `USER root`:
# the hardened image ships no `root` entry in /etc/passwd, so the name does
# not resolve. --chmod keeps the files world-readable/executable so the
# nonroot user can run them.
USER 0
# Pre-create the cowfile dir as uid 0: BuildKit auto-creates a COPY's missing
# parent dirs as the base's nonroot user, which cannot write /usr/local/share,
# so the write is dropped. Making the dir first means COPY lands into an
# existing, writable directory.
RUN mkdir -p /usr/local/share/cows
# cowsay + the Docker whale as the default cow.
COPY --chmod=0755 cowsay     /usr/local/bin/cowsay
COPY --chmod=0644 docker.cow /usr/local/share/cows/default.cow
USER 65532
# Invoke perl on the script explicitly: the image runs nonroot and perl is on
# PATH, so this does not depend on the script's /usr/bin/perl shebang.
ENTRYPOINT ["perl", "/usr/local/bin/cowsay"]
CMD ["Happy Whaleness Day"]
