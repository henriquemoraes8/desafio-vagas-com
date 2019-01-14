object @application
attributes :id, :score

child (:pessoa) { extends('users/show') }
child (:vaga) { extends('jobs/show') }