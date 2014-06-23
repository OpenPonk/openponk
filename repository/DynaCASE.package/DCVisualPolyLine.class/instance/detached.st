adding
detached
	self pointHandles do: [ :node | self session announce: (DCVisualNodeDeleted node: node) ]