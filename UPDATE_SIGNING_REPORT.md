# Relatório — Falha de assinatura do update (Sparkle)

## Resumo
O update ainda falha com:
**“The update is improperly signed and could not be validated.”**

Após as correções, o app instalado **agora contém** `SUPublicEDKey` e `SUFeedURL`, e a **chave pública derivada** da chave privada local **bate** com a chave pública embutida no app. Mesmo assim, o erro persiste.

Isso indica que o problema **não é mais a ausência da chave no app**, e sim **(a) assinatura do ZIP feita com outra chave** ou **(b) mismatch de code signing** entre o app instalado e o update.

## O que foi feito / verificado
1. **Sintoma inicial**
   - Erro: `The update is improperly signed and could not be validated.`

2. **Causa inicial encontrada**
   - O app instalado **não continha** `SUPublicEDKey` nem `SUFeedURL` no `Info.plist`.

3. **Correção aplicada no projeto**
   - Criado `converge/Info.plist` com:
     - `SUFeedURL = https://rckbrcls.github.io/converge/appcast.xml`
     - `SUPublicEDKey = c3jKYVWrrjNacKjLqspxj/rlbVeDt13eC+lH4Cc5inU=`
   - `INFOPLIST_FILE = converge/Info.plist`
   - `GENERATE_INFOPLIST_FILE = NO`
   - CI passou a falhar se as chaves não estiverem no app gerado.

4. **Validação local após o release**
   - O `Info.plist` do app instalado **contém** `SUPublicEDKey` e `SUFeedURL`.

5. **Chave pública derivada da chave privada local**
   - `keys/eddsa_private_key.pem` → `c3jKYVWrrjNacKjLqspxj/rlbVeDt13eC+lH4Cc5inU=`
   - **Combina** com o `SUPublicEDKey` embutido no app.

## Por que ainda não funciona
Com o app contendo a chave correta, restam duas causas prováveis:

### 1) CI assinando com **outra chave privada**
Se o secret `SPARKLE_EDDSA_PRIVATE_KEY` do GitHub **não for o mesmo** que `keys/eddsa_private_key.pem`, a assinatura do ZIP não vai bater com o `SUPublicEDKey` do app.

**Sinal de que isso está acontecendo:**
- A assinatura (`sparkle:edSignature`) no `appcast.xml` **não coincide** com a assinatura gerada localmente para o ZIP publicado.

### 2) **Mismatch de code signing**
Se o app instalado estiver assinado (Developer ID) e o update estiver unsigned ou assinado com outra identidade/entitlements, o Sparkle pode rejeitar o update com erro de assinatura.

## Verificações pendentes (para isolar a causa)

### A) Garantir que o secret do GitHub é a mesma chave privada
Regravar o secret diretamente do arquivo local:

```bash
gh secret set SPARKLE_EDDSA_PRIVATE_KEY -b "$(cat keys/eddsa_private_key.pem)"
```

Depois, fazer novo release.

### B) Comparar assinatura do ZIP com o `appcast.xml`
1. Baixar o ZIP do release.
2. Rodar `sign_update` localmente com a **chave privada correta**.
3. Comparar o `sparkle:edSignature` gerado com o do `appcast.xml`.

Se não bater, o CI está assinando com outra chave ou o ZIP mudou depois da assinatura.

### C) Verificar code signing entre app instalado e update
Comparar identidades de assinatura:

```bash
codesign -dv --verbose=4 /Applications/Converge.app 2>&1 | rg "Authority|TeamIdentifier|Signature"
```

E no app extraído do ZIP de update:

```bash
codesign -dv --verbose=4 /tmp/converge/Converge.app 2>&1 | rg "Authority|TeamIdentifier|Signature"
```

Se houver diferença, o update pode ser rejeitado.

## Conclusão
A falta de `SUPublicEDKey` foi **corrigida**, mas o erro persiste porque o **ZIP assinado no CI provavelmente não está usando a mesma chave privada** que o app espera, ou porque há **mismatch de code signing** entre o app instalado e o update.

A próxima ação crítica é **regravar o secret do GitHub** com a chave privada correta e validar a assinatura do ZIP contra o `appcast.xml`.
