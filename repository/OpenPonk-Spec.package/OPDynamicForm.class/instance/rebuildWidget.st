private - building widgets
rebuildWidget
	self widgets removeAll.
	self createWidgets.
	self needFullRebuild: false.
	self buildWithSpecLayout: self dynamicLayout.
	self resizeWidgets