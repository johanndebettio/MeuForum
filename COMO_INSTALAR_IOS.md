# 📱 Como Instalar o App no iPhone 13

## ✅ Passo 1: Build Automático (GitHub Actions)

O projeto está configurado para compilar automaticamente quando você fizer push para a branch `iPhone-test` ou `main`.

### Como funciona:
1. Faça commit e push das suas alterações
2. Acesse: https://github.com/johanndebettio/MeuForum/actions
3. Aguarde o build terminar (~10-15 minutos)
4. Baixe o arquivo `ForumMobile.ipa`

## 📥 Passo 2: Instalar no iPhone

### Opção A: Usando AltStore (GRATUITO - Recomendado)

**AltStore** permite instalar apps sem conta de desenvolvedor Apple.

1. **Instalar AltServer no Windows:**
   - Baixe: https://altstore.io/
   - Execute o instalador
   - Conecte seu iPhone no PC via cabo USB
   - Confie no computador no iPhone

2. **Instalar AltStore no iPhone:**
   - Abra o AltServer (ícone na bandeja do Windows)
   - Clique em "Install AltStore" → Selecione seu iPhone
   - Digite seu Apple ID e senha (não precisa ser Developer Account)
   - Aceite a instalação no iPhone

3. **Confiar no Desenvolvedor:**
   - iPhone: Ajustes → Geral → VPN e Gerenciamento de Dispositivos
   - Confie no seu Apple ID

4. **Instalar o App:**
   - Abra AltStore no iPhone
   - Vá em "My Apps" → Toque no "+"
   - Selecione o arquivo `ForumMobile.ipa` que você baixou
   - Aguarde a instalação

⚠️ **Limitação:** Apps instalados pelo AltStore expiram em 7 dias. Você precisa reconectar o iPhone no PC e "refrescar" o app semanalmente.

---

### Opção B: Usando Sideloadly (GRATUITO)

1. **Baixar Sideloadly:**
   - Site: https://sideloadly.io/
   - Instale no Windows

2. **Conectar iPhone:**
   - Conecte via cabo USB
   - Confie no computador

3. **Instalar o App:**
   - Abra Sideloadly
   - Arraste o arquivo `ForumMobile.ipa`
   - Digite seu Apple ID (não precisa ser Developer)
   - Clique em "Start"
   - Aguarde a instalação

4. **Confiar no Desenvolvedor:**
   - iPhone: Ajustes → Geral → VPN e Gerenciamento de Dispositivos
   - Confie no seu Apple ID

⚠️ **Limitação:** Apps expiram em 7 dias (sem Developer Account) ou 1 ano (com Developer Account de $99/ano).

---

### Opção C: Usando TestFlight (Requer Apple Developer - $99/ano)

Se você tiver conta Apple Developer:

1. **Subir para TestFlight:**
   - O workflow pode ser configurado para upload automático
   - Precisa configurar App Store Connect

2. **Instalar no iPhone:**
   - Instale o app TestFlight da App Store
   - Aceite o convite de teste
   - Instale o app pelo TestFlight

✅ **Vantagem:** Sem limite de tempo, atualizações automáticas.

---

## 🔧 Passo 3: Atualizar o App

Sempre que você fizer push para `iPhone-test`:
1. GitHub Actions compila automaticamente
2. Baixe o novo `.ipa`
3. Reinstale usando o mesmo método (AltStore ou Sideloadly)

---

## ❓ Problemas Comuns

### "App não confiável"
- Ajustes → Geral → VPN e Gerenciamento → Confiar no desenvolvedor

### "Não foi possível verificar o app"
- Conecte à internet
- Ajustes → Geral → Data e Hora → Desligar/Ligar "Ajustar Automaticamente"

### App expira em 7 dias
- Use AltStore e "refresh" semanalmente
- OU compre Apple Developer Account ($99/ano)

---

## 🎯 Resumo Rápido

**Melhor opção gratuita:** AltStore + USB
- ✅ Gratuito
- ✅ Sem limite de dispositivos
- ⚠️ Precisa renovar a cada 7 dias

**Para desenvolvimento sério:** Apple Developer Account
- ✅ Apps válidos por 1 ano
- ✅ TestFlight para testers
- ❌ Custa $99/ano
