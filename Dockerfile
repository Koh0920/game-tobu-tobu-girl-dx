# Tobu Tobu Girl Deluxe (GBC homebrew) as a static web capsule.
# Game: (c) Tangram Games - MIT code / CC BY 4.0 assets. The ROM hash matches
# the author's itch.io upload (game 400060, upload 1739588); build uses a fixed mirror.
# See PROVENANCE.md for the official-source comparison record.
# Player: EmulatorJS v4.2.3 (GPL-3.0) + libretro Gambatte core (GPL-2.0).
# Browser/game payloads fetched at build time are version-pinned and sha256-verified.
FROM alpine:3.20@sha256:d9e853e87e55526f6b2917df91a2115c36dd7c696a35be12163d44e6e2a4b6bc AS assets
RUN apk add --no-cache curl unzip tar
WORKDIR /w
RUN curl -fsSL -o emulator.min.zip https://cdn.emulatorjs.org/4.2.3/data/emulator.min.zip \
 && echo "8901df17c264ba8f047e3e65d9d52b2b6e0d8816393fea725718035e7549402e  emulator.min.zip" | sha256sum -c - \
 && mkdir -p data/cores/reports data/compression && unzip -q emulator.min.zip -d data/
RUN curl -fsSL -o core.tgz https://registry.npmjs.org/@emulatorjs/core-gambatte/-/core-gambatte-4.2.3.tgz \
 && echo "2edc2ed30fb18da28f67e95209a25f18307913a7eaba693d0d8481986c2fdd32  core.tgz" | sha256sum -c - \
 && tar xzf core.tgz && cp package/gambatte-*.data data/cores/ && cp package/reports/gambatte.json data/cores/reports/ \
 && cp package/README.md data/GAMBATTE-NOTICE.md
RUN curl -fsSL -o data/GAMBATTE-GPL-2.0.txt https://raw.githubusercontent.com/EmulatorJS/gambatte-libretro/c8c8bb71e0abeec34c753eab0e754e4cab61445a/COPYING \
 && echo "ab15fd526bd8dd18a9e77ebc139656bf4d33e97fc7238cd11bf60e2b9b8666c6  data/GAMBATTE-GPL-2.0.txt" | sha256sum -c -
RUN curl -fsSL -o ejs.tar.gz https://codeload.github.com/EmulatorJS/EmulatorJS/tar.gz/refs/tags/v4.2.3 \
 && echo "7dde1d271379d884bd433a1153d6f24b027180363141a300bb94cb81a287d6d1  ejs.tar.gz" | sha256sum -c - \
 && tar xzf ejs.tar.gz && cp EmulatorJS-4.2.3/data/loader.js data/ \
 && cp EmulatorJS-4.2.3/data/compression/*.js data/compression/ \
 && cp EmulatorJS-4.2.3/data/version.json data/ \
 && cp EmulatorJS-4.2.3/LICENSE data/EMULATORJS-LICENSE.txt
RUN curl -fsSL -o rom.gb "https://archive.org/download/tobudx/tobudx.gb" \
 && echo "0a0e8018dbbc8d7f8cd99f05e7cdc7b4cc9e358ecfe9377ebfb2291a84c6e310  rom.gb" | sha256sum -c -

FROM python:3.12-alpine@sha256:6d43704baacd1bfbe7c295d7f13079d5d8104ed33568873133f8fc69980419df
COPY site/ /www/
COPY --from=assets /w/data /www/data
COPY --from=assets /w/rom.gb /www/tobudx.gb
COPY --from=assets /w/data/EMULATORJS-LICENSE.txt /www/licenses/EMULATORJS-GPL-3.0.txt
COPY --from=assets /w/data/GAMBATTE-NOTICE.md /www/licenses/GAMBATTE-NOTICE.md
COPY --from=assets /w/data/GAMBATTE-GPL-2.0.txt /www/licenses/GAMBATTE-GPL-2.0.txt
COPY PROVENANCE.md /www/licenses/TOBU-ROM-PROVENANCE.md
EXPOSE 8080
CMD ["python","-m","http.server","8080","--directory","/www","--bind","0.0.0.0"]
