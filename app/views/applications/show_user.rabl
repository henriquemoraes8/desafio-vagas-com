object @application
attributes :id, :score

node do |t|
{
    :id_pessoa => t.user.id,
    :nome => t.user.name,
    :profissao => t.user.job_description,
    :nivel => t.user.level,
    :localizacao => t.user.location.name
}
end

