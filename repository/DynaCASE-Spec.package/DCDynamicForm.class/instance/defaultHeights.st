initialization
defaultHeights
	| lineHeight |
	lineHeight := self class inputTextHeight - 4.
	^ {(LabelModel -> (lineHeight - 5)).
	(TextInputFieldModel -> lineHeight).
	(TextModel -> (lineHeight * 4)).
	(CheckBoxModel -> (lineHeight * 1))} asDictionary