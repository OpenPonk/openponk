"
A DCRTEdgeConstraint are utility classes that contain methods to position elements against edges
"
Class {
	#name : #OPRTEdgeAbstractConstraint,
	#superclass : #OPRTAbstractConstraint,
	#instVars : [
		'callbacks',
		'edge',
		'shape',
		'subscription',
		'offset'
	],
	#category : 'OpenPonk-Roassal2-Constraints'
}

{ #category : #accessing }
OPRTEdgeAbstractConstraint >> edge [
	^ edge
]

{ #category : #accessing }
OPRTEdgeAbstractConstraint >> edge: anEdge [ 
	edge := anEdge
]

{ #category : #running }
OPRTEdgeAbstractConstraint >> fix [
	"reverse process of move: gets settings according to shape and edge positions"

	^ self subclassResponsibility
]

{ #category : #initialization }
OPRTEdgeAbstractConstraint >> initialize [
	super initialize.
	callbacks := Bag new.
	subscription := AnnouncementSubscription new
		announcementClass: TRMouseDragEnd;
		yourself.
	offset := 0
]

{ #category : #running }
OPRTEdgeAbstractConstraint >> move [
	"moves shape according to edge positions and settings"

	^ self subclassResponsibility
]

{ #category : #accessing }
OPRTEdgeAbstractConstraint >> offset: anOffset [
	offset := anOffset
]

{ #category : #private }
OPRTEdgeAbstractConstraint >> removeCallbacksOfEdge [
	callbacks
		do: [ :each | 
			edge from trachelShape removeCallback: each ifAbsent: [ self error ].
			edge to trachelShape removeCallback: each ifAbsent: [ self error ] ].
	callbacks := Bag new
]

{ #category : #private }
OPRTEdgeAbstractConstraint >> setCallbacksOfEdge [
	self removeCallbacksOfEdge.
	callbacks ifEmpty: [ callbacks := Set with: TRTranslationCallback new with: TRExtentCallback new ].
	callbacks
		do: [ :each | 
			each block: [ self move ].
			edge from addCallback: each.
			edge to addCallback: each ]
]

{ #category : #accessing }
OPRTEdgeAbstractConstraint >> shape [
	^ shape
]

{ #category : #accessing }
OPRTEdgeAbstractConstraint >> shape: aShape [
	shape := aShape
]

{ #category : #running }
OPRTEdgeAbstractConstraint >> stick [
	"Moves shape according to edge positions and settings whenever edge is moved.
	When shape is dragged, change settings via fix method"

	self
		move;
		setCallbacksOfEdge;
		subscribeShapeDrag
]

{ #category : #private }
OPRTEdgeAbstractConstraint >> subscribeShapeDrag [
	self unSubscribeShapeDrag.
	subscription
		announcer: shape announcer;
		valuable: [ self fix ].
	shape announcer basicSubscribe: subscription
]

{ #category : #private }
OPRTEdgeAbstractConstraint >> unSubscribeShapeDrag [
	shape announcer removeSubscription: subscription
]
