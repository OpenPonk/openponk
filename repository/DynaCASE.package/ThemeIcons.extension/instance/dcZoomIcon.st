*DynaCASE-Icons
dcZoomIcon
	"Private - Generated method"
	^icons 
			at: #dcZoomIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcZoomIconContents readStream) ].