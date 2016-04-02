accessing - icons
dcOmlDiagramIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcOmlDiagramIconContents readStream)