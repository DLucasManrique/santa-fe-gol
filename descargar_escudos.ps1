# Santa Fe GOL - Descargar escudos reales a la carpeta del proyecto
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$folder = Join-Path $root 'escudos'
New-Item -Path $folder -ItemType Directory -Force | Out-Null
$headers = @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/125.0.0.0 Safari/537.36'; 'Referer' = 'https://lsf.ar/' }
$logos = @(
    @{ File = "dc.jpg"; Url = "https://lsf.ar/est/escudos/e_Colon%20de%20San%20Justo.jpg" }
    @{ File = "an.jpg"; Url = "https://lsf.ar/est/escudos/e_Sanjustino.jpg" }
    @{ File = "uo.jpg"; Url = "https://lsf.ar/est/escudos/6881d942b676e_e_La%20Perla.jpg" }
    @{ File = "er.jpg"; Url = "https://lsf.ar/est/escudos/e_Sportivo%20Guadalupe.jpg" }
    @{ File = "lt.jpg"; Url = "https://lsf.ar/est/escudos/6881db4e8625d_la%20salle%20jobson.jpg" }
    @{ File = "sl.jpg"; Url = "https://lsf.ar/est/escudos/e_Nautico%20El%20Quilla.jpg" }
    @{ File = "dr.jpg"; Url = "https://lsf.ar/est/escudos/e_Union.jpg" }
    @{ File = "ju.jpg"; Url = "https://lsf.ar/est/escudos/e_Juventud%20Unida.jpg" }
    @{ File = "cr.jpg"; Url = "https://lsf.ar/est/escudos/e_Ciclon%20Racing.jpg" }
    @{ File = "no.jpg"; Url = "https://lsf.ar/est/escudos/e_Nobleza.jpg" }
    @{ File = "co.png"; Url = "https://thumb.wikimedia.org/wikipedia/commons/thumb/6/68/Escudo_Colon_Con_Estrella.png/500px-Escudo_Colon_Con_Estrella.png?utm_source=es.wikipedia.org&utm_campaign=index&utm_content=thumbnail" }
    @{ File = "cos.jpg"; Url = "https://lsf.ar/est/escudos/6a041cf434cb9_e_Cosmos.jpg" }
    @{ File = "at.jpg"; Url = "https://lsf.ar/est/escudos/6881d8c028129_ateneo.jpg" }
    @{ File = "gy.jpg"; Url = "https://lsf.ar/est/escudos/e_Gimnasia%20y%20Esgrima.jpg" }
    @{ File = "cn.jpg"; Url = "https://lsf.ar/est/escudos/e_Ciclon%20Norte.jpg" }
    @{ File = "in.jpg"; Url = "https://lsf.ar/est/escudos/e_Independiente.jpg" }
    @{ File = "unl.jpeg"; Url = "https://lsf.ar/est/escudos/6881d99db8678_UNL.jpeg" }
    @{ File = "na.jpg"; Url = "https://lsf.ar/est/escudos/e_Nacional.jpg" }
    @{ File = "new.jpg"; Url = "https://lsf.ar/est/escudos/e_Newells.jpg" }
    @{ File = "ac.png"; Url = "https://lsf.ar/est/escudos/6881d96c36577_e_Academia%20AC.png" }
    @{ File = "lf.jpg"; Url = "https://lsf.ar/est/escudos/6881d85da51b9_e_Las%20Flores.jpg" }
    @{ File = "dsr.jpg"; Url = "https://lsf.ar/est/escudos/6881d3942a949_e_Santa%20Rosa.jpg" }
 )
$ok=0; $failed=0
foreach($logo in $logos){
    $path = Join-Path $folder $logo.File
    try {
        Invoke-WebRequest -Uri $logo.Url -Headers $headers -OutFile $path -TimeoutSec 25 -MaximumRedirection 5
        $bytes=(Get-Item $path).Length
        if($bytes -lt 100){throw "Archivo demasiado pequeno ($bytes bytes)"}
        [byte[]]$sig = [System.IO.File]::ReadAllBytes($path)
        $jpg = $sig.Length -ge 3 -and $sig[0] -eq 255 -and $sig[1] -eq 216 -and $sig[2] -eq 255
        $png = $sig.Length -ge 8 -and $sig[0] -eq 137 -and $sig[1] -eq 80 -and $sig[2] -eq 78 -and $sig[3] -eq 71
        if(-not ($jpg -or $png)){throw "El servidor no entrego una imagen JPG/PNG valida"}
        Write-Host "OK: $($logo.File) ($bytes bytes)" -ForegroundColor Green
        $ok++
    } catch {
        if(Test-Path $path){Remove-Item $path -Force}
        Write-Host "ERROR: $($logo.File) - $($_.Exception.Message)" -ForegroundColor Yellow
        $failed++
    }
}
Write-Host "Listo: $ok escudos descargados, $failed fallaron" -ForegroundColor Cyan
Write-Host "Ahora subi index.html y la carpeta escudos a GitHub con git add . / commit / push."
