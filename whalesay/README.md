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

As a mixin the kit has no entrypoint of its own — it layers onto a **v3
workload** (the base agent's launch command stays, and you run `whalesay` from
the shell). A mixin cannot run alone.

### Run locally (from source — no push needed)

```console
# compose onto any local v3 workload kit (a plain shell workload shown here)
$ sbx run ./path/to/shell-workload --kit ./whalesay .
$ whalesay "hello from a kit"
```

### Run in the cloud

Cloud sandboxes resolve kits from a **registry**, so both the workload and the
mixin must be published OCI references (a local `./whalesay` path won't do), and
the workload must itself be a **v3** kit — the cloud built-in `shell`/`claude`
agents are v1/v2 and will not compose with a v3 mixin.

```console
# build + publish the kit (see ../scripts/push-kit.sh)
$ docker buildx build ./whalesay -f ./whalesay/whalesay.yaml \
    --platform linux/amd64,linux/arm64 --push \
    -t docker.io/ajeetraina777/sbx-whalesay-kits:latest

# launch a cloud sandbox: a published v3 shell workload + the published mixin
$ sbx --cloud run --detach --name whalecloud \
    docker.io/ajeetraina777/sbx-shellbase:latest \
    --kit docker.io/ajeetraina777/sbx-whalesay-kits:latest
$ sbx --cloud exec whalecloud whalesay "hello from the cloud"
$ sbx --cloud rm -f whalecloud          # tidy up when done
```

> `sbx-shellbase` is just a minimal `kind: workload` kit on the `shell-docker`
> template, published so the mixin has a v3 base to layer onto in the cloud.

Source & the full story: https://github.com/ajeetraina/docker-whaleness-day
