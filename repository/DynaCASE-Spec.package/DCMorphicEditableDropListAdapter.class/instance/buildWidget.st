factory
buildWidget
	^ (EditableDropListMorph
		on: self
		list: #getList
		selected: #getIndex
		changeSelected: #setIndex:
		useIndex: true
		addToList: #addToList:
		class: String
		getEnabled: nil
		default: '')
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		yourself