Class {
	#name : #OPOpenPonkDiagram,
	#superclass : #OPDiagram,
	#instVars : [
		'isOpen',
		'isSelected',
		'camera'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPOpenPonkDiagram >> camera: aCamera [

	camera := OPDICamera newFrom: aCamera
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
