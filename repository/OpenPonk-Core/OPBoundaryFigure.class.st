Class {
	#name : #OPBoundaryFigure,
	#superclass : #OPResizableFigureWithText,
	#instVars : [
		'innerBoxToDisallowDrag',
		'outerBoxToDrag'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #accessing }
OPBoundaryFigure >> baseShape [
	^ RTBox new
		color: Color transparent;
		borderColor: Color darkGray;
		width: self defaultWidth;
		height: self defaultHeight;
		yourself
]

{ #category : #'creating - subelements' }
OPBoundaryFigure >> createOwnedElements [
	super createOwnedElements."
	outerBoxToDrag := RTBox new
		color: Color transparent;
		borderColor: Color transparent;
		elementOn: self.
	outerBoxToDrag @ RTDraggable."
	innerBoxToDisallowDrag := RTBox new
		color: Color transparent;
		borderColor: Color transparent;
		elementOn: self.
	innerBoxToDisallowDrag @ OPRTNotDraggable.
	self
		"add: outerBoxToDrag;"
		add: innerBoxToDisallowDrag.
	self updateDragBoxes.
	"outerBoxToDrag
		addCallback: (TRTranslationCallback block: [ self updateAfterDrag ])."
	self
		addCallback: (TRTranslationCallback block: [ self updateDragBoxes ]).
	self addCallback: (TRExtentCallback block: [ self updateDragBoxes ])
]

{ #category : #accessing }
OPBoundaryFigure >> defaultHeight [
	^ 400
]

{ #category : #accessing }
OPBoundaryFigure >> defaultWidth [
	^ 500
]

{ #category : #accessing }
OPBoundaryFigure >> draggableOffset [
	^ 10
]

{ #category : #hooks }
OPBoundaryFigure >> modelTextSelector [
	^ #name
]

{ #category : #'as yet unclassified' }
OPBoundaryFigure >> updateAfterDrag [
	self translateTo: outerBoxToDrag position
]

{ #category : #'as yet unclassified' }
OPBoundaryFigure >> updateDragBoxes [
	"outerBoxToDrag shape
		width: (self defaultWidth + (2 * self draggableOffset) max: 0);
		height: (self defaultHeight + (2 * self draggableOffset) max: 0).
	outerBoxToDrag update.
	outerBoxToDrag trachelShape
		doWithoutCallbacks: [ outerBoxToDrag translateTo: self position ]."

	innerBoxToDisallowDrag shape
		width: (self defaultWidth - (2 * self draggableOffset) max: 0);
		height: (self defaultHeight - (2 * self draggableOffset) max: 0).
	innerBoxToDisallowDrag update.
	innerBoxToDisallowDrag translateTo: self position.
	self view
		ifNotNil: [ innerBoxToDisallowDrag pushBack.
			self pushBack
			"outerBoxToDrag pushBack" ]
]
