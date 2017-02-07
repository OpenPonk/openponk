diagram handling
applyLayoutFor: aModel
	| layout |
	layout := self workbench projectController layoutFor: aModel.
	layout ifNotNil: [ diagramController layout: layout ]