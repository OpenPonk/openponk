Class {
	#name : 'OPDiagramGeometrySnapshot',
	#superclass : 'Object',
	#instVars : [
		'initialBounds',
		'initialAnchors'
	],
	#category : 'OpenPonk-Core-Layouting',
	#package : 'OpenPonk-Core',
	#tag : 'Layouting'
}

{ #category : 'instance creation' }
OPDiagramGeometrySnapshot class >> onNodes: aCollectionOfNodes [
	^ self new
		captureNodes: aCollectionOfNodes;
		yourself
]

{ #category : 'capturing' }
OPDiagramGeometrySnapshot >> captureNodes: aCollectionOfNodes [
	"Capture initial bounds and anchor parameters for all bound nodes in the collection."
	initialBounds := Dictionary new.
	initialAnchors := Dictionary new.
	aCollectionOfNodes do: [ :eachShape |
		(eachShape model isKindOf: OPBoundNode) ifTrue: [
			| elementModel |
			elementModel := eachShape model.
			initialBounds at: elementModel put: (elementModel bounds ifNotNil: #copy ifNil: [
				OPNodeBounds withPosition: eachShape position extent: eachShape extent ]).
			(eachShape propertyAt: OPRSAnchorConstraint ifAbsent: [ nil ]) ifNotNil: [ :anchorConstraint |
				initialAnchors at: elementModel put: { anchorConstraint balance . anchorConstraint distanceToLine } ] ] ]
]

{ #category : 'private' }
OPDiagramGeometrySnapshot >> commandForElement: anElementModel oldBounds: oldBounds newBounds: newBounds [
	"Construct an undoable bounds command, preserving anchor parameters if applicable."
	^ (initialAnchors includesKey: anElementModel)
		ifTrue: [
			| oldAnchorState anchorConstraint |
			oldAnchorState := initialAnchors at: anElementModel.
			anchorConstraint := anElementModel roassalShape propertyAt: OPRSAnchorConstraint.
			(OPChangeAnchoredBoundsCommand
				element: anElementModel
				oldBounds: oldBounds
				newBounds: newBounds)
				oldBalance: oldAnchorState first
				newBalance: anchorConstraint balance
				oldDistanceToLine: oldAnchorState second
				newDistanceToLine: anchorConstraint distanceToLine;
				yourself ]
		ifFalse: [
			OPChangeBoundsCommand
				element: anElementModel
				oldBounds: oldBounds
				newBounds: newBounds ]
]

{ #category : 'accessing' }
OPDiagramGeometrySnapshot >> deltaCommands [
	"Answer a collection of undoable bounds change commands for all elements whose geometry changed since capture."
	| commands |
	commands := OrderedCollection new.
	initialBounds keysAndValuesDo: [ :elementModel :oldBounds |
		| roassalShape newBounds |
		roassalShape := elementModel roassalShape.
		newBounds := OPNodeBounds withPosition: roassalShape position extent: roassalShape extent.
		oldBounds ~= newBounds ifTrue: [
			commands add: (self
				commandForElement: elementModel
				oldBounds: oldBounds
				newBounds: newBounds) ] ].
	^ commands
]
