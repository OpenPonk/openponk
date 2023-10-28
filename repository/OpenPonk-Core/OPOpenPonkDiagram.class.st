Class {
	#name : #OPOpenPonkDiagram,
	#superclass : #OPDiagram,
	#instVars : [
		'isOpen',
		'isSelected',
		'camera'
	],
	#category : #'OpenPonk-Core-Shapes'
}

{ #category : #'ston-core' }
OPOpenPonkDiagram class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #isOpen #isSelected #camera )
]

{ #category : #accessing }
OPOpenPonkDiagram >> camera: aCamera [

	camera := OPDiagramCamera newFrom: aCamera
]

{ #category : #accessing }
OPOpenPonkDiagram >> isOpen [

	^ isOpen ifNil: [ true ]
]

{ #category : #accessing }
OPOpenPonkDiagram >> isOpen: anObject [

	isOpen := anObject
]

{ #category : #accessing }
OPOpenPonkDiagram >> isSelected [

	^ isSelected ifNil: [ false ]
]

{ #category : #accessing }
OPOpenPonkDiagram >> isSelected: anObject [

	isSelected := anObject
]

{ #category : #'instance creation' }
OPOpenPonkDiagram >> newCopy [

	| serializer |
	self updateFromRender.
	serializer := OPStonDiagramSerializer new.
	^ (String streamContents: [ :s |
		   serializer serializeDiagram: self to: s ]) readStreamDo: [ :s |
		  serializer materializeDiagramOf: self modelElement from: s ]
]

{ #category : #removing }
OPOpenPonkDiagram >> removeRender [

	self ownedElements do: #removeRender.
	roassalShape := nil
]

{ #category : #'as yet unclassified' }
OPOpenPonkDiagram >> updateFromRender [

	super updateFromRender.
	self camera: roassalShape camera
]

{ #category : #'as yet unclassified' }
OPOpenPonkDiagram >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	super updateRenderFromSelf.
	camera ifNil: [ ^ self ].
	camera updateRoassalCamera: roassalShape camera
]
