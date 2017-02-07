*OpenPonk-Trachel
translateArray: anArray
	^ self block: [ :shape :step | anArray do: [ :each | each translateBy: step ] ]