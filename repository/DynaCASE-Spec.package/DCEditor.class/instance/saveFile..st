file support
saveFile: aFileName
	| serializedDiagram |
	serializedDiagram := diagramController serialize.
	serializedDiagram at: #version put: '0.1'.
	StandardFileStream forceNewFileNamed: aFileName do: [ :stream | STON put: serializedDiagram onStreamPretty: stream ]