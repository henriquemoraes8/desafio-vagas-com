object @application
attributes :id, :score

node (:pessoa) { partial('users/show', :object => @application.user) }
node (:vaga) { partial('jobs/show', :object => @application.job) }