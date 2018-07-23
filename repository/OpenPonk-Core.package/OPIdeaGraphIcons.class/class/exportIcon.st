accessing - icons
exportIcon
	"Private - Generated method"
	^ self icons
		at: #exportIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self exportIconContents readStream) ]