accessing - icons
dcFsmRegularStateIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmRegularStateIconContents readStream)