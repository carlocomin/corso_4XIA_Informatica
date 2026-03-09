$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Content
    )

    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

function New-MenuBlock {
    param(
        [Parameter(Mandatory = $true)][string]$Heading,
        [Parameter(Mandatory = $true)][array]$Items,
        [string]$ActivePath = ""
    )

    $lines = @(
        "<!-- BEGIN MENU -->",
        "<button class=""menu-toggle"" onclick=""toggleMenu()"">&#9776; Menu</button>",
        "<div class=""sidebar"" id=""menu"">",
        "  <h2>$Heading</h2>",
        "  <ul>"
    )

    foreach ($item in $Items) {
        $classAttr = if ($item.Path -eq $ActivePath) { ' class="active"' } else { "" }
        $lines += "    <li><a href=""$($item.Path)""$classAttr>$($item.Label)</a></li>"
    }

    $lines += @(
        "  </ul>",
        "</div>",
        "<!-- END MENU -->"
    )

    return ($lines -join "`r`n")
}

function Set-MenuBlock {
    param(
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$MenuBlock
    )

    if ($Content -match "<!-- BEGIN MENU -->") {
        return [regex]::Replace(
            $Content,
            "(?s)<!-- BEGIN MENU -->.*?<!-- END MENU -->",
            [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $MenuBlock },
            1
        )
    }

    $pattern = '(?s)<body>\s*<button class="menu-toggle".*?</div>\s*(?=<div class="slide">)'
    if ([regex]::IsMatch($Content, $pattern)) {
        return [regex]::Replace(
            $Content,
            $pattern,
            [System.Text.RegularExpressions.MatchEvaluator]{ param($m) "<body>`r`n$MenuBlock`r`n" },
            1
        )
    }

    throw "Blocco menu non trovato."
}

function Ensure-MenuJs {
    param(
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$ScriptSrc
    )

    if ($Content -match [regex]::Escape($ScriptSrc)) {
        return $Content
    }

    $menuScript = "<script src=""$ScriptSrc""></script>"

    if ($Content -match '<script src="[^"]*highlight\.js"></script>') {
        return [regex]::Replace(
            $Content,
            '(<script src="[^"]*highlight\.js"></script>)',
            [System.Text.RegularExpressions.MatchEvaluator]{ param($m) "$($m.Groups[1].Value)`r`n  $menuScript" },
            1
        )
    }

    return [regex]::Replace(
        $Content,
        '(<link rel="stylesheet" href="[^"]*style\.css"[^>]*>\s*)',
        [System.Text.RegularExpressions.MatchEvaluator]{ param($m) "$($m.Groups[1].Value)    $menuScript`r`n" },
        1
    )
}

function Remove-InlineToggleMenu {
    param([Parameter(Mandatory = $true)][string]$Content)

    $content = $Content
    $patterns = @(
        '(?m)^\s*function toggleMenu\(\)\s*\{[^\r\n]*\}\s*\r?\n?',
        '(?ms)^\s*function toggleMenu\(\)\s*\{.*?^\s*\}\s*\r?\n?'
    )

    foreach ($pattern in $patterns) {
        $content = [regex]::Replace($content, $pattern, '', 1)
    }

    $content = [regex]::Replace(
        $content,
        '(?ms)\r?\n<script>\s*function toggleMenu\(\)\s*\{.*?^\s*\}\s*</script>\s*(?=</body>)',
        ''
    )

    return $content
}

$rootItems = @(
    @{ Path = "lez1/lez1_1.html"; Label = "Lezione 1: Matrici 2D in C/C++" },
    @{ Path = "lez2/lez2_1.html"; Label = "Lezione 2: Struct in C/C++" },
    @{ Path = "lez3/lez3_1.html"; Label = "Lezione 3: File I/O in C/C++" },
    @{ Path = "lez4/lez4_1.html"; Label = "Lezione 4: OOP in C++" }
)

$lez1Items = @(
    @{ Path = "lez1_1.html"; Label = "L1.1 - Introduzione e obiettivi" },
    @{ Path = "lez1_2.html"; Label = "L1.2 - Definizioni, indici, row-major" },
    @{ Path = "lez1_3.html"; Label = "L1.3 - Dichiarazione e attraversamento" },
    @{ Path = "lez1_4.html"; Label = "L1.4 - I/O e utility" },
    @{ Path = "lez1_5.html"; Label = "L1.5 - Passare matrici a funzione" },
    @{ Path = "lez1_6.html"; Label = "L1.6 - Matrici dinamiche" },
    @{ Path = "lez1_7.html"; Label = "L1.7 - Operazioni base" }
)

$lez2Items = @(
    @{ Path = "lez2_1.html"; Label = "Lez2.1: Motivazione e sintassi base" },
    @{ Path = "lez2_2.html"; Label = "Lez2.2: Inizializzazioni in C/C++" },
    @{ Path = "lez2_3.html"; Label = "Lez2.3: Passaggio a funzione" },
    @{ Path = "lez2_4.html"; Label = "Lez2.4: Collezioni di struct e lambda" },
    @{ Path = "lez2_5.html"; Label = "Lez2.5: Layout, sizeof, padding e align" },
    @{ Path = "lez2_6.html"; Label = "Lez2.6: Serializzare le struct in modo sicuro" }
)

$lez3Items = @(
    @{ Path = "lez3_1.html"; Label = "Lez3_1: File, concetti e modelli" },
    @{ Path = "lez3_2.html"; Label = "Lez3_2: I/O su file testuali (C++)" },
    @{ Path = "lez3_3.html"; Label = "Lez3_3: File binari (base) in C++ e C" },
    @{ Path = "lez3_4.html"; Label = "Lez3_4: Spostamento del cursore nei file binari" },
    @{ Path = "lez3_5.html"; Label = "Lez3_5: Perche non scrivere struct raw" },
    @{ Path = "lez3_6.html"; Label = "Lez3_6: fseek/ftell e seekg/tellg (text mode)" },
    @{ Path = "lez3_7.html"; Label = "Lez3_7: Indici per file binari" }
)

$lez4Items = @(
    @{ Path = "lez4_1.html"; Label = "Lez4_1: Perche OOP? Concetti di base" },
    @{ Path = "lez4_2.html"; Label = "Lez4_2: Definire una classe (sintassi minima)" },
    @{ Path = "lez4_3.html"; Label = "Lez4_3: Costruttori, distruttore, lista d'iniz." },
    @{ Path = "lez4_4.html"; Label = "Lez4_4: Incapsulamento, metodi const, overload" },
    @{ Path = "lez4_5.html"; Label = "Lez4_5: to_string(), operator<<, pre/postcondiz." },
    @{ Path = "lez4_6.html"; Label = "Lez4_6: Header/Sorgenti, include-guard, build" },
    @{ Path = "lez4_7.html"; Label = "Lez4_7: Costruttore di copia e semantica di copia" },
    @{ Path = "lez4_8.html"; Label = "Lez4_8: Move constructor e move assignment" },
    @{ Path = "lez4_9.html"; Label = "Lez4_9: Esercizi svolti - livello base" },
    @{ Path = "lez4_10.html"; Label = "Lez4_10: Esercizi svolti - livello intermedio" },
    @{ Path = "lez4_11.html"; Label = "Lez4_11: Esercizi svolti - livello avanzato" }
)

$targets = @(
    @{ Path = "index.html"; Heading = "Menu Lezioni"; Items = $rootItems; Active = ""; ScriptSrc = "menu.js" },
    @{ Path = "programma.html"; Heading = "Menu Lezioni"; Items = $rootItems; Active = ""; ScriptSrc = "menu.js" }
)

$targets += @($lez1Items | ForEach-Object {
    @{ Path = "lez1/$($_.Path)"; Heading = "Lezione 1 - Matrici 2D (4BIA)"; Items = $lez1Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez2Items | ForEach-Object {
    @{ Path = "lez2/$($_.Path)"; Heading = "Lezione 2 - Struct (ripasso mirato)"; Items = $lez2Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez3Items | ForEach-Object {
    @{ Path = "lez3/$($_.Path)"; Heading = "Lezione 3 - File I/O"; Items = $lez3Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez4Items | ForEach-Object {
    @{ Path = "lez4/$($_.Path)"; Heading = "Lezione 4 - OOP in C++"; Items = $lez4Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

foreach ($target in $targets) {
    $fullPath = Join-Path $PSScriptRoot $target.Path
    $content = Get-Content -Path $fullPath -Raw -Encoding utf8
    $content = Ensure-MenuJs -Content $content -ScriptSrc $target.ScriptSrc
    $content = Remove-InlineToggleMenu -Content $content
    $menuBlock = New-MenuBlock -Heading $target.Heading -Items $target.Items -ActivePath $target.Active
    $content = Set-MenuBlock -Content $content -MenuBlock $menuBlock
    Write-Utf8NoBom -Path $fullPath -Content $content
    Write-Host "Aggiornato: $($target.Path)"
}
