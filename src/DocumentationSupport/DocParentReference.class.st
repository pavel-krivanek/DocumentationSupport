"
I am a helping object for serialization of documentation chapters. The references are kept only in form of references identified by a key. When the objects with a given key are known, the helping references are replaced by real object references.
"
Class {
	#name : #DocParentReference,
	#superclass : #Object,
	#instVars : [
		'key'
	],
	#category : #'DocumentationSupport-Serialization'
}

{ #category : #'instance creation' }
DocParentReference class >> key: aKey [ 

	^ self new key: aKey
]

{ #category : #testing }
DocParentReference >> isParentReference [ 

	^ true
]

{ #category : #accessing }
DocParentReference >> key [

	^ key
]

{ #category : #accessing }
DocParentReference >> key: anObject [

	key := anObject
]
