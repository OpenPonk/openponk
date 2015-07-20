*DynaCASE-Icons
dcFsmDiagramIcon
	"Private - Generated method"
	^icons 
			at: #dcFsmDiagramIcon
			ifAbsentPut:[ Form fromBinaryStream: (Base64MimeConverter mimeDecodeToBytes: self dcFsmDiagramIconContents readStream) ].