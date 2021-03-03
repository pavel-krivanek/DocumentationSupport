"
Pillar rich text composer with additional URL schemas:
- `ref://` - reference to another document
- `include://` - reference to another document. During printing, it should include the referred chapter
"
Class {
	#name : #DocRichTextComposer,
	#superclass : #PRRichTextComposer,
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
