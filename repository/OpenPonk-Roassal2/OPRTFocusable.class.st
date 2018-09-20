"
I highlight an element or edge when the item is clicked. Previously selected item automatically loses focus.

There is some feature overlapping with DCAcceptDenyFeedbackBuilder... should investigate.
"
Class {
	#name : #OPRTFocusable,
	#superclass : #RTAbstractHighlightable,
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #actions }
OPRTFocusable >> doHighlightClass: anElement [
	| boundingBox |
	boundingBox := self newBoundingBoxFor: anElement.
	anElement attributes at: #focusBoundingBox put: boundingBox.
	anElement view add: boundingBox
]

{ #category : #actions }
OPRTFocusable >> doHighlightEdge: anEdge [
	anEdge attributes at: #focusOriginalColor put: anEdge shape color.
	anEdge shape color: Color blue.
	anEdge update
]

{ #category : #actions }
OPRTFocusable >> doHighlightElement: anElement [
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doHighlightEdge: anElement ].

	anElement attributeAt: #focusOriginalColor put: (anElement shape borderColorFor: anElement).
	anElement shape borderColor: Color blue.
	anElement update
]

{ #category : #actions }
OPRTFocusable >> doUnhighlightClass: anElement [
	(anElement attributes includesKey: #focusBoundingBox)
		ifFalse: [ ^ self ].
	(anElement attributes at: #focusBoundingBox) remove.
	anElement attributes removeKey: #focusBoundingBox
]

{ #category : #actions }
OPRTFocusable >> doUnhighlightEdge: anEdge [
	(anEdge attributes includesKey: #focusOriginalColor)
		ifFalse: [ ^ self ].
	anEdge shape color: (anEdge attributes at: #focusOriginalColor).
	anEdge update.
	anEdge attributes removeKey: #focusOriginalColor
]

{ #category : #actions }
OPRTFocusable >> doUnhighlightElement: anElement [
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doUnhighlightEdge: anElement ].

	(anElement hasAttribute: #focusOriginalColor)
		ifFalse: [ ^ self ].

	anElement shape borderColor: (anElement attributeAt: #focusOriginalColor).
	anElement removeAttributeAt: #focusOriginalColor.
	anElement update
]

{ #category : #hooks }
OPRTFocusable >> initializeElement: element [
	element
		when: OPTRFocused
		do: [ :e | 
			self doHighlight: element.
			e signalUpdate ].
	element
		when: OPTRUnfocused
		do: [ :e | 
			self doUnhighlight: element.
			e signalUpdate ]
]

{ #category : #'instance creation' }
OPRTFocusable >> newBoundingBoxFor: anElement [
	| boundingBox |
	boundingBox := RTBox new
		color: Color transparent;
		borderColor: Color blue;
		element.
	OPRTElementsConstraint keepExtentOf: boundingBox like: anElement plus: 3 @ 3.
	TRConstraint stick: boundingBox onTheCenterOf: anElement.
	^ boundingBox
]
