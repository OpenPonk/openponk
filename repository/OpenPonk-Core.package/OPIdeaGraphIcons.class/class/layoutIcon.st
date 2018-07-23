accessing - icons
layoutIcon
	"Private - Generated method"
	^ self icons
		at: #layoutIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self layoutIconContents readStream) ]