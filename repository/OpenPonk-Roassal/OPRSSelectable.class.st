Class {
	#name : #OPRSSelectable,
	#superclass : #RSHighlightable,
	#category : #'OpenPonk-Roassal-Interactions'
}

{ #category : #accessing }
OPRSSelectable class >> highlightAdornments: aBlock [

	^ self new
		  highlightAdornments: aBlock;
		  yourself
]

{ #category : #accessing }
OPRSSelectable class >> highlightBorderColor: aColor [

	^ self new
		  highlightBorderColor: aColor;
		  yourself
]

{ #category : #accessing }
OPRSSelectable class >> highlightBorderColorBlue [

	^ self highlightBorderColor: Color blue
]

{ #category : #accessing }
OPRSSelectable class >> highlightColor: aColor [

	^ self new
		  highlightColor: aColor;
		  yourself
]

{ #category : #accessing }
OPRSSelectable class >> highlightColorBlue [

	^ self highlightColor: Color blue
]

{ #category : #announcer }
OPRSSelectable >> announceHighlight: shape source: shapeOrCanvas [

	(shape propertyAt: self class ifAbsent: [ ^ self ]) announce: [ 
		RSHighlightEvent new
			interaction: self;
			shape: shape;
			source: shapeOrCanvas ]
]

{ #category : #announcer }
OPRSSelectable >> announceUnHightlight: shape source: shapeOrCanvas [

	(shape propertyAt: self class ifAbsent: [ ^ self ]) announce: [ 
		RSUnHighlightEvent new
			interaction: self;
			shape: shape;
			source: shapeOrCanvas ]
]

{ #category : #hooks }
OPRSSelectable >> clicked: aShape by: anEvent [

	aShape canvas
		propertyAt: OPRSSelectableCanvas
		ifPresent: [ :selectableCanvasInteraction |
			| currentlySelectedShapes |
			currentlySelectedShapes := selectableCanvasInteraction
				                           selectedShapes.
			selectableCanvasInteraction
				selectShapes: (anEvent metaKeyPressed
						 ifTrue: [
							 (currentlySelectedShapes includes: aShape)
								 ifTrue: [
								 RSGroup withAll:
									 (currentlySelectedShapes copyWithout: aShape) ]
								 ifFalse: [
									 (RSGroup withAll: currentlySelectedShapes)
										 add: aShape;
										 yourself ] ]
						 ifFalse: [ RSGroup with: aShape ])
				byEvent: anEvent ]
		ifAbsent: [
			self error:
				'OPRSSelectable requires OPRSSelectableCanvas on canvas' ]
]

{ #category : #'as yet unclassified' }
OPRSSelectable >> highlightAdornments: aBlock [
	"Show adornments (little icons with actions). The block receives an OPRSAdornmentBuilder"

	| builder |
	builder := OPRSAdornmentBuilder new.
	aBlock value: builder.

	self
		when: RSHighlightEvent
		do: [ :evt | builder showOn: evt shape ]
		for: self;
		when: RSUnHighlightEvent do: [ :evt | builder hide ] for: self
]

{ #category : #'as yet unclassified' }
OPRSSelectable >> highlightBorderColor: aColor [
	"Set the border color"

	self
		when: RSHighlightEvent
		do: [ :evt | self setBorderColorOf: evt shape to: aColor ]
		for: self;
		when: RSUnHighlightEvent
		do: [ :evt | self restore: evt shape selector: #border ]
		for: self
]

{ #category : #hooks }
OPRSSelectable >> onShape: aShape [

	aShape propertyAt: self class put: self.
	aShape
		when: RSMouseLeftClick
		do: [ :evt | self clicked: aShape by: evt ]
		for: self
]

{ #category : #accessing }
OPRSSelectable >> propertyKey [

	^ propertyKey ifNil: [ propertyKey := #selectedShapes ]
]

{ #category : #'as yet unclassified' }
OPRSSelectable >> setBorderColorOf: aShape to: aColor [

	self
		record: aShape
		selector: #border
		value:
			((aShape border
				  ifNil: [ RSBorder new ]
				  ifNotNil: [ :val | val copy ])
				 color: aColor;
				 yourself)
]
