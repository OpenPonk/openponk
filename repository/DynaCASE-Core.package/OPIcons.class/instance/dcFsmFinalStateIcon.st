accessing - icons
dcFsmFinalStateIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmFinalStateIconContents readStream)