execute
execute
	| fileName |
	fileName := (UIManager default request: 'Please enter file name' initialAnswer: defaultFileName) ifNil: [ ^ nil ].
	self exportTo: fileName.
	UIManager default inform: 'Diagram exported to ''' , fileName , ''''