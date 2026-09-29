"
Abstract base class for developer-oriented context menu commands used to open a Pharo inspector on specific internal components related to the selected shape.
"
Class {
	#name : 'OPInspectDevCommand',
	#superclass : 'OPRoassalShapeDevCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'testing' }
OPInspectDevCommand class >> isAbstract [

	^ self = OPInspectDevCommand
]

{ #category : 'accessing' }
OPInspectDevCommand >> defaultMenuIconName [

	^ #glamorousInspect
]

{ #category : 'accessing' }
OPInspectDevCommand >> defaultMenuItemName [

	| basicName |
	basicName := 'Inspect ', self itemType.
	controllers ifNil: [ ^ basicName ].
	controllers size = 1 ifTrue: [ ^ basicName ].
	^ GRInflector pluralize: basicName
]

{ #category : 'execution' }
OPInspectDevCommand >> execute [

	self items size = 1 ifTrue: [ ^ self items anyOne inspect ].
	^ self items inspect
]

{ #category : 'accessing' }
OPInspectDevCommand >> itemType [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPInspectDevCommand >> items [

	^ self subclassResponsibility
]
