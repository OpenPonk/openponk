private
scaleToMorphLimits
	"scale down to estimated morph (maxWidthAndHeight) and exporter (maxArea) size limits"

	| maxArea maxWidthAndHeight maxWidth maxHeight |
	maxArea := 32000000.
	maxWidthAndHeight := 10000.

	maxWidth := maxWidthAndHeight - (2 * margin x).
	maxHeight := maxWidthAndHeight - (2 * margin y).

	self extent x * self extent y > maxArea
		ifTrue: [ self scale: (maxArea / (self extent x * self extent y)) sqrt * self cameraScale ].
	self extent x > maxWidth
		ifTrue: [ self scale: maxWidth / self extent x * self cameraScale ].
	self extent y > maxHeight
		ifTrue: [ self scale: maxHeight / self extent y * self cameraScale ]