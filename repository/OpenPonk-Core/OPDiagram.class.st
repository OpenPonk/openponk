Class {
	#name : 'OPDiagram',
	#superclass : 'OPBoundNode',
	#instVars : [
		'name',
		'documentation',
		'resolution'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'ston-core' }
OPDiagram class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #name #documentation #resolution )
]

{ #category : 'accessing' }
OPDiagram >> canvas: aCanvas [

	self isRendered ifTrue: [
		self
			assert: roassalShape canvas = aCanvas
			description:
			'Reusing same diagram element for 2 canvases not allowed'.
		^ self ].
	roassalShape := aCanvas.
	self updateRenderFromSelf
]

{ #category : 'accessing' }
OPDiagram >> documentation [

	^ documentation
]

{ #category : 'accessing' }
OPDiagram >> documentation: anObject [

	documentation := anObject
]

{ #category : 'testing' }
OPDiagram >> isPositionableByUser [

	^ false
]

{ #category : 'testing' }
OPDiagram >> isRendered [

	^ roassalShape isNotNil
]

{ #category : 'testing' }
OPDiagram >> isResizableByUser [

	^ false
]

{ #category : 'accessing' }
OPDiagram >> modelElementName [

	^ (self modelElement respondsTo: #name)
		  ifTrue: [ self modelElement name ]
		  ifFalse: [ self modelElementType ]
]

{ #category : 'accessing' }
OPDiagram >> modelElementType [

	^ self modelElement className
]

{ #category : 'accessing' }
OPDiagram >> name [

	^ name ifNil: [ self modelElement name ]
]

{ #category : 'accessing' }
OPDiagram >> name: anObject [

	name := anObject
]

{ #category : 'as yet unclassified' }
OPDiagram >> ownedElement: aShape willRenderIn: aCanvas [

	self canvas: aCanvas
]

{ #category : 'removing' }
OPDiagram >> removeRender [

	self ownedElements do: [ :each | each removeRender ].
	roassalShape ifNil: [ ^ self ].
	self attachedShapesDo: [ :each | each remove ].
	roassalShape := nil
]

{ #category : 'rendering' }
OPDiagram >> renderBasicShape [

	"diagram cannot be rendered directly now, only its owned elements"

	^ nil
]

{ #category : 'rendering' }
OPDiagram >> renderBasicShapeIn: aCanvas [

	self isRendered ifTrue: [ 
		roassalShape canvas = aCanvas ifFalse: [ 
			self error:
				'Reusing same diagram element for 2 canvases not allowed' ] ]
]

{ #category : 'rendering' }
OPDiagram >> renderShapeDetails [
	"diagram cannot be rendered directly now, only its owned elements"

	^ nil
]

{ #category : 'accessing' }
OPDiagram >> resolution [

	^ resolution
]

{ #category : 'accessing' }
OPDiagram >> resolution: anObject [

	resolution := anObject
]

{ #category : 'rendering' }
OPDiagram >> updateFromRender [

	self bounds: (OPNodeBounds
			 withPosition: 0 @ 0
			 extent: roassalShape encompassingRectangle extent).
	self ownedElements do: #updateFromRender
]
