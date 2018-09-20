Class {
	#name : #OPRTOrthogonalHandles,
	#superclass : #RTInteraction,
	#instVars : [
		'points',
		'edge',
		'isActive',
		'segmentHandles',
		'cornerHandles',
		'handles'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #private }
OPRTOrthogonalHandles >> addCornerHandles [
	| pointsList |
	pointsList := self router pointsList.
	handles := DoubleLinkedList new.
	handles add: (OPRTOrthoEndHandle endElement: edge from positionLink: pointsList head edge: edge).
	self router pointsList
		linksDo:
			[ :each | 
			each hasPredecessor & each hasSuccessor
				ifTrue: [ handles add: (OPRTOrthoCornerHandle positionLink: each edge: edge) ] ].
	handles add: (OPRTOrthoEndHandle endElement: edge to positionLink: pointsList tail edge: edge)
]

{ #category : #private }
OPRTOrthogonalHandles >> addHandles [
	isActive
		ifTrue: [ ^ self ].
	self ensureOrthogonal.
	self addCornerHandles.
	handles linksDo: [ :each | each renderIn: edge view ].
	edge update.
	edge signalUpdate.
	isActive := true
]

{ #category : #private }
OPRTOrthogonalHandles >> connectWithView: aView [
	(aView hasAttribute: self className)
		ifFalse: [ self setupView: aView ].
	aView canvas eventOverseer
		when: TRMouseLeftClick
		do:
			[ :event | 
			(event element = edge) not & isActive
				ifTrue: [ self removeHandles ] ]
]

{ #category : #private }
OPRTOrthogonalHandles >> ensureOrthogonal [
	| path p isOrthogonal next |
	path := (edge shape pathFor: edge) allButFirst allButLast.
	p := path first.
	isOrthogonal := true.
	p x = path second x
		ifTrue: [ next := #x ]
		ifFalse: [ next := #y ].
	path allButFirst
		do:
			[ :each | 
			(p perform: next) = (each perform: next)
				ifTrue: [ p := each ]
				ifFalse: [ isOrthogonal := false ].
			next := next = #x
				ifTrue: [ #y ]
				ifFalse: [ #x ] ].
	isOrthogonal
		ifFalse:
			[ path := edge shape pathFor: edge.
			self router
				points:
					{path first.
					(path first x @ path last y).
					path last}.
			edge update.
			edge signalUpdate ]	"self shouldBeImplemented."
]

{ #category : #initialization }
OPRTOrthogonalHandles >> initialize [
	super initialize.
	segmentHandles := OrderedCollection new.
	isActive := false
]

{ #category : #initialization }
OPRTOrthogonalHandles >> initializeElement: anEdge [
	self lazyInitializeElement: anEdge
]

{ #category : #initialization }
OPRTOrthogonalHandles >> lazyInitializeElement: anEdge [
	edge := anEdge.
	edge shape
		router:
			(OPRTOrthogonalRouter new
				points: (edge shape pathFor: edge);
				handler: self;
				yourself).
	edge when: TRMouseLeftClick do: [ self addHandles ].
	edge trachelShape addCallback: (TRRemoveCallback block: [ self removeHandles ]).
	self connectWithView: edge view.
	self addHandles.
	self removeHandles
]

{ #category : #private }
OPRTOrthogonalHandles >> removeHandles [
	isActive
		ifFalse: [ ^ self ].
	handles linksDo: #removeHandle.
	edge view signalUpdate.
	isActive := false
]

{ #category : #private }
OPRTOrthogonalHandles >> router [
	^ edge shape router
]

{ #category : #private }
OPRTOrthogonalHandles >> setupView: aView [
	aView canvas eventOverseer ifNil: [ aView canvas eventOverseer: TRAnnouncingOverseer new ].
	aView attributeAt: self className put: true
]
