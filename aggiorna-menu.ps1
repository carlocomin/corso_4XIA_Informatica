
$startMarker = '<!-- BEGIN MENU -->'
$endMarker = '<!-- END MENU -->'

$newMenu = @"
$startMarker
<button class='menu-toggle' onclick='toggleMenu()'>&#9776; Menu</button>
<div class='sidebar' id='menu'>
    <h2>Menu Lezioni</h2>
    <ul>
        <li><a href='lez1/lez1_1.html'>Lezione 1: Introduzione</a></li>
        <li><a href='lez2/lez2_1.html'>Lezione 2: Strutture di Controllo</a></li>
        <li><a href='lez3/lez3_1.html'>Lezione 3: Liste, Tuple, Dizionari, Iteratori</a></li>
        <li><a href='lez4/lez4_1.html'>Lezione 4: Funzioni</a></li>
        <li><a href='lez5/lez5_1.html'>Lezione 5: OOP</a></li>
		<li><a href='lez6/lez6_1.html'>Lezione 6: Progettino Videogioco Testuale</a></li>
		<li><a href='lez7/lez7_1.html'>Lezione 7: Interfacciamento LLM API</a></li>
		<li><a href='lez8/lez8_1.html'>Lezione 8: Ricorsione e divide et impera</a></li>
		<li><a href='lez9/lez9_1.html'>Lezione 9: Strutture dati avanzate</a></li>
		<li><a href='lez10/lez10_1.html'>Lezione 10: Grafi e shortest-paths</a></li>
		<li><a href='lez11/lez11_1.html'>Lezione 11: Programmazione Competitiva</a></li>
		<li><a href='lez12/lez12_1.html'>Lezione 12: Pygame e grafica 2D</a></li>
		<li><a href='lez13/lez13_1.html'>Lezione 13: Mini-gioco 2D</a></li>
		<li><a href='lez14/lez14_1.html'>Lezione 14: Pathfinding nei videogiochi con A*</a></li>
		<li><a href='lez15/lez15_1.html'>Lezione 15: AI nei giochi</a></li>
		<li><a href='lez16/lez16_1.html'>Lezione 16: Progetto finale</a></li>
    </ul>
</div>
$endMarker
"@

Get-ChildItem -Filter *.html | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path -Raw -Encoding utf8

    # Rimuove TUTTI i blocchi vecchi <!-- BEGIN MENU --> ... <!-- END MENU -->
    while ([regex]::IsMatch($content, "$startMarker.*?$endMarker", 'Singleline')) {
        $content = [regex]::Replace($content, "$startMarker.*?$endMarker", "", 'Singleline')
    }

    Write-Host "Scrivo menu aggiornato in: $($_.Name)"
    $content = $content -replace '<body>', "<body>`n$newMenu"

    $toggleJs = @"
<script>
function toggleMenu() {
    const menu = document.getElementById('menu');
    menu.classList.toggle('open');
}
</script>
"@

    if ($content -notmatch 'function toggleMenu') {
        $content = $content -replace '</body>', "$toggleJs`n</body>"
    }

    $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($path, $content, $utf8NoBomEncoding)
}

Write-Host "Modifica completata."
