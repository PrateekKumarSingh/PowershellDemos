# Powershell Extension on Visual Studio Code - Demo

This extension provides rich PowerShell language support for Visual Studio Code. 
Now you can write and debug PowerShell scripts using the excellent IDE-like interface that Visual Studio Code provides.

## Installation

- [Instructions to Install VScode and powershell Extension](https://github.com/PowerShell/PowerShell/blob/master/docs/learning-powershell/using-vscode.md)

- One-Liner to download VScode and install Powershell Extension **[Requires Powershell v5]**

     **`Install-Script Install-VSCode -Scope CurrentUser; Install-VSCode.ps1`**

## Why to use VSCode? When I have ISE!
*   Open source! runs on Linux, Mac and Windows. Same Scripting experience on all OS in a Hybrid environment
*   Powershell extension for Visual studio code has been downloaded by 800,000+ times, that means something!
*   Version 1.0 has been released in May and its already very popular
*   Powershell is not only for small tasks and quick automation fixes,
    and IDE makes it easy to develop complex automation projects for On Prem and Cloud technologies

### A. Features
1. Syntax highlighting
2. Intellisense
3. Code Completion
4. Snippets
5. Peek/GoTo definition of Functions, Cmdlets & Variables
6. Find References
7. Text Encoding
8. Indent Customization
9. Global Search / Replace
10. Version/Source Control integration [Git]
11. Run selection       **[F8]**
12. Launch Online help  **[Ctrl+F1]**
13. Command Palette     **[Ctrl+Shift+P]** 
14. Powershell Gallery Integration and more...
### B. Performance   
- Light weight IDE (Integrated development Enviroment)    
- Also makes you write scripts faster
    * Rich text editing feartues and Looks ups
    * Very Keyboard Friendly
    * Below is a oneliner to download **VSCode cheat sheet for Keyboard shortcuts on Windows**
    
    **`(iwr "https://github.com/PrateekKumarSingh/CheatSheets").Links | ?{$_.title -Like "*VSCODE*windows*"} | %{iwr "http://github.com$($_.href)?raw=true" -OutFile $_.title -Verbose}`**

### C. Extensibility
-   Doesn't matter what language you are using like, Powershell, C#, Java, Python
    You can add rich editing, build and more features using the extensions to inhance you overall experience.

-   Rich extension ecosystem - More than thousands of extensions available
    * Language Support - **Powershell, C#, Python, Perl, PHP, HTML** etc.
    * MSSQL, Docker, Git History, Markdown
    * Stack Overflow/ Google search and much more

### D. Microsoft is heavily investing on VSCode
- No more active development on Powershell ISE in recent years.
- Infact [Powershell team](https://twitter.com/PowerShell_Team) at Microsoft & even powershell Community actively contributes to Powershell Extension on VSCode
    * [@daviwil](https://twitter.com/daviwil) - Maintainer of VSCode-Powershell Extension
- and it would be no wonder if VSCode starts getting shipped with Windows OS few years down the line    
- Very fast development, Issues reported are getting tracked and there are quick bugfixes
    * Any one can [Report Issues](https://github.com/PowerShell/vscode-powershell/issues) here
    * These guys fix issues pretty fast - `Start-Process https://twitter.com/jsnover/status/867697579504611328`

## What Powershell-VSCode ext can't do but ISE can? I mean as of now ;)
- Remote runspace tabs
- Language aware code folding

## VSCode-Powershell Learning Resources
- [Setting up Visual Studio Code for PowerShell Development](https://www.youtube.com/watch?v=LJNdK0QrIo8) [Video]

- [Get started with PowerShell development in Visual Studio Code](https://blogs.technet.microsoft.com/heyscriptingguy/2016/12/05/get-started-with-powershell-development-in-visual-studio-code/) [Article]

- [Visual Studio Code editing features for PowerShell development – Part 1](https://blogs.technet.microsoft.com/heyscriptingguy/2017/01/11/visual-studio-code-editing-features-for-powershell-development-part-1/) [Article]

- [Visual Studio Code editing features for PowerShell development – Part 2](https://blogs.technet.microsoft.com/heyscriptingguy/2017/01/12/visual-studio-code-editing-features-for-powershell-development-part-2/) [Article]

- [Debugging PowerShell script in Visual Studio Code – Part 1](https://blogs.technet.microsoft.com/heyscriptingguy/2017/02/06/debugging-powershell-script-in-visual-studio-code-part-1/) [Article]

- [Debugging PowerShell script in Visual Studio Code – Part 2](https://blogs.technet.microsoft.com/heyscriptingguy/2017/02/13/debugging-powershell-script-in-visual-studio-code-part-2/) [Article]