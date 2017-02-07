initialize-release
initialize
	super initialize.
	modelName := ''.
	self addExportPane.
	self atEndDo: [ :values | self exportWith: values ]