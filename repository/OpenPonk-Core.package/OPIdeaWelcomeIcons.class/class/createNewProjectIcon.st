accessing - icons
createNewProjectIcon
	"Private - Generated method"
	^ self icons
		at: #createNewProjectIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self createNewProjectIconContents readStream) ]