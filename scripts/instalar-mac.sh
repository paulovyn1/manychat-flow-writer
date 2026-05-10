#!/bin/bash
# ============================================================
# Instalador da Skill ManyChat Flow Writer — Triwer
# Repositório: https://github.com/triwer/manychat-flow-writer
# ============================================================

set -e

REPO_RAW="https://raw.githubusercontent.com/triwer/manychat-flow-writer/main/skill"
INSTALL_DIR="$HOME/.claude/skills/manychat-flow-writer"
REFERENCES_DIR="$INSTALL_DIR/references"

# Arquivos pessoais que NUNCA devem ser sobrescritos
PERSONAL_FILES=("references/user-memory.md" "references/user-profile.md")

# Arquivos da skill que serão instalados/atualizados
SKILL_FILES=(
  "SKILL.md"
  "VERSION"
  "references/sun-personality.md"
  "references/patterns-venda.md"
  "references/patterns-captacao.md"
  "references/copy-rules.md"
  "references/json-format.md"
  "references/manychat-mcp.md"
)

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   ManyChat Flow Writer Skill — Triwer        ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# --- Verificar versão remota ---
echo "🔍 Verificando versão disponível..."
REMOTE_VERSION=$(curl -fsSL "$REPO_RAW/VERSION" 2>/dev/null | tr -d '[:space:]')

if [ -z "$REMOTE_VERSION" ]; then
  echo "❌ Não foi possível conectar ao repositório."
  echo "   Verifique sua conexão e tente novamente."
  exit 1
fi

echo "   Versão disponível: $REMOTE_VERSION"

# --- Verificar versão instalada ---
LOCAL_VERSION=""
if [ -f "$INSTALL_DIR/VERSION" ]; then
  LOCAL_VERSION=$(cat "$INSTALL_DIR/VERSION" | tr -d '[:space:]')
  echo "   Versão instalada:  $LOCAL_VERSION"
else
  echo "   Versão instalada:  nenhuma"
fi

# --- Comparar versões ---
if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
  echo ""
  echo "✅ Você já tem a versão mais recente ($REMOTE_VERSION) instalada."
  echo ""
  exit 0
fi

# --- Confirmar instalação/atualização ---
if [ -z "$LOCAL_VERSION" ]; then
  ACTION="instalar"
  echo ""
  echo "📦 Pronto para instalar a skill versão $REMOTE_VERSION."
else
  ACTION="atualizar"
  echo ""
  echo "📦 Atualização disponível: $LOCAL_VERSION → $REMOTE_VERSION"
fi

read -r -p "   Deseja $ACTION agora? (s/n): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Ss]$ ]]; then
  echo ""
  echo "   Instalação cancelada."
  exit 0
fi

# --- Criar diretórios ---
mkdir -p "$REFERENCES_DIR"

# --- Backup dos arquivos pessoais (se existirem) ---
BACKUP_DIR=""
if [ -n "$LOCAL_VERSION" ]; then
  BACKUP_DIR="$INSTALL_DIR/.backup-$LOCAL_VERSION"
  mkdir -p "$BACKUP_DIR/references"
  echo ""
  echo "💾 Fazendo backup da versão anterior em:"
  echo "   $BACKUP_DIR"
  for personal in "${PERSONAL_FILES[@]}"; do
    if [ -f "$INSTALL_DIR/$personal" ]; then
      cp "$INSTALL_DIR/$personal" "$BACKUP_DIR/$personal" 2>/dev/null || true
    fi
  done
fi

# --- Download dos arquivos ---
echo ""
echo "⬇️  Baixando arquivos..."

FAILED=0
for file in "${SKILL_FILES[@]}"; do
  printf "   %-45s" "$file"
  URL="$REPO_RAW/$file"
  DEST="$INSTALL_DIR/$file"
  if curl -fsSL "$URL" -o "$DEST" 2>/dev/null; then
    echo "✓"
  else
    echo "✗ ERRO"
    FAILED=$((FAILED + 1))
  fi
done

if [ "$FAILED" -gt 0 ]; then
  echo ""
  echo "❌ $FAILED arquivo(s) não puderam ser baixados."
  echo "   Verifique sua conexão e tente novamente."
  # Restaurar backup se atualização falhou
  if [ -n "$BACKUP_DIR" ]; then
    for personal in "${PERSONAL_FILES[@]}"; do
      if [ -f "$BACKUP_DIR/$personal" ]; then
        cp "$BACKUP_DIR/$personal" "$INSTALL_DIR/$personal"
      fi
    done
    echo "   Arquivos pessoais restaurados do backup."
  fi
  exit 1
fi

# --- Garantir que arquivos pessoais existem (não sobrescrever se já existem) ---
for personal in "${PERSONAL_FILES[@]}"; do
  if [ ! -f "$INSTALL_DIR/$personal" ]; then
    # Baixar template inicial
    URL="$REPO_RAW/$personal"
    curl -fsSL "$URL" -o "$INSTALL_DIR/$personal" 2>/dev/null || true
  fi
done

# --- Concluído ---
INSTALLED_VERSION=$(cat "$INSTALL_DIR/VERSION" | tr -d '[:space:]')
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   ✅ Instalação concluída! v$INSTALLED_VERSION"
echo "╚══════════════════════════════════════════════╝"
echo ""

if [ "$ACTION" = "instalar" ]; then
  echo "🚀 Próximos passos:"
  echo "   1. Abra o Claude Desktop ou Claude Code"
  echo "   2. Peça: 'cria um fluxo de venda no ManyChat'"
  echo "   3. A skill vai iniciar o onboarding automaticamente"
else
  echo "🔄 Skill atualizada para v$INSTALLED_VERSION"
  echo "   Seus dados pessoais (memória e perfil) foram preservados."
  if [ -n "$BACKUP_DIR" ]; then
    echo "   Backup da versão anterior: $BACKUP_DIR"
  fi
fi

echo ""
echo "💡 Instale também o ManyChat MCP para buscar IDs automaticamente:"
echo "   curl -fsSL https://raw.githubusercontent.com/triwer/manychat-mcp/main/scripts/instalar-mac.sh | bash"
echo ""
