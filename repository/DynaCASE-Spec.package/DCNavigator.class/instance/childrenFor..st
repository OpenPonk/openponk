private
childrenFor: anObject
	"todo: double dispatch?"

	| col name |
	name := anObject class asString asSymbol.
	col := OrderedCollection new.
	name = #DMMindMap
		ifTrue: [ ^ col ].
	(anObject isKindOf: DCDiagram)
		ifTrue: [ col addAll: anObject elements ].
	(anObject isKindOf: DCNamedElement)
		ifTrue: [ 
			name = #BormParticipant
				ifTrue: [ col addAll: anObject nodes ].
			name = #BormActivity | (name = #BormState)
				ifTrue: [ col addAll: anObject outgoing ].
			name = #BormActivity
				ifTrue: [ col addAll: anObject sent ].
			name = #BormCommunication
				ifTrue: [ col addAll: anObject dataFlows ].
			name = #BormCommunication
				ifTrue: [ 
					anObject hasConstraint
						ifTrue: [ col add: anObject constraint ] ].
			name = #BormTransition
				ifTrue: [ 
					anObject hasConstraint
						ifTrue: [ col add: anObject constraint ] ] ].
	^ col