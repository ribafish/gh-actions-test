#!/bin/bash

function readProperty {
  PROPERTIES_FILE=$1
  PROP_KEY=$2

  PROP_VALUE=$(grep "$PROP_KEY" "$PROPERTIES_FILE"| cut -d'=' -f2)

  echo "$PROP_VALUE"
}

function writeProperty {
  PROPERTIES_FILE=$1
  PROP_KEY=$2
  PROP_REPLACE_VALUE=$3

  PROP_VALUE=$(readProperty "$PROPERTIES_FILE" "$PROP_KEY")

  sed -i'.original' "s/$PROP_KEY=$PROP_VALUE/$PROP_KEY=$PROP_REPLACE_VALUE/" "$PROPERTIES_FILE"
}

function incrementVersion {
  PROPERTIES_FILE=$1
  OLD_CODE=$(readProperty "$PROPERTIES_FILE" "version.code")
  NEW_CODE=$((OLD_CODE + 1))

  writeProperty "$PROPERTIES_FILE" "version.code" "$NEW_CODE"
}

function forceVersion {
  PROPERTIES_FILE=$1
  NEW_CODE=$2

  writeProperty "$PROPERTIES_FILE" "version.code" "$NEW_CODE"
}

FORCE_VERSION=$1
MOBILE_PROPERTIES_FILE="config/version/mobile.properties"

if [ -z "$FORCE_VERSION"]; then
  incrementVersion "$MOBILE_PROPERTIES_FILE"
else
  forceVersion "$MOBILE_PROPERTIES_FILE" "$FORCE_VERSION"
fi

rm "$MOBILE_PROPERTIES_FILE.original"
