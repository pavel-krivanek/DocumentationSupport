title: Chapters and references
key: 3z9zm765drcfzotsq9dvc48d4
parent: 9oyk5dgkepkaexj58cjea76jk
nextChapter: 

# Chapters and references

Chapters can build a tree of subchapters and can be linked using a **Next** chapter reference to build a logical order.  The order is specified only for chapters on the same level, so you do not need to link the subchapters.

To add a chapter into a book, select the book in the library tree and press the _Add chapter_ button.

## Subchapters

Every chapter can contain other chapters as subchapters. 

To create a subchapter or move a chapter from one book to another, drag the chapter in the library tree and place it on top of the parent chapter. Then select _Move_. 

## References

There are two kinds of references between chapters - `ref://` and `include://`

### Direct references (ref://)

Direct references directly link a given chapter. 

In Microdown, they are specified as URI references with protocol _ref_ and key associated with the chapter.  The direct reference then looks like this: `[Displayed reference text](ref://3z9zm765drcfzotsq9dvc48d4)`

To create a reference to a chapter, go to the referenced chapter and click on the button labelled "_ref://_". It will paste to the clipboard a Microdown string that defines the reference. Go to the place where you want to create the reference and paste the text from the clipboard.

### References with inclusion (include://)

They have a similar role as the direct references, but the difference is that exporters (e.g. to HTML) are supposed to directly include the referenced chapter on the place where the reference is. 

In Microdown, they are specified as URI references with protocol _include_ and key associated with the chapter.  The reference with inclusion then looks like this: `[Displayed reference text](include://3z9zm765drcfzotsq9dvc48d4)`

The reference with inclusion should be on a separate line.

### Reference to a next chapter

References to the next chapters help to define the order in the book.  

To define the next chapter, drag the chapter that is supposed to be the next one in the library tree and place it on top of the previous chapter. Then select _Set as next chapter_. Alternatively, you can drop the chapter directly to _Next_ field in the chapter editor. You can remove the reference in the chapter form by clicking on the button with the red cross next to the _Next:_ chapter field.

To go the to next chapter during documentation reading, click on the button with the green arrow next to the reference field.

