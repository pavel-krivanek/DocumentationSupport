"
I search the index of all substring's occurence in a `DocLibrary` that I register in my searchCache
"
Class {
	#name : #DocSearchBook,
	#superclass : #Object,
	#instVars : [
		'searchCache',
		'nbOccurence',
		'actualBook',
		'actualChapter',
		'actualPosition'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #accessing }
DocSearchBook >> actualBook [
	^ actualBook
]

{ #category : #accessing }
DocSearchBook >> actualChapter [
	^ actualChapter
]

{ #category : #accessing }
DocSearchBook >> actualIndex [
	^ searchCache at: actualPosition
]

{ #category : #accessing }
DocSearchBook >> firstOccurence [
	^ searchCache first
		ifAbsent: [ ^ DocSearchIndex new ]
]

{ #category : #search }
DocSearchBook >> indexOfBooks: aSubString in: aDocLibrary [

  aDocLibrary books doWithIndex: [ :book :i|
		actualBook := i.
		self indexOfChapters: aSubString in: book ]
]

{ #category : #search }
DocSearchBook >> indexOfChapters: aSubString in: aDocBook [

  aDocBook chapters do: [ :chapter |
		actualChapter := chapter key.
		self indexOfSubstring: aSubString in: chapter source ]
]

{ #category : #search }
DocSearchBook >> indexOfSubstring: aSubString in: aString [
  | index i |
  i := 0.
  [ (i := aString findString: aSubString startingAt: i + 1) > 0 ] whileTrue: [
    index := DocSearchIndex index: actualBook in: actualChapter at: i.
	 searchCache add: index. 
	 nbOccurence := nbOccurence + 1 ]
]

{ #category : #initialization }
DocSearchBook >> initialize [
	super initialize.
	nbOccurence := 0.
	actualPosition := 0.
]

{ #category : #accessing }
DocSearchBook >> lastOccurence [
	^ searchCache last 
		ifAbsent: [ ^ DocSearchIndex new ]
]

{ #category : #accessing }
DocSearchBook >> nbOccurence [
	^ nbOccurence
]

{ #category : #actions }
DocSearchBook >> next [
	actualPosition < searchCache size 
		ifTrue: [ actualPosition := actualPosition + 1 ]
]

{ #category : #actions }
DocSearchBook >> prev [
	actualPosition > 1
		ifTrue: [ actualPosition := actualPosition - 1 ]
]

{ #category : #search }
DocSearchBook >> search: aSubString in: aDocLibrary [
	nbOccurence = 0.
	searchCache := OrderedCollection new.
	self indexOfBooks: aSubString in: aDocLibrary.
	actualPosition := 1
]

{ #category : #accessing }
DocSearchBook >> searchCache [
	^ searchCache
]
