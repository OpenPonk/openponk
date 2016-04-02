diagram handling
applyLayoutFor: aModel
	| layout |
	layout := self workbench projectController layoutFor: aModel.
	diagramController layout: layout