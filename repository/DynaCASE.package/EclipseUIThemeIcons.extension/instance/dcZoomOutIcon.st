*DynaCASE-Icons
dcZoomOutIcon
	"Private - Generated method"
	^icons 
			at: #dcZoomOutIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcZoomOutIconContents readStream) ].