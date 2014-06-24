as yet unclassified
export: aStateMachine toFile: aFile using: aBuilder
	| stream |
	stream := StandardFileStream fileNamed: aFile.
	self export: aStateMachine toStream: stream using: aBuilder.
	stream flush.
	stream close