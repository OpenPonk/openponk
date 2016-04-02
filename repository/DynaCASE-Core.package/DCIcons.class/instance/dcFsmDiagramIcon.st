accessing - icons
dcFsmDiagramIcon
	"Private - Generated method"
	^Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmDiagramIconContents readStream)