adding
attached
	self pointHandles do: [ :node | self session announce: (DCVisualNodeAdded node: node) ]