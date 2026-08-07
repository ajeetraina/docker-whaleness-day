# Happy Whaleness Day

[![Publish whalesay image](https://github.com/ajeetraina/docker-whaleness-day/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/ajeetraina/docker-whaleness-day/actions/workflows/docker-publish.yml)

This is a spin on the classic [`docker/whalesay`](https://hub.docker.com/r/docker/whalesay)
demo, the whale that talks with [cowsay](https://en.wikipedia.org/wiki/Cowsay).

This version runs the very same whale, but from inside an **isolated Docker
Sandbox** created with [`sbx`](https://docs.docker.com/ai/sandboxes/) instead of a
plain `docker run`:

```console
$ ./whalesay.sh boo
 _____
< boo >
 -----
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

## Or just pull the image

The classic image is published to Docker Hub by CI on every push to `main`
(see [`.github/workflows/docker-publish.yml`](.github/workflows/docker-publish.yml)),
built for both `linux/amd64` and `linux/arm64`:

```console
$ docker run --rm ajeetraina777/whaleness-day boo
```

No message? The whale wishes you a Happy Whaleness Day by default.

## Or add it as an sbx kit (the sbx-native way)

The whale is also published to Docker Hub as an [sbx **kit**](https://docs.docker.com/ai/sandboxes/) —
an OCI artifact that drops a `whalesay` command into any sandbox. This is the
most on-brand distribution: it lands on Docker Hub *and* stays in sbx-land.

```console
$ sbx run --kit docker.io/ajeetraina777/sbx-whalesay-kits:latest shell
 _____________________
< Happy Whaleness Day >
 ---------------------
    \   ## ## ##  ...  🐳   ← greets you the moment you enter
```

The whale greets you **automatically on entry** — the kit wires a greeting into
the sandbox's `~/.bashrc` (its "entrypoint"), so you don't have to type anything.
Want to say something specific? The `whalesay` command is on `PATH`:

```console
$ whalesay "hello from a kit"
```

Attach it to an AI agent just as easily — `... sbx-whalesay-kits:latest claude`.

Unlike a kit that wraps an authenticated service (where you'd first run something
like `sbx secret set openai`), this kit needs **no secret, no network, and no
install** — `perl` already ships in the sandbox image, so the whale is fully
offline. Re-push it after changes with [`scripts/push-kit.sh`](scripts/push-kit.sh)
(needs `docker login`).

## Why sbx instead of `docker run`?

[Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) (`sbx`) create isolated,
disposable environments — originally built to run AI agents safely, but a
`shell` sandbox works great for anything you'd normally throw in a container.
Here the whale becomes a tiny excuse to try the workflow: create a sandbox,
bind-mount a workspace, run a command inside it, throw it away.

## Prerequisites

- [`sbx` installed](https://docs.docker.com/ai/sandboxes/) (`brew install sbx` or see the docs)
- Signed in to Docker: `sbx login`

Check your setup any time with `sbx diagnose`.

## Quick start

```console
$ git clone https://github.com/ajeetraina/docker-whaleness-day.git
$ cd docker-whaleness-day
$ ./whalesay.sh Happy Whaleness Day
```

The first run creates a sandbox named `whalesay`; later runs reuse it, so
they're instant.

## Usage

```console
$ ./whalesay.sh                     # the whale greets you
$ ./whalesay.sh boo
$ ./whalesay.sh Happy Whaleness Day
$ ./whalesay.sh "sbx > docker run"
$ ./whalesay.sh --clean             # stop & remove the sandbox
$ ./whalesay.sh --help
```

## How it works

`whalesay.sh` is a thin wrapper around `sbx`:

1. **Create once** — `sbx create --name whalesay shell .` spins up an Ubuntu
   sandbox with this repo bind-mounted as its workspace. `perl` already ships in
   the image, so there's nothing to install.
2. **Talk** — `sbx exec` runs the `cowsay` perl script *inside* the sandbox,
   pointing `COWPATH` at the workspace so it finds `docker.cow` (the whale).
3. **Clean up** — `./whalesay.sh --clean` runs `sbx rm --force whalesay`.

### From `docker/whalesay` to `sbx`

| Original (Docker)                          | This repo (Sandboxes)                          |
| ------------------------------------------ | ---------------------------------------------- |
| `Dockerfile` bakes cowsay + `docker.cow`   | files live in the workspace, mounted as-is     |
| `docker build -t whalesay .`               | `sbx create --name whalesay shell .`           |
| `docker run whalesay cowsay boo`           | `sbx exec whalesay perl cowsay -f docker boo`  |
| `docker rm` / `docker rmi`                 | `sbx rm --force whalesay`                       |

Want to poke around inside the sandbox yourself? Attach a shell:

```console
$ sbx run --name whalesay
```

## Files

| File          | What it is                                          |
| ------------- | --------------------------------------------------- |
| `whalesay.sh` | wrapper that drives `sbx` and makes the whale talk  |
| `cowsay`      | the original cowsay perl script                     |
| `docker.cow`  | the Docker whale ASCII art, as a cowsay cowfile     |
| `Dockerfile`  | builds the classic image published to Docker Hub    |
| `kit/`        | the sbx kit (`spec.yaml` + files) pushed to Docker Hub |
| `scripts/`    | `push-kit.sh` to (re)publish the kit                |

## Credits

- The whale and `cowsay` come from the original
  [`docker/whalesay`](https://github.com/docker/whalesay).
- `cowsay` was created by Tony Monroe.
