Class {
	#name : #DocRichTextComposer,
	#superclass : #MicRichTextComposer,
	#instVars : [
		'executor'
	],
	#classInstVars : [
		'searchIndex',
		'searchSize',
		'searchHighLightEnableOn',
		'searchWord'
	],
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #accessing }
DocRichTextComposer class >> searchHighLightEnableOn [
	^ searchHighLightEnableOn ifNil: [ ^ false ]
]

{ #category : #accessing }
DocRichTextComposer class >> searchHighLightEnableOn: aBoolean [
	searchHighLightEnableOn := aBoolean
]

{ #category : #accessing }
DocRichTextComposer class >> searchIndex [
	^ searchIndex ifNil: [ ^ 1 ]
]

{ #category : #accessing }
DocRichTextComposer class >> searchIndex: anInteger [
	searchIndex := anInteger
]

{ #category : #accessing }
DocRichTextComposer class >> searchSize [
	^ searchSize ifNil: [ ^ 1 ]
]

{ #category : #accessing }
DocRichTextComposer class >> searchSize: anInteger [
	searchSize := anInteger.
]

{ #category : #accessing }
DocRichTextComposer class >> searchWord [
	^ searchWord ifNil: [ ^ '' ]
]

{ #category : #accessing }
DocRichTextComposer class >> searchWord: aString [
	searchWord := aString.
]

{ #category : #accessing }
DocRichTextComposer >> executor [

	^ executor
]

{ #category : #accessing }
DocRichTextComposer >> executor: anObject [

	executor := anObject
]

{ #category : #highlighting }
DocRichTextComposer >> highlightText: aText [
	| index |
	index := self indexOfOccurence: aText.
	(index > 0 and: [ self class searchHighLightEnableOn ]) ifTrue: [ 
		aText  addAttribute: (TextBackgroundColor new color: Color lightGray ) from: index to: index + self class searchSize - 1
		 ]
	
	
]

{ #category : #highlighting }
DocRichTextComposer >> indexOfOccurence: aText [
	| index |
	index := 0.
	1 to: self class searchIndex do: [ :occurence |
		 index := aText findString: self class searchWord startingAt: index + 1 ].
	^ index
]

{ #category : #visiting }
DocRichTextComposer >> visit: aDocument [
	| text |
	text := super visit: aDocument.
	self highlightText: text.
	^ text.
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
