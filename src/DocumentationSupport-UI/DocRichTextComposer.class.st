Class {
	#name : #DocRichTextComposer,
	#superclass : #MicRichTextComposer,
	#instVars : [
		'executor'
	],
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #accessing }
DocRichTextComposer >> executor [

	^ executor
]

{ #category : #accessing }
DocRichTextComposer >> executor: anObject [

	executor := anObject
]

{ #category : #visiting }
DocRichTextComposer >> visitExternalLink: aLink [
	| attribute target url |
	target := aLink reference.
	url := target asUrl.
	attribute := nil.
	(#(http https) includes: url scheme )
		ifTrue: [ attribute := "PRExternalLinkTextAction url: target"
			 	TextAction new actOnClickBlock: [WebBrowser openOn: target]].
	url scheme = #browse
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ self class browse: aLink urlEntry ] ].
	url scheme = #ref
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ executor openReference: aLink urlEntry ] ].
	url scheme = #include
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ executor openReference: aLink urlEntry ] ].
	attribute
		ifNotNil:
			[ canvas includeAttribute: attribute in: [ self visitLink: aLink ] ]
		ifNil: [ self visitLink: aLink ]
]

{ #category : #visiting }
DocRichTextComposer >> visitLink: aLink [
	| attribute |
	attribute := nil.
	(#(http https) includes: aLink url scheme )
		ifTrue: [ attribute := TextAction new actOnClickBlock: [ WebBrowser openOn: aLink url printString ]].
		
	aLink url scheme = #browse
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ self class browse: aLink url ] ].
	aLink url scheme = #ref
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ executor openReference: aLink url ] ].
	aLink url scheme = #include
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ executor openReference: aLink url ] ].
	attribute
		ifNotNil:
			[ canvas includeAttribute: attribute in: [ super visitLink: aLink ] ]
		ifNil: [ super visitLink: aLink ]
]
