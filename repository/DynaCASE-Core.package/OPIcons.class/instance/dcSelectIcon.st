accessing - icons
dcSelectIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcSelectIconContents readStream)