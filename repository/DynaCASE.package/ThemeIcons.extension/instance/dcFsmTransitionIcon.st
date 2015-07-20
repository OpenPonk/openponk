*DynaCASE-Icons
dcFsmTransitionIcon
	"Private - Generated method"
	^icons 
			at: #dcFsmTransitionIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmTransitionIconContents readStream) ].