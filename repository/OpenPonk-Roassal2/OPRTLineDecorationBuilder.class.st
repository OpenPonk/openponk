Class {
	#name : #OPRTLineDecorationBuilder,
	#superclass : #Object,
	#instVars : [
		'head',
		'tail',
		'dashes',
		'color',
		'attachPoint'
	],
	#category : 'OpenPonk-Roassal2-Builders'
}

{ #category : #decorators }
OPRTLineDecorationBuilder >> arrowHead [
	self head: RTSimpleArrow
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> arrowTail [
	self tail: RTSimpleArrow
]

{ #category : #accessing }
OPRTLineDecorationBuilder >> attachPoint: anAttachPoint [
	attachPoint := anAttachPoint.
	tail attachPoint: anAttachPoint.
	head attachPoint: anAttachPoint.
]

{ #category : #accessing }
OPRTLineDecorationBuilder >> color: aColor [
	color := aColor.
	tail color: aColor.
	head color: aColor
]

{ #category : #'line styles' }
OPRTLineDecorationBuilder >> dashdotLine [
		dashes := #("fill" 6 "gap" 3 "fill" 1 "gap" 3)
]

{ #category : #'line styles' }
OPRTLineDecorationBuilder >> dashedLine [
		dashes := #("fill" 6 "gap" 4)
]

{ #category : #accessing }
OPRTLineDecorationBuilder >> dashes [
	^ dashes
]

{ #category : #'line styles' }
OPRTLineDecorationBuilder >> dottedLine [
	dashes := #("fill" 1 "gap" 2)
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> emptyArrowHead [
	self head: RTEmptyArrow
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> emptyArrowTail [
	self tail: RTEmptyArrow
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> emptyCircleHead [
	self head: RTEmptyCircle
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> emptyCircleTail [
	self tail: RTEmptyCircle
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> emptyDiamondHead [
	self head: RTEmptyDiamond
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> emptyDiamondTail [
	self tail: RTEmptyDiamond
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> emptyNarrowArrowHead [
	self head: RTEmptyNarrowArrow
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> emptyNarrowArrowTail [
	self tail: RTEmptyNarrowArrow
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> filledArrowHead [
	self head: RTFilledArrow
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> filledArrowTail [
	self tail: RTFilledArrow
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> filledCircleHead [
	self head: RTFilledCircle
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> filledCircleTail [
	self tail: RTFilledCircle
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> filledDiamondHead [
	self head: RTFilledDiamond
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> filledDiamondTail [
	self tail: RTFilledDiamond
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> filledNarrowArrowHead [
	self head: RTFilledNarrowArrow
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> filledNarrowArrowTail [
	self tail: RTFilledNarrowArrow
]

{ #category : #accessing }
OPRTLineDecorationBuilder >> head [
	^ head
]

{ #category : #accessing }
OPRTLineDecorationBuilder >> head: aLineDecorationShape [
	(head := aLineDecorationShape asHead)
		attachPoint: attachPoint;
		color: color
]

{ #category : #initialization }
OPRTLineDecorationBuilder >> initialize [
	super initialize.
	self notDecorated
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> noHead [
	self head: RTNoDecorationShape
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> noTail [
	self tail: RTNoDecorationShape
]

{ #category : #decorators }
OPRTLineDecorationBuilder >> notDecorated [
	self
		noHead;
		noTail;
		attachPoint: RTCenteredAttachPoint new
]

{ #category : #'line styles' }
OPRTLineDecorationBuilder >> solidLine [
	dashes := nil
]

{ #category : #accessing }
OPRTLineDecorationBuilder >> tail [
	^ tail
]

{ #category : #accessing }
OPRTLineDecorationBuilder >> tail: aLineDecorationShape [
	(tail := aLineDecorationShape asTail)
		attachPoint: attachPoint;
		color: color
]
