events
watchRecognizer: aRecognizer
	aRecognizer
		when: DCFsmRecognizerEvent
		do: [ :ann | 
			aRecognizer isInputEmpty
				ifFalse: [ nextButton enable ].
			aRecognizer isPathEmpty
				ifFalse: [ backButton enable ].
			ann place isState
				ifTrue: [ self letterPanel widget changeBoxAt: aRecognizer inputPosition - 1 to: #beSuccess ].
			ann place isTransition
				ifTrue: [ self letterPanel widget changeBoxAt: aRecognizer inputPosition - 1 to: #beProcessed ] ].

	aRecognizer
		when: DCFsmRecognizerSuccess
		do: [ :ann | DCFsmFigureHighlighter highlightElement: (diagramController figureFor: ann place) with: Color green ].

	aRecognizer
		when: DCFsmRecognizerFailure
		do: [ :ann | 
			DCFsmFigureHighlighter highlightElement: (diagramController figureFor: ann place) with: Color red.
			self letterPanel widget changeBoxAt: aRecognizer inputPosition - 1 to: #beFailure ].

	aRecognizer
		when: DCFsmRecognizerLeave
		do: [ :ann | DCFsmFigureHighlighter unhighlight: (diagramController figureFor: ann place) ].

	aRecognizer
		when: DCFsmRecognizerEnter
		do: [ :ann | DCFsmFigureHighlighter highlight: (diagramController figureFor: ann place) with: Color orange ]