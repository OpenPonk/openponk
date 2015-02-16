setting
dynamicCenteringBlock: aBlock
	"Sets centering to dynamic, using default centering block.
	Block takes collection of sources and collection of targets as 2 arguments, and should return new position of center"

	centeringBlock := aBlock.
	self dynamicCentering