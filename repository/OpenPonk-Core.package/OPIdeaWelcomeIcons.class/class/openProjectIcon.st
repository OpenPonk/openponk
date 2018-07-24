accessing - icons
openProjectIcon
	"Private - Generated method"
	^ self icons
		at: #openProjectIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self openProjectIconContents readStream) ]