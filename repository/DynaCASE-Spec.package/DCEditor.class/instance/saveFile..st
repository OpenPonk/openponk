file support
saveFile: aFileName
	| serializedProject |
	serializedProject := project serialize.
	StandardFileStream forceNewFileNamed: aFileName do: [ :stream | STON put: serializedProject onStreamPretty: stream ].
	project saved