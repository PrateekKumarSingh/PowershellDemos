
# WHAT IS PIPELINE?

* Pipeline is a series of commands connected by the operator "**|**" called **'Pipe'**

    `Get-Process a* | ?{$_.Handles -gt 150} | Sort-Object -Property CPU`

* Pipeline binds the **results\outputs of one command entring from one side of the pipeline to another command on the other side** of the pipeline
    
    ![Example](./Images/PipelineExample.png?raw=true)

    ![Picture](./Images/PictorialView.jpg?raw=true)

* Important technique when you are performing operation, such as reading files of indeterminate length, 
    or processing collections of large objects to **conserve memory consumption** by **breaking a large task into its atomic components.**

   `NOTE : While PowerShell provides an ample supply of constructs for pipelining, it is all too easy to write code that simply does not pipeline at all.`


# ADVANTAGES

1. **Low Memory foot print :** Pipeline is helpful to conserve memory resources. Say you want to modify text in a huge file. Without a pipeline effect you might read the huge file into memory, modify the appropriate lines, and write the file back out to disk. If it is large enough you might not even have enough memory to read the whole thing.

2. **Concurrent Execution :** Pipelining can substantially improve actual performance. Commands in a pipeline are run concurrently (_**not parallel processing**_) , for example when one process is blocked while reading a large chunk of your file, then another process in the pipeline can do a unit of work in the meantime.

3. **Less Code :** Considering the lesser time taken by enabling us to [write less code](./Example1_Basic.ps1) using the pipelines. 
    Because, You don't have to declare variables, write loops etc.

4. **Quicker Object processing :** Objects are processed **as soon as they are sent to the pipeline**, which can have a significant effect on your end-user experience, enhancing the perceived performance dramatically. 

     If your end-user executes a sequence of commands that takes 60 seconds, then without pipelining the user sees nothing until the end of that 60 seconds, while with pipelining output might start appearing in just a couple seconds.

5. **Easy to write One-liners :** One-liners are comparitively easy to write from a powershell console, instead of writing a multi-lines of code



# DRAWBACKS (Because it's designed that way)

*   Not very fast **in most cases**, there is a performance penalty that comes with Pipelines
*   Its a trade-off between High Memmory Consumption and Speed. 
    Choice is yours there is nothing wrong or right, if you understand how and when to use Pipelines.


## Foreach vs Foreach-Object

Foreach statement                                           | Foreach-Object (% - Alias)
----------------------------------------------------------- |---------------------------------------------------------------------------
 More code usually                                          | Less code
 Faster                                                     | [Comparatively slower](./Example2_Speed.ps1)
 Loads all items upfront in Memory and then process them    | keeps processing the objects as they come through the pipe
 High Memory consumtion                                     | Less Memory utilization and [Better user XP](./Example3_UserExperience.ps1)



# HOW PIPELINE WORKS?
*   "Pipe"ing objects, is sending the output objects of one command to another command 
    through pipeline **one object at a time**
    Like, 
            ` Get-Service b* | Stop-Service `

    Proof that only one object passes through :            
    ```
        Get-service b* | get-member

                    VS 

        Get-Member -InputObject (Get-service b*)
    ```
*   Piped **objects are tried to associate** with one of the **parameters of the receiving cmdlet**.
    In order to do that recieving cmdlets are dsigned to Accept values from Pipeline

    Following are 2 ways through which cmdlet accept values from pipeline
    - **By Value** -
        Parameters that accept input [by value](./Example4_Valuefrompipeline.ps1) can accept piped objects that have the same .NET type as their parameter value or objects that can be converted to that type.
    - **By Name**
        Parameters that accept input [by property name](./Example5_ValuebyPropertyName.ps1) can accept piped objects only when a property of the object has the same name as the parameter.

    `Get-Help Stop-Service -full`
    `Get-Help Stop-Process | ForEach-Object{$_. parameters.parameter} | select name, pipelineinput, required`

*   To understand better parameter binding works, use the following commands

    `Trace-Command -Name ParameterBinding -PSHost -Expression { Get-ChildItem | Select-Object -f 1 }`

## Pipeline variables

1.  Current Pipeline object [ $_ or $PSItem ]

`    Get-Service |Where-Object{$_ -like "a*"}       `
`    Get-Service |Where-Object{$PSItem -like "a*"}  	`

2.  Automatic variable $input
`    Get-Service |Where-Object{$input -like "a*"}       `

## Where you can use PipeLines?

* With Powershell Cmdlets (Obviously!)
    `Get-Service Bits | Stop-Service`
* With native windows commands
    1. `Ipconfig | Where{$_ -like "*.*.*.*"}` - You can pipe native win command to a cmdlet
    2. `Ipconfig | findstr` - You can pipe native win command to a native windows command
    3. `Get-WMIObject win32_computersystem |findstr "Model"` - You can pipe cmdlet to a win native command
* Foreach-Object cmdlet lets you access pipeline blocks/variables and use them effieciently

    `1..4 | ForEach-Object -Begin {$Sum} -Process {$Sum += $_} -End {$Sum}`

* Functions that Accept pipeline inputs    
    

# Learning resources

* [Ins and Outs of the PowerShell Pipeline](https://www.simple-talk.com/sysadmin/powershell/ins-and-outs-of-the-powershell-pipeline/) [Article]
* [A Study in PowerShell Pipelines, Functions, and Parameters](https://www.simple-talk.com/dotnet/.net-tools/down-the-rabbit-hole--a-study-in-powershell-pipelines,-functions,-and-parameters/) [Article]


