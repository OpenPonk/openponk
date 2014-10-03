public
trachelShapeFor: anElement
	| group ss s h firstGroup contentGroups y |
	group := RTGroup new.

	firstGroup := self firstGroupFor: anElement.
	contentGroups := self contentGroupsFor: anElement.
	group addAll: firstGroup.
	contentGroups do: [ :each | group addAll: each ].

	"align all lines to left"
	RTVerticalLineLayout new
		verticalGap: 0;
		on: group.

	"align first group to center"
	firstGroup do: [ :shape | shape translateTo: group center x @ shape center y ].

	ss := TRMultiCompositeShape new.
	ss addShape: (self createBox: group extent).

	h := firstGroup height.
	contentGroups
		do: [ :aGroup | 
			| box |
			box := self createBox: group extent x @ aGroup height.
			y := h + ((group height - aGroup height) / -2).
			h := h + aGroup height.
			ss addShape: box translateBy: 0 @ y ].

	s := TRMultiCompositeShape new.
	s setShapes: (self convertGroupToShapeAndOffsets: group).
	ss addShape: s.
	^ ss