public - sticking
stick: aShape nearStartOfEdge: anEdge distance: aNumber offset: anotherNumber
	| callbackex callbacktr block |
	self
		move: aShape
		nearStartOfEdge: anEdge
		distance: aNumber
		offset: anotherNumber.
	block := [ :shape :step | 
	self
		move: aShape
		nearStartOfEdge: anEdge
		distance: aNumber
		offset: anotherNumber ].
	callbacktr := TRTranslationCallback block: block.
	callbackex := TRExtentCallback block: block.
	anEdge from
		addCallback: callbacktr;
		addCallback: callbackex.
	anEdge to
		addCallback: callbacktr;
		addCallback: callbackex.
	aShape
		when: TRMouseDragEnd
		do: [ 
			anEdge from trachelShape
				removeCallback: callbacktr ifAbsent: nil;
				removeCallback: callbackex ifAbsent: nil.
			anEdge to trachelShape
				removeCallback: callbacktr ifAbsent: nil;
				removeCallback: callbackex ifAbsent: nil.
			aShape announcer unsubscribe: self.
			self fix: aShape nearStartOfEdge: anEdge ]