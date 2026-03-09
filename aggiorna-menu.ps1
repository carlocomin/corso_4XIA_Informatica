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
    @{ Path = "lez4/lez4_1.html"; Label = "Lezione 4: OOP in C++" },
    @{ Path = "lez5/lez5_1.html"; Label = "Lezione 5: Ereditarietà e polimorfismo in C++" },
    @{ Path = "lez6/lez6_1.html"; Label = "Lezione 6: Alberi e BST in C/C++" }
)

$lez1Items = @(
    @{ Path = "lez1_1.html"; Label = "L1.1 - Introduzione, obiettivi, convenzioni" },
    @{ Path = "lez1_2.html"; Label = "L1.2 - Definizioni e indici" },
    @{ Path = "lez1_3.html"; Label = "L1.3 - Row-major e modello di memoria" },
    @{ Path = "lez1_4.html"; Label = "L1.4 - Dichiarazione e inizializzazione" },
    @{ Path = "lez1_5.html"; Label = "L1.5 - Attraversamento per riga/colonna" },
    @{ Path = "lez1_6.html"; Label = "L1.6 - I/O di base su matrici" },
    @{ Path = "lez1_7.html"; Label = "L1.7 - Utility e input robusto" },
    @{ Path = "lez1_8.html"; Label = "L1.8 - Perche la firma conta" },
    @{ Path = "lez1_9.html"; Label = "L1.9 - Firme corrette in C++ e C" },
    @{ Path = "lez1_10.html"; Label = "L1.10 - Matrici dinamiche" },
    @{ Path = "lez1_11.html"; Label = "L1.11 - Operazioni classiche e chiusura" }
)

$lez2Items = @(
    @{ Path = "lez2_1.html"; Label = "L2.1 - Perche esistono le struct" },
    @{ Path = "lez2_2.html"; Label = "L2.2 - Sintassi minima e accesso ai membri" },
    @{ Path = "lez2_3.html"; Label = "L2.3 - Inizializzare bene in C++" },
    @{ Path = "lez2_4.html"; Label = "L2.4 - Inizializzare in C" },
    @{ Path = "lez2_5.html"; Label = "L2.5 - Errori tipici e checklist" },
    @{ Path = "lez2_6.html"; Label = "L2.6 - Passaggio per valore, riferimento e puntatore" },
    @{ Path = "lez2_7.html"; Label = "L2.7 - Intento dell'API, const e lifetime" },
    @{ Path = "lez2_8.html"; Label = "L2.8 - Collezioni di struct in C++" },
    @{ Path = "lez2_9.html"; Label = "L2.9 - Lambda, ordinamento e filtro" },
    @{ Path = "lez2_10.html"; Label = "L2.10 - Layout, padding e serializzazione raw" }
)

$lez3Items = @(
    @{ Path = "lez3_1.html"; Label = "L3.1 - Che cos'e un file" },
    @{ Path = "lez3_2.html"; Label = "L3.2 - Testo vs binario" },
    @{ Path = "lez3_3.html"; Label = "L3.3 - Modello d'I/O e scelte pratiche" },
    @{ Path = "lez3_4.html"; Label = "L3.4 - CSV e TSV: scrivere e leggere" },
    @{ Path = "lez3_5.html"; Label = "L3.5 - Robustezza: escape, locale, round-trip" },
    @{ Path = "lez3_6.html"; Label = "L3.6 - Binario: modello base" },
    @{ Path = "lez3_7.html"; Label = "L3.7 - Read e write in C++ e C" },
    @{ Path = "lez3_8.html"; Label = "L3.8 - Seek e cursore nei file binari" },
    @{ Path = "lez3_9.html"; Label = "L3.9 - Perche i seek arbitrari in text mode non sono portabili" },
    @{ Path = "lez3_10.html"; Label = "L3.10 - Indici per file binari" }
)

$lez4Items = @(
    @{ Path = "lez4_1.html"; Label = "L4.1 - Perche OOP" },
    @{ Path = "lez4_2.html"; Label = "L4.2 - Astrazione e incapsulamento" },
    @{ Path = "lez4_3.html"; Label = "L4.3 - Anatomia minima di una classe" },
    @{ Path = "lez4_4.html"; Label = "L4.4 - Costruttori e invarianti" },
    @{ Path = "lez4_5.html"; Label = "L4.5 - Distruttore, ordine, default e delete" },
    @{ Path = "lez4_6.html"; Label = "L4.6 - Incapsulamento forte e metodi const" },
    @{ Path = "lez4_7.html"; Label = "L4.7 - Overload e overload const/non-const" },
    @{ Path = "lez4_8.html"; Label = "L4.8 - Rendere leggibile un oggetto e contratti d'uso" },
    @{ Path = "lez4_9.html"; Label = "L4.9 - Header, sorgenti e translation unit" },
    @{ Path = "lez4_10.html"; Label = "L4.10 - Build, linking, ODR e dipendenze" },
    @{ Path = "lez4_11.html"; Label = "L4.11 - Copy semantics e Rule of Three/Zero" },
    @{ Path = "lez4_12.html"; Label = "L4.12 - Move semantics, Rule of Five e RVO" },
    @{ Path = "lez4_13.html"; Label = "L4.13 - Esercizi base" },
    @{ Path = "lez4_14.html"; Label = "L4.14 - Esercizi intermedi" },
    @{ Path = "lez4_15.html"; Label = "L4.15 - Esercizi avanzati e ponte" }
)

$lez5Items = @(
    @{ Path = "lez5_1.html"; Label = "Lez5_1: Ereditarietà: significato" },
    @{ Path = "lez5_2.html"; Label = "Lez5_2: Sintassi della derivazione e accessi" },
    @{ Path = "lez5_3.html"; Label = "Lez5_3: Costruttori, distruttori, ordine" },
    @{ Path = "lez5_4.html"; Label = "Lez5_4: Object slicing" },
    @{ Path = "lez5_5.html"; Label = "Lez5_5: Polimorfismo e virtual" },
    @{ Path = "lez5_6.html"; Label = "Lez5_6: override, classi astratte, distruttore virtuale" },
    @{ Path = "lez5_7.html"; Label = "Lez5_7: Casting tra base e derivata" },
    @{ Path = "lez5_8.html"; Label = "Lez5_8: Multipla, diamond problem, buone pratiche" },
    @{ Path = "lez5_9.html"; Label = "Lez5_9: Esercizi guidati - base" },
    @{ Path = "lez5_10.html"; Label = "Lez5_10: Esercizi guidati - concetti e progettazione" },
    @{ Path = "lez5_11.html"; Label = "Lez5_11: Esercizio pratico finale" }
)

$lez6Items = @(
    @{ Path = "lez6_1.html"; Label = "Lez6_1: Alberi: significato, lessico, importanza" },
    @{ Path = "lez6_2.html"; Label = "Lez6_2: Rappresentazione in C/C++" },
    @{ Path = "lez6_3.html"; Label = "Lez6_3: Visite ordinate - pre, in, post" },
    @{ Path = "lez6_4.html"; Label = "Lez6_4: DFS e BFS" },
    @{ Path = "lez6_5.html"; Label = "Lez6_5: Le visite nel problem solving" },
    @{ Path = "lez6_6.html"; Label = "Lez6_6: BST - proprietà e ricerca" },
    @{ Path = "lez6_7.html"; Label = "Lez6_7: Inserimento in un BST" },
    @{ Path = "lez6_8.html"; Label = "Lez6_8: Cancellazione in un BST" },
    @{ Path = "lez6_9.html"; Label = "Lez6_9: Applicazioni algoritmiche dei BST" },
    @{ Path = "lez6_10.html"; Label = "Lez6_10: Altezza, costo, degenerazione" },
    @{ Path = "lez6_11.html"; Label = "Lez6_11: Alberi bilanciati e rotazioni" },
    @{ Path = "lez6_12.html"; Label = "Lez6_12: Esercizi guidati" },
    @{ Path = "lez6_13.html"; Label = "Lez6_13: Esercizio pratico finale" }
)

$targets = @(
    @{ Path = "index.html"; Heading = "Menu Lezioni"; Items = $rootItems; Active = ""; ScriptSrc = "menu.js" },
    @{ Path = "programma.html"; Heading = "Menu Lezioni"; Items = $rootItems; Active = ""; ScriptSrc = "menu.js" }
)

$targets += @($lez1Items | ForEach-Object {
    @{ Path = "lez1/$($_.Path)"; Heading = "Lezione 1 - Matrici 2D (ripasso guidato)"; Items = $lez1Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez2Items | ForEach-Object {
    @{ Path = "lez2/$($_.Path)"; Heading = "Lezione 2 - Struct (ripasso guidato)"; Items = $lez2Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez3Items | ForEach-Object {
    @{ Path = "lez3/$($_.Path)"; Heading = "Lezione 3 - File I/O (ripasso guidato)"; Items = $lez3Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez4Items | ForEach-Object {
    @{ Path = "lez4/$($_.Path)"; Heading = "Lezione 4 - OOP in C++ (ripasso guidato)"; Items = $lez4Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez5Items | ForEach-Object {
    @{ Path = "lez5/$($_.Path)"; Heading = "Lezione 5 - Ereditarietà e polimorfismo"; Items = $lez5Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez6Items | ForEach-Object {
    @{ Path = "lez6/$($_.Path)"; Heading = "Lezione 6 - Alberi e BST"; Items = $lez6Items; Active = $_.Path; ScriptSrc = "../menu.js" }
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
