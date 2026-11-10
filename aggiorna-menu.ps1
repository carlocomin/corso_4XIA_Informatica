param([string]$Lezione = "")

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
        "<button class=""menu-toggle"" type=""button"" aria-controls=""menu"" aria-expanded=""false"" onclick=""toggleMenu()"">&#9776; Menu</button>",
        "<nav class=""sidebar"" id=""menu"" aria-label=""Indice della lezione"">",
        "  <h2>$Heading</h2>",
        "  <ul>"
    )

    foreach ($item in $Items) {
        $classAttr = if ($item.Path -eq $ActivePath) { ' class="active" aria-current="page"' } else { "" }
        $lines += "    <li><a href=""$($item.Path)""$classAttr>$($item.Label)</a></li>"
    }

    $lines += @(
        "  </ul>",
        "</nav>",
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
    @{ Path = "raccomandazioni.html"; Label = "Prima di iniziare: metodo di lavoro" },
    @{ Path = "impatto-ai.html"; Label = "AI: didattica e lavoro informatico" },
    @{ Path = "lez0/lez0_1.html"; Label = "Lezione 0: Array, funzioni e parametri" },
    @{ Path = "lez1/lez1_1.html"; Label = "Lezione 1: Matrici 2D in C/C++" },
    @{ Path = "lez2/lez2_1.html"; Label = "Lezione 2: Struct in C/C++" },
    @{ Path = "lez3/lez3_1.html"; Label = "Lezione 3: File I/O in C/C++" },
    @{ Path = "lez4/lez4_1.html"; Label = "Lezione 4: Classi e oggetti in C++" }
)

$lez0Items = @(
    @{ Path = "lez0_1.html"; Label = "L0.1 - Partiamo da ciò che serve" },
    @{ Path = "lez0_2.html"; Label = "L0.2 - const e constexpr" },
    @{ Path = "lez0_3.html"; Label = "L0.3 - Un array, molti valori" },
    @{ Path = "lez0_4.html"; Label = "L0.4 - Inizializzare e rispettare i limiti" },
    @{ Path = "lez0_5.html"; Label = "L0.5 - Scorrere con un ciclo" },
    @{ Path = "lez0_6.html"; Label = "L0.6 - Leggere e stampare in sicurezza" },
    @{ Path = "lez0_7.html"; Label = "L0.7 - Accumulare e contare" },
    @{ Path = "lez0_8.html"; Label = "L0.8 - Ricerca lineare" },
    @{ Path = "lez0_9.html"; Label = "L0.9 - Minimo, massimo e posizione" },
    @{ Path = "lez0_10.html"; Label = "L0.10 - Inserire e cancellare con gli shift" },
    @{ Path = "lez0_11.html"; Label = "L0.11 - Invertire in place" },
    @{ Path = "lez0_12.html"; Label = "L0.12 - Ordinamento per selezione" },
    @{ Path = "lez0_13.html"; Label = "L0.13 - Ricerca binaria" },
    @{ Path = "lez0_14.html"; Label = "L0.14 - Costruire funzioni con un contratto" },
    @{ Path = "lez0_15.html"; Label = "L0.15 - Passaggio per valore" },
    @{ Path = "lez0_16.html"; Label = "L0.16 - Indirizzi e puntatori" },
    @{ Path = "lez0_17.html"; Label = "L0.17 - Passaggio per indirizzo" },
    @{ Path = "lez0_18.html"; Label = "L0.18 - Array passati a funzione" },
    @{ Path = "lez0_19.html"; Label = "L0.19 - Passaggio per riferimento in C++" },
    @{ Path = "lez0_20.html"; Label = "L0.20 - Scegliere il passaggio corretto" },
    @{ Path = "lez0_21.html"; Label = "L0.21 - Laboratorio e autoverifica" },
    @{ Path = "lez0_lab.html"; Label = "Laboratorio extra - Missione serra" }
)

$lez1Items = @(
    @{ Path = "lez1_1.html"; Label = "L1.1 - Ripartiamo dalle matrici" },
    @{ Path = "lez1_2.html"; Label = "L1.2 - Due indici, una cella" },
    @{ Path = "lez1_3.html"; Label = "L1.3 - Dichiarare e inizializzare" },
    @{ Path = "lez1_4.html"; Label = "L1.4 - Righe contigue in memoria" },
    @{ Path = "lez1_5.html"; Label = "L1.5 - Il doppio ciclo" },
    @{ Path = "lez1_6.html"; Label = "L1.6 - Leggere e stampare" },
    @{ Path = "lez1_7.html"; Label = "L1.7 - Matrici nelle funzioni C++" },
    @{ Path = "lez1_8.html"; Label = "L1.8 - Matrici nelle funzioni C" },
    @{ Path = "lez1_9.html"; Label = "L1.9 - Pattern: accumulare" },
    @{ Path = "lez1_10.html"; Label = "L1.10 - Somme per righe e colonne" },
    @{ Path = "lez1_11.html"; Label = "L1.11 - Diagonali e traccia" },
    @{ Path = "lez1_12.html"; Label = "L1.12 - Simmetria e metà matrice" },
    @{ Path = "lez1_13.html"; Label = "L1.13 - Matrici dinamiche (estensione)" },
    @{ Path = "lez1_14.html"; Label = "L1.14 - Laboratorio e autoverifica" }
)

$lez2Items = @(
    @{ Path = "lez2_1.html"; Label = "L2.1 - Dati che viaggiano insieme" },
    @{ Path = "lez2_2.html"; Label = "L2.2 - Definire un nuovo tipo" },
    @{ Path = "lez2_memoria.html"; Label = "L2.2bis - Nomi e oggetti in memoria" },
    @{ Path = "lez2_3.html"; Label = "L2.3 - Inizializzare senza sorprese" },
    @{ Path = "lez2_4.html"; Label = "L2.4 - Leggere e modificare i campi" },
    @{ Path = "lez2_5.html"; Label = "L2.5 - La stessa idea in C" },
    @{ Path = "lez2_6.html"; Label = "L2.6 - Passaggio per valore" },
    @{ Path = "lez2_7.html"; Label = "L2.7 - Modificare con un riferimento" },
    @{ Path = "lez2_8.html"; Label = "L2.8 - Leggere con const&amp;" },
    @{ Path = "lez2_9.html"; Label = "L2.9 - Puntatori e operatore ->" },
    @{ Path = "lez2_10.html"; Label = "L2.10 - Restituire una struct" },
    @{ Path = "lez2_11.html"; Label = "L2.11 - Collezioni di record" },
    @{ Path = "lez2_12.html"; Label = "L2.12 - Cercare, contare, scegliere" },
    @{ Path = "lez2_13.html"; Label = "L2.13 - Ordinare per un campo" },
    @{ Path = "lez2_14.html"; Label = "L2.14 - Layout, padding e file" },
    @{ Path = "lez2_15.html"; Label = "L2.15 - Laboratorio e autoverifica" }
)

$lez3Items = @(
    @{ Path = "lez3_1.html"; Label = "L3.1 - Dal dato al file" },
    @{ Path = "lez3_2.html"; Label = "L3.2 - Testo o binario?" },
    @{ Path = "lez3_3.html"; Label = "L3.3 - Apri, usa, controlla" },
    @{ Path = "lez3_4.html"; Label = "L3.4 - Scrivere testo in C++" },
    @{ Path = "lez3_5.html"; Label = "L3.5 - Leggere valori in C++" },
    @{ Path = "lez3_6.html"; Label = "L3.6 - Leggere righe in C++" },
    @{ Path = "lez3_7.html"; Label = "L3.7 - Il ciclo di lettura corretto" },
    @{ Path = "lez3_lab_testo.html"; Label = "L3.7bis - Primo laboratorio sui file di testo" },
    @{ Path = "lez3_8.html"; Label = "L3.8 - La stessa idea in C" },
    @{ Path = "lez3_9.html"; Label = "L3.9 - Dalla struct al testo" },
    @{ Path = "lez3_10.html"; Label = "L3.10 - Dalla riga alla struct" },
    @{ Path = "lez3_11.html"; Label = "L3.11 - Provare scrittura e lettura" }
)

$lez4Items = @(
    @{ Path = "lez4_1.html"; Label = "L4.1 - Dai dati alle operazioni" },
    @{ Path = "lez4_2.html"; Label = "L4.2 - Una classe, più oggetti" },
    @{ Path = "lez4_3.html"; Label = "L4.3 - Il primo programma completo" },
    @{ Path = "lez4_4.html"; Label = "L4.4 - Astrazione e incapsulamento" },
    @{ Path = "lez4_5.html"; Label = "L4.5 - Un metodo riceve dati e restituisce un risultato" },
    @{ Path = "lez4_6.html"; Label = "L4.6 - Rispettare le regole anche in caso di errore" },
    @{ Path = "lez4_7.html"; Label = "L4.7 - Il costruttore stabilisce lo stato iniziale" },
    @{ Path = "lez4_8.html"; Label = "L4.8 - Creare oggetti con dati iniziali diversi" },
    @{ Path = "lez4_9.html"; Label = "L4.9 - Consultare senza modificare: i metodi const" },
    @{ Path = "lez4_10.html"; Label = "L4.10 - Copiare un oggetto" },
    @{ Path = "lez4_11.html"; Label = "L4.11 - Passare un oggetto a una funzione" },
    @{ Path = "lez4_12.html"; Label = "L4.12 - Quando un oggetto nasce e quando termina" },
    @{ Path = "lez4_13.html"; Label = "L4.13 - Un array contiene più oggetti" },
    @{ Path = "lez4_14.html"; Label = "L4.14 - Dalla consegna a una nuova classe" },
    @{ Path = "lez4_15.html"; Label = "L4.15 - Laboratorio e autoverifica" },
    @{ Path = "lez4_inizializzazione.html"; Label = "L4.16 - Inizializzare i membri con una lista" },
    @{ Path = "lez4_metodi_esterni.html"; Label = "L4.17 - Definire i metodi fuori dalla classe" },
    @{ Path = "lez4_progetto.html"; Label = "L4.18 - Un progetto in tre file" }
)

$targets = @(
    @{ Path = "index.html"; Heading = "Menu Lezioni"; Items = $rootItems; Active = ""; ScriptSrc = "menu.js" },
    @{ Path = "programma.html"; Heading = "Menu Lezioni"; Items = $rootItems; Active = ""; ScriptSrc = "menu.js" },
    @{ Path = "raccomandazioni.html"; Heading = "Menu Lezioni"; Items = $rootItems; Active = "raccomandazioni.html"; ScriptSrc = "menu.js" },
    @{ Path = "impatto-ai.html"; Heading = "Menu Lezioni"; Items = $rootItems; Active = "impatto-ai.html"; ScriptSrc = "menu.js" }
)

$targets += @($lez0Items | ForEach-Object {
    @{ Path = "lez0/$($_.Path)"; Heading = "Lezione 0 - Array e funzioni"; Items = $lez0Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez1Items | ForEach-Object {
    @{ Path = "lez1/$($_.Path)"; Heading = "Lezione 1 - Matrici 2D (ripasso guidato)"; Items = $lez1Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez2Items | ForEach-Object {
    @{ Path = "lez2/$($_.Path)"; Heading = "Lezione 2 - Struct (ripasso guidato)"; Items = $lez2Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez3Items | ForEach-Object {
    @{ Path = "lez3/$($_.Path)"; Heading = "Lezione 3 - File I/O"; Items = $lez3Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

$targets += @($lez4Items | ForEach-Object {
    @{ Path = "lez4/$($_.Path)"; Heading = "Lezione 4 - Classi e oggetti in C++"; Items = $lez4Items; Active = $_.Path; ScriptSrc = "../menu.js" }
})

foreach ($target in $targets) {
    if ($Lezione -and -not $target.Path.StartsWith("$Lezione/")) {
        continue
    }
    $fullPath = Join-Path $PSScriptRoot $target.Path
    $content = Get-Content -Path $fullPath -Raw -Encoding utf8
    $content = Ensure-MenuJs -Content $content -ScriptSrc $target.ScriptSrc
    $content = Remove-InlineToggleMenu -Content $content
    $menuBlock = New-MenuBlock -Heading $target.Heading -Items $target.Items -ActivePath $target.Active
    $content = Set-MenuBlock -Content $content -MenuBlock $menuBlock
    Write-Utf8NoBom -Path $fullPath -Content $content
    Write-Host "Aggiornato: $($target.Path)"
}
