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

  index := OrderedDictionary new.
  aBook chapters do: [ :chapter |
		index at: chapter key put: (self indexOfSubstring: aSubString in: chapter source) ].
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
