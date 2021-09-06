title: 'Documentation entities'
key: '9oyk5dgkepkaexj58cjea76jk'
parent: '91bclk1izenja63tom5j39v34'
nextChapter: '3z9zm74a6w6vnk79244tykdrk'

# Documentation entitites

The documentation is organized into libraries, books and chapters.

### Chapter

The basic documentation entity is a **chapter** (`DocChapter`). The chapter has a title and contains a single `Microdown` document with references to other chapters.

A chapter has a given title and can link another chapter that is supposed to be read as the next one. 

Every chapter can have other chapters as their own subchapters so they can build a complex tree.

Every chapter has its **unique key**.  The title can be changed but not the key.

[Chapters](include://3z9zm765drcfzotsq9dvc48d4)

### Book

Book is a collection of chapters. The order or chapters inside the book is not strictly given, but it may be explicitly set by defining next (following) chapters for given chapters. If the order is not set, the alphabetical order is used. 

Every book has its **unique key**. The title can be changed but not the key.

### Libraries

A library is a collection of books. References between chapters are limited to one library. A library is identified by its name. Libraries have associated repositories. 

### Library repository

A library repository is a repository that contains one or more libraries. It is associated with the way how the repository is stored (e.g. on a disc). It is not directly related to a Git repository.

[Libraries](include://9oyk5dkpk8vy8zfy0i9emf2ug)
 


