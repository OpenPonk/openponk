accessing
borderRadius: aValueOrAOneArgBlock
	"aValueOrAOneArgBlock is applied on the object model"
	self borderRadiusElement: [ :anElement | aValueOrAOneArgBlock rtValue: anElement model ]
	