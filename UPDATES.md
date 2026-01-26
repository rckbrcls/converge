# Sistema de Atualizações Automáticas

Este documento explica como configurar e usar o sistema de atualizações automáticas do app Pomodoro usando o framework **Sparkle**.

## Visão Geral

O app usa o framework **Sparkle** para fornecer atualizações automáticas aos usuários. Sparkle é o padrão da indústria para apps macOS distribuídos fora da Mac App Store.

### Como Funciona

1. O app verifica periodicamente (diariamente) se há atualizações disponíveis
2. Quando uma nova versão é detectada, o usuário é notificado
3. O usuário pode baixar e instalar a atualização diretamente do app
4. O processo é automático e seguro

## Configuração Inicial

### 1. Adicionar Sparkle ao Projeto

#### Opção A: Swift Package Manager (Recomendado)

1. No Xcode, vá em **File → Add Package Dependencies...**
2. Adicione a URL: `https://github.com/sparkle-project/Sparkle`
3. Selecione a versão mais recente
4. Adicione o framework ao target `pomodoro`

#### Opção B: CocoaPods

Adicione ao `Podfile`:
```ruby
pod 'Sparkle', '~> 2.0'
```

#### Opção C: Manual

1. Baixe Sparkle de: https://sparkle-project.org/download/
2. Arraste `Sparkle.framework` para o projeto
3. Configure o framework como "Embed & Sign"

### 2. Configurar Info.plist

Adicione as seguintes chaves ao `Info.plist` do app (ou configure no Xcode):

```xml
<key>SUFeedURL</key>
<string>https://seu-dominio.com/releases/appcast.xml</string>

<key>SUPublicEDKey</key>
<string>SUA_CHAVE_PUBLICA_EDDSA</string>
```

**Importante:** Substitua `https://seu-dominio.com/releases/appcast.xml` pela URL real do seu appcast.

### 3. Gerar Chaves de Assinatura (EdDSA)

Para segurança, você precisa gerar um par de chaves EdDSA:

```bash
# Gerar chaves (execute uma vez)
./scripts/generate-keys.sh
```

Isso criará:
- `eddsa_private_key.pem` (mantenha privado!)
- `eddsa_public_key.pem` (adicione ao Info.plist como SUPublicEDKey)

**⚠️ IMPORTANTE:** Nunca compartilhe a chave privada! Ela é usada para assinar os releases.

## Processo de Release com Atualizações

### 1. Fazer um Release Normal

```bash
./scripts/release.sh patch
```

### 2. Gerar Appcast

Após criar o DMG, gere o appcast:

```bash
./scripts/generate-appcast.sh https://seu-dominio.com/releases
```

Isso criará/atualizará `releases/appcast.xml` com informações da nova versão.

### 3. Assinar o DMG (Opcional mas Recomendado)

Para segurança adicional, assine o DMG:

```bash
./scripts/sign-dmg.sh build/Pomodoro-1.0.dmg
```

### 4. Fazer Upload

Faça upload de:
- O DMG: `build/Pomodoro-X.X.dmg` → `https://seu-dominio.com/releases/`
- O appcast: `releases/appcast.xml` → `https://seu-dominio.com/releases/appcast.xml`

### 5. Verificar

Teste a atualização:
1. Instale uma versão antiga do app
2. Execute o app
3. Vá em **Settings → Updates → Check for Updates**
4. A atualização deve ser detectada

## Estrutura de Arquivos

```
projeto/
├── releases/
│   └── appcast.xml          # Feed de atualizações
├── scripts/
│   ├── generate-appcast.sh  # Gera appcast automaticamente
│   ├── sign-dmg.sh         # Assina DMG (opcional)
│   └── generate-keys.sh     # Gera chaves EdDSA
└── build/
    └── Pomodoro-X.X.dmg     # DMG para distribuição
```

## Hospedagem do Appcast

Você precisa hospedar o `appcast.xml` e os DMGs em um servidor web. Opções:

### Opção 1: GitHub Releases

1. Crie releases no GitHub
2. Use GitHub Pages ou raw.githubusercontent.com para o appcast
3. URLs: `https://github.com/usuario/repo/releases/download/v1.0/Pomodoro-1.0.dmg`

### Opção 2: Servidor Próprio

1. Configure um servidor web (Apache, Nginx, etc.)
2. Faça upload dos arquivos
3. Configure HTTPS (obrigatório para Sparkle)

### Opção 3: Serviços de CDN

- AWS S3 + CloudFront
- Cloudflare Pages
- Netlify
- Vercel

## Exemplo de Appcast

O appcast é um feed RSS XML. Exemplo:

```xml
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
    <channel>
        <title>Pomodoro App Updates</title>
        <link>https://seu-dominio.com/releases</link>
        <item>
            <title>Version 1.1</title>
            <pubDate>Mon, 25 Jan 2026 12:00:00 +0000</pubDate>
            <sparkle:minimumSystemVersion>26.2</sparkle:minimumSystemVersion>
            <enclosure
                url="https://seu-dominio.com/releases/Pomodoro-1.1.dmg"
                sparkle:version="2"
                sparkle:shortVersionString="1.1"
                length="5242880"
                type="application/octet-stream"
                sparkle:edSignature="ASSINATURA_AQUI"
            />
            <description><![CDATA[
                <h2>Version 1.1</h2>
                <ul>
                    <li>Novas funcionalidades</li>
                    <li>Correções de bugs</li>
                </ul>
            ]]></description>
        </item>
    </channel>
</rss>
```

## Segurança

### Assinatura EdDSA

Sparkle usa assinatura EdDSA para verificar que os updates não foram modificados:

1. **Chave Privada**: Usada para assinar cada release (mantenha segura!)
2. **Chave Pública**: Incluída no Info.plist do app

### HTTPS Obrigatório

O appcast e os DMGs devem ser servidos via HTTPS. Sparkle não aceita HTTP por segurança.

### Notarização (Opcional)

Para melhor compatibilidade com Gatekeeper:
1. Assine o app com Developer ID
2. Notarize com Apple
3. Os usuários não precisarão desabilitar Gatekeeper

## Troubleshooting

### Atualizações não aparecem

1. Verifique se `SUFeedURL` está correto no Info.plist
2. Verifique se o appcast está acessível via HTTPS
3. Verifique se a versão no appcast é maior que a atual
4. Verifique os logs do console para erros

### Erro de Assinatura

1. Verifique se `SUPublicEDKey` está correto no Info.plist
2. Verifique se o DMG foi assinado com a chave privada correspondente
3. Regere as chaves se necessário

### DMG não baixa

1. Verifique se a URL do DMG está correta
2. Verifique se o servidor permite downloads
3. Verifique se o tamanho do arquivo está correto no appcast

## Integração no App

O app já está configurado com `UpdateManager` e `UpdateSettingsSection`. Quando Sparkle for adicionado:

1. O app verificará atualizações automaticamente (diariamente)
2. Os usuários verão uma seção "Updates" nas configurações
3. Podem verificar manualmente clicando em "Check for Updates"

## Scripts Disponíveis

- `generate-appcast.sh`: Gera/atualiza o appcast.xml
- `sign-dmg.sh`: Assina o DMG com EdDSA (a criar)
- `generate-keys.sh`: Gera par de chaves EdDSA (a criar)

## Próximos Passos

1. Adicionar Sparkle ao projeto
2. Configurar `SUFeedURL` e `SUPublicEDKey`
3. Gerar chaves EdDSA
4. Configurar servidor para hospedar releases
5. Fazer primeiro release com atualizações

## Referências

- [Sparkle Documentation](https://sparkle-project.org/documentation/)
- [Sparkle GitHub](https://github.com/sparkle-project/Sparkle)
- [App Signing Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
