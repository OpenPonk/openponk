toolbar
exportFormatSubmenu
	| fileName |
	fileName := self editor diagramController model name , ' - DynaCASE'.
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'PNG';
						action: [ self exportAsPng: fileName ] ].
			group
				addItem: [ :item | 
					item
						name: 'JPEG';
						action: [ self exportAsJpg: fileName ] ] ]