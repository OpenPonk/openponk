accessing - icons
importProjectIcon
	"Private - Generated method"
	^ self icons
		at: #importProjectIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self importProjectIconContents readStream) ]