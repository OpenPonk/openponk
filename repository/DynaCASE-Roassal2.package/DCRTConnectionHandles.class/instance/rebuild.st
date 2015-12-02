private
rebuild
	visible
		ifTrue: [ self removeHandles.
			self showHandles ].
	edge update.
	edge signalUpdate