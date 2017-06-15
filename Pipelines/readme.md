
# What is pipeline?

* Pipeline is a series of commands connected by the operator "**|**" called 'Pipe'
* Pipeline binds the results\output from 
Pipelining is an important technique when the operation you are performing, such as reading files of indeterminate length, or processing collections of large objects, requires you to conserve memory resources by breaking a large task into its atomic components. If you get it wrong, you don’t get that benefit. While PowerShell provides an ample supply of constructs for pipelining, it is all too easy to write code that simply does not pipeline at all.

# So why is pipelining important?

* Low memory foot print : Pipeline is helpful to conserve memory resources. Say you want to modify text in a huge file. Without a pipeline effect you might read the huge file into memory, modify the appropriate lines, and write the file back out to disk. If it is large enough you might not even have enough memory to read the whole thing.

* Pipelining can substantially improve actual performance. Commands in a pipeline are run concurrently-even if you have only a single processor, because when one process blocks, for example, while reading a large chunk of your file, then another process in the pipeline can do a unit of work in the meantime.

* Considering it enables to write less code and Time taken to write code

* Objects are process as soon as they are sent to the pipeline, which can have a significant effect on your end-user experience, enhancing the perceived performance dramatically. 
If your end-user executes a sequence of commands that takes 60 seconds, then without pipelining the user sees nothing until the end of that 60 seconds, while with pipelining output might start appearing in just a couple seconds.

* One-liners are comparitively easy to write from a powershell console, instead of writing a multi-lines of code


# Drawbacks of pipeline
* Not very fast, there is a performance penalty that comes with Pipelines

# Foreach vs Foreach-Object

# Where you can use PipeLines?

* With Powershell Cmdlets (Obviously!)
    `Get-Service Bits | Stop-Service`
* With native windows commands
    1. `Ipconfig | Where{$_ -like "*.*.*.*"}` - You can pipe native win command to a cmdlet
    2. `Ipconfig | findstr` - You can pipe native win command to a native windows command
    3. `Get-WMIObject win32_computersystem |findstr "Model"` - You can pipe cmdlet to a win native command

# How PipeLine Works
* When you "pipe" objects, that is send the objects in the output of one command to another command, Windows PowerShell tries to associate the piped objects with one of the parameters of the receiving cmdlet.
[](/Images/PictorialView.jpg)
1. one object at a time (Proof using the Get-Member cmdlet)
2. Accept value from Pipeline (Use Get-member/Get-Help to understand)

    - **By Value**
        Parameters that accept input "by value" can accept piped objects that have the same .NET type as their parameter value or objects that can be converted to that type.
    - **By Name**
        Parameters that accept input "by property name" can accept piped objects only when a property of the object has the same name as the parameter.

    - Examples
3. parameter binding using trace-object
4. Begin process end

## Pipeline variable\object\data
* $_
* $PSItem
* $input

1..5|%{$_}


# Learning resources

* [Ins and Outs of the PowerShell Pipeline](https://www.simple-talk.com/sysadmin/powershell/ins-and-outs-of-the-powershell-pipeline/) [Article]
* [A Study in PowerShell Pipelines, Functions, and Parameters](https://www.simple-talk.com/dotnet/.net-tools/down-the-rabbit-hole--a-study-in-powershell-pipelines,-functions,-and-parameters/) [Article]


