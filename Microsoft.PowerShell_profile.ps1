#(@(& "$env:LOCALAPPDATA/Programs/oh-my-posh/bin/oh-my-posh.exe" init pwsh --config="$env:POSH_THEMES_PATH/pure.omp.json" --print) -join "`n") | Invoke-Expression

& ([ScriptBlock]::Create((oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" --print) -join "`n"))
#$modulos = @('Terminal-Icons', 'Selenium')  

#foreach ($modulo in $modulos) {
  #if (Get-Module -ListAvailable -Name $modulo) {
    #Import-Module $modulo
  #}
#}
#Import-Module Terminal-Icons
Set-PSReadLineOption -PredictionViewStyle ListView -PredictionSource History 
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
    Get-ChildItem -Filter $Filter @params| ForEach-Object { $_ | Format-TerminalIcons }    
    Write-Host "`n"
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

function stat{
  param([string]$Path)
  Get-Item -Path $Path | Format-List
}



function Buscar-Google {
    param ( [string]$query)

    $chromeDriverPath = "$env:USERPROFILE/Downloads/chromedriver-131/"
    $chromeDriverService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($chromeDriverPath)
    $chromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
    $chromeOptions.AddArgument("--headless")  

    try {
        $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeDriverService, $chromeOptions)
    } catch {
        Write-Output "Error al iniciar el navegador: $_"
        return
    }

    if ($null -eq $driver) {
        Write-Output "El driver no se ha creado correctamente."
        return
    }

    #write-output $driver
    $encodedQuery = [uri]::EscapeDataString($query)
    $url = "https://www.google.com/search?q=$encodedQuery"
    $driver.Navigate().GoToUrl($url)
    $pageSource = $driver.PageSource
    #Write-Output $pageSource

    $blockComponent = $pageSource | Select-String -Pattern 'data-exchange-rate="([^"]+)"'

    if ($blockComponent) {
        $exchangeRateMatch = [regex]::Match($blockComponent.Line, 'data-exchange-rate="([^"]+)"')
        if ($exchangeRateMatch.Success) {
            $exchangeRate = $exchangeRateMatch.Groups[1].Value
            Write-Output "search: $exchangeRate"
        } else {
            Write-Output "No se encontró el valor."
        }
    } else {
        Write-Output "No se encontró el componente de interés."
    }
    if ($null -ne $driver) {
        Stop-SeDriver $driver
    } else {
        Write-Output "No hay ningún driver para detener."
    }
}



function chg-space {
  param ( [string]$path)
  if (-Not (Test-Path -Path $path)) {
    Write-Host "El directorio no existe: $path"
      return
  }

  $items = Get-ChildItem -Path $path -Recurse

  foreach ($item in $items) {
    if ($item.Name -match ' ') {
      $newName = $item.Name -replace ' ', '-'
      $newPath = Join-Path -Path $item.DirectoryName -ChildPath $newName

      try {
        Rename-Item -Path $item.FullName -NewName $newName
        Write-Host "Renombrado '$($item.FullName)' a '$newPath'"
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

function sudo {
  param (
    [Parameter(Mandatory = $true)]
    [string]$Command
    )

  Start-Process pwsh -ArgumentList "-NoExit -Command $Command" -Verb RunAs
  #invoke-expression $command
}
