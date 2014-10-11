hooks
renderIn: aView
	group := RTGroup new.
	topGroup := self createTopGroup.
	attributesGroup := RTGroup new.
	methodsGroup := RTGroup new.
	separatorGroup := RTGroup new.
	separatorGroup
		add:
			(DCRTClassSeparator new
				build;
				yourself).
	separatorGroup
		add:
			(DCRTClassSeparator new
				build;
				yourself).
	background @ RTDraggable.
	RTNest new on: background nest: group.
	aView add: background.
	aView addAll: topGroup.
	aView addAll: separatorGroup first.
	aView addAll: separatorGroup second.
	self initializeCallbacks.
	self update