SELECT
                uuid,
                customer_uuid,
                survey_uuid,
                distribution_uuid,
                out_status,
                out_channel,
                out_at,
                in_status,
                in_channel,
                answered_at,
                opened_at,
                created_at,
                modified_at,
                deleted_at,
                CASE WHEN opened_at = 0 THEN NULL ELSE TO_TIMESTAMP(opened_at) AT TIME ZONE 'America/Sao_Paulo' END AS opened_dt,
                CASE WHEN opened_at = 0 THEN NULL ELSE DATE(TO_TIMESTAMP(opened_at) AT TIME ZONE 'America/Sao_Paulo') END AS opened_data,
                TO_TIMESTAMP(out_at) AT TIME ZONE 'America/Sao_Paulo' AS out_dt,
                DATE(TO_TIMESTAMP(out_at) AT TIME ZONE 'America/Sao_Paulo') AS out_data,
                TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo' AS created_dt,
                DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') AS created_data,
                TO_TIMESTAMP(modified_at) AT TIME ZONE 'America/Sao_Paulo' AS modified_dt,
                DATE(TO_TIMESTAMP(modified_at) AT TIME ZONE 'America/Sao_Paulo') AS modified_data,
                CASE WHEN answered_at = 0 THEN NULL ELSE TO_TIMESTAMP(answered_at) AT TIME ZONE 'America/Sao_Paulo' END AS answered_dt,
                CASE WHEN answered_at = 0 THEN NULL ELSE DATE(TO_TIMESTAMP(answered_at) AT TIME ZONE 'America/Sao_Paulo') END AS answered_data,
                TO_TIMESTAMP(deleted_at) AT TIME ZONE 'America/Sao_Paulo' AS deleted_dt,
                DATE(TO_TIMESTAMP(deleted_at) AT TIME ZONE 'America/Sao_Paulo') AS deleted_data,
                CURRENT_TIMESTAMP AT TIME ZONE 'America/Sao_Paulo' AS extracted_at
            FROM demo_schema.interactions
            WHERE 
                DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') BETWEEN 
                    (CURRENT_DATE - INTERVAL '20 day') AND 
                    (CURRENT_DATE - INTERVAL '0 day')
                AND (
                    (answered_at = 0) OR 
                    (answered_at != 0)
                )        
        ;
