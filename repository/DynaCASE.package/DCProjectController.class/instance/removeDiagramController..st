as yet unclassified
removeDiagramController: aController
	self project layout: aController layout for: aController model.
	controllers remove: aController