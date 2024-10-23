Class {
	#name : 'OPNoShape',
	#superclass : 'Object',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'testing' }
OPNoShape >> doesNotExist [

	^ true
]

{ #category : 'conditions' }
OPNoShape >> ifExists: aFullBlockClosure [

	^ nil
]

{ #category : 'existence' }
OPNoShape >> ifExists: aFullBlockClosure else: aFullBlockClosure2 [

	^ aFullBlockClosure2 value
]

{ #category : 'conditions' }
OPNoShape >> ifNotExists: aFullBlockClosure [

	^ aFullBlockClosure value
]

{ #category : 'testing' }
OPNoShape >> isRendered [

	^ false
]

{ #category : 'as yet unclassified' }
OPNoShape >> modelChanged [

	"do nothing"
]

{ #category : 'accessing' }
OPNoShape >> modelElement [

	^ nil
]

{ #category : 'accessing' }
OPNoShape >> ownedElements [

	^ #(  )
]

{ #category : 'introspection' }
OPNoShape >> readSlotNamed: aName [

	<reflection: 'Object Inspection - State inspection'>
	^ nil
]

{ #category : 'removing' }
OPNoShape >> remove [
	"do nothing"

	
]

{ #category : 'accessing' }
OPNoShape >> roassalShape [

	^ nil
]

{ #category : 'as yet unclassified' }
OPNoShape >> roassalShapeUnsubscribe: aSubscriber [
	"do nothing"

	
]

{ #category : 'accessing' }
OPNoShape >> sharedStyle [

	^ nil
]

{ #category : 'accessing' }
OPNoShape >> sourceEdges [

	^ #(  )
]

{ #category : 'accessing' }
OPNoShape >> targetEdges [

	^ #(  )
]

{ #category : 'subscription' }
OPNoShape >> unsubscribe: aReceiver [
	"do nothing"

	
]

{ #category : 'introspection' }
OPNoShape >> writeSlotNamed: aName value: anObject [

	<reflection: 'Class structural modification - Slot modification'>
	^ nil
]
