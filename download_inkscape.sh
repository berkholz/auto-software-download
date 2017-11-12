#!/bin/bash 

OVERVIEWPAGE_URL="https://inkscape.org"

CURL_COMMAND=/usr/bin/curl
CURL_OPTIONS=" -L -s "
DOWNLOAD_URL=""

function getUrlForRelease {
	OVERVIEWPAGE=$( $CURL_COMMAND $CURL_OPTIONS ${OVERVIEWPAGE_URL}/de/ )
	#echo $OVERVIEWPAGE

	VERSION_OF_RELEASE=$( echo $OVERVIEWPAGE |tr '>' '\n' |grep "Aktuelle stabile Version" |cut -f2 -d ':' |cut -f1 -d'<'|tr -d ' ' )
	echo $VERSION_OF_RELEASE

	DOWNLOADPAGE_URL=$($CURL_COMMAND $CURL_OPTIONS "https://inkscape.org/de/release/$VERSION_OF_RELEASE/windows/64-bit/msi/dl/" )
	DOWNLOAD_URL="${OVERVIEWPAGE_URL}$( echo $DOWNLOADPAGE_URL | tr '>' '\n' | grep -i refresh |sed -e 's/.*url\=\(.*\.msi\).*/\1/' )"
	echo $DOWNLOAD_URL
}

function downloadUrl {
	$CURL_COMMAND $CURL_OPTIONS -o inkscape-$VERSION_OF_RELEASE-x64.msi $DOWNLOAD_URL
}

############################
getUrlForRelease

downloadUrl
