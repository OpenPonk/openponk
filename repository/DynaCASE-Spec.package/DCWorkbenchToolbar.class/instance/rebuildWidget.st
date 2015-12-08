building widgets
rebuildWidget
	self initializeWidgets.
	self initializePresenter.
	self needFullRebuild: false.
	self buildWithSpecLayout: self class defaultSpec