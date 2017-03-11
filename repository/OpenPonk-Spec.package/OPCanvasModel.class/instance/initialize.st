initialization
initialize
	super initialize.
	onZoomChange := [ :value |  ].
	self
		script: [ :view :canvas | 
			roassalView := view.
			self initializeView: view ]