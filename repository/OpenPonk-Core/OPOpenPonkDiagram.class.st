"
Concrete implementation of an OpenPonk diagram. 
Extends the structural OPDiagram by holding active session state variables, such as camera positioning, open/closed status, and current selections.
"
Class {
	#name : 'OPOpenPonkDiagram',
	#superclass : 'OPDiagram',
	#instVars : [
		'isOpen',
		'isSelected',
		'camera'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'ston-core' }
OPOpenPonkDiagram class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #isOpen #isSelected #camera )
]

{ #category : 'accessing' }
OPOpenPonkDiagram >> camera: aCamera [

	camera := OPDiagramCamera newFrom: aCamera
]

{ #category : 'accessing' }
OPOpenPonkDiagram >> isOpen [

	^ isOpen ifNil: [ true ]
]

{ #category : 'accessing' }
OPOpenPonkDiagram >> isOpen: anObject [

	isOpen := anObject
]

{ #category : 'accessing' }
OPOpenPonkDiagram >> isSelected [

	^ isSelected ifNil: [ false ]
]

{ #category : 'accessing' }
OPOpenPonkDiagram >> isSelected: anObject [

	isSelected := anObject
]

{ #category : 'instance creation' }
OPOpenPonkDiagram >> newCopy [

	| serializer |
	self isRendered ifTrue: [ self updateFromRender ].
	serializer := OPStonDiagramSerializer new.
	^ (String streamContents: [ :s |
		   serializer serializeDiagram: self to: s ]) readStreamDo: [ :s |
		  serializer materializeDiagramOf: self modelElement from: s ]
]

{ #category : 'initialization' }
OPOpenPonkDiagram >> updateFromRender [

	super updateFromRender.
	self camera: roassalShape camera
]

{ #category : 'rendering' }
OPOpenPonkDiagram >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	super updateRenderFromSelf.
	camera ifNil: [ ^ self ].
	camera updateRoassalCamera: roassalShape camera
]
