search
checkIfObject: xObject isInCollection: xCollection

	^ xCollection anySatisfy: [ :each | each name = xObject name ]