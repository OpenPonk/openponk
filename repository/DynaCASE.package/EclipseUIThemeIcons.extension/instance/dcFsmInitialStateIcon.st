*DynaCASE-Icons
dcFsmInitialStateIcon
	"Private - Generated method"
	^icons 
			at: #dcFsmInitialStateIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmInitialStateIconContents readStream) ].