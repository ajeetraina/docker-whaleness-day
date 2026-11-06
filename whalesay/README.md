# whalesay 🐳 — an sbx kit

The Docker whale, packaged as a [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/)
**kit**. Add it to any sandbox and you get a `whalesay` command that makes the
whale talk.

```console
$ sbx run --kit docker.io/ajeetraina777/sbx-whalesay-kits:latest shell
# then, inside the sandbox:
$ whalesay "hello from a kit"
```

Or attach it to an AI agent instead of a shell:

```console
$ sbx run --kit docker.io/ajeetraina777/sbx-whalesay-kits:latest claude
```

Unlike most kits, this one needs **no secret, no network, and no install** —
`perl` already ships in the sandbox image, so the whale works fully offline.
(Contrast a service kit like `sbx-mem0-kits`, where you'd first run
`sbx secret set openai`.)

## Build from source

This is a [sandbox-kit **v3**](https://github.com/docker/sandbox-kit-spec/blob/main/docs/spec/SPEC-v3.md)
mixin — a single OCI image built with `docker buildx`. The descriptor lives in
[`whalesay.yaml`](whalesay.yaml), the overlay recipe in
[`whalesay.dockerfile`](whalesay.dockerfile).

```console
# run it straight from source, composed onto the shell workload — no push needed
$ sbx run ./shell --kit ./whalesay .

# or build + publish the OCI kit image (see ../scripts/push-kit.sh)
$ docker buildx build ./whalesay -f ./whalesay/whalesay.yaml \
    -t docker.io/ajeetraina777/sbx-whalesay-kits:latest --push
```

As a mixin the kit has no entrypoint of its own: the base workload's launch
command stays, and you run `whalesay` from the shell.

Source & the full story: https://github.com/ajeetraina/docker-whaleness-day
