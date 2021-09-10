Class {
	#name : #SearchBook,
	#superclass : #Object,
	#instVars : [
		'searchCache'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #search }
SearchBook >> indexOfChapters: aSubString in: aBook [
  | index |

  index := OrderedCollection new.
  aBook chapters doWithIndex: [ :chapter :i |
		(chapter title includesSubstring: aSubString) 
			ifTrue: [ index addLast: i ] ].
  ^ index
]

{ #category : #search }
SearchBook >> indexOfSubstring: aSubString in: aString [
  | index i |

  index := OrderedCollection new.
  i := 0.
  [ (i := aString findString: aSubString startingAt: i + 1) > 0 ] whileTrue: [
    index addLast: i ].
  ^ index
]
