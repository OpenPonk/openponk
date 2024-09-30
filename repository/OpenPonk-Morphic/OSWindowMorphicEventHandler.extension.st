Extension { #name : 'OSWindowMorphicEventHandler' }

{ #category : '*OpenPonk-Morphic' }
OSWindowMorphicEventHandler >> dispatchMorphicEvent: anEvent [

	(anEvent isKindOf: MouseMoveEvent) ifTrue: [ 
		morphicWorld worldState deferredUIMessages flushAllSuchThat: [ 
			:each | 
			each size = 1 and: [ (each at: 1) isKindOf: MouseMoveEvent ] ] ].
	morphicWorld defer: [ 
		(morphicWorld activeHand isNotNil and: [ anEvent hand isNotNil ]) 
			ifTrue: [ morphicWorld activeHand handleEvent: anEvent ] ]
]
