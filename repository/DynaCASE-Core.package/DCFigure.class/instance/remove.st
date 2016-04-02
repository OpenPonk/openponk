removing
remove
	self figures copy do: [ :each | self remove: each ].
	background remove.
	view := nil