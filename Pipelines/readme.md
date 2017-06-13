
# What is pipeline?

Pipelining is an important technique when the operation you are performing, such as reading files of indeterminate length, or processing collections of large objects, requires you to conserve memory resources by breaking a large task into its atomic components. If you get it wrong, you don’t get that benefit. While PowerShell provides an ample supply of constructs for pipelining, it is all too easy to write code that simply does not pipeline at all.

# So why is pipelining important?

* pipelining is helpful to conserve memory resources. Say you want to modify text in a huge file. Without a pipeline effect you might read the huge file into memory, modify the appropriate lines, and write the file back out to disk. If it is large enough you might not even have enough memory to read the whole thing.

* Pipelining can substantially improve actual performance. Commands in a pipeline are run concurrently-even if you have only a single processor, because when one process blocks, for example, while reading a large chunk of your file, then another process in the pipeline can do a unit of work in the meantime.
Pipelining can have a significant effect on your end-user experience, enhancing the perceived performance dramatically. If your end-user executes a sequence of commands that takes 60 seconds, then without pipelining the user sees nothing until the end of that 60 seconds, while with pipelining output might start appearing in just a couple seconds.


one object at a time

## Pipeline variable\object\data
* $_
* $PSItem
* $input

1..5|%{$_}

