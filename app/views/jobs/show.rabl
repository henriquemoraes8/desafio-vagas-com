object @job
attributes :id, :empresa, :titulo, :descricao, :nivel

node (:localizacao) { |c| c.localizacao.name }