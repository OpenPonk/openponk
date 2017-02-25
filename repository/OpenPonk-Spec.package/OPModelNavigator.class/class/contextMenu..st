as yet unclassified
contextMenu: aBuilder
	<opModelNavigatorContextMenu>
	| navigator |
	navigator := aBuilder model.
	(aBuilder item: 'Inspect') action: [ navigator selectedItem inspect ]