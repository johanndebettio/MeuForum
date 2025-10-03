Aplicativo Flutter de Fórum local com uso de banco de dados SQLite.

Integrantes: Johan Debtil e João Vieira

O aplicativo conta com banco de dados SQLite, criptografia de senha com BCrypt, persistência de sessão com o provider, validações com expressões regulares para nome de usuário, senha, nome de exibição, título do post, conteúdo do post e comentários. 

O aplicativo é capaz de cadastrar usuários, ao efetuar login ele é direcionado para uma homepage exibindo todos os posts (página "Todos") criados por todos os usuários. Ao criar um post ele pode visualizá-lo na página "Meus Posts". Ele pode criar posts, comentar em posts, dar like ou dislike. Cada usuário é capaz de excluir seus próprios comentários e posts e também pode favoritar qualquer post para deixar salvo na página "Favoritos".

Nessa primeira versão, existe um usuário administrador com as credenciais: 

login: johan
senha: Johan123!

É preciso que essas credenciais sejam exatamente as citadas para que esse usuário criado seja capaz de: excluir QUALQUER post, excluir QUALQUER comentário e até RESETAR o banco de dados. 
