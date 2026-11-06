# Happy Whaleness Day 🐳

The classic [`docker/whalesay`](https://hub.docker.com/r/docker/whalesay) whale, packaged as a [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) kit — a [**sandbox-kit v3**](https://github.com/docker/sandbox-kit-spec/blob/main/docs/spec/SPEC-v3.md) mixin (see [`whalesay/`](whalesay/)).

```console
$ whalesay
 _____________________
< Happy Whaleness Day >
 ---------------------
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

The whale greets you the moment you enter. Say something yourself with
`whalesay "hello"`. No secret, no network, no install — it works offline.

As a **mixin** the kit has no entrypoint of its own: it layers onto a
[sandbox-kit **v3**](https://github.com/docker/sandbox-kit-spec/blob/main/docs/spec/SPEC-v3.md)
workload, the base agent's launch command stays, and you run `whalesay` from
the shell. (A mixin cannot run alone.)

## Run it locally

Compose the kit straight from source onto any local v3 workload — no registry,
no push:

```console
$ sbx run ./path/to/shell-workload --kit ./whalesay .
# then, inside the sandbox:
$ whalesay "hello from a kit"
```

## Run it in the cloud

Cloud sandboxes resolve kits from a **registry**, so the workload and the mixin
must be published OCI references, and the workload must itself be a **v3** kit —
the cloud built-in `shell`/`claude` agents are v1/v2 and will not compose with a
v3 mixin.

```console
# build + publish the kit (see scripts/push-kit.sh)
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

More detail — the descriptor, the overlay recipe, and the full build/run/verify
flow — is in [`whalesay/README.md`](whalesay/README.md).
