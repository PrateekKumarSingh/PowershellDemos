# PowerShell Classes

PowerShell is object-oriented programming languages, which means that almost everything is implemented using a special programming construct called classes, which are used to create objects that have properties and functionalities, like any real-world object. Before we dig deep into this, let's just quickly understand the basics of `classes`, `objects` and its members.

Generally speaking, a `class` is :

* a category
* a set
* a classification 

that has some attribute in common and can be differentiated from other classes by kind, type, or quality. 

'Human' is a class, and that is different from 'Animal' class. But in terms of programming languages, especially PowerShell a `class` is a template for creating instances of the class, also known as objects.

The simplest way to create a class 'Human', with some properties and functionalities in PowerShell is using the `class` keyword, followed by the name of the class, then body of class enclosed in brackets `{ }`.

```PowerShell
class Human
{
    # this is a property/attribute
    [String]$Name = 'homo sapiens'
    [Int] $Age = 5

    # method definition of a class
    eat(){
        Write-Host $this.Name 'is eating'
    }

    run(){
        Write-Host $this.Name 'is running'
    }
}
```

### Object

Objects are instances of a category (class) that has some attributes (properties) and performs some functions (methods). Just for the sake of making things simpler here let us suppose there is a category or a classification called as 'Human', Humans represent us together as a species, but if you take an instance of this class Human, let's suppose 'John' then John is an Object of the class human. 'John' has all attributes and functionalities of the class 'Human' of which he is an instance because all objects are created from the same class template.

### Attributes or Properties or characteristics

Attribute or Property is just another word for the characteristic of an object, like -

* name
* height
* weight

### Functionalities or Methods

Functionalities are actions performed by the object and can be called Methods in terms of programming languages.

* eat()
* sleep()
* talk()

#### Note
* Functions and Methods are often used interchangeably, **which is incorrect!**.
* A Method is a function defined inside the body of the class and to access a method you have to use the (` . `) Dot operator on the object of the class.
* A function on another hand can be a standalone, not necessarily in a class.

### Instantiating the Class, or creating an Object

PowerShell objects are created using the `New-Object` cmdlet, followed by the name of the class.

```PowerShell
$prateek = New-Object Human

# alternatively
$john = [Human]::new()
```

### Accessing Attributes and Functions of an Objects

In order to access the attributes and functions of an object, both PowerShell and Python use a Dot (`.`) operator. That means, to access the `height` property or `talk()` method of object 'John' in PowerShell, you would write some like this:

```PowerShell
$john.height
$john.eat()
```

## 'Get-Member' cmdlet in PowerShell

In PowerShell to introspect members of an object we pass the object to the `Get-Member` cmdlet directly or through the pipeline.

Methods and Properties of an object are also called as '`Members`' of the object, this is the reason behind the name of the cmdlet, i.e. `'Get' (Verb) 'Member' (Noun)` as per the PowerShell's 'Verb-Noun' syntax of a cmdlet. `Get-Member` cmdlet will return the member(Status) of an object passed to it.

```PowerShell
# object as an argument to the input object parameter
Get-Member -InputObject 1

# object through the pipeline
"String" | Get-Member
```

![](images/Chapter5-PSGetMember.jpg)

If you look closely in the output of `Get-Member` cmdlet, first you'll notice a '`TypeName`' which is the data type of the object passed to the cmdlet, like `System.String`, `System.Int32` or `System.Object[]`.

Next are properties, with `MemberType` as '`Property`' which is a characteristic of the object like `Rank`, `Count`, `Length` and `IsReadOnly`, and finally the '`Methods`' of the object like `Add()`, `Remove()` or `ToString()` that represent functionalities that can be performed on the object.

Inspecting the object in PowerShell provides an understanding of properties and methods available in the object.
-----------


The following list describes the properties that are added when you use the Force parameter:

* PSBase: The original properties of the .NET Framework object without extension or adaptation. These are the properties defined for the object class and listed in MSDN.
* PSAdapted: The properties and methods defined in the Windows PowerShell extended type system.
* PSExtended: The properties and methods that were added in the Types.ps1xml files or by using the Add-Member cmdlet.

```PowerShell
gsv bits -ov p
$p | Add-Member -MemberType NoteProperty -Name test -Value test
$p | gm -f
```

* PSObject: The adapter that converts the base object to a Windows PowerShell PSObject object.

* PSTypeNames: A list of object types that describe the object, in order of specificity. When formatting the object, Windows PowerShell searches for the types in the Format.ps1xml files in the Windows PowerShell installation directory ($pshome). It uses the formatting definition for the first type that it finds

* PSStandardMembers: 

```PowerShell
# how to add custom typenames to objects

$a = [pscustomobject]@{a=1;b=2}
$a
$a |gm
$a.pstypenames.Clear()
$a.pstypenames.Add('Prateek')
$a |gm

# also
$a.psobject.TypeNames.Insert(0,'new')

# alternatively
$widget = [pscustomobject]@{    PSTypeName = 'Widget';Color = $null;Size = $null}
```


------------

# Understanding getters and setters

Write-host 'console' *>&1  | gm
$info = Write-host 'console' *>&1

# read-only properties
$info.tags = 'something'

# writable properties
$info.TimeGenerated = [datetime]::now

-----



# Using Static Classes and Methods

Not all .NET Framework classes can be created by using New-Object. For example, if you try to create a System.Environment or a System.Math object with New-Object, you will get the following error messages:


Copy-Item
PS> New-Object System.Environment
New-Object : Constructor not found. Cannot find an appropriate constructor for
Get-Content System.Environment.
At line:1 char:11
+ New-Object  <<<< System.Environment

PS> New-Object System.Math
New-Object : Constructor not found. Cannot find an appropriate constructor for
Get-Content System.Math.
At line:1 char:11
+ New-Object  <<<< System.Math
These errors occur because there is no way to create a new object from these classes. These classes are reference libraries of methods and properties that do not change state. You don't need to create them, you simply use them. Classes and methods such as these are called static classes because they are not created, destroyed, or changed. To make this clear we will provide examples that use static classes.

## :: Static member operator
    Calls the static properties operator and methods of a .NET
    Framework class. To find the static properties and methods of an
    object, use the Static parameter of the Get-Member cmdlet.


       [datetime]::now


## checking method overload definitions


The System.Environment class contains general information about the working environment for the current process, which is powershell.exe when working within Windows PowerShell.

If you try to view details of this class by typing [System.Environment] | Get-Member, the object type is reported as being System.RuntimeType , not System.Environment:


Copy
PS> [System.Environment] | Get-Member

   TypeName: System.RuntimeType
To view static members with Get-Member, specify the Static parameter:


Copy
PS> [System.Environment] | Get-Member -Static


# how to check if a class is a static class
 [system.environment].GetConstructors()


# Get-Member

# .GetType().GetProperties()
# .GetType().GetMethods()

```PowerShell
$temp = 'Hello world!'
$temp.gettype().Getproperties() | ft name, membertype
$Temp | gm -membertype *Property
```

# Member types and meaning
|Member Type|Description|
|:--|:--|
|AliasProperty|An alias to another member|
|All|All member types|
|CodeMethod|A method defined as a reference to another method|
|CodeProperty|A property defined as a reference to a method|
|Dynamic|All dynamic members (where PowerShell cannot know the type of the member)|
|Event|All events|
|MemberSet|A set of members|
|Method|A method from the BaseObject|
|Methods|All method member types|
|NoteProperty|A prorperty defined by a Name-Value pair|
|ParameterizedProperty|A member that acts like a Property that takes parameters. This is not consider to be a property or a method.|
|Properties|All property member types|
|Property|A property from the BaseObject|
|PropertySet|A set of properties|
|ScriptMethod|A method defined as a script|
|ScriptProperty|A property defined by script language


## 

```PowerShell
'Hello' | gm 
# parameterized properties
'Hello'.chars
'Hello' | gm 

[pscustomobject]@{a=1;b=2}
$a |Add-Member -MemberType ScriptMethod -Name addvalues -Value {$this.'a' + $this.'b'}
```