file support
saveFile: aFileName
	| serializer serializedProject |
	serializer := DCSerializer new.
	self projectController persistLayouts.
	serializedProject := serializer serializeProject: project.
	StandardFileStream forceNewFileNamed: aFileName do: [ :stream | STON put: serializedProject onStreamPretty: stream ].
	project beClean