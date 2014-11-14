private
scaleToMorphLimits
	"scale down to estimated morph exporter size limits reached"

	| maxArea maxWidthAndHeight |
	maxArea := 32000000.
	maxWidthAndHeight := 9999.
	self extent x * self extent y > maxArea
		ifTrue: [ self scale: (maxArea / (self extent x * self extent y)) sqrt * self cameraScale ].
	self extent x >= maxWidthAndHeight
		ifTrue: [ self scale: maxWidthAndHeight / self extent x * self cameraScale ].
	self extent y >= maxWidthAndHeight
		ifTrue: [ self scale: maxWidthAndHeight / self extent y * self cameraScale ]