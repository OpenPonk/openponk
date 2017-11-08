controllers management
removeController: aController
	aController diagramController: nil.
	self controllers remove: aController