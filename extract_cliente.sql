

-----------------------------------------------------------------------
select
	co_usuario_farmacia as id
	,
	dt_nascimento::date as dt_nascimento,
		dt_cadastro::date as dt_cadastro,
	id_gender as de_sexo,
	person_name_use_official_t::varchar as nm_nome_oficial,
	person_address_use_home_state::varchar as cd_uf_estado,
	person_address_use_home_id_municipio_t as id_ibge_municipio,
	person_address_use_home_postalcode::varchar as cd_cep,
	person_address_use_home_country::varchar as cd_pais,
	person_address_use_home_text_t::varchar as de_logradouro,
	person_address_use_home_district::varchar as nm_bairro
from
	(
	select
		tuf.co_usuario_farmacia 
,
		substring(trim(translate(upper(tuf.no_usuario), 'áàâãäåÁÂÃÄÅÀéèêëÉÊÈìíîïìÌÍÎÏÌóôõöòÒÓÔÕÖùúûüÙÚÛÜçÇñÑýÝ0123456789|\+=;"´_`''^~&¨#!?@%}]{[:*()°ºª,', 'aaaaaaAAAAAAeeeeEEEiiiiiIIIIIoooooOOOOOuuuuUUUUcCnNyY')), 1, 9) || '@GMAIL.COM' as person_email_use_official_t
,
		case
			when translate (trim(upper(tuf.no_usuario)) ,
			'_.-/|\+=;"´`'',^~&¨#!?@%}]{[:*()0123456789 A',
			'') = '' then null
			else substring(trim(translate(upper(tuf.no_usuario), 'áàâãäåÁÂÃÄÅÀéèêëÉÊÈìíîïìÌÍÎÏÌóôõöòÒÓÔÕÖùúûüÙÚÛÜçÇñÑýÝ0123456789|\+=;"´_`''^~&¨#!?@%}]{[:*()°ºª,', 'aaaaaaAAAAAAeeeeEEEiiiiiIIIIIoooooOOOOOuuuuUUUUcCnNyY')), 1, 9)
		end as person_name_use_official_t
,
		tuf.dt_nascimento_usuario as dt_nascimento
,
		case
			when trim(sg_sexo_usuario) = 'F' then 'Feminino'
			when trim(sg_sexo_usuario) = 'M' then 'Masculino'
			else null
		end as id_gender 
,
		cast(dt_atualizacao as date) as dt_cadastro
,
		case
			when translate (trim(upper(no_logradouro_usuario)) ,
			'.-/|\+=;"´`'',^~&¨#!?@%}]{[:*()0123456789 A',
			'') = '' then null
			else trim(translate(upper(no_logradouro_usuario), 'áàâãäåÁÂÃÄÅÀéèêëÉÊÈìíîïìÌÍÎÏÌóôõöòÒÓÔÕÖùúûüÙÚÛÜçÇñÑýÝ0123456789|\+=;"´`''^~&¨#!?@%}]{[:*()°ºª,', 'aaaaaaAAAAAAeeeeEEEiiiiiIIIIIoooooOOOOOuuuuUUUUcCnNyY'))
		end as person_address_use_home_text_t,
		case
			when co_pais_nacionalidade is null then null
			when co_pais_nacionalidade = '010' then 'BR'
			else 'BR'
		end as person_address_use_home_country,
		case
			when translate (trim(upper(co_municipio_logradouro)),
			'ABCDEFGHIJKLMNOPQRSTUVWXYZÂÁÃÀÉÈÊÍÓÔÕÚÇ.-/|\+=;"´`'',^~&¨#!?@%}]{[:*() ',
			'') = '' then null
			else substring(translate (trim(upper(co_municipio_logradouro)),
			'ABCDEFGHIJKLMNOPQRSTUVWXYZÂÁÃÀÉÈÊÍÓÔÕÚÇ.-/|\+=;"´`'',^~&¨#!?@%}]{[:*() ',
			''), 1, 6)
		end as person_address_use_home_id_municipio_t,
		nu_cep_usuario as person_address_use_home_postalcode,
		case
			when translate (trim(upper(no_bairro_usuario)) ,
			'.-/|\+=;"´`'',^~&¨#!?@%}]{[:*()0123456789 A',
			'') = ''
	 then null
			else trim(translate(upper(no_bairro_usuario), 'áàâãäåÁÂÃÄÅÀéèêëÉÊÈìíîïìÌÍÎÏÌóôõöòÒÓÔÕÖùúûüÙÚÛÜçÇñÑýÝ0123456789|\+=;"´`''^~&¨#!?@%}]{[:*()°ºª,', 'aaaaaaAAAAAAeeeeEEEiiiiiIIIIIoooooOOOOOuuuuUUUUcCnNyY'))
		end as person_address_use_home_district,
		case
			when sg_uf_rg_usuario = '' then null
			else trim(translate(upper(sg_uf_rg_usuario), 'áàâãäåÁÂÃÄÅÀéèêëÉÊÈìíîïìÌÍÎÏÌóôõöòÒÓÔÕÖùúûüÙÚÛÜçÇñÑýÝ0123456789|\+=;"´`''^~&¨#!?@%}]{[:*()°ºª,', 'aaaaaaAAAAAAeeeeEEEiiiiiIIIIIoooooOOOOOuuuuUUUUcCnNyY'))
		end as person_address_use_home_state
	from
		sismedex.tb_usuario_farmacia tuf
	left join sismedex.tb_pais tp on
		tuf.co_pais_nacionalidade = tp.co_pais 
) as t1
where
	 co_usuario_farmacia in (
	select
		co_usuario_farmacia
	from
		(
		select
			tsm.co_usuario_farmacia
	,
			dt_deferimento_solicitacao as dt_venda
	,
			med.no_medicamento
	,
			case
				when med.no_medicamento like 'ACITRETINA 10mg%' then 50
				when med.no_medicamento like 'ACITRETINA 25mg%' then 80
				when med.no_medicamento like 'ADALIMUMABE 40 MG ORIGINADOR %' then 1200
				when med.no_medicamento like 'ALFADORNASE 2,5 MG %' then 150
				when med.no_medicamento like 'ALFAEPOETINA 2.000 U.I %' then 60
				when med.no_medicamento like 'ALFAEPOETINA 3.000 U.I.%' then 80
				when med.no_medicamento like 'ALFAEPOETINA 4.000 U.I.%' then 100
				when med.no_medicamento like 'ALFAEPOETINA 10.000 U.I. %' then 200
				when med.no_medicamento like 'AMANTADINA 100 MG%' then 30
				when med.no_medicamento like 'ATORVASTATINA 10MG %' then 20
				when med.no_medicamento like 'ATORVASTATINA 20 MG%' then 30
				when med.no_medicamento like 'AZATIOPRINA 50MG %' then 40
				when med.no_medicamento like 'BETAINTERFERONA 1A 6.000.000 UI (22 MCG) %' then 500
				when med.no_medicamento like 'BETAINTERFERONA 1A 6.000.000 UI (30 MCG) %' then 600
				when med.no_medicamento like 'BETAINTERFERONA 1A 12.000.000 UI (44 MCG)%' then 1200
				when med.no_medicamento like 'BETAINTERFERONA 1B 9.600.000 UI (300MCG) 15 un %' then 1800
				when med.no_medicamento like 'BEZAFIBRATO 200 MG %' then 40
				when med.no_medicamento like 'BEZAFIBRATO 400 MG %' then 60
				when med.no_medicamento like 'BUDESONIDA 200 MCG %' then 30
				when med.no_medicamento like 'CABERGOLINA 0.5 MG %' then 90
				when med.no_medicamento like 'CALCITONINA 200 UI %' then 70
				when med.no_medicamento like 'CALCITRIOL 0,25 MCG%' then 40
				when med.no_medicamento like 'CICLOSPORINA 25 MG %' then 150
				when med.no_medicamento like 'CICLOSPORINA 50 MG %' then 250
				when med.no_medicamento like 'CICLOSPORINA 100 MG%' then 400
				when med.no_medicamento like 'CICLOSPORINA 100 MG/ML %' then 450
				when med.no_medicamento like 'CIPROFIBRATO 100 MG%' then 50
				when med.no_medicamento like 'CIPROTERONA 50 MG%' then 70
				when med.no_medicamento like 'CLOROQUINA 150 MG%' then 20
				when med.no_medicamento like 'CLOZAPINA 100 MG %' then 90
				when med.no_medicamento like 'CLOZAPINA 25 MG%' then 40
				when med.no_medicamento like 'CODEINA 3 MG/ML SOL ORAL %' then 30
				when med.no_medicamento like 'CODEINA 30 MG%' then 50
				when med.no_medicamento like 'COMPL ALIMENTAR MENOR 1 ANO FENILCETONURICOS %' then 60
				when med.no_medicamento like 'COMPL ALIMENTAR 1-8 ANOS FENILCETONURICOS%' then 70
				else null
			end as vl_PRECO
		from
			tb_solicitacao_medicamento tsm
		join
	tb_medicamento_solicitado msol on
			tsm.co_usuario_farmacia = msol.co_usuario_farmacia
			and tsm.co_solicitacao_medicamento = msol.co_solicitacao_medicamento
		join tb_medicamento med on
			msol.co_medicamento = med.co_medicamento
		where
			dt_deferimento_solicitacao > '2022-12-31 23:59:59.052') as Q1
	where
		vl_PRECO is not null)
order by
	id;