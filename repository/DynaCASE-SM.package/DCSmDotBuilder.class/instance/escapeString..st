private
escapeString: aString
	| escapedString |
	escapedString := (aString copyReplaceAll: '\' with: '\\') copyReplaceAll: '"' with: '\"'.
	^ '"' , escapedString , '"'