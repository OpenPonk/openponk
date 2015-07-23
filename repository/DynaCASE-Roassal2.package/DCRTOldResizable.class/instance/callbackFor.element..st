hooks
callbackFor: handle element: element
	^ TRTranslationCallback
		block: [ :shape :step | 
			| tStep newSize position |
			tStep := handle position - element encompassingRectangle bottomRight + (handle extent / 2).
			newSize := element extent + tStep max: 20 @ 20.
			position := element encompassingRectangle topLeft.
			element trachelShape
				doWithoutCallbacks: [ 
					element extent: newSize.
					RTDirectLayoutTranslator new translateTopLeftOf: element to: position ].
			element trachelShape triggerCallbacksForStep: 0 ]