# Object Introspection

PowerShell is object-oriented programming languages, which means that almost everything is implemented using a special programming construct called classes, which are used to create objects that have properties and functionalities, like any real-world object. Before we dig deep into this, let's just quickly understand the basics of `classes`, `objects` and its members.

## Class, Object, Property, and Method

### Class

Generally speaking, a class is a category, set or a classification that has some attribute in common and can be differentiated from other classes by kind, type, or quality. For example, 'Human' is a class, and that is different from 'Animal' class. But in terms of programming languages, especially Python and PowerShell a `class` is a template for creating instances of the class, also known as objects.

The simplest way to create or define a class in Python and PowerShell is using the `class` keyword. For an example, let's create a simple class 'Human', with some properties and functionalities in Python, first thing first, you have to use the `class` keyword with the name of the class, followed by a colon (` : `). In the next line we change the indentation and provide a body of this class, as demonstrated in the following example:

PowerShell on other hand has some small syntactical changes, like the `class` body is now enclosed in brackets `{ }` and we are not using `def` keyword to define methods like in Python. But overall there are a lot of similarities how a basic class is defined in both scripting languages, as you can deduce from the previous and the following example of a class.

```PowerShell
class Human {
    # this is a property/attribute
    [String]$name = 'homo sapiens'
    [Int] $height = 5
    # method definition of a class
    eat(){
        Write-Host $this.name 'is eating now'
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

![Creating PowerShell Objects from a class](images\Chapter5-PSObjInstance.jpg)

### Accessing Attributes and Functions of an Objects

In order to access the attributes and functions of an object, both PowerShell and Python use a Dot (`.`) operator. That means, to access the `height` property or `talk()` method of object 'John' in PowerShell, you would write some like this:

```PowerShell
$john.height
$john.talk()
```

## 'Get-Member' cmdlet in PowerShell

In PowerShell to introspect members of an object we pass the object to the `Get-Member` cmdlet directly or through the pipeline.

Methods and Properties of an object are also called as '`Members`' of the object, this is the reason behind the name of the cmdlet, i.e. `'Get' (Verb) 'Member' (Noun)` as per the PowerShell's 'Verb-Noun' syntax of a cmdlet. `Get-Member` cmdlet will return the member(s) of an object passed to it.

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

![](images/Chapter5-PSGetMemberintro.jpg)


# Using Static Classes and Methods

Not all .NET Framework classes can be created by using New-Object. For example, if you try to create a System.Environment or a System.Math object with New-Object, you will get the following error messages:


Copy
PS> New-Object System.Environment
New-Object : Constructor not found. Cannot find an appropriate constructor for
type System.Environment.
At line:1 char:11
+ New-Object  <<<< System.Environment

PS> New-Object System.Math
New-Object : Constructor not found. Cannot find an appropriate constructor for
type System.Math.
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

# 
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
|ParameterizedProperty|A member that acts like a Property that takes parameters. |This is not consider to be a property or a method.
|Properties|All property member types|
|Property|A property from the BaseObject|
|PropertySet|A set of properties|
|ScriptMethod|A method defined as a script|
|ScriptProperty|A property defined by script language