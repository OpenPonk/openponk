Class {
	#name : #OPRSResizable,
	#superclass : #RSTransformable,
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #private }
OPRSResizable >> saveCurrentShapeState [
	"do nothing"
]

{ #category : #private }
OPRSResizable >> updateCurrentShape: evt [

	| handle newRec rect |
	currentShape ifNil: [ ^ self ].
	handle := evt shape.
	newRec := self
		          perform: (handle model key , ':rectangle:') asSymbol
		          withArguments: { 
				          handle position.
				          currentShape encompassingRectangle }.

	rect := newRec value corner: newRec key.

	currentShape extent: rect extent.
	currentShape translateTo: rect floatCenter.

	self updateHandles: evt.
	evt signalUpdate
]
