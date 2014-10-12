file support
saveFile: aFileName
	| serializedDiagram |
	serializedDiagram := diagramController serialize.
	serializedDiagram at: #version put: '0.1'.
	aFileName asFileReference writeStreamDo: [ :stream | STON put: serializedDiagram onStreamPretty: stream ]