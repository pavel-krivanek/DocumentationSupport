Class {
	#name : #CleanMarkupVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'text'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #initialization }
CleanMarkupVisitor >> initialize [
	super initialize.
	text := ''
]

{ #category : #accessing }
CleanMarkupVisitor >> text [
	^ text
]

{ #category : #visiting }
CleanMarkupVisitor >> visit: test [
	super visit: test
]

{ #category : #visiting }
CleanMarkupVisitor >> visitCode: aMicCodeBlock [
	text := text , String cr.
	aMicCodeBlock caption 
		ifNotEmpty: [ text := text , aMicCodeBlock caption, String cr ].
	text := text , aMicCodeBlock body.
	text := text , String cr
]

{ #category : #visiting }
CleanMarkupVisitor >> visitFigure: aMicFigure [
	text := text , String cr , (String tab repeat: 3), aMicFigure substring , String cr
]

{ #category : #visiting }
CleanMarkupVisitor >> visitHeader: aMicHeaderBlock [
	text := text , String cr.
	super visitHeader: aMicHeaderBlock.
	text := text , String cr
]

{ #category : #visiting }
CleanMarkupVisitor >> visitHorizontalLine: aMicHorizontalLine [
	super visitHorizontalLine: aMicHorizontalLine.
	text := text , ('     ' repeat: 20) , String cr
]

{ #category : #visiting }
CleanMarkupVisitor >> visitListItem: anItem [
	anItem textElements do: [ :each | 
		anItem parent class = MicUnorderedListBlock 
			ifTrue: [ text := text , '- ' ] 
			ifFalse: [ text := text , '1. '. ].		
		each accept: self ].
	self visitChildrenOf: anItem
]

{ #category : #visiting }
CleanMarkupVisitor >> visitMath: aMicMathBlock [
	text := text , (String cr repeat: 3)
]

{ #category : #visiting }
CleanMarkupVisitor >> visitMathInline: aMicMathInlineBlock [
	text := text , ' '
]

{ #category : #visiting }
CleanMarkupVisitor >> visitOrderedList: aMicOrderedList [
	aMicOrderedList children do: [ :each | 
		self visitOrderedListItem: each.
		text := text , String cr ]
]

{ #category : #visiting }
CleanMarkupVisitor >> visitParagraph: aMicParagraph [
	text := text , String cr.
	super visitParagraph: aMicParagraph.
	text := text , String cr
]

{ #category : #visiting }
CleanMarkupVisitor >> visitText: aMicTextBlock [
	text := text , aMicTextBlock substring
]

{ #category : #visiting }
CleanMarkupVisitor >> visitUnorderedList: aMicUnorderedList [
	aMicUnorderedList children do: [ :each | 
		self visitUnorderedListItem: each.
		text := text , String cr ]
]
