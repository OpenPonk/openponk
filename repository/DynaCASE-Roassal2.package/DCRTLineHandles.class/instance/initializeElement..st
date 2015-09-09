initialization
initializeElement: anEdge
	anEdge
		when: TRMouseLeftClick
		do:
			[ 
			anEdge announcer unsubscribe: self.
			self lazyInitializeElement: anEdge.
			self showHandles ]