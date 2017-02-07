as yet unclassified
registerModelEvents: aModel
	super registerModelEvents: aModel.
	aModel className = #MooseModel | (aModel className = #OmlDiagram)
		| (aModel className = #OmlInstancesDiagram)
		ifFalse: [ aModel when: OPElementChanged do: [ :evt | self saveState ] ]