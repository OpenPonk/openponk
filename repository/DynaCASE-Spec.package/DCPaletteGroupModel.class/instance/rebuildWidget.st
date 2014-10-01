building widgets
rebuildWidget
	self widgets removeAll.
	self createWidgets.
	self needRebuild: false.
	layout := self dynamicLayout