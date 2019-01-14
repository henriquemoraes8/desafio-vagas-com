object @user
attributes :id, :nome, :profissao, :nivel

node (:localizacao) { |c| c.localizacao.name }