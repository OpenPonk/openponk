diagram handling
applyLayoutFor: aDiagram
	| layout |
	layout := self workbench projectController layoutFor: aDiagram.
	diagramController layout: layout