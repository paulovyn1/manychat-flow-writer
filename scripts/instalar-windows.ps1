# ============================================================
# Instalador da Skill ManyChat Flow Writer — Triwer
# Repositório: https://github.com/paulovyn1/manychat-flow-writer
# ============================================================

$ErrorActionPreference = "Stop"

$RepoRaw = "https://raw.githubusercontent.com/paulovyn1/manychat-flow-writer/main/skill"
$InstallDir = Join-Path $env:USERPROFILE ".claude\skills\manychat-flow-writer"
$ReferencesDir = Join-Path $InstallDir "references"

# Arquivos pessoais que NUNCA devem ser sobrescritos
$PersonalFiles = @("references\user-memory.md", "references\user-profile.md")

# Arquivos da skill que serão instalados/atualizados
$SkillFiles = @(
    "SKILL.md",
    "VERSION",
    "references\sun-personality.md",
    "references\patterns-venda.md",
    "references\patterns-captacao.md",
    "references\copy-rules.md",
    "references\json-format.md",
    "references\manychat-mcp.md"
)

Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   ManyChat Flow Writer Skill — Triwer        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# --- Verificar versão remota ---
Write-Host "🔍 Verificando versão disponível..." -ForegroundColor Yellow
try {
    $RemoteVersion = (Invoke-WebRequest -Uri "$RepoRaw/VERSION" -UseBasicParsing).Content.Trim()
} catch {
    Write-Host "❌ Não foi possível conectar ao repositório." -ForegroundColor Red
    Write-Host "   Verifique sua conexão e tente novamente."
    exit 1
}

Write-Host "   Versão disponível: $RemoteVersion"

# --- Verificar versão instalada ---
$LocalVersion = ""
$VersionFile = Join-Path $InstallDir "VERSION"
if (Test-Path $VersionFile) {
    $LocalVersion = (Get-Content $VersionFile).Trim()
    Write-Host "   Versão instalada:  $LocalVersion"
} else {
    Write-Host "   Versão instalada:  nenhuma"
}

# --- Comparar versões ---
if ($LocalVersion -eq $RemoteVersion) {
    Write-Host ""
    Write-Host "✅ Você já tem a versão mais recente ($RemoteVersion) instalada." -ForegroundColor Green
    Write-Host ""
    exit 0
}

# --- Confirmar instalação/atualização ---
$Action = if ($LocalVersion -eq "") { "instalar" } else { "atualizar" }
Write-Host ""
if ($Action -eq "instalar") {
    Write-Host "📦 Pronto para instalar a skill versão $RemoteVersion."
} else {
    Write-Host "📦 Atualização disponível: $LocalVersion → $RemoteVersion"
}

$Confirm = Read-Host "   Deseja $Action agora? (s/n)"
if ($Confirm -notmatch "^[Ss]$") {
    Write-Host ""
    Write-Host "   Instalação cancelada."
    exit 0
}

# --- Criar diretórios ---
New-Item -ItemType Directory -Force -Path $ReferencesDir | Out-Null

# --- Backup dos arquivos pessoais ---
$BackupDir = ""
if ($LocalVersion -ne "") {
    $BackupDir = Join-Path $InstallDir ".backup-$LocalVersion"
    New-Item -ItemType Directory -Force -Path (Join-Path $BackupDir "references") | Out-Null
    Write-Host ""
    Write-Host "💾 Fazendo backup da versão anterior em:" -ForegroundColor Yellow
    Write-Host "   $BackupDir"
    foreach ($personal in $PersonalFiles) {
        $src = Join-Path $InstallDir $personal
        $dst = Join-Path $BackupDir $personal
        if (Test-Path $src) {
            Copy-Item $src $dst -Force -ErrorAction SilentlyContinue
        }
    }
}

# --- Download dos arquivos ---
Write-Host ""
Write-Host "⬇️  Baixando arquivos..." -ForegroundColor Yellow

$Failed = 0
foreach ($file in $SkillFiles) {
    $fileDisplay = $file.PadRight(45)
    $url = "$RepoRaw/$($file -replace '\\', '/')"
    $dest = Join-Path $InstallDir $file
    # Garantir que diretório pai existe
    $parentDir = Split-Path $dest -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Host "   $fileDisplay ✓" -ForegroundColor Green
    } catch {
        Write-Host "   $fileDisplay ✗ ERRO" -ForegroundColor Red
        $Failed++
    }
}

if ($Failed -gt 0) {
    Write-Host ""
    Write-Host "❌ $Failed arquivo(s) não puderam ser baixados." -ForegroundColor Red
    Write-Host "   Verifique sua conexão e tente novamente."
    # Restaurar backup se atualização falhou
    if ($BackupDir -ne "") {
        foreach ($personal in $PersonalFiles) {
            $src = Join-Path $BackupDir $personal
            $dst = Join-Path $InstallDir $personal
            if (Test-Path $src) { Copy-Item $src $dst -Force }
        }
        Write-Host "   Arquivos pessoais restaurados do backup."
    }
    exit 1
}

# --- Garantir que arquivos pessoais existem sem sobrescrever ---
foreach ($personal in $PersonalFiles) {
    $dest = Join-Path $InstallDir $personal
    if (-not (Test-Path $dest)) {
        $url = "$RepoRaw/$($personal -replace '\\', '/')"
        try {
            Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        } catch { }
    }
}

# --- Concluído ---
$InstalledVersion = (Get-Content (Join-Path $InstallDir "VERSION")).Trim()
Write-Host ""
Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅ Instalação concluída! v$InstalledVersion" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

if ($Action -eq "instalar") {
    Write-Host "🚀 Próximos passos:"
    Write-Host "   1. Abra o Claude Desktop ou Claude Code"
    Write-Host "   2. Peça: 'cria um fluxo de venda no ManyChat'"
    Write-Host "   3. A skill vai iniciar o onboarding automaticamente"
} else {
    Write-Host "🔄 Skill atualizada para v$InstalledVersion"
    Write-Host "   Seus dados pessoais (memória e perfil) foram preservados."
    if ($BackupDir -ne "") {
        Write-Host "   Backup da versão anterior: $BackupDir"
    }
}

Write-Host ""
Write-Host "💡 Instale também o ManyChat MCP para buscar IDs automaticamente:" -ForegroundColor Cyan
Write-Host "   irm https://raw.githubusercontent.com/paulovyn1/manychat-mcp/main/scripts/instalar-windows.ps1 | iex"
Write-Host ""
