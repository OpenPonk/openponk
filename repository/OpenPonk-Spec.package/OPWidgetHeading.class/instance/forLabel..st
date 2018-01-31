instance creation
forLabel: aString
	^ (TabMorph label: aString icon: nil morph: nil)
		closeable: false;
		selected: true;
		hResizing: #spaceFill;
		asSpecAdapter