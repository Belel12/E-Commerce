# E-Commerce

### Uma aplicação de eCommerce implementada em ruby utilizando o framework `Sinatra` para a disciplina de Programação Web.

### Dependências
* ruby ^3.x
* gema bundle instalada
  * você pode instalar rodando o comando `gem install bundler` no terminal

### Comandos Úteis
* **Instalar dependências do projeto**: `bundle install`
* **Construir o banco de dados**: `bundle exec rake build`
* **Apagar o banco existente**: `bundle exec rake db:drop`
* **Popular o banco de desenvolvimento com tuplas artificiais**: `bundle exec rake db:seed`
* **Executar suíte de testes completa**: `bundle exec rspec`
* **Iniciar servidor da aplicação**: `bundle exec rackup`

### Ambiente do aplicativo
O ambiente do aplicativo pode ser configurado dentro do código do `app.rb` em:
```ruby
ENV['RACK_ENV'] ||= 'ambiente'
```
Os ambientes disponíveis são:
* `'development'` -_padrão_
* `'production'`
  * Caso você builde o projeto usando o ambiente de 
  produção, o banco possui uma trava de segurança 
  contra deleção, sendo necessário rodar o comando
  ```shell
  DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop
  ```
##### Observações
* A porta padrão do servidor é `9292`, podendo ser configurada no arquivo `config.ru`
* Prints das telas da página estão disponíveis na pasta `page_prints`



