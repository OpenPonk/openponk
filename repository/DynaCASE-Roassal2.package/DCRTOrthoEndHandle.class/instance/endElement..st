accessing
endElement: anElement
	endElement := anElement.
	endElement addCallback: (TRTranslationCallback block: [ :e :step | self movedBy: step ])