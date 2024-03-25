# PowerShell-Scripts
Just some PowerShell scripts I use.
**Remember to connect to Microsoft Graph and/or Exchange Online!**

<br>

`create_M365_memberOf_group.ps1`
<details>
<summary>What's its deal?</summary>
  
> This script takes a group name & email nickname  
> Checks if there are groups called `groupName`, `groupName+"_Manual"`, `groupName+"_Dynamic"`  
> If there aren't, it makes them  
> Most importantly, it gives the group `groupName` the dynamic rule `"user.memberof -any (group.objectId -in ['$($group_manual.id)', '$($group_dynamic.id)'])"`
</details>
<br>

`disable_group_welcomes.ps1`
<details>
<summary>What's its deal?</summary>

> Gets all your M365 groups  
> Checks if they have welcome messages enabled
> If they do, it turns them off  
</details>
<br>

`get_users_in_group.ps1`
<details>
<summary>What's its deal?</summary>

> Exactly what it says on the tin  
> Takes a `GroupID` as input  
</details>
<br>

`get_device_users.ps1`
<details>
<summary>What's its deal?</summary>

> Using the Microsoft Graph ==Beta==  
> It gets all the registered devices  
> Gets what userid most recently signed in  
> Gets that user's display name  
> Displays it all in a `Format-Table` table  
</details>
<br>
