SELECT 
                uuid,
                name,
                created_at,
                modified_at,
                deleted_at,
                public_hash,
                CONCAT(COALESCE(name, '_'), '_', COALESCE(public_hash, '_')) AS name_hash,
                TO_CHAR(TO_TIMESTAMP(created_at), 'YYYY-MM-DD HH24:MI') as created_dt,
                TO_CHAR(TO_TIMESTAMP(deleted_at), 'YYYY-MM-DD HH24:MI') as deleted_dt,
                TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI') AS extracted_at
            FROM 
                demo_schema.metadata
            WHERE DATE(TO_TIMESTAMP(created_at)) <= DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 day')
        ;
