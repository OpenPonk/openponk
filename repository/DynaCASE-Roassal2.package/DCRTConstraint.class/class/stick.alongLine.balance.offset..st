public - sticking
stick: aShape alongLine: anEdge balance: aFloat offset: aNumber
	| callbackex callbacktr block |
	self
		move: aShape
		alongEdge: anEdge
		balance: aFloat
		offset: aNumber.
	block := [ :shape :step | 
	self
		move: aShape
		alongEdge: anEdge
		balance: aFloat
		offset: aNumber ].
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
			self fix: aShape alongEdge: anEdge ]