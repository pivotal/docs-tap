#!/usr/bin/bash

set -euo pipefail

yqCommand="$(command -v yq)"

function usage {
	echo "usage: $(basename $0) BACKSTAGE_VERSION"
	echo "where:"
	echo "  BACKSTAGE_VERSION: is the version of backstage you wish to use in 1.MINOR.PATCH format."
	echo "                     It should match the name of a directory in https://github.com/backstage/versions/tree/main/v1/releases"
}

function main {
	if [ "$#" -lt 1 ] || ! (echo "$1" | grep -q '1\.[0-9]\+\.[0-9]\+'); then
		usage
		exit 1
	fi

	BACKSTAGE_VERSION="$1"

	local missingDependency=0
	if ! hasYQ; then
		echo "You must have the kislyuk version of yq to run this script."
		echo "Ensure that the path this script prints \"command -v yq\": $(command -v yq) is using the correct version of yq."
		missingDependency=1
	fi

	if [ "$missingDependency" == "1" ]; then
		exit 1
	fi

	repoRoot="$(git rev-parse --show-toplevel)"
	backstageVersionDict="$(downloadBackstageVersion "$BACKSTAGE_VERSION" | transformBackstageVersionsIntoDict)"
	"$yqCommand" --explicit-start -i -y ".template_variables.tap_gui.backstage = $backstageVersionDict" "$repoRoot/template_variables.yaml"

	echo "Complete, you should check the output of \"git diff\" carefully"
}

function transformBackstageVersionsIntoDict {
	# shellcheck disable=SC2016
	"$yqCommand" '{version: .releaseVersion, packages: (reduce .packages[] as $item ({}; . + {($item.name | sub("^@"; "") | sub("\/"; "-")): $item.version}))}'
}

function downloadBackstageVersion {
	VERSION="$1"
	curl -L "https://raw.githubusercontent.com/backstage/versions/main/v1/releases/${VERSION}/manifest.json"
}

function hasYQ {
	if ! (command -v yq &>/dev/null && (! "$yqCommand" --version | grep -q mikefarah) && "$yqCommand" --help | grep -q kislyuk); then
		return 1
	fi
	return 0
}

main "$@"
