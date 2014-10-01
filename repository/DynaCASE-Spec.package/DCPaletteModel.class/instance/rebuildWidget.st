building widgets
rebuildWidget
	self widgets removeAll.
	self createWidgets.
	self needFullRebuild: false.
	groups do: [ :group | group rebuildWidget ].
	self buildWithSpecLayout: self dynamicLayout