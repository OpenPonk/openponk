Class {
	#name : #OPIdentifierChooserMorph,
	#superclass : #IdentifierChooserMorph,
	#category : #'OpenPonk-Morphic-Polymorph'
}

{ #category : #'instance creation' }
OPIdentifierChooserMorph >> newChoiceButtonFor: index [
	"Answer a new choice button."
	^ (self labels at: index) 
		ifNotNil: [:option | (OPSubtextedMenuItemMorph new
			contents: option text;
			subtext: option subtext;
			target: self;
			selector: #choose:;
			arguments: {index})
			cornerStyle: #square;
			hResizing: #spaceFill]
		ifNil: [MenuLineMorph new]
]
