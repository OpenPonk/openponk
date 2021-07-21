Class {
	#name : #OPRTMultilineLabeled,
	#superclass : #RTLabeled,
	#category : #'OpenPonk-Roassal2-Interactivity'
}

{ #category : #hooks }
OPRTMultilineLabeled >> initializeElement: element [
	| s t |
	"We first get a reference to the canvas, and then we add the shape in it"
	"We are using the variable canvas to let the user specificy the canvas (or the view) before 
	adding the element into it"
	"Make sure that if we remove the element, the trachel shape is also removed"
	"Not really nice. Maybe a different solution could be to have a double dispatch"
	t := text rtValue: element.
	t ifNil: [ ^ self ].
	s := element trachelShape.
	labelTrachel := OPTRTextCompositeShape new text: t asString.
	labelTrachel color: (color rtValue: element).
	labelTrachel fontSize: (fontSize rtValue: element model).
	labelTrachel vertical.
	canvas := canvas rtValue: element.
	canvas addShape: labelTrachel.
	self pushBackLabelIfNecessary.
	self makeLabelHighlightableIfNecessaryBy: element.
	self registerRemoveCallbackForElement: element.
	(element isKindOf: RTEdge)
		ifTrue: [ TRConstraint
				stick: labelTrachel
				between: element from trachelShape
				and: element to trachelShape
				offset: offsetOnEdge.
			^ labelTrachel ].
	self positionLabelAgainst: s.
	^ labelTrachel
]
