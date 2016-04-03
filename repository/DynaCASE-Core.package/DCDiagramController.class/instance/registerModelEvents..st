as yet unclassified
registerModelEvents: aModel
	super registerModelEvents: aModel.
	aModel className = #MooseModel
		ifFalse: [ aModel when: DCElementChanged do: [ :evt | self saveState ] ]