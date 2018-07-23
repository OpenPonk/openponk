accessing - icons
zoomOutIcon
	"Private - Generated method"
	^ self icons
		at: #zoomOutIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self zoomOutIconContents readStream) ]