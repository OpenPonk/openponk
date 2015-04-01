as yet unclassified
registerModelEvents: aModel
	super registerModelEvents: aModel.
	aModel when: DCElementChanged do: [ :event | figure ifNotNil: [ self refreshFigure ] ]