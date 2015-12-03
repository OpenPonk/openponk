private
addHandles
	isActive
		ifTrue: [ ^ self ].
	self ensureOrthogonal.
	self addCornerHandles.
	handles linksDo: [ :each | each renderIn: edge view ].
	edge update.
	edge signalUpdate.
	isActive := true