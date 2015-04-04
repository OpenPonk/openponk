private
childrenFor: anObject
	| col |
	col := OrderedCollection new.
	(anObject isKindOf: DCDiagram)
		ifTrue: [ col addAll: anObject elements ].
	(anObject isKindOf: DCNamedElement)
		ifTrue: [ 
			| name "todo: double dispatch?" |
			name := anObject class asString asSymbol.
			name = #BormParticipant
				ifTrue: [ col addAll: anObject nodes ].
			name = #BormActivity | (name = #BormState)
				ifTrue: [ col addAll: anObject outgoing ].
			name = #BormActivity
				ifTrue: [ col addAll: anObject sent ].
			name = #BormCommunication
				ifTrue: [ col addAll: anObject dataFlows ] ].
	^ col