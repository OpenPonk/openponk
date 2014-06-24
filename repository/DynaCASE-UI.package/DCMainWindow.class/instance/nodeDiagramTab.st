initialization
nodeDiagramTab
	| tab |
	tab := self newTab.
	tab
		label: 'Nodes';
		icon: Smalltalk ui icons nautilusIcon;
		model: DCNodeTab new.
	^ tab