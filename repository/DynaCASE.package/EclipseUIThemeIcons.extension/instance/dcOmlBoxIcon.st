*DynaCASE-Icons
dcOmlBoxIcon
	"Private - Generated method"
	^icons 
			at: #dcOmlBoxIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcOmlBoxIconContents readStream) ].