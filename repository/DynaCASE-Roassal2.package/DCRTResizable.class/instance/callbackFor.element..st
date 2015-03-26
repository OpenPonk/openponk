hooks
callbackFor: handle element: element
	^ TRTranslationCallback
		block: [ :shape :step | 
			| tStep newSize position |
			tStep := handle position - element encompassingRectangle bottomRight + (handle extent / 2).
			tStep := tStep asIntegerPoint.
			newSize := (element extent + tStep max: 20 @ 20) asIntegerPoint.
			position := element encompassingRectangle topLeft asIntegerPoint.
			element trachelShape
				doWithoutCallbacks: [ 
					element extent: newSize.
					RTDirectLayoutTranslator new translateTopLeftOf: element to: position ] ]