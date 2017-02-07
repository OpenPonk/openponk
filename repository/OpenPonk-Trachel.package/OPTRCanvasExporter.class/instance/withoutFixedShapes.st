settings
withoutFixedShapes
	"Irreversible setting applied immediately.
	Removes shapes with fixed position (based on position in window/morph, not canvas)"

	canvas camera doWithoutCallbacks: [ canvas fixedShapes do: [ :shape | shape doWithoutCallbacks: [ shape remove ] ] ]