# Happy Whaleness Day

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

## Credits

- The whale and `cowsay` come from the original
  [`docker/whalesay`](https://github.com/docker/whalesay).
- `cowsay` was created by Tony Monroe.
