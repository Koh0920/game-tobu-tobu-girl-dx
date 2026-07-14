# Tobu Tobu Girl Deluxe (GBC homebrew) — Ato game capsule

A static-web "click and play" capsule for [Ato](https://ato.run): a Dockerfile
that serves EmulatorJS + the game's author-distributed ROM. Emulation runs
client-side (WebAssembly).

License: MIT code / CC BY 4.0 assets (Tangram Games). Full attributions in
`site/licenses/`.

The ROM is NOT stored here. The Dockerfile fetches it from a stable archive.org
mirror and verifies SHA-256
`0a0e8018dbbc8d7f8cd99f05e7cdc7b4cc9e358ecfe9377ebfb2291a84c6e310`.
Those bytes were independently verified to match the author's official itch.io
distribution (game id `400060`, upload id `1739588`, file `tobudx.gb`). The
official download uses a generated web-flow URL rather than a stable direct URL,
so it is provenance evidence rather than the Docker build source. See the
[full provenance record](PROVENANCE.md).

The player is pinned to EmulatorJS v4.2.3. Its distribution zip, Gambatte npm
package, and source tarball are each SHA-256 verified; the source tarball digest
is `7dde1d271379d884bd433a1153d6f24b027180363141a300bb94cb81a287d6d1`.
The capsule also ships local EmulatorJS/Gambatte license texts and the Gambatte
package notice. Both Docker base images are pinned by immutable digest.

Run `tests/verify-reproducibility.sh` for the repository's static supply-chain
checks.

Not affiliated with, endorsed by, or connected to Nintendo / id Software / Bethesda.
