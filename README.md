# README

Esse projeto foi criado como parte do processo de entrevista para VAGAS.com

## Especificações

* Ruby: 2.6.0
* Rails: 5.2.2
* Db: Postgresql
* IDE: RubyMine

## Setup

Para inicializar o banco de dados deve-se executar 

`bundle intall`

`rake db:setup db:migrate`

O projeto possui dois arquivos para pre-popular o banco de dados.

O primeiro arquivo se chama `db/seeds/paths.rb` que possui a montagem inicial do grafo especificado no desafio 
técnico e pode ser executado via `rake db:seed:paths`

O segundo arquivo se chama `db/seeds/mock.rb` e popula o banco inicialmente com pessoas, vagas e candidaturas. 
Para executá-lo, basta rodar `rake db:seed:mock`

## Configurações e dependências

O projeto se mantém simples a única gem adicionada foi rabl para facilitar a montagem do retorno dos requests.
`config/initializers/rabl_config.rb` possui algumas configurações default para melhor montar o objeto de 
acordo com as especificações

Rails inerentemente não permite criar múltiplos arquivos de seed. Porém isso é possivel através do arquivo `lib/tasks/custom_seed.rake`.
Isso melhora a modularização da criação dos dados e permite ter um controle maior no tipo de informação produzida

O arquivo `mock.db` foi implementado da seguinte maneira:
* Cria-se um random generator com uma seed. A seed permitira que toda vez que os dados forem recriados as informações se manterão
consistentes para serem testadas
* Gera-se 20 pessoas com nivel e localização aleatórios
* Gera-se 20 vagas com nivel e localização aleatórios
* Gera-se 50 candidaturas entre pessoas e vagas aleatórias

## Migrações e banco de dados

O banco modela muito os specs fornecido na página do desafio. Apenas vale notar uma tabela de candidaturas (Applications)
que liga uma pessoa a uma vaga com um score e outra de arestas do grafo (Paths) que liga uma localização com outra através
de uma distância 

Os modelos utilizados são:
* User: representa uma pessoa. Os campos estão nomeados em inglês porem com o uso de `alias_attribute` podemos 
fazer o objeto responder normalmente às keys em português

* Location: representa uma localização. Os campos estão nomeados em inglês porem com o uso de `alias_attribute` podemos 
fazer o objeto responder normalmente às keys em português. Possui o método paths que retorna todos os caminhos ligados àquela
localização em específico

* Job: representa uma vaga. Os campos estão nomeados em inglês porem com o uso de `alias_attribute` podemos 
fazer o objeto responder normalmente às keys em português

* Application: representa uma candidatura. Esse modelo relaciona um User a um Job com o valor do score. O cálculo do score 
é feito através do callback `before_create` para salvar no objeto. Discutirei mais abaixo o porque dessa escolha e o algoritmo 
implementado

* Path: representa um caminho (aresta) entre duas localizações

Para ver um diagrama do banco de dados atual, favor consultar o arquivo `erd.pdf`

## Endpoints

A maioria dos chamadas são auto explicativas. Apenas o cálculo do score será elaborado abaixo. Caso não for providenciada
as informações corretas, o servidor enviará status 400 com a mensagem de erro do RM

```cassandraql
                Prefix Verb          Description                                            URI Pattern                                          Controller#Action
ranking_v1_vaga_candidaturas GET     Lista candidaturas para uma vaga baseado em ranking    /v1/vagas/:vaga_id/candidaturas/ranking(.:format)    v1/applications#ranking
                    v1_vagas GET     Lista vagas                                            /v1/vagas(.:format)                                  v1/jobs#index
                             POST    Cria uma vaga                                          /v1/vagas(.:format)                                  v1/jobs#create
                  v1_pessoas GET     Lista dos candidatos                                   /v1/pessoas(.:format)                                v1/users#index
                             POST    Cria um candidato                                      /v1/pessoas(.:format)                                v1/users#create
             v1_candidaturas POST    Cria uma candidatura                                   /v1/candidaturas(.:format)                           v1/applications#create
              v1_candidatura DELETE  Deleta uma candidatura                                 /v1/candidaturas/:id(.:format)                       v1/applications#destroy
                   v1_locais POST    Cria um local                                          /v1/locais(.:format)                                 v1/locations#create
                   v1_locais DELETE  Deleta um local                                        /v1/locais/:id(.:format)                             v1/locations#destroy
                   v1_locais GET     Lista os locais existentes                             /v1/locais(.:format)                                 v1/locations#index
```

## Cálculo do score

A primeira pergunta a se fazer para essa situação é "quando calcular o score?". Temos dois cases:

* Quando se cria a candidatura
* Quando se lista as candidaturas

Levando em consideracão que candidaturas são criadas com menos frequência do que são consultadas faz sentido calcularmos o 
score durante a criação de uma candidatura. Além do mais, se fosse calculado no retorno da listagem estaríamos desperdiçando processamento
executando cálculos repetidos toda a vez. Por isso, o mais adequado seria implementar o calculo durante o callback da criação
de uma candidatura 

Obviamente alguns fatores devem ser considerados já que estamos calculando o score previamente. E se a empresa mudar o seu branch? 
E se possuir multiplas localizações? E se um candidato melhorar seu nível técnico? Para fins do escopo desse desafio estamos 
considerando que:

* Um candidato aplica para uma vaga em uma localização escolhida e não para uma vaga em uma empresa que pode ter multiplas localizações

* Se algum aspecto mudar o candidato deve reaplicar à vaga. Candidaturas serão tratadas readonly e não podem ser modificadas, apenas deletadas.
Obviamente seria mais adequado um controle de status ao invés de simplesmente deletar uma candidatura mas, de novo, vamos nos 
manter ao escopo do desafio

O cálculo do score de uma candidatura é dado pela fórmula *(N + D)/2* onde:

* *N = 100 - 25 |Nivel vaga - Nivel candidato|*
* *D* é um valor cruzado com uma tabela da menor distância entre o candidato e a vaga

Calcular o valor de *N* é simples e direto ao ponto, porém o valor de *D* é um típico problema de encontrar o caminho mais curto 
em um grafo cujas arestas possuem um peso. O algorítmo mais adequado para essa situação é o de Dijkstra. O algorítimo é 
executado da seguinte maneira:

* Começamos pela localização do candidato

* Criamos um hash com todos os ids de localização mapeando para o valor da distancia mais curta do candidato. Inicializamos o 
local do candidato como distância 0 e os demais com distância infinita

* Mantemos uma array `seen` dos nodes que ja processamos e não precisam ser revisitados

* Utilizado as classes `Node` e `PriorityQueue` que serão discutidas abaixo, colocamos o primeiro node (local do usuário) no queue.

* Enquanto o queue não estiver vazio:

    * Popar o primeiro node com menor distancia total
    
    * Para cada caminho com endpoint não visitado ligando a esse node, verifique se a distância mínima ao endpoint é maior
    que a distância do node atual + a distância do caminho. Se sim, atualizamos a distância minima ao endpoint
    
    * Marcar o node atual como visto. 
    
    * Se o node visto é o local da vaga, quebramos o ciclo e retornamos a distância total a ele. Caso contrário repetimos o processo

### Node

Utilizamos um objeto Node para conseguir trabalhar o progresso do algoritmo:
```cassandraql
{ location_id: Int, distance: Int }
```

O Node implementa `Comparable` de uma forma que o Node com distância menor deva ser priorizado. Implementando dessa forma
nos permite sempre poparmos o melhor node do `PriorityQueue` e executarmos o algorítmo de forma gananciosa

### Priority Queue

Utilizamos um heap binário para o melhor aproveitamento de performance. O heap implementa 3 metodos:

* << para adicionar um objeto

* pop para retirar um objeto priorizado

* size para saber o tamanho do queue

O método de implementação escolhido visa simplicidade e eficiência. Embora não existe uma estrutura de dados para referenciar
os branches da árvore, podemos facilmente simular o heap binário com uma array onde, dado um Node em *index*, seu branch esquerdo 
estará em *index * 2* e o direito estará em *index * 2 + 1*

O heap binário possui no pior caso uma performance *O(log n)* já que no máximo um objeto deve atravessar a altura da árvore completa. 
Cada pai na árvore será sempre maior que os filhos.
Então quando adicionamos um objeto ao queue, vamos recursivamente subindo esse Node na árvore até o pai imediato ser maior
ou ele chegar na raiz.

Similarmente, ao popar um objeto, nós trocamos o último item com o primeiro (garantido ser o maior elemento) e popamos esse elemento 
do queue. Depois, recursivamente descemos o primeiro Node na árvore até ele ser imediatamente maior que os filhos ou chegar ao fim da árvore

### Complexidade

Considerando um grafo totalmente conectado:

Para evitar o consumo de memória no stack de chamadas de métodos, preferimos uma solução iterativa ao invés de recursiva.

O loop continua enquanto ainda temos vértices para visitar, e para cada vértice devemos comparar os caminhos (arestas). 
Considerando o total de Locais *L* e o total de caminhos bidirecionais *C* nós temos uma execução de *O(L + C)*. Note
que no algoritmo nos não processamos arestas de locais ja visitados e por isso a complexidade não se multiplica.

Porém, devemos considerar tambem o processamento do heap binário que é executado dentro do loop, dando uma complexidade
total de 

`O((L + C) log L)`

Obviamente ainda temos heurísticas implementadas para cessar o loop assim que local da vaga for marcado como visitado, evitando 
assim o processamento do grafo inteiro


### Testes

Para rodar os testes utilizamos `rspec` e `shoulda`. O escopo dos testes se limitam apenas à validação de modelos. Todos os
arquivos validam campos e associações exceto `spec/models/application_spec.rb`, que possui alguns
casos de candidato + vaga para testar se o score foi calculado corretamente

Para rodar os testes basta executar

`rspec spec/models`

