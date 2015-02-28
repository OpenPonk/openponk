hooks
renderIn: aView
	group := RTGroup new.
	topGroup := self createTopGroup.
	attributesGroup := RTGroup new.
	methodsGroup := RTGroup new.
	separatorGroup := RTGroup new.
	separatorGroup
		add: DCRTClassSeparator build;
		add: DCRTClassSeparator build.
	background @ RTDraggable.
	RTNest new on: background nest: group.
	aView
		add: background;
		addAll: topGroup;
		addAll: separatorGroup first;
		addAll: separatorGroup second.
	self
		initializeCallbacks;
		update