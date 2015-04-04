*DynaCASE-Trachel
removeArray: anArray
	^ self block: [ anArray do: [ :each | each remove ] ]