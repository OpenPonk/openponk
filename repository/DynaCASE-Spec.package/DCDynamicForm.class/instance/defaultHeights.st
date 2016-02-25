initialization
defaultHeights
	| lineHeight |
	lineHeight := self class inputTextHeight - 4.
	^ {(LabelModel -> (lineHeight - 5)).
	(TextInputFieldModel -> lineHeight).
	(TextModel -> (lineHeight * 4)).
	(DropListModel -> (lineHeight)).
	(CheckBoxModel -> (lineHeight * 1)).
	(ButtonModel -> (lineHeight * 1.2))} asDictionary