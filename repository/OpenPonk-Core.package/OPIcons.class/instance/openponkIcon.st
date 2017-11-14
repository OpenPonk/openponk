accessing - icons
openponkIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dynacaseIconContents readStream)