file support
saveFile: aFileName
	| serializedProject |
	serializedProject := projectController serializeProject.
	StandardFileStream forceNewFileNamed: aFileName do: [ :stream | STON put: serializedProject onStreamPretty: stream ].
	project setClean