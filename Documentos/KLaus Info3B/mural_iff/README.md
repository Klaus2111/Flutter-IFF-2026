# Mural IFF

Aplicativo estudantil de perguntas e respostas para o IFF Itaperuna.

**Aluno:** Klaus Samuel de Souza Setta • **Turma:** INFO3B  
**Disciplina:** Programação para Dispositivos Móveis

O aluno publica uma dúvida, escolhe uma disciplina e recebe explicações de outros usuários. O autor pode marcar a dúvida como resolvida e reabri-la. As respostas aparecem em tempo real.

## Estado da configuração em 08/10/2026

- Código implementado e análise do Flutter sem problemas.
- Quatro testes locais aprovados; versão Web compilada e tela de entrada/cadastro conferida no navegador.
- Aplicativos Android e Web registrados no Firebase; login por e-mail e senha habilitado.
- Firestore criado na região São Paulo (`southamerica-east1`), com autorização do aluno; regras deste projeto publicadas.
- Os três índices dos filtros estão habilitados (Enabled).
- Cadastro e entrada da primeira conta fictícia verificados no navegador. Uma publicação de demonstração foi enviada, mas sua confirmação final não foi verificada.
- **Verificação pendente:** conversa completa entre duas contas. Os testes foram autorizados pelo aluno, mas a revisão automática ficou indisponível por limite de uso antes da conclusão do segundo cadastro.
- APK Android de demonstração compilado com sucesso. Ainda não foi instalado em um aparelho físico.

Os testes locais não comprovam ainda o funcionamento completo do banco online.

## Executar

Abra esta pasta no VS Code ou Android Studio. No terminal da pasta:

```powershell
flutter pub get
flutter run -d chrome
```

Para Android, conecte um celular com depuração USB ou abra um emulador, confira `flutter devices` e execute `flutter run -d ID_DO_DISPOSITIVO`. O aplicativo exige Android 7.0 (API 24) ou superior e conexão com a internet.

Para gerar um APK de demonstração:

```powershell
flutter build apk --debug
```

O arquivo fica em `build/app/outputs/flutter-apk/app-debug.apk`. Ele serve para testes e apresentação; não é uma versão assinada para publicar na loja.

## O que atende ao enunciado

| Exigência | Implementação |
| --- | --- |
| Flutter e Firebase na conta do aluno | Projeto `mural-iff-63e6c`, aplicativos Android e Web |
| Coleção e subcoleção | `perguntas/{id}/respostas/{id}` |
| Autenticação | Cadastro, entrada por e-mail e senha e saída da conta |
| Shared Preferences | Opção “Lembrar meu e-mail”; ao desmarcar, remove o endereço salvo |
| Dois filtros no banco | Disciplina e situação (aberta/resolvida), combináveis |
| Troca real de informações | Um usuário publica, outro responde; todos veem a conversa |

## Entenda os arquivos

| Arquivo | Responsabilidade |
| --- | --- |
| `lib/main.dart` | Inicializa o Firebase, define o tema e acompanha a sessão |
| `lib/firebase_options.dart` | Configuração dos aplicativos Android e Web |
| `lib/telas/login.dart` | Formulários de entrada e cadastro |
| `lib/telas/mural.dart` | Lista de dúvidas e filtros |
| `lib/telas/nova_pergunta.dart` | Publicação de uma pergunta |
| `lib/telas/detalhes.dart` | Conversa, respostas e mudança de situação |
| `lib/servicos/banco.dart` | Consultas e gravações do Firestore |
| `lib/servicos/preferencias.dart` | Leitura e gravação do e-mail no aparelho |
| `lib/servicos/validacao.dart` | Validação dos campos |
| `lib/modelos/pergunta.dart` | Converte documentos do banco em objetos Dart |
| `lib/componentes.dart` | Componentes visuais pequenos e reutilizáveis |
| `firestore.rules` | Permissões e validações do banco |
| `firestore.indexes.json` | Índices necessários para os filtros com ordenação |

## Conceitos para explicar

- **StatefulWidget e setState:** guardam e atualizam escolhas da tela, como filtro e visibilidade da senha.
- **Future e await:** aguardam uma operação que termina, como publicar uma pergunta ou carregar o e-mail salvo.
- **FutureBuilder:** mostra o formulário depois da leitura das preferências locais.
- **Stream e StreamBuilder:** recebem atualizações contínuas do login, das perguntas e das respostas.
- **Navigator:** abre a tela de publicação e a conversa de uma pergunta.
- **Form e validator:** impedem o envio de campos vazios, e-mail inválido e textos fora dos limites.
- **where:** executa os filtros no Firestore. `orderBy` coloca primeiro as perguntas mais recentes.

Foi usado Flutter/Dart com os pacotes oficiais do Firebase e Shared Preferences, sem gerenciador de estado externo. O Firebase gerencia a sessão; Shared Preferences guarda apenas a preferência do e-mail, nunca a senha.

## Estrutura dos dados

```text
perguntas (coleção)
  ID_DA_PERGUNTA (documento)
    titulo, texto, disciplina
    autorId, autorNome
    resolvida, criadaEm
    respostas (subcoleção)
      ID_DA_RESPOSTA (documento)
        texto, autorId, autorNome, criadaEm
```

As coleções surgem quando o primeiro documento é gravado. Não é necessário criar coleções vazias no console. A data usa o relógio do servidor (`FieldValue.serverTimestamp`).

## Configuração do Firebase

O projeto está vinculado a `mural-iff-63e6c` (número `804346675489`). A configuração Web está em `lib/firebase_options.dart`; a Android também está em `android/app/google-services.json`. Esses arquivos contêm identificadores do cliente, não uma chave privada administrativa.

Para concluir ou recriar a configuração no console:

1. Em Authentication, habilite **Email/Password**.
2. Em Firestore, crie o banco **(default)**, edição **Standard**, com regras iniciais de produção.
3. Na aba **Rules**, publique o conteúdo completo de `firestore.rules`.
4. Em **Indexes**, crie os três índices da tabela abaixo para a coleção `perguntas`, escopo **Collection**. Aguarde todos ficarem habilitados.

| Índice | Campos e ordem |
| --- | --- |
| Disciplina | `disciplina` Ascending, `criadaEm` Descending |
| Situação | `resolvida` Ascending, `criadaEm` Descending |
| Combinado | `disciplina` Ascending, `resolvida` Ascending, `criadaEm` Descending |

Se usar a CLI do Firebase já autenticada na conta proprietária, os arquivos também permitem executar `firebase deploy --only firestore --project mural-iff-63e6c`.

As regras exigem login, validam os campos e vinculam o autor ao usuário autenticado. Só o autor muda a situação de sua pergunta. O aplicativo não permite apagar perguntas ou respostas. Todo usuário cadastrado pode ler o mural e participar: trata-se de um protótipo estudantil, sem validação de matrícula do IFF.

## Demonstração para o professor

1. Abra duas sessões independentes, por exemplo Chrome e outro navegador, ou navegador e celular.
2. Cadastre uma conta em cada sessão, com e-mails diferentes. Use dados de teste; não use sua senha do Google.
3. Na conta A, publique uma dúvida: **“Quando usar StatefulWidget?”**, disciplina **Programação**. Descreva a dúvida com pelo menos 10 caracteres.
4. Na conta B, abra a pergunta e envie uma explicação. A conta A deve recebê-la sem recarregar.
5. Mostre que a conta B não tem o botão de resolver a pergunta da conta A.
6. Na conta A, marque como resolvida. Use o filtro **Resolvidas**, depois combine com **Programação**. Em **Abertas**, a pergunta deve desaparecer.
7. Saia da conta com “Lembrar meu e-mail” marcado e confira o preenchimento automático. Entre com a opção desmarcada e saia novamente: o campo deve ficar vazio.
8. No console, mostre o documento da pergunta e a subcoleção de respostas. Explique os métodos de `banco.dart` e os dois tipos de Builder.

## Verificar o projeto

```powershell
flutter analyze
flutter test
flutter build web
```

Os testes locais conferem validação dos formulários, remoção do e-mail salvo e uso da tela de cadastro em 360 × 640. Eles não substituem a demonstração entre duas contas conectadas ao Firebase.

## Se aparecer um erro

- **Login não habilitado:** habilite Email/Password no Authentication.
- **Sem permissão:** confira o login e publique as regras deste projeto.
- **Filtro precisa de índice:** crie os índices e aguarde o estado habilitado.
- **Android pede licenças:** o responsável pelo computador precisa ler e aceitar os termos com `flutter doctor --android-licenses`.
- **Nenhum aparelho encontrado:** ligue a depuração USB, autorize o computador no celular ou use Chrome.

## Referências

- [Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [Configuração Android do Firebase](https://firebase.google.com/docs/android/setup)
- [Regras do Cloud Firestore](https://firebase.google.com/docs/firestore/security/rules-conditions)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
