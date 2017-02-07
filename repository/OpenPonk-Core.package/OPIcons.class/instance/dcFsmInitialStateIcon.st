accessing - icons
dcFsmInitialStateIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmInitialStateIconContents readStream)