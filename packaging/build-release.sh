#!/bin/bash
# Builds the Ngó Sen Terminal release packages in Docker, one per distribution, for this machine's
# architecture. Every build runs all tests. The packages land in dist/ under the names install.sh
# looks for, next to a SHA256SUMS covering every package there; upload all of dist/ to a release.
#
#   packaging/build-release.sh                  # every target
#   packaging/build-release.sh bookworm noble   # only these
#   packaging/build-release.sh --sums           # only rewrite dist/SHA256SUMS
#
# Builds run from the committed tree; set NGOSEN_ALLOW_DIRTY=1 to build uncommitted changes.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
dist=${NGOSEN_DIST:-$root/dist}
logs=${NGOSEN_LOGS:-$root/build-logs}

# codename image core: the release targets; Debian 12 keeps the Go core, the others use Rust.
targets="bookworm debian:12 go
trixie debian:13 rust
forky debian:testing rust
jammy ubuntu:22.04 rust
noble ubuntu:24.04 rust
resolute ubuntu:26.04 rust
stonking ubuntu:26.10 rust"

die() {
    printf 'build-release: %s\n' "$*" >&2
    exit 1
}

write_sums() {
    # Written outside dist/ first, so the checksum file never lists itself.
    local sums
    sums=$(mktemp)
    (cd "$dist" && sha256sum -- *.deb > "$sums")
    mv "$sums" "$dist/SHA256SUMS"
    chmod 644 "$dist/SHA256SUMS"
    cat "$dist/SHA256SUMS"
}

build_one() {
    local codename=$1 image=$2 core=$3 apt_opts='' dpkg_opts='' log
    if [ "$core" = rust ]; then
        apt_opts='-o APT::Build-Profiles=pkg.ngosen.rust'
        dpkg_opts='--build-profiles=pkg.ngosen.rust'
    fi
    log=$logs/$codename-$arch.log
    printf '%s (%s, %s core): building, log in %s\n' "$codename" "$image" "$core" "$log"
    rm -f "$dist"/fcitx5-ngosen_*_"${codename}_$arch".deb
    docker run --rm --platform "linux/$arch" \
        -v "$root":/src:ro -v "$dist":/out \
        -e DEBIAN_FRONTEND=noninteractive \
        -e CODENAME="$codename" -e ARCH="$arch" -e OWNER="$(id -u):$(id -g)" \
        "$image" bash -euo pipefail -c "
            apt-get update -qq
            apt-get install -y -qq --no-install-recommends dpkg-dev ca-certificates >/dev/null
            mkdir -p /build/ngosen
            tar -C /src --exclude=./dist --exclude=./build-logs -cf - . | tar -C /build/ngosen -xf -
            cd /build/ngosen
            rm -rf debian
            cp -r packaging/debian debian
            apt-get build-dep -y -qq $apt_opts ./ >/dev/null
            dpkg-buildpackage --build=binary --no-sign $dpkg_opts
            debs=(../fcitx5-ngosen_*_\"\$ARCH\".deb)
            [ \"\${#debs[@]}\" = 1 ] && [ -f \"\${debs[0]}\" ] || { echo \"expected one package: \${debs[*]}\"; exit 1; }
            name=\$(basename \"\${debs[0]}\" \"_\$ARCH.deb\")_\${CODENAME}_\$ARCH.deb
            cp \"\${debs[0]}\" \"/out/\$name\"
            chown \"\$OWNER\" \"/out/\$name\"
        " > "$log" 2>&1 || die "$codename failed; see $log"
    grep -E 'tests passed|tests failed' "$log" | tail -1
}

command -v docker >/dev/null || die "Docker is required"
case "$(uname -m)" in
    x86_64) arch=amd64 ;;
    aarch64) arch=arm64 ;;
    *) die "no release target for $(uname -m)" ;;
esac
mkdir -p "$dist" "$logs"

if [ "${1:-}" = --sums ]; then
    write_sums
    exit 0
fi

[ -f "$root/bamboo/bamboo-core/go.mod" ] || die "run: git submodule update --init --recursive"
if [ "${NGOSEN_ALLOW_DIRTY:-0}" != 1 ] && [ -n "$(git -C "$root" status --porcelain --untracked-files=no)" ]; then
    die "uncommitted changes; commit them or set NGOSEN_ALLOW_DIRTY=1"
fi

wanted=("$@")
[ ${#wanted[@]} -gt 0 ] || mapfile -t wanted < <(printf '%s\n' "$targets" | cut -d' ' -f1)
for codename in "${wanted[@]}"; do
    line=$(printf '%s\n' "$targets" | grep "^$codename " || true)
    [ -n "$line" ] || die "unknown target $codename"
    # shellcheck disable=SC2086
    build_one $line
done
write_sums
