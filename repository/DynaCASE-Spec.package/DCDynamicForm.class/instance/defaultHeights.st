initialization
defaultHeights
	| lineHeight |
	lineHeight := self class inputTextHeight - 4.
	^ {DCSelectEntity -> lineHeight.
	LabelModel -> (lineHeight - 5).
	TextInputFieldModel -> lineHeight.
	TextModel -> (lineHeight * 4).
	DCEditableDropListModel -> (lineHeight * 1.1).
	DropListModel -> lineHeight.
	CheckBoxModel -> (lineHeight * 1).
	ButtonModel -> (lineHeight * 1.2)} asDictionary