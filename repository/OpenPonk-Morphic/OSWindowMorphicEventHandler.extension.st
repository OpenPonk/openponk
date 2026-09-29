Extension { #name : 'OSWindowMorphicEventHandler' }

{ #category : '*OpenPonk-Morphic' }
OSWindowMorphicEventHandler >> dispatchMorphicEvent: anEvent [
	
	"only keep one last unprocessed mouse event"
	(anEvent isKindOf: MouseMoveEvent) ifTrue: [
			morphicWorld worldState deferredUIMessages flushAllSuchThat: [ :each |
				each size = 1 and: [ (each at: 1) isKindOf: MouseMoveEvent ] ] ].
	"original code below"

	morphicWorld defer: [
		(morphicWorld activeHand isNotNil and: [ anEvent hand isNotNil ]) ifTrue: [ morphicWorld activeHand handleEvent: anEvent ] ]
]
