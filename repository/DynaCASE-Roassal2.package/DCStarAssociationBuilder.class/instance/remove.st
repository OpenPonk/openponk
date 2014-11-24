removing
remove
	self elements do: [ :each | self removeEdgeOf: each ].
	center remove.
	centerDragBox remove