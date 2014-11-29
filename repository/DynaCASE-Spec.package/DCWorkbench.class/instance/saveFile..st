file support
saveFile: aFileName
	| serializer serializedProject |
	serializer := DCSerializer new.
	serializedProject := serializer serializeProject: project.
	StandardFileStream forceNewFileNamed: aFileName do: [ :stream | STON put: serializedProject onStreamPretty: stream ].
	project beClean