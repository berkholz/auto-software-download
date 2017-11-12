#!/bin/bash 

OVERVIEWPAGE_URL="https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html"

CURL_COMMAND=/usr/bin/curl
CURL_OPTIONS=" -L -s "
SHA256_COMMAND=/usr/bin/sha256sum
DOWNLOAD_URL=""

function getUrlForRelease {
	OVERVIEWPAGE=$( $CURL_COMMAND $CURL_OPTIONS ${OVERVIEWPAGE_URL} )
	VERSION_OF_RELEASE=$( echo $OVERVIEWPAGE |tr '>' '\n' |grep -i TITLE|grep -i release|cut -f2 -d'('|cut -f1 -d')')
	DOWNLOAD_URL="https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-${VERSION_OF_RELEASE}-installer.msi"
}

function downloadUrl {
	$CURL_COMMAND $CURL_OPTIONS -O $DOWNLOAD_URL
}

function verifyDownload {
	CHECKSUM_FILE_URL="https://the.earth.li/~sgtatham/putty/latest/sha256sums"

	CHECKSUM=$($CURL_COMMAND $CURL_OPTIONS $CHECKSUM_FILE_URL |grep "putty-64bit-${VERSION_OF_RELEASE}-installer.msi"| sed -e "s#w64/##" > "putty-64bit-${VERSION_OF_RELEASE}-installer.msi.sha256")
	echo -en "Checking sha256 sum: "
	$SHA256_COMMAND -c "putty-64bit-${VERSION_OF_RELEASE}-installer.msi.sha256"
}

############################
getUrlForRelease

downloadUrl

verifyDownload
