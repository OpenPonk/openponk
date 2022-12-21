Extension { #name : #AthensCairoCanvas }

{ #category : #'*OpenPonk-Roassal2' }
AthensCairoCanvas >> fillPreserve [
	^ self ffiCall: #(#void #cairo_fill_preserve #(#self))
]

{ #category : #'*OpenPonk-Roassal2' }
AthensCairoCanvas >> textPath: anUTF8EncodedString [
	"A drawing operator that generates the shape from a string of UTF-8 characters, rendered according to the current font_face, font_size (font_matrix), and font_options. "
	
	^ self ffiCall: #(void cairo_text_path (self, void* anUTF8EncodedString ))
]
