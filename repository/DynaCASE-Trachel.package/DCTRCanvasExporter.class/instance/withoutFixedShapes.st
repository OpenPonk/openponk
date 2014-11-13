settings
withoutFixedShapes
	canvas camera doWithoutCallbacks: [ canvas fixedShapes do: [ :shape | shape doWithoutCallbacks: [ shape remove ] ] ]