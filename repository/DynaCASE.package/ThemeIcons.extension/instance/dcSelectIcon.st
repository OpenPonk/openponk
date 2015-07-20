*DynaCASE-Icons
dcSelectIcon
	"Private - Generated method"
	^icons 
			at: #dcSelectIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcSelectIconContents readStream) ].