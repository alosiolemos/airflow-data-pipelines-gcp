SELECT 
                uuid,
                name,
                created_at,
                modified_at,
                deleted_at,
                public_hash,
                TO_CHAR(TO_TIMESTAMP(created_at), 'YYYY-MM-DD HH24:MI') as created_dt,
                TO_CHAR(TO_TIMESTAMP(deleted_at), 'YYYY-MM-DD HH24:MI') as deleted_dt,
                TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI') AS extracted_at
            FROM 
                demo_schema.metadata
        ;
