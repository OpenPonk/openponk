private
rebuild
	isActive
		ifTrue: [ self removeHandles.
			self showHandles ].
	edge update.
	edge signalUpdate