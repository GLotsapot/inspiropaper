function Folder-Clean {
    param (
        [Parameter(Mandatory)]
        $FolderPath,
        [int]
        $FilesToKeep = 25
    )

    # Check folder and remove excess files... randomly
    while($true){
        $files = Get-ChildItem -File -Path $FolderPath
        if($files.Count -ge $FilesToKeep)
        {
            $randomFileNum = Get-Random -Minimum 0 -Maximum $($FilesToKeep - 1)
            Write-Host "Deleting random inspiration #$randomFileNum"
            $files[$randomFileNum].Delete()
        } else {
            Write-Host "Ready to be inspired"
            break
        }
    }
}

function Get-Image {
    param (
        [Parameter(Mandatory)]
        $FolderPath
    )

    #Download new image
    $imageUri = Invoke-RestMethod -Uri https://inspirobot.me/api?generate=true -UserAgent "InspiroPaper"
    $filepath = Join-Path -Path $FolderPath -ChildPath $(Split-Path $imageUri -Leaf)
    Invoke-WebRequest -Uri $imageUri -OutFile $filepath -UserAgent "InspiroPaper"
    Write-Host "I feel inspired"
}

# Make sure the data folder exists
$path = Join-Path -Path $Env:ProgramData -ChildPath "inspiro"
if(!(Test-Path $path)) { New-Item -Path $path -ItemType "directory" }
Write-Host "Saving inspiration to $path"


Folder-Clean -FolderPath $path -FilesToKeep 50
Get-Image -FolderPath $path