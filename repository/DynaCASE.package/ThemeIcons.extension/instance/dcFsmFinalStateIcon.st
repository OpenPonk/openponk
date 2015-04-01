*DynaCASE-Icons
dcFsmFinalStateIcon
	"Private - Generated method"
	^icons 
			at: #dcFsmFinalStateIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmFinalStateIconContents readStream) ].