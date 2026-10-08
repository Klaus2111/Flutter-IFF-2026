# Roteiro de apresentação — Mural IFF

Use como apoio e adapte com suas palavras. Faça a demonstração somente depois de concluir a configuração do Firestore descrita no README.

## Abertura

“Meu projeto é o Mural IFF, um aplicativo de dúvidas e respostas entre estudantes. A ideia é organizar as dúvidas por disciplina, para que uma explicação possa ajudar tanto quem perguntou quanto outros alunos com a mesma dificuldade.”

## Enquanto mostra o aplicativo

“Primeiro, o usuário cria uma conta ou entra com e-mail e senha. Essa autenticação é feita pelo Firebase. A opção de lembrar o e-mail usa Shared Preferences para guardar o endereço no próprio dispositivo. A senha não é armazenada nesse recurso.

No mural, o aluno pode filtrar as publicações por disciplina e por situação: abertas ou resolvidas. Esses filtros são feitos com consultas ao Firestore.

Ao publicar uma dúvida, o aplicativo cria um documento na coleção perguntas. As contribuições dos colegas ficam na subcoleção respostas, dentro daquela pergunta. Assim, cada conversa fica ligada à dúvida correspondente.

Para demonstrar a interação, uma conta publica a pergunta e outra envia uma resposta. O StreamBuilder acompanha as mudanças do banco e atualiza a tela. O autor da pergunta pode marcar que sua dúvida foi resolvida.”

## Mostrando o código

“Separei as telas dos métodos que acessam o banco. No arquivo banco.dart estão a publicação, os filtros, as respostas e a mudança de situação. Usei StatefulWidget e setState para controlar as opções das telas. O FutureBuilder aguarda o carregamento do e-mail salvo, e o StreamBuilder acompanha dados que podem mudar continuamente.

As regras do banco exigem que a pessoa esteja autenticada, conferem os campos enviados e impedem que um aluno marque a pergunta de outro como resolvida.”

## Perguntas para treinar

1. Por que respostas é uma subcoleção? Porque cada resposta pertence à conversa de uma pergunta específica.
2. Qual é a diferença entre Firebase Authentication e Shared Preferences? O primeiro autentica o usuário; o segundo guarda uma preferência local.
3. Onde aparecem os dois filtros? Em observarPerguntas, com where para disciplina e resolvida.
4. Por que StreamBuilder? Porque recebe novos estados do banco e reconstrói a parte da tela relacionada a eles.
5. Para que serve setState? Para avisar ao Flutter que uma informação local da tela mudou e deve ser exibida novamente.
6. Por que as regras também conferem o autor? Porque esconder um botão na tela não impede uma tentativa de alterar o banco por outro cliente.

Antes de apresentar, pratique localizar esses pontos no código e explique cada um com um exemplo.
