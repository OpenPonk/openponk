initialization
defaultHeights
	| lineHeight |
	lineHeight := 20.
	^ {OPSelectEntity -> lineHeight.
	LabelModel -> (lineHeight - 5).
	TextInputFieldModel -> (lineHeight + 2).
	TextModel -> (lineHeight * 4).
	OPEditableDropListModel -> lineHeight.
	DropListModel -> lineHeight.
	CheckBoxModel -> (lineHeight * 1).
	ButtonModel -> (lineHeight * 1.2)} asDictionary