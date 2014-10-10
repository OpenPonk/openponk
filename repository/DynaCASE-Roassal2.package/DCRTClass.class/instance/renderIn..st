hooks
renderIn: aView
	group := RTGroup new.
	topGroup := self createTopGroup.
	attributesGroup := RTGroup new.
	separatorGroup := self createSeparators.
	background @ RTDraggable.
	RTNest new on: background nest: group.
	aView add: background.
	aView addAll: topGroup.
	aView addAll: separatorGroup.
	self initializeCallbacks.
	self update