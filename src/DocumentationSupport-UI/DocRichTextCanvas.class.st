Class {
	#name : #DocRichTextCanvas,
	#superclass : #MicRichTextCanvas,
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #public }
DocRichTextCanvas >> includeAttributes: attrCollection in: aBlock [
	attrCollection do: [ :attr | brushes addLast: (MicRichTextBrush on: self attribute: attr) ].
	aBlock value.
	attrCollection do: [ :attr | brushes removeLast ]
]
