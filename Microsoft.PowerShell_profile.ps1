#(@(& "$env:LOCALAPPDATA/Programs/oh-my-posh/bin/oh-my-posh.exe" init pwsh --config="$env:POSH_THEMES_PATH/pure.omp.json" --print) -join "`n") | Invoke-Expression

& ([ScriptBlock]::Create((oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" --print) -join "`n"))
#$modulos = @('Terminal-Icons', 'Selenium')  

#foreach ($modulo in $modulos) {
  #if (Get-Module -ListAvailable -Name $modulo) {
    #Import-Module $modulo
  #}
#}
#Import-Module Terminal-Icons
set-psreadlineoption -PredictionViewStyle ListView -PredictionSource History
set-psreadlinekeyhandler -key Tab -Function menucomplete

function lsi {
  param(
      [string]$Filter,
      [switch]$Force
      )
  Write-Host "Name"
  Write-Host "----"
  $params = @{}
  if($Force){
    $params["Force"] = $true
  }
#Get-ChildItem -Filter $Filter | ForEach-Object { $_ | Format-TerminalIcons }    
  get-childitem -filter $filter @params| foreach-object { $_ | format-terminalicons }    
  write-host "`n"
}

function fzf-cd { Set-Location (Get-ChildItem -Name -Directory | fzf) }

function fzf-service { get-service | select status,name | fzf }

function fzf-history {
  $command = Get-History | Select-Object -ExpandProperty CommandLine | fzf
  if ($command) {
    Invoke-Expression $command
  }
}
function fzf-kill-process {
    $process = Get-Process | fzf
    Stop-Process -Id $process.Id
}


function stat {
  param([string]$Path)
    $item = Get-Item -Path $Path
    $size = $item.Length
    switch ($size) {
      {$_ -gt 1TB} { $sizeString = "{0:N2} TB" -f ($size / 1TB); break }
      {$_ -gt 1GB} { $sizeString = "{0:N2} GB" -f ($size / 1GB); break }
      {$_ -gt 1MB} { $sizeString = "{0:N2} MB" -f ($size / 1MB); break }
      {$_ -gt 1KB} { $sizeString = "{0:N2} KB" -f ($size / 1KB); break }
      default { $sizeString = "$size Bytes"; break }
    }
  $properties = [PSCustomObject]@{
    Name = $item.Name
    Size = $sizeString
    FullName = $item.FullName
    CreationTime = $item.CreationTime
    LastWriteTime = $item.LastWriteTime
    LastAccessTime = $item.LastAccessTime
    Mode = $item.Mode
  }
  $properties|format-list
}

function chg-space {
  param ( [string]$path)
  if (-Not (Test-Path -Path $path)) {
    write-Host "El directorio no existe: $path"
    return
  }

  $items = Get-ChildItem -Path $path -Recurse

  foreach ($item in $items) {
    if ($item.Name -match ' ') {
      $newName = $item.Name -replace ' ', '-'
      $newPath = Join-Path -Path $item.DirectoryName -ChildPath $newName

      try {
        Rename-Item -Path $item.FullName -NewName $newName
        Write-Host "Renombrado '$($item.FullName)' a " -nonewline
        write-host "$newPath" -foregroundcolor green
      } catch {
        Write-Host "Error renombrando '$($item.FullName)': $_"
      }
    }
  }
}

function .. { cd (Get-Item -LiteralPath (pwd).Path).Parent.Parent }
function ... { cd (Get-Item -LiteralPath (pwd).Path).Parent.Parent.Parent }

# Funciones Git
function gst { git status }
function gcmm { param( [string]$m ) git commit -m $m } 
function glog { git log --oneline --decorate --graph }
function grv { git remote --verbose }
function gcf { git config --list }
function gd { git diff }


function sudo {
  param (
    [Parameter(Mandatory = $true)]
    [string]$Command
    )

  Start-Process pwsh -ArgumentList "-NoExit -Command $Command" -Verb RunAs
  #invoke-expression $command
}

function diskUsage {
  param ( [string]$Operator, [string]$Value )
  function convertto-bytes {
    param([string]$size)
    if ($size -match '(\d+)([kkmmgg]?)') {
      $number = [int]$matches[1]
      $unit = $matches[2].tolower()
      switch ($unit) {
        'k' { return $number * 1kb }
        'm' { return $number * 1mb }
        'g' { return $number * 1gb }
        default { return $number }
      }
    }
    else {
      throw "el tamaño proporcionado no es válido."
    }
  }

  $valueinbytes = convertto-bytes -size $value
  $validoperators = @{
    '-eq' = { $_.length -eq $valueinbytes }
    '-ne' = { $_.length -ne $valueinbytes }
    '-gt' = { $_.length -gt $valueinbytes }
    '-lt' = { $_.length -lt $valueinbytes }
    '-ge' = { $_.length -ge $valueinbytes }
    '-le' = { $_.length -le $valueinbytes }
  }

  if ($validoperators.containskey($operator)) {
    get-childitem -recurse -file | where-object {
      $validoperators[$operator].invoke($_)
    } | select-object @{name='size (mb)'; expression={[math]::round($_.length / 1mb, 2)}}, fullname
  }
  else {
    write-error "operador no válido: $operator"
  }
}

function cato{
  param ( [string]$path)

  $lineanumero = 1
  get-content $path | foreach-object {
    write-host "($lineanumero): $_"
    $lineanumero++
  }
}


function Get-SystemStatus {
  $status = @{
    Network = @()
    Memory = @()
    CPU = @()
    Disk = @()
    Battery = @()
  }

  $networkStats = Test-Connection google.com -count 6
    if ($networkStats | Where-Object { $_.Status -ne 0 }) {
      $status.Network += "Perdida de datos detectada $networkStats.status"
    } else {
      $status.Network += "Red estable"
    }

  $wifiAdapter = Get-NetAdapter | Where-Object { $_.MediaType -like '*802.11*'}
  if ($wifiAdapter) {
    $wifiSignal = (netsh wlan show interfaces) | Select-String -Pattern 'Signal|Señal' | ForEach-Object { $_.ToString().Split(':')[1].Trim() }
    $status.Network += "Signal 802.11: $wifiSignal"
  }

  $mem = Get-CimInstance -ClassName Win32_OperatingSystem
    $memUsagePercent = [math]::Round((($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory) / $mem.TotalVisibleMemorySize) * 100, 2)
    if ($memUsagePercent -lt 60) {
      $status.Memory += "OK"
    } else {
      $memProcesses = Get-Process | Sort-Object WS -Descending | Select-Object -First 5 | ForEach-Object { "$($_.Name): $([math]::Round($_.WS / 1MB, 2)) MB " }
      $status.Memory += "Alto, procesos: $memProcesses"
    }

  $cpuUsage = Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
    if ($cpuUsage -lt 20) {
      $status.CPU += "OK"
    } else {
      $cpuProcesses = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | ForEach-Object { "$($_.Name): $($_.CPU)MB" }
      $status.CPU += "Alto, procesos: $cpuProcesses"
    }

  $diskUsage = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Provider -like '*FileSystem*' }
  $diskQueue = Get-CimInstance -ClassName Win32_PerfFormattedData_PerfDisk_LogicalDisk | Where-Object { $_.Name -eq '_Total' }

  if ($diskQueue.PercentDiskTime -lt 10) {
    foreach ($disk in $diskUsage) {
      if($disk.name -ne 'temp'){
        $percentUsed = [math]::Round(($disk.Used / ($disk.Used + $disk.Free)) * 100, 2)
        $freeSpaceGB = [math]::Round($disk.Free / 1GB, 2)
        $status.Disk += "$($disk.Name): $percentUsed% lleno $freeSpaceGB GB libre "
      }
    }
  } else {
    $ioProcesses = Get-Process | Sort-Object -Property IOReadBytes -Descending | Select-Object -First 3 | ForEach-Object {
      "$($_.Name): $([math]::Round($_.IOReadBytes / 1MB, 2)) MB leídos, $([math]::Round($_.IOWriteBytes / 1MB, 2)) MB escritos"
    }
    $status.Disk += "Alto, procesos: $ioProcesses"
  }

  $battery = Get-CimInstance -ClassName Win32_Battery
    if ($battery) {
      $status.Battery += "Batería: $($battery.EstimatedChargeRemaining)% restante"
    } else {
      $status.Battery += "Información de batería no disponible"
    }

  return $status
}


