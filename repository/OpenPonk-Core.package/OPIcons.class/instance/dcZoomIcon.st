accessing - icons
dcZoomIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcZoomIconContents readStream)