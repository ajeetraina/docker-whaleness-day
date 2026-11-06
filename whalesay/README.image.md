# whalesay 🐳 — a Docker Sandboxes kit

The classic [`docker/whalesay`](https://hub.docker.com/r/docker/whalesay) whale
(cowsay), packaged as a [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/)
kit. This image is a [**sandbox-kit v3**](https://github.com/docker/sandbox-kit-spec/blob/main/docs/spec/SPEC-v3.md)
**mixin** — layer it onto any shell or agent sandbox and you get a `whalesay`
command plus a whale greeting on every interactive shell.

```console
$ sbx run shell --kit docker.io/ajeetraina777/sbx-whalesay-kits:latest
# then, inside the sandbox:
$ whalesay "hello from a kit"
 _________________
< hello from a kit >
 -----------------
    \
     \
      \
                    ##         .
              ## ## ##        ==
           ## ## ## ## ##    ===
       /"""""""""""""""""\___/ ===
      {                       /  ===-
       \______ O           __/
         \    \         __/
          \____\_______/
```

Or attach it to an AI agent instead of a shell:

```console
$ sbx run claude --kit docker.io/ajeetraina777/sbx-whalesay-kits:latest
```

Unlike most kits, this one needs **no secret, no network, and no install** —
`perl` already ships in the sandbox base, so the whale works fully offline.
(Contrast a service kit like `sbx-mem0-kits`, where you'd first run
`sbx secret set openai`.)

## Tags

- `latest` — the current build
- `1.0.0` — the pinned version

Both are published for `linux/amd64` and `linux/arm64`.

## What's inside

As a v3 mixin the kit ships a scratch overlay (the `whalesay` wrapper, the
cowsay script and the `docker.cow` art under `/usr/local`) plus a create-time
hook that wires the greeting into `~/.bashrc`. It declares **no** credentials,
network egress, or volumes.

Source & the full story: https://github.com/ajeetraina/docker-whaleness-day
