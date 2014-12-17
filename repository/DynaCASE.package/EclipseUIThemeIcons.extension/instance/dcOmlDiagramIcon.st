*DynaCASE-Icons
dcOmlDiagramIcon
	"Private - Generated method"
	^icons 
			at: #dcOmlDiagramIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcOmlDiagramIconContents readStream) ].