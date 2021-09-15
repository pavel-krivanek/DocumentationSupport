"
I search the index of all substring's occurence in a `DocLibrary` that I register in my searchCache
"
Class {
	#name : #SearchBook,
	#superclass : #Object,
	#instVars : [
		'searchCache',
		'nbOccurence',
		'firstOccurence',
		'lastOccurence',
		'actualBook',
		'actualChapter',
		'actualIndex'
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
	^ firstOccurence
]

{ #category : #search }
SearchBook >> indexOfBooks: aSubString in: aDocLibrary [
  | index |

  index := OrderedDictionary new.
  aDocLibrary books do: [ :book |
		index at: book key put: (self indexOfChapters: aSubString in: book) ].
  ^ index
]

{ #category : #search }
SearchBook >> indexOfChapters: aSubString in: aDocBook [
  | index |

  index := OrderedDictionary new.
  aDocBook chapters do: [ :chapter |
		index at: chapter key put: (self indexOfSubstring: aSubString in: chapter source) ].
  ^ index
]

{ #category : #search }
SearchBook >> indexOfSubstring: aSubString in: aString [
  | index i |

  index := OrderedCollection new.
  i := 0.
  [ (i := aString findString: aSubString startingAt: i + 1) > 0 ] whileTrue: [
    index addLast: i.
	 nbOccurence := nbOccurence + 1 ].
  ^ index
]

{ #category : #initialization }
SearchBook >> initialize [
	super initialize.
	nbOccurence := 0
]

{ #category : #initialization }
SearchBook >> initializeFirstOccurence [
	firstOccurence := OrderedCollection new.
	 searchCache ifNotEmpty: [ 
		searchCache doWithIndex: [ :book :i |
			actualBook := i.
			self initializeFirstOccurenceBook: book. ] 
		]
]

{ #category : #initialization }
SearchBook >> initializeFirstOccurenceBook: aBook [
	(firstOccurence isEmpty and: [ aBook isNotEmpty ]) ifTrue: [ 
		aBook doWithIndex: [ :chapter :i | 
			actualChapter := i.
			self initializeFirstOccurenceChapter: chapter
			]]
			
]

{ #category : #initialization }
SearchBook >> initializeFirstOccurenceChapter: aChapter [
		(firstOccurence isEmpty and: [ aChapter isNotEmpty ])
			 ifTrue: [ 
				actualIndex = 1.
				firstOccurence add: actualBook;
				add: actualChapter;
				add: 1 ]
]

{ #category : #accessing }
SearchBook >> nbOccurence [
	^ nbOccurence
]

{ #category : #search }
SearchBook >> search: aSubString in: aDocLibrary [
	nbOccurence = 0.
	searchCache := self indexOfBooks: aSubString in: aDocLibrary
]
