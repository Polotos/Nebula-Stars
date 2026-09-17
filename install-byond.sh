#!/bin/sh
set -e

# Keep these defaults in sync with .github/workflows/test.yml. Environment
# variables may still be used to test another BYOND release.
: "${BYOND_MAJOR:=515}"
: "${BYOND_MINOR:=1647}"

install_dir="$HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}"
archive="${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip"

if [ -f "$install_dir/byond/bin/DreamMaker" ];
then
  echo "Using cached directory."
else
  echo "Setting up BYOND."
  mkdir -p "$install_dir"
  cd "$install_dir"
  echo "Installing DreamMaker to $PWD"
  primary_url="https://spacestation13.github.io/byond-builds/${BYOND_MAJOR}/${archive}"
  fallback_url="https://raw.githubusercontent.com/spacestation13/byond-builds/gh-pages/public/${BYOND_MAJOR}/${archive}"
  if ! curl --fail --location --retry 3 "$primary_url" \
    -H "User-Agent: NebulaSS13/1.0 Continuous Integration" -o byond.zip;
  then
    echo "Primary BYOND mirror unavailable; trying GitHub directly."
    curl --fail --location --retry 3 "$fallback_url" \
      -H "User-Agent: NebulaSS13/1.0 Continuous Integration" -o byond.zip
  fi
  unzip -o byond.zip
  cd byond
  make here
fi

echo "BYOND ${BYOND_MAJOR}.${BYOND_MINOR} is available in $install_dir/byond."
echo "Run: source \"$install_dir/byond/bin/byondsetup\""
