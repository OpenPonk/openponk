util
getSelectedElementsWith: aSelectionElement
	| selected bounds candidates |
	selected := RTGroup new.
	bounds := aSelectionElement encompassingRectangle.
	candidates := self candidates copyWithout: aSelectionElement.
	selected := candidates select: [ :each | bounds intersects: each encompassingRectangle ].
	^ selected asGroup