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
		'actualOccurence'
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
DocSearchBook >> actualOccurence [
	^ searchCache at: actualOccurence
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

  aDocBook chapters do: [ :chapter|
		actualChapter := chapter.
		self indexOfSubstring: aSubString in: chapter source ]
]

{ #category : #search }
DocSearchBook >> indexOfSubstring: aSubString in: aString [
  | index i occurence |
  i := 1.
  occurence := 1.

  [ (i := aString findString: aSubString startingAt: i) > 0 ] whileTrue: [
    index := DocSearchIndex index: actualBook in: actualChapter at: occurence.
	 i := i + aSubString size.
	 occurence := occurence + 1.
	 searchCache add: index. 
	 nbOccurence := nbOccurence + 1 ]
]

{ #category : #initialization }
DocSearchBook >> initialize [
	super initialize.
	nbOccurence := 0.
	actualOccurence := 0.
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
	actualOccurence < searchCache size 
		ifTrue: [ actualOccurence := actualOccurence + 1 ]
]

{ #category : #actions }
DocSearchBook >> prev [
	actualOccurence > 1
		ifTrue: [ actualOccurence := actualOccurence - 1 ]
]

{ #category : #search }
DocSearchBook >> search: aSubString in: aDocLibrary [
	nbOccurence = 0.
	searchCache := OrderedCollection new.
	self indexOfBooks: aSubString in: aDocLibrary.
	actualOccurence := 1
]

{ #category : #accessing }
DocSearchBook >> searchCache [
	^ searchCache
]
