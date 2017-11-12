#!/bin/bash 

OVERVIEWPAGE_URL="https://winscp.net/eng/download.php"

CURL_COMMAND=/usr/bin/curl
CURL_OPTIONS=" -L -s "
SHA256_COMMAND=/usr/bin/sha256sum
DOWNLOAD_URL=""

function getUrlForRelease {
	OVERVIEWPAGE=$( $CURL_COMMAND $CURL_OPTIONS ${OVERVIEWPAGE_URL} )
	#VERSION_OF_RELEASE=$( echo $OVERVIEWPAGE |tr '<' '\n' |grep -i H3| cut -f 2 -d'>')
	VERSION_OF_RELEASE=$( echo $OVERVIEWPAGE  |tr '<' '\n'|grep -i winscp |grep -i h3| grep -v -i download|cut -f 2 -d ' ' )
	DOWNLOAD_URL="${OVERVIEWPAGE_URL}/../../download/WinSCP-$VERSION_OF_RELEASE-Setup.exe"
}

function downloadUrl {
	$CURL_COMMAND $CURL_OPTIONS -O $DOWNLOAD_URL
}

function verifyDownload {
	CHECKSUM_URL="https://winscp.net/download/WinSCP-${VERSION_OF_RELEASE}-ReadMe.txt"

	CHECKSUM=$($CURL_COMMAND $CURL_OPTIONS $CHECKSUM_URL |grep -m 1 -i sha-256 | tr -d ' '|tr -d '' |cut -f2 -d ':')
	echo "$CHECKSUM WinSCP-$VERSION_OF_RELEASE-Setup.exe" > "WinSCP-$VERSION_OF_RELEASE-Setup.exe.sha256"
	echo -en "Checking sha256 sum: "
	$SHA256_COMMAND -c "WinSCP-$VERSION_OF_RELEASE-Setup.exe.sha256"
}

############################
getUrlForRelease

downloadUrl

verifyDownload
