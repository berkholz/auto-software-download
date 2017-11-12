#!/bin/bash 

OVERVIEWPAGE_URL="https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html"

CURL_COMMAND=/usr/bin/curl
CURL_OPTIONS=" -L -s "
DOWNLOAD_URL=""

function getUrlForRelease {
	OVERVIEWPAGE=$( $CURL_COMMAND $CURL_OPTIONS ${OVERVIEWPAGE_URL} )

	VERSION_OF_RELEASE=$( echo $OVERVIEWPAGE |tr '>' '\n' |grep -i TITLE|grep -i release|cut -f2 -d'('|cut -f1 -d')')
#grep "Download PuTTY:" |cut -f2 -d ':' |cut -f1 -d'<'|tr -d ' ' )
	echo $VERSION_OF_RELEASE

	DOWNLOAD_URL="https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-${VERSION_OF_RELEASE}-installer.msi"
	echo $DOWNLOAD_URL
}

function downloadUrl {
	$CURL_COMMAND $CURL_OPTIONS -O $DOWNLOAD_URL
}

############################
getUrlForRelease

downloadUrl
