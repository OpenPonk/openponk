*OpenPonk-Trachel
removeArray: anArray
	^ self block: [ anArray do: [ :each | each view ifNotNil: [ each remove ] ] ]