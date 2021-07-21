Class {
	#name : #OPRTEdgeBuilder,
	#superclass : #RTObject,
	#instVars : [
		'shape',
		'labels',
		'constraints'
	],
	#category : #'OpenPonk-Roassal2-Builders'
}

{ #category : #testing }
OPRTEdgeBuilder class >> isDeprecated [
	^ true
]

{ #category : #labels }
OPRTEdgeBuilder >> addLabel: aSymbol [
	self addLabel: aSymbol text: ''
]

{ #category : #labels }
OPRTEdgeBuilder >> addLabel: aSymbol text: aString [
	labels at: aSymbol put: (self newLabel: aString)
]

{ #category : #private }
OPRTEdgeBuilder >> addLabelsTo: anEdge [
	labels
		keysAndValuesDo: [ :name :label | 
			label model: anEdge.
			anEdge trachelShape
				addCallback:
					(TRRemoveCallback new
						block: [ :removedShape | 
							anEdge labels removeKey: name.
							label remove ]).
			anEdge labels at: name put: label.
			anEdge view add: label ]
]

{ #category : #private }
OPRTEdgeBuilder >> applyConstraintsTo: anEdge [
	constraints do: [ :constraint | constraint cull: anEdge ]
]

{ #category : #heads }
OPRTEdgeBuilder >> arrowHead [
	shape arrowHead
]

{ #category : #heads }
OPRTEdgeBuilder >> arrowTail [
	shape arrowTail
]

{ #category : #'attach point' }
OPRTEdgeBuilder >> attachPoint: anAttachPoint [
	shape attachPoint: anAttachPoint
]

{ #category : #'attach point' }
OPRTEdgeBuilder >> borderAttachPoint [
	shape withBorderAttachPoint
]

{ #category : #public }
OPRTEdgeBuilder >> color: aColor [
	shape color: aColor
]

{ #category : #labels }
OPRTEdgeBuilder >> constraintLabel: labelName balance: aFloat offset: aNumber [
	| label |
	label := self labelNamed: labelName.
	constraints
		add: [ :edge | 
			OPRTEdgeAlongConstraint
				stick: label
				alongEdge: edge
				balance: aFloat
				offset: aNumber.
			OPRTElementsConstraint
				whenDragging: label
				drawLineToPoint: [ ((edge shape startingPointOf: edge) + (edge shape endingPointOf: edge)) / 2 ] ]
]

{ #category : #labels }
OPRTEdgeBuilder >> constraintLabel: labelName below: originLabelName [
	| label originLabel |
	label := self labelNamed: labelName.
	originLabel := self labelNamed: originLabelName.
	constraints add: [ TRConstraint stick: label below: originLabel ]
]

{ #category : #labels }
OPRTEdgeBuilder >> constraintLabel: labelName onTheRightOf: originLabelName [
	| label originLabel |
	label := self labelNamed: labelName.
	originLabel := self labelNamed: originLabelName.
	constraints add: [ TRConstraint stick: label onTheRightOf: originLabel ]
]

{ #category : #labels }
OPRTEdgeBuilder >> constraintLabel: labelName toSourceDistance: aNumber offset: anotherNumber [
	| label |
	label := self labelNamed: labelName.
	constraints
		add: [ :edge | 
			OPRTEdgeEndConstraint
				stick: label
				nearStartOfEdge: edge
				distance: aNumber
				offset: anotherNumber.
			OPRTElementsConstraint
				whenDragging: label
				drawLineToPoint: [ (edge shape startingPointOf: edge) * 0.9 + ((edge shape endingPointOf: edge) * 0.1) ] ]
]

{ #category : #labels }
OPRTEdgeBuilder >> constraintLabel: labelName toTargetDistance: aNumber offset: anotherNumber [
	| label |
	label := self labelNamed: labelName.
	constraints
		add: [ :edge | 
			OPRTEdgeEndConstraint
				stick: label
				nearEndOfEdge: edge
				distance: aNumber
				offset: anotherNumber.
			OPRTElementsConstraint
				whenDragging: label
				drawLineToPoint: [ (edge shape endingPointOf: edge) * 0.9 + ((edge shape startingPointOf: edge) * 0.1) ] ]
]

{ #category : #public }
OPRTEdgeBuilder >> createEdgeFrom: fromElement to: toElement [
	"creates edge without labels"

	^ shape edgeFrom: fromElement to: toElement
]

{ #category : #public }
OPRTEdgeBuilder >> createFigureFrom: fromElement to: toElement view: aView [
	| edge |
	edge := self createEdgeFrom: fromElement to: toElement.
	edge @ OPRTFocusable.
	aView add: edge.
	self
		addLabelsTo: edge;
		applyConstraintsTo: edge.
	^ edge
]

{ #category : #'line styles' }
OPRTEdgeBuilder >> dashDotLine [
	shape dashDotLine
]

{ #category : #'line styles' }
OPRTEdgeBuilder >> dashedLine [
	shape dashedLine
]

{ #category : #public }
OPRTEdgeBuilder >> defaultColor [
	^ shape color: Color black
]

{ #category : #'line styles' }
OPRTEdgeBuilder >> dottedLine [
	shape dottedLine
]

{ #category : #heads }
OPRTEdgeBuilder >> emptyArrowHead [
	shape emptyArrowHead
]

{ #category : #heads }
OPRTEdgeBuilder >> emptyArrowTail [
	shape emptyArrowTail
]

{ #category : #heads }
OPRTEdgeBuilder >> emptyCircleHead [
	shape emptyCircleHead
]

{ #category : #heads }
OPRTEdgeBuilder >> emptyCircleTail [
	shape emptyCircleTail
]

{ #category : #heads }
OPRTEdgeBuilder >> emptyDiamondHead [
	shape emptyDiamondHead
]

{ #category : #heads }
OPRTEdgeBuilder >> emptyDiamondTail [
	shape emptyDiamondTail
]

{ #category : #heads }
OPRTEdgeBuilder >> emptyNarrowArrowHead [
	shape emptyNarrowArrowHead
]

{ #category : #heads }
OPRTEdgeBuilder >> emptyNarrowArrowTail [
	shape emptyNarrowArrowTail
]

{ #category : #heads }
OPRTEdgeBuilder >> filledArrowHead [
	shape filledArrowHead
]

{ #category : #heads }
OPRTEdgeBuilder >> filledArrowTail [
	shape filledArrowTail
]

{ #category : #heads }
OPRTEdgeBuilder >> filledCircleHead [
	shape filledCircleHead
]

{ #category : #heads }
OPRTEdgeBuilder >> filledCircleTail [
	shape filledCircleTail
]

{ #category : #heads }
OPRTEdgeBuilder >> filledDiamondHead [
	shape filledDiamondHead
]

{ #category : #heads }
OPRTEdgeBuilder >> filledDiamondTail [
	shape filledDiamondTail
]

{ #category : #heads }
OPRTEdgeBuilder >> filledNarrowArrowHead [
	shape filledNarrowArrowHead
]

{ #category : #heads }
OPRTEdgeBuilder >> filledNarrowArrowTail [
	shape filledNarrowArrowTail
]

{ #category : #heads }
OPRTEdgeBuilder >> head: aLineDecoration [
	shape head: aLineDecoration
]

{ #category : #initialization }
OPRTEdgeBuilder >> initialize [
	labels := Dictionary new.
	constraints := Set new.
	self line
]

{ #category : #private }
OPRTEdgeBuilder >> labelNamed: aSymbol [
	^ labels at: aSymbol ifAbsentPut: self newLabel.
]

{ #category : #shapes }
OPRTEdgeBuilder >> line [
	shape := OPRTStyledMultiLine new.
	self defaultColor.
	self borderAttachPoint
]

{ #category : #'line styles' }
OPRTEdgeBuilder >> lineWidth: aNumber [
	shape width: aNumber
]

{ #category : #shapes }
OPRTEdgeBuilder >> multiLine [
	shape := OPRTStyledConnection new.
	self defaultColor.
	self borderAttachPoint
]

{ #category : #private }
OPRTEdgeBuilder >> newLabel [
	^ self newLabel: ''
]

{ #category : #private }
OPRTEdgeBuilder >> newLabel: aString [
	^ (RTLabel new
		height: 10;
		color: shape color;
		text: aString;
		element)
		@ RTDraggable;
		yourself
]

{ #category : #heads }
OPRTEdgeBuilder >> noHead [
	shape noHead
]

{ #category : #heads }
OPRTEdgeBuilder >> noTail [
	shape noTail
]

{ #category : #heads }
OPRTEdgeBuilder >> notDecorated [
	shape notDecorated
]

{ #category : #'line styles' }
OPRTEdgeBuilder >> solidLine [
	shape solidLine
]

{ #category : #heads }
OPRTEdgeBuilder >> tail: aLineDecoration [
	shape tail: aLineDecoration
]

{ #category : #labels }
OPRTEdgeBuilder >> updateLabel: aSymbol whenChanged: aValueHolder [
	| label |
	label := self labelNamed: aSymbol.
	label trachelShape text: aValueHolder value.
	aValueHolder
		whenChangedDo: [ :newValue | 
			label trachelShape text: newValue.
			label signalUpdate ]
]
