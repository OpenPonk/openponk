accessing - icons
dcZoomOutIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcZoomOutIconContents readStream)