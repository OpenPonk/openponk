private
scaleToMorphLimits
	"scale down to estimated morph (maxWidthAndHeight) and exporter (maxArea) size limits"

	| maxArea maxWidthAndHeight |
	maxArea := 32000000.
	maxWidthAndHeight := 10000.
	self extent x * self extent y > maxArea
		ifTrue: [ self scale: (maxArea / (self extent x * self extent y)) sqrt * self cameraScale ].
	self extent x > maxWidthAndHeight
		ifTrue: [ self scale: maxWidthAndHeight / self extent x * self cameraScale ].
	self extent y > maxWidthAndHeight
		ifTrue: [ self scale: maxWidthAndHeight / self extent y * self cameraScale ]