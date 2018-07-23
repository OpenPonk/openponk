accessing - icons
propertiesIcon
	"Private - Generated method"
	^ self icons
		at: #propertiesIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self propertiesIconContents readStream) ]