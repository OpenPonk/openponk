*DynaCASE-Icons
dcFsmRegularStateIcon
	"Private - Generated method"
	^icons 
			at: #dcFsmRegularStateIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmRegularStateIconContents readStream) ].