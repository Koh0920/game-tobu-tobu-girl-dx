# Tobu Tobu Girl Deluxe ROM provenance

This record documents why the build may use the fixed mirror URL without
describing that mirror as author-operated or official.

## Authoritative publication chain

- Tangram Games' [official game page](https://tangramgames.dk/tobutobugirldx/)
  identifies Tobu Tobu Girl Deluxe as a free download and links to both the
  [official itch.io page](https://tangramgames.itch.io/tobu-tobu-girl-deluxe)
  and the [author's source repository](https://github.com/SimonLarsen/tobutobugirl-dx).
- The itch.io release is game id `400060`, upload id `1739588`, filename
  `tobudx.gb`, uploaded `2019-10-28`, with displayed size `256 kB` and exact
  file size `262,144` bytes.
- On `2026-07-14`, the file was retrieved through itch.io's official web
  download flow. Its SHA-256 was
  `0a0e8018dbbc8d7f8cd99f05e7cdc7b4cc9e358ecfe9377ebfb2291a84c6e310`.
- The bytes at the build URL,
  `https://archive.org/download/tobudx/tobudx.gb`, were independently fetched
  and were byte-for-byte identical: `262,144` bytes with the same SHA-256.

## Build policy

itch.io provides a generated download URL through its web flow, not a stable
official direct URL suitable for an unattended build. The Dockerfile therefore
uses the byte-identical archive.org mirror as a transport location. The mirror
is not represented as author-operated or official. A hard-coded SHA-256 check
makes the build fail closed if those bytes ever differ from the verified
official upload.
