as yet unclassified
fromDiagram: aDiagram toFile: aFileName
	| stream |
	stream := StandardFileStream fileNamed: aFileName.
	aDiagram elements do: [ :class | self writeClass: class to: stream ].
	stream close