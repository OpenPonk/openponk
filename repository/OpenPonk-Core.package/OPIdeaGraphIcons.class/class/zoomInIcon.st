accessing - icons
zoomInIcon
	"Private - Generated method"
	^ self icons
		at: #zoomInIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self zoomInIconContents readStream) ]