SELECT 
            interaction_uuid,
            metadata_uuid,
            value,
            created_at,
            TO_CHAR(TO_TIMESTAMP(created_at), 'YYYY-MM-DD HH24:MI') AS created_dt,    
            TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI') AS extracted_at 
        FROM 
            demo_schema.interaction_metadata
            WHERE DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') BETWEEN 
                    (CURRENT_DATE - INTERVAL '3 day') AND 
                    (CURRENT_DATE - INTERVAL '0 day')
        ;
