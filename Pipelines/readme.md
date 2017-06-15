
# What is pipeline?

* Pipeline is a series of commands connected by the operator "**|**" called **'Pipe'**

    `Get-Process a* | ?{$_.Handles -gt 150} | Sort-Object -Property CPU`

* Pipeline binds the **results\outputs of one command entring from one side of the pipeline to another command on the other side** of the pipeline

    ![Picture](/pipelines/Images/PictorialView.jpg?raw=true)

    ![Example](/pipelines/Images/PipelineExample.png?raw=true)

* Important technique when the operation you are performing, such as reading files of indeterminate length, 
    or processing collections of large objects to **conserve memory consumption** by **breaking a large task into its atomic components.**

   `NOTE : While PowerShell provides an ample supply of constructs for pipelining, it is all too easy to write code that simply does not pipeline at all.`

# So why is pipelining important?

1. **Low Memory foot print :** Pipeline is helpful to conserve memory resources. Say you want to modify text in a huge file. Without a pipeline effect you might read the huge file into memory, modify the appropriate lines, and write the file back out to disk. If it is large enough you might not even have enough memory to read the whole thing.

2. **Concurrent Execution :** Pipelining can substantially improve actual performance. Commands in a pipeline are run concurrently (_**not parallel processing**_) , for example when one process is blocked while reading a large chunk of your file, then another process in the pipeline can do a unit of work in the meantime.

3. **Less Code :** Considering the lesser time taken by enabling us to write less code using the pipelines 

4. **Instant Object processing :** Objects are process **as soon as they are sent to the pipeline**, which can have a significant effect on your end-user experience, enhancing the perceived performance dramatically. 

     If your end-user executes a sequence of commands that takes 60 seconds, then without pipelining the user sees nothing until the end of that 60 seconds, while with pipelining output might start appearing in just a couple seconds.

5. **Easy to write One-liners :** One-liners are comparitively easy to write from a powershell console, instead of writing a multi-lines of code


# Drawbacks of pipeline (Because it's not built for that)

* Not very fast **in most cases**, there is a performance penalty that comes with Pipelines

# Foreach vs Foreach-Object


Foreach statement                   | Foreach-Object 
---------                           |----------------
 Speed                              | [Comparatively slower](Demo.ps1)
 [High Memory consumtion](Demo.ps1) | Less Memory utilization


# Where you can use PipeLines?

* With Powershell Cmdlets (Obviously!)
    `Get-Service Bits | Stop-Service`
* With native windows commands
    1. `Ipconfig | Where{$_ -like "*.*.*.*"}` - You can pipe native win command to a cmdlet
    2. `Ipconfig | findstr` - You can pipe native win command to a native windows command
    3. `Get-WMIObject win32_computersystem |findstr "Model"` - You can pipe cmdlet to a win native command

# How PipeLine Works
* When you "pipe" objects, that is send the objects in the output of one command to another command, Windows PowerShell tries to associate the piped objects with one of the parameters of the receiving cmdlet.


1. one object at a time (Proof using the Get-Member cmdlet)
2. Accept value from Pipeline (Use Get-member/Get-Help to understand)

    - **By Value**
        Parameters that accept input "by value" can accept piped objects that have the same .NET type as their parameter value or objects that can be converted to that type.
    - **By Name**
        Parameters that accept input "by property name" can accept piped objects only when a property of the object has the same name as the parameter.

    - Examples
3. parameter binding using trace-Command
4. Begin process end

## Pipeline variable\object\data
* $_
* $PSItem
* $input

1..5|%{$_}


# Learning resources

* [Ins and Outs of the PowerShell Pipeline](https://www.simple-talk.com/sysadmin/powershell/ins-and-outs-of-the-powershell-pipeline/) [Article]
* [A Study in PowerShell Pipelines, Functions, and Parameters](https://www.simple-talk.com/dotnet/.net-tools/down-the-rabbit-hole--a-study-in-powershell-pipelines,-functions,-and-parameters/) [Article]


