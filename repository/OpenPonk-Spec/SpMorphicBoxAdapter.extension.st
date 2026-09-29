Extension { #name : 'SpMorphicBoxAdapter' }

{ #category : '*OpenPonk-Spec' }
SpMorphicBoxAdapter >> setFixedHeight: aNumber toMorph: aMorph [
	"Sets fixed height constraint without corrupting horizontal cell size."
	aMorph
		minCellSize: 0 @ aNumber;
		maxCellSize: SmallInteger maxVal @ aNumber;
		height: aNumber
]

{ #category : '*OpenPonk-Spec' }
SpMorphicBoxAdapter >> setFixedWidth: aNumber toMorph: aMorph [
	"Sets fixed width constraint without corrupting vertical cell size."
	aMorph
		minCellSize: aNumber @ 0;
		maxCellSize: aNumber @ SmallInteger maxVal;
		width: aNumber
]
