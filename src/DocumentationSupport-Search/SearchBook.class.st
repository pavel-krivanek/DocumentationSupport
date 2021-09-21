"
I search the index of all substring's occurence in a `DocLibrary` that I register in my searchCache
"
Class {
	#name : #SearchBook,
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
SearchBook >> actualBook [
	^ actualBook
]

{ #category : #accessing }
SearchBook >> actualChapter [
	^ actualChapter
]

{ #category : #accessing }
SearchBook >> actualIndex [
	^ actualIndex
]

{ #category : #accessing }
SearchBook >> firstOccurence [
	^ searchCache first
		ifAbsent: [ ^ SearchIndex new ]
]

{ #category : #search }
SearchBook >> indexOfBooks: aSubString in: aDocLibrary [

  aDocLibrary books do: [ :book |
		actualBook := book key.
		self indexOfChapters: aSubString in: book ]
]

{ #category : #search }
SearchBook >> indexOfChapters: aSubString in: aDocBook [

  aDocBook chapters do: [ :chapter |
		actualChapter := chapter key.
		self indexOfSubstring: aSubString in: chapter source ]
]

{ #category : #search }
SearchBook >> indexOfSubstring: aSubString in: aString [
  | index i |
  i := 0.
  [ (i := aString findString: aSubString startingAt: i + 1) > 0 ] whileTrue: [
    index := SearchIndex index: actualBook in: actualChapter at: i.
	 searchCache add: index. 
	 nbOccurence := nbOccurence + 1 ]
]

{ #category : #initialization }
SearchBook >> initialize [
	super initialize.
	nbOccurence := 0
]

{ #category : #accessing }
SearchBook >> lastOccurence [
	^ searchCache last 
		ifAbsent: [ ^ SearchIndex new ]
]

{ #category : #accessing }
SearchBook >> nbOccurence [
	^ nbOccurence
]

{ #category : #actions }
SearchBook >> next [
	| collection |
	collection := OrderedCollection new.
	collection add: actualBook;
	add: actualChapter;
	add: actualIndex.
	collection = lastOccurence ifFalse: [ 
		searchCache doWithIndex: [ :book :i | 
		(i >= actualBook and: [ self nextBook: book ]) ifTrue: [ 
			^ true ].
		i >= actualBook ifTrue: [ 
			actualBook := actualBook + 1.
			actualChapter := 1.
			actualIndex := 0 ] ].
		 ].
	
	^ false
]

{ #category : #actions }
SearchBook >> prev [
	| tmp collection |
	collection := OrderedCollection new.
	collection add: actualBook;
	add: actualChapter;
	add: actualIndex.
	collection = firstOccurence ifFalse: [
	searchCache keys reverseWithIndexDo: [ :key :i |
		(i <= actualBook and: [ self prevBook: (searchCache at: key) ]) ifTrue: [ 
			^ true ].
		actualBook > 1 ifTrue: [ 
			actualBook := actualBook - 1.
			actualChapter := (searchCache at: (searchCache keys  at: actualBook)) size.
			tmp := searchCache at: (searchCache keys at: actualBook).
			actualIndex := ((tmp) at: (tmp keys at: actualChapter)) size ] ]
	].
	^ false
]

{ #category : #search }
SearchBook >> search: aSubString in: aDocLibrary [
	nbOccurence = 0.
	searchCache := OrderedCollection new.
	self indexOfBooks: aSubString in: aDocLibrary.
	actualPosition := 1
]
