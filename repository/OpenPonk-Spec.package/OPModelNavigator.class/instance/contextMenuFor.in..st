toolbar
contextMenuFor: anObject in: aMenu
	| builder |
	builder := OPMenuBuilder new.
	builder menu: aMenu.
	((adapters select: [ :each | each hasMappingFor: anObject ])
		collect: [ :each | each contextMenuFor: anObject ]) flattened
		do: [ :pair | builder addItem: pair key action: [ pair value value: anObject ] ]