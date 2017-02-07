accessing - icons
dcOmlBoxIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcOmlBoxIconContents readStream)