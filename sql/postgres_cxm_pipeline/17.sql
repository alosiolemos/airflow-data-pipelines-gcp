SELECT 
                interaction_uuid,
                survey_item_uuid,
                answer,                
                REPLACE(comment, 'nan', '') AS comment,
                created_at,
                deleted_at,
                TO_CHAR(TO_TIMESTAMP(created_at), 'YYYY-MM-DD HH24:MI') AS created_dt,
                TO_CHAR(TO_TIMESTAMP(deleted_at), 'YYYY-MM-DD HH24:MI') AS deleted_dt,
                TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI') AS extracted_at
            FROM 
                demo_schema.interaction_answers
            WHERE 
                DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') BETWEEN 
                    (CURRENT_DATE - INTERVAL '30 day') AND 
                    (CURRENT_DATE - INTERVAL '0 day')
        ;
