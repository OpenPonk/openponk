event handling
updateModel
	| statements text toks |
	model ifNil: [ model := self newModel ].
	text := editor text.
	text makeAllColor: Smalltalk ui theme textColor.
	statements := self parser class new parseStatements: text asString.
	statements isPetitFailure
		ifTrue: [ text asPetitStream newlines
				overlappingPairsDo: [ :start :end | 
					(statements position between: start and: end)
						ifTrue: [ text makeColor: Color red from: (1 max: start) to: end ] ] ]
		ifFalse: [ parser replaceModel: model withStatements: statements.
			self highlight: text ].
	editor text: text.
	model announcer announce: (OPModelContentReplaced model: model)