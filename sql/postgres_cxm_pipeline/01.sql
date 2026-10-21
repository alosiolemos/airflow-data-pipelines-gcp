SELECT 
                uuid,
                public_hash,
                name,
                channel,
                title,
                subtitle,
                status,
                default_lang,
                start_at,
                end_at,
                created_at,
                deleted_at,
                TO_CHAR(TO_TIMESTAMP(created_at), 'YYYY-MM-DD HH24:MI') AS created_dt,
                TO_CHAR(TO_TIMESTAMP(deleted_at), 'YYYY-MM-DD HH24:MI') AS deleted_dt,
                TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI') AS extracted_at
                FROM  demo_schema.surveys
            WHERE DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') <= DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 day')
        ;
