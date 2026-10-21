CREATE OR REPLACE TABLE `demo-project.analytics.metadata_pivot` AS
                SELECT
                    interaction_uuid,
                    created_at,
                    MAX(CASE WHEN name_hash = 'AccountId_j1Id' THEN value END) AS AccountId,
                    MAX(CASE WHEN name_hash = 'acesso_portal_RCDj' THEN value END) AS acesso_portal,
                    MAX(CASE WHEN name_hash = 'area_ybJX' THEN value END) AS area,
                    MAX(CASE WHEN name_hash = 'atendimento_comercial_uau3' THEN value END) AS atendimento_comercial,
                    MAX(CASE WHEN name_hash = 'Base/Filial_ejTM' THEN value END) AS Base_Filial,
                    MAX(CASE WHEN name_hash = 'cidade_ZbMS' THEN value END) AS cidade_geo,
                    MAX(CASE WHEN name_hash = 'Cidade_DL5h' THEN value END) AS cidade_log,
                    MAX(CASE WHEN name_hash = 'cluster_r9dd' THEN value END) AS cluster,
                    MAX(CASE WHEN name_hash = 'cnpj_k7IQ' THEN value END) AS cnpj_k7IQ,
                    MAX(CASE WHEN name_hash = 'CNPJ_9ijF' THEN value END) AS CNPJ_9ijF,
                    MAX(CASE WHEN name_hash = 'CNPJ Revenda que atendeu_6Sxy' THEN value END) AS CNPJ_Revenda_atendeu,
                    MAX(CASE WHEN name_hash = 'cod_erp_E22z' THEN value END) AS cod_erp,
                    MAX(CASE WHEN name_hash = 'codCliente_9udg' THEN value END) AS codCliente,
                    MAX(CASE WHEN name_hash = 'codEndereco_tWfr' THEN value END) AS codEndereco,
                    MAX(CASE WHEN name_hash = 'codigo_de_cliente_XUe6' THEN value END) AS codigo_de_cliente,
                    MAX(CASE WHEN name_hash = 'codigo_de_endereco_jvId' THEN value END) AS codigo_de_endereco,
                    MAX(CASE WHEN name_hash = 'codigo_erp_nrCL' THEN value END) AS codigo_erp,
                    MAX(CASE WHEN name_hash = 'consultor_4VbQ' THEN value END) AS consultor,
                    MAX(CASE WHEN name_hash = 'core_R4kE' THEN value END) AS core,
                    MAX(CASE WHEN name_hash = 'CPF_PZH7' THEN value END) AS CPF,
                    MAX(CASE WHEN name_hash = 'cpf_cnpj_YVZ0' THEN value END) AS cpf_cnpj,
                    MAX(CASE WHEN name_hash = 'CreatedDate_EOya' THEN value END) AS CreatedDate,
                    MAX(CASE WHEN name_hash = 'Cupom_pDVd' THEN value END) AS Cupom,
                    MAX(CASE WHEN name_hash = 'Código do Endereço_ieVM' THEN value END) AS Codigo_Endereco,
                    MAX(CASE WHEN name_hash = 'data_Rbu0' THEN value END) AS data,
                    MAX(CASE WHEN name_hash = 'Data Contrato Assinado_5dJP' THEN value END) AS Data_Contrato_Assinado,
                    MAX(CASE WHEN name_hash = 'Data de abertura_UBeH' THEN value END) AS Data_de_abertura,
                    MAX(CASE WHEN name_hash = 'Data de fechamento_adKA' THEN value END) AS Data_de_fechamento,
                    MAX(CASE WHEN name_hash = 'Data UC Ativada_39GN' THEN value END) AS Data_UC_Ativada,
                    MAX(CASE WHEN name_hash = 'Distribuidora Nome_ke63' THEN value END) AS Distribuidora_Nome,    
                    MAX(CASE 
                        WHEN name_hash = 'Data de envio importação timestamp_msDs' THEN 
                        FORMAT_TIMESTAMP('%F %H:%M', TIMESTAMP_SECONDS(CAST(CAST(value AS INT64) / 1000 AS INT64))) END) AS Data_de_envio_importacao_timestamp,
                    MAX(CASE WHEN name_hash = 'Data de envio importação_qfD4'THEN value END) AS Data_de_envio_importacao,    
                    MAX(CASE WHEN name_hash = 'Data de resposta importação_JXUa' THEN value END) AS Data_de_resposta_importacao,    
                    MAX(CASE WHEN name_hash = 'Nome da Pesquisa demo importação_n3tQ' THEN value END) AS Nome_da_pesquisa_demo_importacao,
                    MAX(CASE WHEN name_hash = 'document_REXw' THEN value END) AS document,
                    MAX(CASE WHEN name_hash = 'dt_registro_qYO0' THEN value END) AS dt_registro,
                    MAX(CASE WHEN name_hash = 'EndDateTime_ozte' THEN value END) AS EndDateTime,
                    MAX(CASE WHEN name_hash = 'estado_GMLS' THEN value END) AS estado,
                    MAX(CASE WHEN name_hash = 'ExternalLoadID_vI8L' THEN value END) AS ExternalLoadID,
                    MAX(CASE WHEN name_hash = 'ID_MhLN' THEN value END) AS ID,
                    MAX(CASE WHEN name_hash = 'Id Cliente_bXHp' THEN value END) AS Id_Cliente,
                    MAX(CASE WHEN name_hash = 'Id18 UC_jTGf' THEN value END) AS Id18_UC,
                    MAX(CASE WHEN name_hash = 'kWh Contratado_hrO6' THEN value END) AS kWh_Contratado,
                    MAX(CASE WHEN name_hash = 'last_order_status_Oy2o' THEN value END) AS last_order_status,
                    MAX(CASE WHEN name_hash = 'LastModifiedDate_WEDx' THEN value END) AS LastModifiedDate,
                    MAX(CASE WHEN name_hash = 'market_6mVg' THEN value END) AS market,
                    MAX(CASE WHEN name_hash = 'market_core_YquU' THEN value END) AS market_core,
                    MAX(CASE WHEN name_hash = 'mercado_lnra' THEN value END) AS mercado_lnra,
                    MAX(CASE WHEN name_hash = 'Mercado_i7AW' THEN value END) AS Mercado_i7AW,
                    MAX(CASE WHEN name_hash = 'micro_market_jSmY' THEN value END) AS micro_market,
                    MAX(CASE WHEN name_hash = 'Motivo do caso_MmzA' THEN value END) AS Motivo_caso,
                    MAX(CASE WHEN name_hash = 'motivo do contato_MOl2' THEN value END) AS motivo_contato,
                    UPPER(MAX(CASE WHEN name_hash = 'negocio' THEN value END)) AS negocio,
                    MAX(CASE WHEN name_hash = 'nome do atendente_TETT' THEN value END) AS nome_atendente,
                    MAX(CASE WHEN name_hash = 'nucleo_gUY4' THEN value END) AS nucleo_gUY4,
                    MAX(CASE WHEN name_hash = 'Núcleo_E1B3' THEN value END) AS Nucleo_E1B3,
                    MAX(CASE WHEN name_hash = 'Origem Revenda_hBfC' THEN value END) AS Origem_Revenda,
                    MAX(CASE WHEN name_hash = 'Originador Mercado_7cOt' THEN value END) AS Originador_Mercado,
                    MAX(CASE WHEN name_hash = 'Originador Nome_hlHB' THEN value END) AS Originador_Nome,
                    MAX(CASE WHEN name_hash = 'Originador Nucleo_jyzF' THEN value END) AS Originador_Nucleo,
                    MAX(CASE WHEN name_hash = 'Originador Segmento_g8vT' THEN value END) AS Originador_Segmento,
                    MAX(CASE WHEN name_hash = 'Originador Tipo_KyKd' THEN value END) AS Originador_Tipo,
                    MAX(CASE WHEN name_hash = 'proprietarioconta_SGON' THEN value END) AS proprietarioconta,
                    MAX(CASE WHEN name_hash = 'qual_grupo_economico_LgR3' THEN value END) AS qual_grupo_economico,
                    MAX(CASE WHEN name_hash = 'razaoSocial_WULA' THEN value END) AS razaoSocial,
                    MAX(CASE WHEN name_hash = 'Razão Social Revenda que atendeu_L8Al' THEN value END) AS Razao_Social_Revenda_que_atendeu,
                    MAX(CASE WHEN name_hash = 'RCR_Ku32' THEN value END) AS RCR,
                    MAX(CASE WHEN name_hash = 'Revenda_dEa0' THEN value END) AS Revenda,
                    MAX(CASE WHEN name_hash = 'segmentacao_grupo_economico_Pj8n' THEN value END) AS segmentacao_grupo_economico,
                    MAX(CASE WHEN name_hash = 'segmento_ah5q' THEN value END) AS segmento,
                    MAX(CASE WHEN name_hash = 'segmento_gerencial_8YPz' THEN value END) AS segmento_gerencial_8YPz,
                    MAX(CASE WHEN name_hash = 'SegmentoGerencial_Joeg' THEN value END) AS Segmento_Gerencial_Joeg,
                    MAX(CASE WHEN name_hash = 'StartDateTime_WcNH' THEN value END) AS StartDateTime,
                    MAX(CASE WHEN name_hash = 'stattusNF_Chro' THEN value END) AS stattusNF,
                    MAX(CASE WHEN name_hash = 'Status_mXqr' THEN value END) AS Status,
                    MAX(CASE WHEN name_hash = 'Status do Pedido_EohQ' THEN value END) AS Status_Pedido,
                    MAX(CASE WHEN name_hash = 'Submotivo_Yxzx' THEN value END) AS Submotivo,
                    MAX(CASE WHEN name_hash = 'tipo_contato_6j2P' THEN value END) AS tipo_contato,
                    MAX(CASE WHEN name_hash = 'tipo_programacao_tp6B' THEN value END) AS tipo_programacao,
                    MAX(CASE WHEN name_hash = 'uf_mOtg' THEN value END) AS uf_GEO,
                    MAX(CASE WHEN name_hash = 'UF_xkrU' THEN value END) AS uf_log
                FROM (
                    SELECT 
                        imtd.interaction_uuid,
                        imtd.created_dt AS created_at,
                        mtd.name,
                        mtd.public_hash,
                        CASE 
                            WHEN mtd.public_hash IS NULL OR mtd.public_hash = '' THEN mtd.name
                            ELSE CONCAT(
                                COALESCE(NULLIF(mtd.name, ''), ''),
                                '_',
                                COALESCE(NULLIF(mtd.public_hash, ''), '')
                            )
                        END AS name_hash,
                        CASE  
                            WHEN value = 'NUC Cear�' THEN 'NUC CEARÁ'
                            WHEN value = 'NUC Cear� Dom' THEN 'NUC CEARÁ DOM'
                            WHEN value = 'NUC Comercial Maranh�o' THEN 'NUC COMERCIAL MARANHÃO'
                            WHEN value = 'NUC Comercial Maranho' THEN 'NUC COMERCIAL MARANHÃO'                            
                            WHEN value = 'NUC Comercial Par�' THEN 'NUC COMERCIAL PARÁ'
                            WHEN value = 'NUC Comercial V�rzea Grande' THEN 'NUC COMERCIAL VÁRZEA GRANDE'
                            WHEN value = 'NUC Goi�nia' THEN 'NUC GOIÂNIA'
                            WHEN value = 'NUC Goinia' THEN 'NUC GOIÂNIA' 
                            WHEN value = 'NUC Mau� Emp' THEN 'NUC MAUÁ EMP'
                            WHEN value = 'NUC Paran� Emp' THEN 'NUC PARANÁ EMP'
                            WHEN value = 'NUC Par� Dom' THEN 'NUC PARÁ DOM'
                            WHEN value = 'NUC Paul�nia' THEN 'NUC PAULÍNIA'
                            WHEN value = 'NUC Paul�nia Dom' THEN 'NUC PAULÍNIA DOM'
                            WHEN value = 'NUC Paul�nia Emp' THEN 'NUC PAULÍNIA EMP'
                            WHEN value = 'NUC Piau� Dom' THEN 'NUC PIAUÍ DOM'
                            WHEN value = 'NUC Ribeir�o' THEN 'NUC RIBEIRÃO'
                            WHEN value = 'NUC Ribeir�o Preto' THEN 'NUC RIBEIRÃO PRETO'
                            WHEN value = 'NUC Ribeir�o Preto Dom' THEN 'NUC RIBEIRÃO PRETO DOM'
                            WHEN value = 'NUC S�o Jos� dos Campos Dom' THEN 'NUC SÃO JOSÉ DOS CAMPOS DOM'
                            WHEN value = 'Cear�' THEN 'CEARÁ'
                            WHEN value = 'Par�' THEN 'PARÁ'
                            WHEN value = 'MM BEL�M' THEN 'MM BELÉM'
                            WHEN value = 'MM BELM' THEN 'MM BELÉM'
                            WHEN value = 'MM BRAS�LIA' THEN 'MM BRASÍLIA'
                            WHEN value = 'MM BRASLIA' THEN 'MM BRASÍLIA'
                            WHEN value = 'MM CHAPEC�' THEN 'MM CHAPECÓ'
                            WHEN value = 'MM CHAPEC' THEN 'MM CHAPECÓ'
                            WHEN value = 'MM ESP�RITO SANTO' THEN 'MM ESPÍRITO SANTO'
                            WHEN value = 'MM ESPRITO SANTO' THEN 'MM ESPÍRITO SANTO'
                            WHEN value = 'MM EXPANS�O PAR� DOM' THEN 'MM EXPANSÃO PARÁ DOM'
                            WHEN value = 'MM EXPANS�O SUDESTE DOM' THEN 'MM EXPANSÃO SUDESTE DOM'
                            WHEN value = 'MM EXPANSO SUDESTE DOM' THEN 'MM EXPANSÃO SUDESTE DOM'
                            WHEN value = 'MM FLORIAN�POLIS' THEN 'MM FLORIANÓPOLIS'
                            WHEN value = 'MM FLORIANPOLIS' THEN 'MM FLORIANÓPOLIS'                            
                            WHEN value = 'MM JO�O PESSOA' THEN 'MM JOÃO PESSOA'
                            WHEN value = 'MM JOO PESSOA' THEN 'MM JOÃO PESSOA'
                            WHEN value = 'MM MAU� SBM EMP' THEN 'MM MAUÁ SBM EMP'
                            WHEN value = 'MM PAULNIA' THEN 'MM PAULÍNIA'                            
                            WHEN value = 'MM PAUL�NIA' THEN 'MM PAULÍNIA'
                            WHEN value = 'MM RIBEIR�O PRETO' THEN 'MM RIBEIRÃO PRETO'
                            WHEN value = 'MM S�O JOS� DOS CAMPOS' THEN 'MM SÃO JOSÉ DOS CAMPOS'
                            WHEN value = 'MM S�O LUIS' THEN 'MM SÃO LUÍS'
                            WHEN value = 'MM V�RZEA GRANDE' THEN 'MM VÁRZEA GRANDE'
                            WHEN value = 'MM VRZEA GRANDE' THEN 'MM VÁRZEA GRANDE'  
                            WHEN value = 'MM SO LUIS' THEN 'MM SÃO LUÍS'
                            WHEN value = 'Cear' THEN 'CEARÁ'
                            WHEN value = 'Ceara' THEN 'CEARÁ'
                            WHEN value = 'NUC Paran Emp' THEN 'NUC PARANÁ EMP'
                            WHEN value = 'Par' THEN 'PARÁ'
                            WHEN value = 'Para' THEN 'PARÁ'
                            WHEN value = 'NUC Cear' THEN 'NUC CEARÁ'
                            WHEN value = 'NUC Cear Dom' THEN 'NUC CEARÁ DOM'                                
                            WHEN value = 'NUC Comercial Par' THEN 'NUC COMERCIAL PARÁ'                                
                            WHEN value = 'NUC Paulnia Dom' THEN 'NUC PAULÍNIA DOM'                              
                            WHEN value = 'NUC Paulnia' THEN 'NUC PAULÍNIA DOM'    
                            WHEN value = 'UC PAULINIA' THEN 'NUC PAULÍNIAM'
                            WHEN value = 'NUC Paulnia Emp' THEN 'NUC PAULÍNIA EMP'                                                         
                            WHEN value = 'MM RIBEIRO PRETO' THEN 'MM RIBEIRÃO PRETO'                                                       
                            WHEN value = 'NUC Ribeiro' THEN 'NUC RIBEIRÃO'    
                            WHEN value = 'NUC Ribeir�o' THEN 'NUC RIBEIRÃO'    
                            WHEN value = 'NUC Ribeir�o Preto' THEN 'NUC RIBEIRÃO PRETO'  
                            WHEN value = 'NUC Ribeiro Preto' THEN 'NUC RIBEIRÃO PRETO'                              
                            WHEN value = 'NUC Ribeir�o Preto Dom' THEN 'NUC RIBEIRÃO PRETO DOM'
                            WHEN value = 'NUC Ribeiro Preto Dom' THEN 'NUC RIBEIRÃO PRETO DOM'              
                            WHEN value = 'nan' THEN null
                            ELSE value
                            END AS value
                    FROM `demo-project.analytics.metadata` AS mtd
                    LEFT JOIN `demo-project.analytics.interaction_metadata` AS imtd 
                    ON imtd.metadata_uuid = mtd.uuid
                    WHERE imtd.interaction_uuid IS NOT NULL
                ) AS sub
                GROUP BY interaction_uuid, created_at
                ;
