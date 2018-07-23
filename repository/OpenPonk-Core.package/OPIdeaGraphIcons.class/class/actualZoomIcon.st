accessing - icons
actualZoomIcon
	"Private - Generated method"
	^ self icons
		at: #actualZoomIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self actualZoomIconContents readStream) ]