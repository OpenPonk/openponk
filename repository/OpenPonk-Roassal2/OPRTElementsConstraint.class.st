"
A DCRTElementsConstraint is a utility class that contains methods to change element according other
"
Class {
	#name : #OPRTElementsConstraint,
	#superclass : #OPRTAbstractConstraint,
	#category : #'OpenPonk-Roassal2-Constraints'
}

{ #category : #'as yet unclassified' }
OPRTElementsConstraint class >> changeExtentOf: conformingShape like: originShape plus: aPoint [
	^ conformingShape extent: originShape encompassingRectangle extent + aPoint
]

{ #category : #'public - resizing' }
OPRTElementsConstraint class >> keepExtentOf: conformingShape like: originShape plus: aPoint [
	| b |
	self changeExtentOf: conformingShape like: originShape plus: aPoint.
	b := [ :shape :step | self changeExtentOf: conformingShape like: originShape plus: aPoint ].
	originShape
		addCallback: (TRExtentCallback block: b);
		addCallback: (TRTranslationCallback block: b)
]

{ #category : #'public - visualization' }
OPRTElementsConstraint class >> whenDragging: anElement drawLineToPoint: aBlock [
	| lineTargetBox dynamicLine |
	anElement
		when: TRMouseDragStart
			do: [ (lineTargetBox := RTBox new
				size: 0;
				color: Color transparent;
				element) translateTo: aBlock value.
			anElement view
				add: lineTargetBox;
				add:
					(dynamicLine := (RTLine new color: Color veryLightGray)
						edgeFrom: lineTargetBox
						to: anElement);
				signalUpdate ];
		when: TRMouseDragging
			do: [ lineTargetBox translateTo: aBlock value ];
		when: TRMouseDragEnd
			do: [ dynamicLine remove.
			lineTargetBox remove.
			dynamicLine := lineTargetBox := nil.
			anElement view signalUpdate ]
]
