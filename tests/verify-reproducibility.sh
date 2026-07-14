#!/bin/sh
set -eu

fail() {
  printf 'verification failed: %s\n' "$1" >&2
  exit 1
}

expect_in() {
  grep -F -- "$1" "$2" >/dev/null || fail "$2 is missing: $1"
}

from_count=$(grep -c '^FROM ' Dockerfile)
pinned_from_count=$(grep -Ec '^FROM [^ ]+@sha256:[0-9a-f]{64}( AS [[:alnum:]_.-]+)?$' Dockerfile)
[ "$from_count" -eq 2 ] || fail "expected 2 build stages"
[ "$pinned_from_count" -eq "$from_count" ] || fail "every base image must use a sha256 digest"
[ "$(grep -c 'sha256sum -c -' Dockerfile)" -eq 5 ] || fail "expected 5 fetched-artifact checksum checks"

expect_in 'alpine:3.20@sha256:d9e853e87e55526f6b2917df91a2115c36dd7c696a35be12163d44e6e2a4b6bc' Dockerfile
expect_in 'python:3.12-alpine@sha256:6d43704baacd1bfbe7c295d7f13079d5d8104ed33568873133f8fc69980419df' Dockerfile
expect_in '7dde1d271379d884bd433a1153d6f24b027180363141a300bb94cb81a287d6d1  ejs.tar.gz' Dockerfile
expect_in 'ab15fd526bd8dd18a9e77ebc139656bf4d33e97fc7238cd11bf60e2b9b8666c6  data/GAMBATTE-GPL-2.0.txt' Dockerfile
expect_in '0a0e8018dbbc8d7f8cd99f05e7cdc7b4cc9e358ecfe9377ebfb2291a84c6e310  rom.gb' Dockerfile
expect_in '/www/licenses/EMULATORJS-GPL-3.0.txt' Dockerfile
expect_in '/www/licenses/GAMBATTE-NOTICE.md' Dockerfile
expect_in '/www/licenses/GAMBATTE-GPL-2.0.txt' Dockerfile
expect_in 'COPY PROVENANCE.md /www/licenses/TOBU-ROM-PROVENANCE.md' Dockerfile
expect_in 'EJS_gameUrl = "tobudx.gb"' site/index.html
expect_in 'message.type !== "ato.session-control.v1"' site/index.html
expect_in 'emulator.pause()' site/index.html
expect_in 'ok = pausedByAto;' site/index.html
expect_in 'if (pausedByAto) emulator.play()' site/index.html
expect_in 'event.source !== window.parent' site/index.html
expect_in 'href="EMULATORJS-GPL-3.0.txt"' site/licenses/index.html
expect_in 'href="GAMBATTE-GPL-2.0.txt"' site/licenses/index.html
expect_in 'href="TOBU-ROM-PROVENANCE.md"' site/licenses/index.html
expect_in 'upload id `1739588`' PROVENANCE.md

printf 'reproducibility checks passed\n'
