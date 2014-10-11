file support
saveFile: aFileName
	| serializedDiagram |
	serializedDiagram := diagramController serialize.
	serializedDiagram at: #version put: '0.1'.
	FLSerializer serialize: serializedDiagram toFileNamed: aFileName