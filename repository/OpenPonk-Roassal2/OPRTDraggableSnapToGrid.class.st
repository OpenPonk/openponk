Class {
	#name : #OPRTDraggableSnapToGrid,
	#superclass : #RTDraggableSnapToGrid,
	#category : #'OpenPonk-Roassal2-Interactivity'
}

{ #category : #hooks }
OPRTDraggableSnapToGrid >> initializeElementForCenter: element [
	| totalD spacing |
	totalD := 0 @ 0.
	element when: TRMouseDragStart do: [ :event | totalD := 0 @ 0 ].
	spacing := self gridSizeFor: element.
	element
		when: TRMouseDragging
		do: [ :event | 
			| d t horizontalSpacing verticalSpacing |
			horizontalSpacing := (element width rounded % (spacing * 2)) isZero
				ifTrue: [ spacing / 2 ]
				ifFalse: [ spacing ].
			verticalSpacing := (element height rounded % (spacing * 2)) isZero
				ifTrue: [ spacing / 2 ]
				ifFalse: [ spacing ].
			t := RTGroup withAll: groupToDrag.
			(t includes: element)
				ifFalse: [ t add: element ].
			d := element encompassingRectangle center.
			d := d
				+ (element view canvas camera distanceFromPixelToSpace: event step).
			totalD := totalD + d.
			d := (horizontalSpacing * (totalD x / horizontalSpacing) rounded)
				@ (verticalSpacing * (totalD y / verticalSpacing) rounded).
			totalD := totalD - d.
			d := d - element encompassingRectangle center.
			t translateBy: d.
			event signalUpdate ]
]

{ #category : #hooks }
OPRTDraggableSnapToGrid >> initializeElementForTopLeft: element [
	| totalD spacing |
	totalD := 0 @ 0.
	element when: TRMouseDragStart do: [ :event | totalD := 0 @ 0 ].
	spacing := self gridSizeFor: element.
	element
		when: TRMouseDragging
		do: [ :event | 
			| d t horizontalSpacing verticalSpacing |
			horizontalSpacing := (element width rounded % (spacing * 2)) isZero
				ifTrue: [ spacing / 2 ]
				ifFalse: [ spacing ].
			verticalSpacing := (element height rounded % (spacing * 2)) isZero
				ifTrue: [ spacing / 2 ]
				ifFalse: [ spacing ].
			t := RTGroup withAll: groupToDrag.
			(t includes: element)
				ifFalse: [ t add: element ].
			d := element encompassingRectangle topLeft.
			d := d
				+ (element view canvas camera distanceFromPixelToSpace: event step).
			totalD := totalD + d.
			d := (horizontalSpacing * (totalD x / horizontalSpacing) rounded)
				@ (verticalSpacing * (totalD y / verticalSpacing) rounded).
			totalD := totalD - d.
			d := d - element encompassingRectangle topLeft.
			t translateBy: d.
			event signalUpdate ]
]
