accessing - icons
fitContentIcon
	"Private - Generated method"
	^ self icons
		at: #fitContentIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self fitContentIconContents readStream) ]