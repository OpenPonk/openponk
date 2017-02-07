initialization
initialize
	super initialize.
	self
		script: [ :view :canvas | 
			roassalView := view.
			self initializeView: view ]