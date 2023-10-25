Class {
	#name : #OPRSRemoveable,
	#superclass : #RSAbstractControlCanvasInteraction,
	#category : #'OpenPonk-Roassal-Interactions'
}

{ #category : #testing }
OPRSRemoveable class >> isDeprecated [
	"does not work with UML"
	^ true
]

{ #category : #hooks }
OPRSRemoveable >> onShape: aCanvas [
	aCanvas
		when: RSKeyDown send: #processKeyDown: to: self
]

{ #category : #events }
OPRSRemoveable >> processKeyDown: evt [
	| keyName |
	keyName := evt keyName.
	keyName = #DELETE ifTrue: [ ^ self removeFrom: evt canvas ].
]

{ #category : #removing }
OPRSRemoveable >> removeFrom: aCanvas [
	(aCanvas propertyAt: OPRSSelectableCanvas) selectedShapes do: 
		[ :each | (each className asString = 'RSCanvas')
						ifFalse: [ each remove.
									  aCanvas signalUpdate.
									  self unselectDeletedForms: aCanvas ] ].
]

{ #category : #rendering }
OPRSRemoveable >> renderLegendOn: aLegendBuilder [
	aLegendBuilder 
		text: 'x' description: 'X to delete selected elements'.
]

{ #category : #'as yet unclassified' }
OPRSRemoveable >> unselectDeletedForms: aCanvas [
	aCanvas announcer subscriptions subscriptions
		do: 	[ :subs | subs subscriber class == OPErdController
			ifTrue: [ subs subscriber diagramController deselectAll ] ] .
]
