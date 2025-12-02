# 🎉 Projeto Configurado para iOS!

## ✅ O que foi feito:

1. **Info.plist configurado:**
   - Nome do app: "Forum - Mobile"
   - Permissões de câmera e galeria adicionadas

2. **Ícones configurados:**
   - `flutter_launcher_icons` habilitado para iOS
   - Usa o mesmo ícone do Android

3. **GitHub Actions configurado:**
   - Build automático quando você fizer push
   - Gera arquivo `.ipa` pronto para instalar
   - Workflow em: `.github/workflows/ios-build.yml`

---

## 🚀 Como testar no seu iPhone 13:

### Passo 1: Fazer Push para GitHub

```bash
git add .
git commit -m "Configuração iOS completa"
git push origin iPhone-test
```

### Passo 2: Aguardar Build

1. Acesse: https://github.com/johanndebettio/MeuForum/actions
2. Veja o workflow "Build iOS App" rodando
3. Aguarde ~10-15 minutos
4. Quando terminar, clique no workflow
5. Baixe o arquivo `ios-app` (ForumMobile.ipa)

### Passo 3: Instalar no iPhone

**Opção mais fácil: AltStore (GRATUITO)**

1. **No Windows:**
   - Baixe AltServer: https://altstore.io/
   - Instale e execute
   - Conecte iPhone via USB
   - Instale AltStore no iPhone (clique no ícone da bandeja)

2. **No iPhone:**
   - Abra AltStore
   - Vá em "My Apps" → "+"
   - Selecione o arquivo `ForumMobile.ipa`
   - Instale

3. **Confiar no Desenvolvedor:**
   - Ajustes → Geral → VPN e Gerenciamento de Dispositivos
   - Confie no seu Apple ID

⚠️ **Importante:** O app expira em 7 dias. Use AltStore para renovar.

---

## 📋 Instruções Detalhadas

Veja o arquivo: `COMO_INSTALAR_IOS.md`

---

## 🔄 Próximos Passos

Toda vez que você quiser atualizar o app no iPhone:

1. Faça suas alterações no código
2. Commit e push para `iPhone-test`
3. Aguarde o build no GitHub Actions
4. Baixe o novo `.ipa`
5. Reinstale usando AltStore

---

## ✨ Funcionalidades Configuradas

- ✅ Splash screen com ícone customizado
- ✅ Nome: "Forum - Mobile"
- ✅ Ícone personalizado
- ✅ Permissões de câmera/galeria
- ✅ Share Plus (compartilhamento)
- ✅ Build automático via GitHub Actions

---

## ❓ Precisa de Ajuda?

- GitHub Actions não rodou? Verifique se está na branch `iPhone-test`
- Problemas no iPhone? Leia `COMO_INSTALAR_IOS.md`
- App expirou? Use AltStore para renovar (conecte USB + clique em "Refresh")

Boa sorte! 🚀📱
