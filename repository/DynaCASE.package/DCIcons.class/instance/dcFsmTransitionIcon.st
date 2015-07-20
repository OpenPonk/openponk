accessing - icons
dcFsmTransitionIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmTransitionIconContents readStream)