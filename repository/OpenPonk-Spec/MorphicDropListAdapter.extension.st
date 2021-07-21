Extension { #name : #MorphicDropListAdapter }

{ #category : #'*OpenPonk-Spec' }
MorphicDropListAdapter >> buildWidget [
	^ SpecDropListMorph new
		wrapSelector: #wrap:withIndex:;
		on: self
			list: #getList
			selected: #getIndex
			changeSelected: #setIndex:;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled;
		enabled: self enabled;
		setBalloonText: self help;
		yourself
]
