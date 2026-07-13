# Tobu Tobu Girl Deluxe (GBC homebrew) as a static web capsule.
# Game: (c) Tangram Games - MIT code / CC BY 4.0 assets; ROM distributed by the authors.
# Player: EmulatorJS v4.2.3 (GPL-3.0) + libretro Gambatte core (GPL-2.0).
# Everything fetched at build time from pinned, author/official distribution
# points and sha256-verified where the artifact is immutable.
FROM alpine:3.20 AS assets
RUN apk add --no-cache curl unzip tar
WORKDIR /w
RUN curl -fsSL -o emulator.min.zip https://cdn.emulatorjs.org/4.2.3/data/emulator.min.zip \
 && echo "8901df17c264ba8f047e3e65d9d52b2b6e0d8816393fea725718035e7549402e  emulator.min.zip" | sha256sum -c - \
 && mkdir -p data/cores/reports data/compression && unzip -q emulator.min.zip -d data/
RUN curl -fsSL -o core.tgz https://registry.npmjs.org/@emulatorjs/core-gambatte/-/core-gambatte-4.2.3.tgz \
 && echo "2edc2ed30fb18da28f67e95209a25f18307913a7eaba693d0d8481986c2fdd32  core.tgz" | sha256sum -c - \
 && tar xzf core.tgz && cp package/gambatte-*.data data/cores/ && cp package/reports/gambatte.json data/cores/reports/
RUN curl -fsSL -o ejs.tar.gz https://codeload.github.com/EmulatorJS/EmulatorJS/tar.gz/refs/tags/v4.2.3 \
 && tar xzf ejs.tar.gz && cp EmulatorJS-4.2.3/data/loader.js data/ \
 && cp EmulatorJS-4.2.3/data/compression/*.js data/compression/ \
 && cp EmulatorJS-4.2.3/data/version.json data/ \
 && cp EmulatorJS-4.2.3/LICENSE data/EMULATORJS-LICENSE.txt
RUN curl -fsSL -o rom.gb "https://archive.org/download/tobudx/tobudx.gb" \
 && echo "0a0e8018dbbc8d7f8cd99f05e7cdc7b4cc9e358ecfe9377ebfb2291a84c6e310  rom.gb" | sha256sum -c -

FROM python:3.12-alpine
COPY site/ /www/
COPY --from=assets /w/data /www/data
COPY --from=assets /w/rom.gb /www/tobudx.gb
EXPOSE 8080
CMD ["python","-m","http.server","8080","--directory","/www","--bind","0.0.0.0"]
