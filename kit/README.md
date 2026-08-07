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

Source & the full story: https://github.com/ajeetraina/docker-whaleness-day
