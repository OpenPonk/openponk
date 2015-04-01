*DynaCASE-Icons
dcZoomInIcon
	"Private - Generated method"
	^icons 
			at: #dcZoomInIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcZoomInIconContents readStream) ].