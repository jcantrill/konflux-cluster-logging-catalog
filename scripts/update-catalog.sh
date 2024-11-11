#!/bin/sh

set -eou pipefail

root="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/.."

help(){
  
  local return_code="$?"

  if [ $return_code -ne 0 ]; then

    echo Update the catalog.json using a catalog-template for an operator package on a given version of Openshift Container Platform.
    echo
    echo 'Usage: $0 <OCP_VERSION> <PACKAGE> <BUNDLE_INDEX> <TARGET_INDEX_LESS_SHA>'
    echo 
    echo   'OCP_VERSION           - OCP version in the form of "v<major>.<minor>." (e.g. v4.16)'
    echo   PACKAGE               - The package name of the operator, the annotation "operators.operatorframework.io.bundle.package.v1"
    echo   BUNDLE_INDEX          - The full pull spec of an existing bundle image
    echo   TARGET_INDEX_LESS_SHA - The pull spec minus SHA information to use to update the pull spec of the BUNDLE_INDEX

  fi

  exit ${return_code}
}
trap help exit

OCP_VERSION=$1
PACKAGE=$2
BUNDLE_INDEX=$3
TARGET_INDEX_LESS_SHA=$4
PACKAGE_PATH=${root}/${OCP_VERSION}/${PACKAGE}/configs/${PACKAGE}
CATALOG_TEMPLATE=${root}/${OCP_VERSION}/${PACKAGE}/catalog-template.json
CATALOG=${root}/${OCP_VERSION}/${PACKAGE}/configs/${PACKAGE}/catalog.json

# found in service mesh scripts.  needed?
# echo "Rendering template, migrating-level '${CATALOG_TEMPLATE}' to '${CATALOG}' ..."
# opm alpha render-template basic --output json --migrate-level bundle-object-to-csv-metadata ${CATALOG_TEMPLATE} > ${CATALOG}

echo "Rendering template '${CATALOG_TEMPLATE}' to '${CATALOG}' ..."
opm alpha render-template basic --output json "${CATALOG_TEMPLATE}" > "${CATALOG}"

echo "Replacing image registry of '${BUNDLE_INDEX}' with '${TARGET_INDEX_LESS_SHA}'"
sed -i "s#${BUNDLE_INDEX}#${TARGET_INDEX_LESS_SHA}#g" "${CATALOG}"

echo "Validating $OCP_VERSION catalog for '${PACKAGE}' ..."
opm validate "${PACKAGE_PATH}"