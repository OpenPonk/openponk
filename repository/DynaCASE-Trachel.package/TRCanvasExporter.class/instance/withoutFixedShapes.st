settings
withoutFixedShapes
	"removes shapes at fixed position in window/morph (not on canvas)"

	canvas camera doWithoutCallbacks: [ canvas fixedShapes do: [ :shape | shape doWithoutCallbacks: [ shape remove ] ] ]