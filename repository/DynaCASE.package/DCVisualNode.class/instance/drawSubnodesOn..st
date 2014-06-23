drawing
drawSubnodesOn: aCanvas
	self subnodes do: [ :node | node drawOn: aCanvas ]