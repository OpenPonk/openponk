accessing - icons
dcZoomInIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcZoomInIconContents readStream)